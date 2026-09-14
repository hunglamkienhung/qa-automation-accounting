#!/usr/bin/env node
'use strict';

const http = require('http');
const path = require('path');
const { URL } = require('url');
const { open } = require('./lib/db');
const H = require('./lib/http');

/**
 * mini-books: a small double-entry accounting backend over one SQLite file.
 * Node standard library only. It serves the chart of accounts, journal entries,
 * reversals and the financial reports over one REST API, plus small labelled
 * HTML pages for Playwright.
 *
 * The rules are the rules of bookkeeping. An account has one of the five types,
 * which fixes its normal balance (asset and expense debit; liability, equity and
 * revenue credit). A journal entry is a set of debit and credit lines whose
 * debits equal its credits, in integer cents, dated on a business day. Because
 * every entry balances, the ledger always satisfies the accounting equation --
 * Assets = Liabilities + Equity + Revenue - Expenses -- and the trial balance's
 * debit and credit totals are equal. Entries carry a gapless sequence number
 * assigned inside one IMMEDIATE transaction, so concurrent posting never
 * duplicates or skips a number, and posting is idempotent by key.
 */

const cfg = {
  port: Number(process.env.MINI_BOOKS_PORT || 8170),
  dbFile: process.env.MINI_BOOKS_DB || path.join(__dirname, 'data', 'mini-books.db'),
  adminToken: process.env.MINI_BOOKS_ADMIN_TOKEN || 'admin-token',
};
const DEBIT_NORMAL = new Set(['asset', 'expense']);

const now = () => Math.floor(Date.now() / 1000);
const money = (c) => (c / 100).toFixed(2);

function json(res, status, body, extra = {}) { res.writeHead(status, { 'content-type': 'application/json; charset=utf-8', ...extra }); res.end(JSON.stringify(body)); }
function html(res, status, body) { res.writeHead(status, { 'content-type': 'text/html; charset=utf-8' }); res.end('<!doctype html><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">' + body); }
function esc(s) { return String(s).replace(/[&<>"]/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c])); }
function readBody(req) {
  return new Promise((resolve, reject) => {
    let d = '';
    req.on('data', (c) => { d += c; if (d.length > 262144) reject(new H.ApiError(413, 'too_large', 'body too large')); });
    req.on('end', () => { try { resolve(d ? JSON.parse(d) : {}); } catch { reject(new H.ApiError(400, 'bad_request', 'body is not JSON')); } });
  });
}
const isWeekend = (dateStr) => { const day = new Date(dateStr + 'T00:00:00Z').getUTCDay(); return day === 0 || day === 6; };

function main() {
  const db = open(cfg.dbFile);
  const q = {
    insUser: db.prepare('INSERT INTO users (name, token, created_at) VALUES (?, ?, ?)'),
    userByToken: db.prepare('SELECT * FROM users WHERE token = ?'),
    accounts: db.prepare('SELECT * FROM accounts ORDER BY code'),
    account: db.prepare('SELECT * FROM accounts WHERE id = ?'),
    sideTotals: db.prepare("SELECT COALESCE(SUM(CASE WHEN side='debit' THEN amount_cents ELSE 0 END),0) AS debit, COALESCE(SUM(CASE WHEN side='credit' THEN amount_cents ELSE 0 END),0) AS credit FROM lines WHERE account_id = ?"),
    balanceRows: db.prepare("SELECT a.id, a.code, a.name, a.type, a.currency, COALESCE(SUM(CASE WHEN l.side='debit' THEN l.amount_cents ELSE 0 END),0) AS debit, COALESCE(SUM(CASE WHEN l.side='credit' THEN l.amount_cents ELSE 0 END),0) AS credit FROM accounts a LEFT JOIN lines l ON l.account_id = a.id GROUP BY a.id ORDER BY a.code"),

    insEntry: db.prepare('INSERT INTO journal_entries (entry_no, entry_date, memo, status, reverses_id, idempotency_key, created_at) VALUES (?, ?, ?, \'posted\', ?, ?, ?)'),
    entry: db.prepare('SELECT * FROM journal_entries WHERE id = ?'),
    entryByKey: db.prepare('SELECT * FROM journal_entries WHERE idempotency_key = ?'),
    allEntries: db.prepare('SELECT * FROM journal_entries ORDER BY entry_no'),
    maxEntryNo: db.prepare('SELECT COALESCE(MAX(entry_no),0) AS n FROM journal_entries'),
    setReversed: db.prepare("UPDATE journal_entries SET status = 'reversed' WHERE id = ?"),
    insLine: db.prepare('INSERT INTO lines (entry_id, account_id, side, amount_cents, created_at) VALUES (?, ?, ?, ?, ?)'),
    linesOf: db.prepare('SELECT l.*, a.code, a.name FROM lines l JOIN accounts a ON a.id = l.account_id WHERE l.entry_id = ? ORDER BY l.id'),
    grandTotals: db.prepare("SELECT COALESCE(SUM(CASE WHEN side='debit' THEN amount_cents ELSE 0 END),0) AS debit, COALESCE(SUM(CASE WHEN side='credit' THEN amount_cents ELSE 0 END),0) AS credit FROM lines"),
    countEntries: db.prepare('SELECT COUNT(*) AS n FROM journal_entries'),
  };

  const tx = (fn) => { db.exec('BEGIN IMMEDIATE'); try { const r = fn(); db.exec('COMMIT'); return r; } catch (e) { db.exec('ROLLBACK'); throw e; } };
  function bearer(req) { const m = /^Bearer\s+(\S+)$/i.exec(req.headers.authorization || ''); return m ? m[1] : null; }
  function requireUser(req) { const u = q.userByToken.get(bearer(req) || ''); if (!u) throw new H.ApiError(401, 'unauthenticated', 'an accountant Bearer token is required'); return u; }
  function isAdmin(req) { return bearer(req) === cfg.adminToken; }
  function requireAdmin(req) { if (!isAdmin(req)) throw new H.ApiError(401, 'unauthenticated', 'the admin token is required'); }

  /** Natural (normal-sign) balance of an account. */
  function naturalBalance(acc) { const t = q.sideTotals.get(acc.id); return DEBIT_NORMAL.has(acc.type) ? t.debit - t.credit : t.credit - t.debit; }
  const accountView = (a) => { const t = q.sideTotals.get(a.id); return { id: a.id, code: a.code, name: a.name, type: a.type, currency: a.currency, active: !!a.active, debit_total: t.debit, credit_total: t.credit, balance_cents: DEBIT_NORMAL.has(a.type) ? t.debit - t.credit : t.credit - t.debit }; };
  const entryView = (e) => ({ id: e.id, entry_no: e.entry_no, entry_date: e.entry_date, memo: e.memo, status: e.status, reverses_id: e.reverses_id, lines: q.linesOf.all(e.id).map((l) => ({ account_id: l.account_id, code: l.code, side: l.side, amount_cents: l.amount_cents })) });

  /** Compute the report totals by account type from the whole ledger. */
  function totals() {
    const t = { asset: 0, liability: 0, equity: 0, revenue: 0, expense: 0 };
    for (const r of q.balanceRows.all()) { const nat = DEBIT_NORMAL.has(r.type) ? r.debit - r.credit : r.credit - r.debit; t[r.type] += nat; }
    const net_income = t.revenue - t.expense;
    return { assets: t.asset, liabilities: t.liability, equity: t.equity, revenue: t.revenue, expenses: t.expense, net_income };
  }

  /** Validate and post a journal entry. Inside a transaction. Returns the entry id. */
  function postEntry(body, key, kind) {
    const lines = Array.isArray(body.lines) ? body.lines : null;
    const date = String(body.entry_date || '');
    if (!/^\d{4}-\d{2}-\d{2}$/.test(date)) throw new H.ApiError(400, 'bad_request', 'entry_date must be YYYY-MM-DD');
    if (isWeekend(date)) throw new H.ApiError(422, 'non_business_day', 'entries cannot be posted on a weekend', { date });
    if (!lines || lines.length < 2) throw new H.ApiError(422, 'too_few_lines', 'an entry needs at least two lines');
    let debit = 0, credit = 0; let currency = null;
    const resolved = [];
    for (const ln of lines) {
      const acc = q.account.get(Number(ln.account_id));
      if (!acc) throw new H.ApiError(404, 'not_found', 'no such account: ' + ln.account_id);
      if (!acc.active) throw new H.ApiError(422, 'inactive_account', 'account ' + acc.code + ' is archived', { account_id: acc.id });
      if (currency === null) currency = acc.currency; else if (acc.currency !== currency) throw new H.ApiError(422, 'currency_mismatch', 'all lines of an entry must share a currency');
      const amt = Number(ln.amount_cents);
      if (!Number.isInteger(amt) || amt <= 0) throw new H.ApiError(400, 'bad_request', 'amount_cents must be a positive integer');
      if (ln.side !== 'debit' && ln.side !== 'credit') throw new H.ApiError(400, 'bad_request', "side must be 'debit' or 'credit'");
      if (ln.side === 'debit') debit += amt; else credit += amt;
      resolved.push({ account_id: acc.id, side: ln.side, amount: amt });
    }
    if (debit !== credit) throw new H.ApiError(422, 'unbalanced', 'debits must equal credits', { debit, credit });
    const entryNo = q.maxEntryNo.get().n + 1;
    const info = q.insEntry.run(entryNo, date, body.memo ? String(body.memo) : null, null, key || null, now());
    const id = Number(info.lastInsertRowid);
    for (const r of resolved) q.insLine.run(id, r.account_id, r.side, r.amount, now());
    return id;
  }

  async function route(req, res, url) {
    const parts = url.pathname.replace(/\/+$/, '').split('/').filter(Boolean);
    const [a, b, c] = parts;

    // ---- app screens (HTML) ----
    if (req.method === 'GET' && parts.length === 0) return renderHome(res);
    if (req.method === 'GET' && a === 'account' && b) return renderAccount(res, b);
    if (req.method === 'GET' && a === 'entry' && b) return renderEntry(res, b);
    if (req.method === 'GET' && a === 'trial-balance' && !b) return renderTrialBalance(res);
    if (req.method === 'GET' && a === 'balance-sheet' && !b) return renderBalanceSheet(res);
    if (req.method === 'GET' && a === 'admin' && !b) return renderAdmin(res);

    // ---- health ----
    if (req.method === 'GET' && a === 'health') return json(res, 200, { ok: true, accounts: q.accounts.all().length, entries: q.countEntries.get().n, ts: now() });

    // ---- onboarding ----
    if (req.method === 'POST' && a === 'users' && !b) { const body = await readBody(req); const tok = H.token('usr'); const info = q.insUser.run(String(body.name || 'Accountant'), tok, now()); return json(res, 201, { id: Number(info.lastInsertRowid), token: tok }); }

    // ---- chart of accounts (reference data, public read) ----
    if (req.method === 'GET' && a === 'accounts' && !b) return json(res, 200, { accounts: q.accounts.all().map(accountView) });
    if (req.method === 'GET' && a === 'accounts' && b && !c) { const acc = q.account.get(Number(b)); if (!acc) throw new H.ApiError(404, 'not_found', 'no such account'); return json(res, 200, accountView(acc)); }

    // ---- journal entries ----
    if (req.method === 'POST' && a === 'journal-entries' && !b) {
      const user = requireUser(req); const body = await readBody(req);
      const key = body.idempotency_key ? String(body.idempotency_key) : null;
      const id = tx(() => {
        if (key) { const prior = q.entryByKey.get(key); if (prior) return { id: prior.id, replay: true }; }
        return { id: postEntry(body, key, 'journal'), replay: false };
      });
      return json(res, id.replay ? 200 : 201, { ...entryView(q.entry.get(id.id)), idempotent_replay: id.replay || undefined });
    }
    if (req.method === 'GET' && a === 'journal-entries' && !b) { requireUser(req); return json(res, 200, { entries: q.allEntries.all().map(entryView) }); }
    if (req.method === 'GET' && a === 'journal-entries' && b && !c) { requireUser(req); const e = q.entry.get(Number(b)); if (!e) throw new H.ApiError(404, 'not_found', 'no such entry'); return json(res, 200, entryView(e)); }
    if (req.method === 'POST' && a === 'journal-entries' && b && c === 'reverse') {
      requireAdmin(req); const e = q.entry.get(Number(b));
      if (!e) throw new H.ApiError(404, 'not_found', 'no such entry');
      if (e.status === 'reversed') throw new H.ApiError(409, 'bad_state', 'this entry is already reversed');
      if (e.reverses_id != null) throw new H.ApiError(409, 'bad_state', 'a reversal cannot itself be reversed');
      const id = tx(() => {
        const entryNo = q.maxEntryNo.get().n + 1;
        const info = q.insEntry.run(entryNo, e.entry_date, 'Reversal of entry ' + e.entry_no, e.id, null, now());
        const rid = Number(info.lastInsertRowid);
        for (const l of q.linesOf.all(e.id)) q.insLine.run(rid, l.account_id, l.side === 'debit' ? 'credit' : 'debit', l.amount_cents, now());
        q.setReversed.run(e.id);
        return rid;
      });
      return json(res, 201, entryView(q.entry.get(id)));
    }

    // ---- financial reports ----
    if (req.method === 'GET' && a === 'reports' && b === 'trial-balance') {
      requireUser(req); const g = q.grandTotals.get();
      const rows = q.balanceRows.all().filter((r) => r.debit !== 0 || r.credit !== 0).map((r) => { const nat = DEBIT_NORMAL.has(r.type) ? r.debit - r.credit : r.credit - r.debit; const onDebit = DEBIT_NORMAL.has(r.type); return { code: r.code, name: r.name, type: r.type, debit: onDebit ? Math.max(0, nat) : Math.max(0, -nat), credit: onDebit ? Math.max(0, -nat) : Math.max(0, nat) }; });
      return json(res, 200, { total_debits: g.debit, total_credits: g.credit, balanced: g.debit === g.credit, rows });
    }
    if (req.method === 'GET' && a === 'reports' && b === 'balance-sheet') {
      requireUser(req); const t = totals();
      return json(res, 200, { assets: t.assets, liabilities: t.liabilities, equity: t.equity, net_income: t.net_income, retained_earnings: t.equity + t.net_income, balanced: t.assets === t.liabilities + t.equity + t.net_income });
    }
    if (req.method === 'GET' && a === 'reports' && b === 'income-statement') {
      requireUser(req); const t = totals();
      return json(res, 200, { revenue: t.revenue, expenses: t.expenses, net_income: t.net_income });
    }
    if (req.method === 'GET' && a === 'reports' && b === 'equation') {
      requireUser(req); const t = totals();
      return json(res, 200, { assets: t.assets, liabilities: t.liabilities, equity: t.equity, revenue: t.revenue, expenses: t.expenses, holds: t.assets === t.liabilities + t.equity + t.revenue - t.expenses });
    }

    // ---- admin ----
    if (req.method === 'GET' && a === 'admin' && b === 'overview') { requireAdmin(req); const g = q.grandTotals.get(); return json(res, 200, { entries: q.countEntries.get().n, accounts: q.accounts.all().length, total_debits: g.debit, total_credits: g.credit, balanced: g.debit === g.credit }); }
    if (req.method === 'GET' && a === 'admin' && b === 'entries') { requireAdmin(req); return json(res, 200, { entries: q.allEntries.all().map(entryView) }); }

    if (['GET', 'POST', 'PATCH', 'DELETE'].includes(req.method)) throw new H.ApiError(404, 'not_found', 'no such route');
    throw new H.ApiError(405, 'method_not_allowed', 'method not allowed');
  }

  // ---- HTML renderers (labelled for Playwright) ----
  function renderHome(res) {
    const rows = q.accounts.all().map((acc) => { const v = accountView(acc); return `<li class="account" data-id="${acc.id}"><a href="/account/${acc.id}"><span class="code">${esc(acc.code)}</span> <span class="name">${esc(acc.name)}</span></a> <span class="type">${esc(acc.type)}</span> <span class="balance">${money(v.balance_cents)}</span></li>`; }).join('');
    return html(res, 200, `<title>mini-books</title><h1>mini-books</h1><nav class="apps"><a href="/trial-balance">Trial balance</a> <a href="/balance-sheet">Balance sheet</a> <a href="/admin">Admin</a></nav><ul class="accounts">${rows}</ul>`);
  }
  function renderAccount(res, id) {
    const acc = q.account.get(Number(id)); if (!acc) return html(res, 404, '<title>account</title><p>no such account</p>');
    const v = accountView(acc);
    return html(res, 200, `<title>${esc(acc.name)}</title><h1 class="account-name">${esc(acc.name)}</h1><p class="code">${esc(acc.code)}</p><p class="type">${esc(acc.type)}</p><p class="balance">${money(v.balance_cents)}</p>`);
  }
  function renderEntry(res, id) {
    const e = q.entry.get(Number(id)); if (!e) return html(res, 404, '<title>entry</title><p>no such entry</p>');
    const rows = q.linesOf.all(e.id).map((l) => `<li class="line" data-account="${l.account_id}"><span class="code">${esc(l.code)}</span> <span class="side">${esc(l.side)}</span> <span class="amount">${money(l.amount_cents)}</span></li>`).join('');
    return html(res, 200, `<title>entry ${e.entry_no}</title><h1 class="entry-id">Entry ${e.entry_no}</h1><p class="date">${esc(e.entry_date)}</p><p class="status">${esc(e.status)}</p><ul class="lines">${rows}</ul>`);
  }
  function renderTrialBalance(res) {
    const g = q.grandTotals.get();
    return html(res, 200, `<title>trial balance</title><h1>Trial balance</h1><p class="debits">${money(g.debit)}</p><p class="credits">${money(g.credit)}</p><p class="balanced">${g.debit === g.credit ? 'balanced' : 'UNBALANCED'}</p>`);
  }
  function renderBalanceSheet(res) {
    const t = totals();
    return html(res, 200, `<title>balance sheet</title><h1>Balance sheet</h1><p class="assets">${money(t.assets)}</p><p class="liabilities">${money(t.liabilities)}</p><p class="equity">${money(t.equity)}</p><p class="net-income">${money(t.net_income)}</p><p class="balanced">${t.assets === t.liabilities + t.equity + t.net_income ? 'balanced' : 'UNBALANCED'}</p>`);
  }
  function renderAdmin(res) {
    const g = q.grandTotals.get();
    return html(res, 200, `<title>mini-books admin</title><h1>Admin</h1><p class="entries">${q.countEntries.get().n}</p><p class="balanced">${g.debit === g.credit ? 'balanced' : 'UNBALANCED'}</p><p class="debits">${money(g.debit)}</p>`);
  }

  const server = http.createServer(async (req, res) => {
    const url = new URL(req.url, 'http://localhost');
    try { await route(req, res, url); }
    catch (err) { if (err instanceof H.ApiError) json(res, err.status, H.errorBody(err)); else { console.error(err); json(res, 500, { error: 'internal error', code: 'internal' }); } }
  });
  server.listen(cfg.port, '127.0.0.1', () => console.error(`mini-books on http://127.0.0.1:${cfg.port}  db ${cfg.dbFile}`));
  const shutdown = () => { server.close(); db.close(); process.exit(0); };
  process.on('SIGINT', shutdown); process.on('SIGTERM', shutdown);
}

if (require.main === module) main();
module.exports = { cfg, isWeekend };

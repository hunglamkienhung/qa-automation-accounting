'use strict';

const { Given, When, Then, Before, After } = require('@cucumber/cucumber');
const { Store, DbUnreachable, throwaway } = require('../store');
const { MiniBooks, ApiUnreachable, ACC } = require('../../api/venues/books');

/**
 * Steps for features/be-mini-books-db.feature, plus the shared "drive the
 * service" Givens the journal, reports, integrity and security features reuse.
 * Seeded accounts accumulate across scenarios, so balance assertions are on
 * deltas (note, act, check the change); per-entry and grand-total assertions are
 * absolute because they hold regardless of what else has posted.
 */

const books = new MiniBooks();
const UNREACHABLE = [DbUnreachable, ApiUnreachable];
const j = (v) => JSON.stringify(v);

Before({ tags: '@books' }, function () {
  this.store = null; this.books = books; this.token = books.seedBook; this.user = null;
  this.entry = null; this.report = null; this.noted = {}; this.api = null; this.tmp = null;
});
After({ tags: '@books' }, function () {
  if (this.tmp) { try { this.tmp.close(); } catch { /* fine */ } }
  if (this.store) this.store.close();
});

async function act(world, fn) {
  if (world.sourceError) return undefined;
  try { return await fn(); } catch (err) { if (UNREACHABLE.some((C) => err instanceof C)) { world.sourceError = err.message; return undefined; } throw err; }
}
async function check(world, description, fn) {
  if (world.sourceError) { world.unobservable(description, 'the source could not be reached -- ' + world.sourceError); return; }
  let r; try { r = await fn(); } catch (err) { if (UNREACHABLE.some((C) => err instanceof C)) { world.unobservable(description, err.message); return; } throw err; }
  world.check(description, r.passed, r.detail);
}

// ---------------------------------------------------------------- Background

Given('the store is open and the service is reachable', { timeout: 30_000 }, async function () {
  if (this.sourceError) return;
  try { this.store = new Store(); } catch (err) { if (err instanceof DbUnreachable) { this.sourceError = err.message; return; } throw err; }
  const r = await act(this, () => books.get('/health'));
  if (this.sourceError) return;
  if (!r || r.status !== 200) this.sourceError = 'mini-books did not answer /health: ' + (r ? r.status : 'no response');
  this.evidence('storeFile', this.store.file);
});

// ---------------------------------------------------------------- drive the service (shared)

Given('an accountant', async function () { this.token = books.seedBook; });

async function postNamed(world, fn) { await act(world, async () => { world.api = await fn(); world.entry = world.api.status < 300 ? world.api.body : null; }); }
Given('a cash sale of {int}', { timeout: 30_000 }, async function (amt) { await postNamed(this, () => books.entry(this.token, ACC.CASH, ACC.SALES, amt)); });
Given('rent paid of {int}', { timeout: 30_000 }, async function (amt) { await postNamed(this, () => books.entry(this.token, ACC.RENT, ACC.CASH, amt)); });
Given('an owner investment of {int}', { timeout: 30_000 }, async function (amt) { await postNamed(this, () => books.entry(this.token, ACC.CASH, ACC.OWNER_CAPITAL, amt)); });
Given('a balanced entry debiting account {int} and crediting account {int} for {int}', { timeout: 30_000 }, async function (dr, cr, amt) { await postNamed(this, () => books.entry(this.token, dr, cr, amt)); });
Given('a cash sale of {int} with key {string}', { timeout: 30_000 }, async function (amt, key) { await postNamed(this, () => books.entry(this.token, ACC.CASH, ACC.SALES, amt, { key })); this.firstEntry = this.api; this.lastAmt = amt; });
Given('the same cash sale is retried with key {string}', { timeout: 30_000 }, async function (key) { await act(this, async () => { this.api = await books.entry(this.token, ACC.CASH, ACC.SALES, this.lastAmt, { key }); this.secondEntry = this.api; }); });
Given('the entry is reversed by the admin', { timeout: 30_000 }, async function () { await act(this, async () => { this.originalEntry = this.entry; this.api = await books.post(`/journal-entries/${this.entry.id}/reverse`, undefined, { token: books.adminToken }); if (this.api.status < 300) this.reversal = this.api.body; }); });

Given('the balance of account {int} is noted', function (id) { if (this.store) this.noted['bal.' + id] = this.store.accountBalance(id); });

// ---------------------------------------------------------------- schema (throwaway)

Then('the store has tables {}', async function (list) {
  const want = list.split(/,\s*/);
  await check(this, 'store has the documented tables', () => { const have = this.store.tables(); const missing = want.filter((t) => !have.includes(t)); return { passed: missing.length === 0, detail: missing.length ? 'missing ' + missing.join(', ') : have.length + ' tables' }; });
});

Given('a throwaway database with the schema applied', function () {
  this.tmp = throwaway();
  this.tmp.exec("INSERT INTO users (id, name, token, created_at) VALUES (1, 'U', 'tok', 1)");
  this.tmp.exec("INSERT INTO accounts (id, code, name, type, currency, active, created_at) VALUES (1, '1000', 'Cash', 'asset', 'USD', 1, 1), (2, '2000', 'AP', 'liability', 'USD', 1, 1)");
  this.tmp.exec("INSERT INTO journal_entries (id, entry_no, entry_date, memo, status, reverses_id, idempotency_key, created_at) VALUES (1, 1, '2024-01-03', 'm', 'posted', NULL, 'k1', 1)");
  this.tmp.exec("INSERT INTO lines (id, entry_id, account_id, side, amount_cents, created_at) VALUES (1, 1, 1, 'debit', 100, 1), (2, 1, 2, 'credit', 100, 1)");
});
Given('a throwaway database with the schema and seed applied', function () {
  const fs = require('fs'); const path = require('path');
  this.tmp = throwaway();
  this.tmp.exec(fs.readFileSync(path.join(__dirname, '..', '..', '..', '..', 'services', 'mini-books', 'db', 'seed.sql'), 'utf8'));
});

function fails(db, sql, params, re) {
  try { db.prepare(sql).run(...params); return { passed: false, detail: 'insert succeeded' }; } catch (err) { return { passed: re.test(err.message), detail: err.message }; }
}
Then('inserting an account with type {string} fails a CHECK', function (t) { this.observe('account type CHECK', () => fails(this.tmp, "INSERT INTO accounts (code, name, type, currency, created_at) VALUES ('9999', 'X', ?, 'USD', 1)", [t], /CHECK constraint failed/)); });
Then('inserting a line for a missing entry fails a FOREIGN KEY', function () { this.observe('lines.entry_id FK', () => fails(this.tmp, "INSERT INTO lines (entry_id, account_id, side, amount_cents, created_at) VALUES (999, 1, 'debit', 10, 1)", [], /FOREIGN KEY constraint failed/)); });
Then('inserting a line for a missing account fails a FOREIGN KEY', function () { this.observe('lines.account_id FK', () => fails(this.tmp, "INSERT INTO lines (entry_id, account_id, side, amount_cents, created_at) VALUES (1, 999, 'debit', 10, 1)", [], /FOREIGN KEY constraint failed/)); });
Then('inserting a line with side {string} fails a CHECK', function (s) { this.observe('line side CHECK', () => fails(this.tmp, "INSERT INTO lines (entry_id, account_id, side, amount_cents, created_at) VALUES (1, 1, ?, 10, 1)", [s], /CHECK constraint failed/)); });
Then('inserting a line with a zero amount fails a CHECK', function () { this.observe('amount_cents > 0', () => fails(this.tmp, "INSERT INTO lines (entry_id, account_id, side, amount_cents, created_at) VALUES (1, 1, 'debit', 0, 1)", [], /CHECK constraint failed/)); });
Then('inserting an entry with status {string} fails a CHECK', function (s) { this.observe('entry status CHECK', () => fails(this.tmp, "INSERT INTO journal_entries (entry_no, entry_date, status, created_at) VALUES (2, '2024-01-03', ?, 1)", [s], /CHECK constraint failed/)); });
Then('inserting an account with active flag 2 fails a CHECK', function () { this.observe('active IN (0,1)', () => fails(this.tmp, "INSERT INTO accounts (code, name, type, currency, active, created_at) VALUES ('9998', 'X', 'asset', 'USD', 2, 1)", [], /CHECK constraint failed/)); });
Then('inserting two entries with the same entry number fails on the second', function () {
  this.observe('entry_no UNIQUE', () => { const a = fails(this.tmp, "INSERT INTO journal_entries (entry_no, entry_date, created_at) VALUES (5, '2024-01-03', 1)", [], /never/); if (a.detail !== 'insert succeeded') return { passed: false, detail: 'first: ' + a.detail }; return fails(this.tmp, "INSERT INTO journal_entries (entry_no, entry_date, created_at) VALUES (5, '2024-01-03', 1)", [], /UNIQUE constraint failed/); });
});
Then('inserting two accounts with the same code fails on the second', function () {
  this.observe('account code UNIQUE', () => { const a = fails(this.tmp, "INSERT INTO accounts (code, name, type, currency, created_at) VALUES ('7777', 'X', 'asset', 'USD', 1)", [], /never/); if (a.detail !== 'insert succeeded') return { passed: false, detail: 'first: ' + a.detail }; return fails(this.tmp, "INSERT INTO accounts (code, name, type, currency, created_at) VALUES ('7777', 'Y', 'asset', 'USD', 1)", [], /UNIQUE constraint failed/); });
});
Then('inserting two entries with the same idempotency key fails on the second', function () {
  this.observe('entry idempotency_key UNIQUE', () => { const a = fails(this.tmp, "INSERT INTO journal_entries (entry_no, entry_date, idempotency_key, created_at) VALUES (8, '2024-01-03', 'DUP', 1)", [], /never/); if (a.detail !== 'insert succeeded') return { passed: false, detail: 'first: ' + a.detail }; return fails(this.tmp, "INSERT INTO journal_entries (entry_no, entry_date, idempotency_key, created_at) VALUES (9, '2024-01-03', 'DUP', 1)", [], /UNIQUE constraint failed/); });
});
Then('applying the seed again changes no row counts', function () {
  const fs = require('fs'); const path = require('path');
  this.observe('seed idempotent', () => {
    const tables = ['users', 'accounts', 'journal_entries', 'lines'];
    const before = tables.map((t) => this.tmp.prepare('SELECT COUNT(*) AS n FROM ' + t).get().n);
    this.tmp.exec(fs.readFileSync(path.join(__dirname, '..', '..', '..', '..', 'services', 'mini-books', 'db', 'seed.sql'), 'utf8'));
    const after = tables.map((t) => this.tmp.prepare('SELECT COUNT(*) AS n FROM ' + t).get().n);
    return { passed: j(before) === j(after), detail: 'before ' + j(before) + ', after ' + j(after) };
  });
});

// ---------------------------------------------------------------- ledger-wide

Then('the whole ledger is balanced', async function () {
  await check(this, 'grand debits == grand credits', () => { const g = this.store.grandTotals(); return { passed: g.debit === g.credit, detail: `debit ${g.debit}, credit ${g.credit}` }; });
});
Then('the chart of accounts has an account of every type', async function () {
  await check(this, 'chart covers five types', () => { const types = ['asset', 'liability', 'equity', 'revenue', 'expense']; const missing = types.filter((t) => this.store.count('accounts', 'WHERE type = ?', t) === 0); return { passed: missing.length === 0, detail: missing.length ? 'missing ' + missing.join(',') : 'all five present' }; });
});

// ---------------------------------------------------------------- per-entry

Then('entry number {int} has exactly two lines', async function (no) {
  await check(this, `entry ${no} has two lines`, () => { const e = this.store.get('SELECT id FROM journal_entries WHERE entry_no = ?', no); const n = this.store.lines(e.id).length; return { passed: n === 2, detail: n + ' lines' }; });
});
Then('entry number {int}\'s debit and credit lines are equal', async function (no) {
  await check(this, `entry ${no} balances`, () => { const e = this.store.get('SELECT id FROM journal_entries WHERE entry_no = ?', no); return entryBalanced(this.store, e.id); });
});
Then('the entry\'s debit and credit lines are equal', async function () {
  await check(this, 'entry balances', () => entryBalanced(this.store, this.entry.id));
});
function entryBalanced(store, id) { const ls = store.lines(id); const d = ls.filter((l) => l.side === 'debit').reduce((a, l) => a + l.amount_cents, 0); const c = ls.filter((l) => l.side === 'credit').reduce((a, l) => a + l.amount_cents, 0); return { passed: ls.length >= 2 && d === c, detail: `debit ${d}, credit ${c}` }; }
Then('the entry has exactly two lines', async function () {
  await check(this, 'entry has two lines', () => { const n = this.store.lines(this.entry.id).length; return { passed: n === 2, detail: n + ' lines' }; });
});
Then('the debit line hits account {int} and the credit line hits account {int}', async function (dr, cr) {
  await check(this, `debit ${dr}, credit ${cr}`, () => { const ls = this.store.lines(this.entry.id); const d = ls.find((l) => l.side === 'debit'); const c = ls.find((l) => l.side === 'credit'); return { passed: !!d && !!c && d.account_id === dr && c.account_id === cr, detail: `debit acct ${d && d.account_id}, credit acct ${c && c.account_id}` }; });
});

// ---------------------------------------------------------------- balances (delta)

Then('account {int} balance rose by {int}', async function (id, delta) { await balanceDelta(this, id, delta); });
Then('account {int} balance fell by {int}', async function (id, delta) { await balanceDelta(this, id, -delta); });
async function balanceDelta(world, id, delta) {
  await check(world, `account ${id} moved by ${delta}`, () => { const now = world.store.accountBalance(id); const before = world.noted['bal.' + id]; return { passed: now - before === delta, detail: `before ${before}, now ${now}, change ${now - before}` }; });
}

// ---------------------------------------------------------------- numbering & idempotency

Then('the entry number is at least {int}', async function (n) {
  await check(this, 'entry_no >= ' + n, () => ({ passed: !!this.entry && this.entry.entry_no >= n, detail: 'entry_no ' + (this.entry && this.entry.entry_no) }));
});
Then('the entry numbers run without a gap', async function () {
  await check(this, 'entry numbers gapless', () => { const max = this.store.get('SELECT COALESCE(MAX(entry_no),0) AS n FROM journal_entries').n; const cnt = this.store.count('journal_entries'); return { passed: max === cnt, detail: `max ${max}, count ${cnt}` }; });
});
Then('only one entry carries that idempotency key', async function () {
  await check(this, 'one entry per key', () => { const same = this.firstEntry.body.id === this.secondEntry.body.id; return { passed: same, detail: `first ${this.firstEntry.body.id}, second ${this.secondEntry.body.id}` }; });
});

// ---------------------------------------------------------------- reversals

Then('the reversal\'s lines are the original\'s with sides swapped', async function () {
  await check(this, 'reversal swaps sides', () => {
    const orig = this.store.lines(this.originalEntry.id).map((l) => [l.account_id, l.side, l.amount_cents]).sort();
    const rev = this.store.lines(this.reversal.id).map((l) => [l.account_id, l.side === 'debit' ? 'credit' : 'debit', l.amount_cents]).sort();
    return { passed: j(orig) === j(rev), detail: 'orig ' + j(orig) + ' rev(swapped) ' + j(rev) };
  });
});
Then('the original entry row is reversed', async function () {
  await check(this, 'original status reversed', () => { const e = this.store.get('SELECT status FROM journal_entries WHERE id = ?', this.originalEntry.id); return { passed: e.status === 'reversed', detail: e.status }; });
});

// ---------------------------------------------------------------- integrity

Then('no lines row references an entry missing from journal_entries', async function () {
  await check(this, 'no orphan line->entry', () => { const n = this.store.count('lines l', 'WHERE NOT EXISTS (SELECT 1 FROM journal_entries e WHERE e.id = l.entry_id)'); return { passed: n === 0, detail: n + ' orphans' }; });
});
Then('no lines row references an account missing from accounts', async function () {
  await check(this, 'no orphan line->account', () => { const n = this.store.count('lines l', 'WHERE NOT EXISTS (SELECT 1 FROM accounts a WHERE a.id = l.account_id)'); return { passed: n === 0, detail: n + ' orphans' }; });
});
Then('every entry in the store has at least two lines', async function () {
  await check(this, 'every entry >= 2 lines', () => { const bad = this.store.all('SELECT e.id, COUNT(l.id) AS n FROM journal_entries e LEFT JOIN lines l ON l.entry_id = e.id GROUP BY e.id HAVING n < 2'); return { passed: bad.length === 0, detail: bad.length ? 'bad ' + j(bad) : 'all >= 2' }; });
});
Then('every entry\'s debits equal its credits', async function () {
  await check(this, 'every entry balances', () => { const bad = this.store.all("SELECT entry_id, SUM(CASE WHEN side='debit' THEN amount_cents ELSE -amount_cents END) AS net FROM lines GROUP BY entry_id HAVING net <> 0"); return { passed: bad.length === 0, detail: bad.length ? 'unbalanced ' + j(bad) : 'all balanced' }; });
});

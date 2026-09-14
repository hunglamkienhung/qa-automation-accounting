'use strict';

/**
 * HTTP client for the mini-books service. Node's built-in fetch; no library.
 *
 * A response is returned whole -- status, lower-cased headers, parsed body --
 * so a step can assert on any of them. Only a transport failure is
 * ApiUnreachable (grades Blocked); a 4xx/5xx is an answer, often the one under
 * test.
 *
 * The convenience helpers post common bookkeeping entries (a cash sale, paying
 * rent, an owner investment) so a step can build up a set of books to report on.
 * Account ids come from the seeded chart of accounts (ACC).
 */

const BASE = (process.env.MINI_BOOKS_URL || 'http://127.0.0.1:8170').replace(/\/+$/, '');
const ADMIN_TOKEN = process.env.MINI_BOOKS_ADMIN_TOKEN || 'admin-token';
const SEED_BOOK = 'usr_seed_book';
const SEED_AUX = 'usr_seed_aux';
// Seeded chart of accounts ids (see db/seed.sql).
const ACC = {
  CASH: 1, BANK: 2, AR: 3, INVENTORY: 4,
  AP: 5, LOAN: 6, OWNER_CAPITAL: 7, RETAINED: 8,
  SALES: 9, SERVICE: 10, RENT: 11, SALARIES: 12, SUPPLIES: 13, UTILITIES: 14,
  CASH_EUR: 15, ARCHIVED: 16,
};
const BIZ_DAY = '2024-01-03';   // a Wednesday -- a safe default posting date

class ApiUnreachable extends Error {}

class MiniBooks {
  constructor(base = BASE) { this.base = base; this.adminToken = ADMIN_TOKEN; this.seedBook = SEED_BOOK; this.seedAux = SEED_AUX; this.acc = ACC; this.bizDay = BIZ_DAY; }

  async request(method, path, { token, body, headers = {} } = {}) {
    const h = { ...headers };
    if (token) h.authorization = 'Bearer ' + token;
    const init = { method, headers: h };
    if (body !== undefined) { h['content-type'] = 'application/json'; init.body = JSON.stringify(body); }
    let res;
    try { res = await fetch(this.base + path, init); } catch (err) {
      throw new ApiUnreachable('mini-books at ' + this.base + ' did not answer ' + method + ' ' + path + ': ' + (err.cause && err.cause.message ? err.cause.message : err.message));
    }
    const text = await res.text();
    let parsed = null; try { parsed = text ? JSON.parse(text) : null; } catch { parsed = null; }
    return { status: res.status, headers: Object.fromEntries([...res.headers.entries()].map(([k, v]) => [k.toLowerCase(), v])), body: parsed, text };
  }
  get(p, o) { return this.request('GET', p, o); }
  post(p, body, o = {}) { return this.request('POST', p, { ...o, body }); }

  async newUser(name = 'Accountant') { const r = await this.post('/users', { name }); if (r.status !== 201) throw new Error('create user failed: HTTP ' + r.status + ' ' + r.text); return r.body; }

  /** Post a two-line entry: debit `dr`, credit `cr`, for `amount` cents. Returns the response. */
  entry(token, dr, cr, amount, { date = BIZ_DAY, memo, key } = {}) {
    const body = { entry_date: date, memo, lines: [{ account_id: dr, side: 'debit', amount_cents: amount }, { account_id: cr, side: 'credit', amount_cents: amount }] };
    if (key) body.idempotency_key = key;
    return this.post('/journal-entries', body, { token });
  }
  /** Post an entry and throw on a non-2xx; returns the entry body. */
  async postEntry(token, dr, cr, amount, opts) { const r = await this.entry(token, dr, cr, amount, opts); if (r.status !== 201 && r.status !== 200) throw new Error('post entry failed: HTTP ' + r.status + ' ' + r.text); return r.body; }

  // named bookkeeping transactions, each a balanced entry
  cashSale(token, amount, opts) { return this.postEntry(token, ACC.CASH, ACC.SALES, amount, opts); }        // Dr Cash / Cr Sales
  payRent(token, amount, opts) { return this.postEntry(token, ACC.RENT, ACC.CASH, amount, opts); }          // Dr Rent Expense / Cr Cash
  ownerInvest(token, amount, opts) { return this.postEntry(token, ACC.CASH, ACC.OWNER_CAPITAL, amount, opts); }
}

module.exports = { MiniBooks, ApiUnreachable, BASE, ADMIN_TOKEN, ACC, BIZ_DAY };

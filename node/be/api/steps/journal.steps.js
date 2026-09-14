'use strict';

const { When, Then } = require('@cucumber/cucumber');
const { MiniBooks, ApiUnreachable } = require('../venues/books');

/**
 * Steps for features/be-mini-books-journal.feature. The generic "refused with
 * code/status" steps live here and are shared across every @books @api tier.
 */

const books = new MiniBooks();

async function act(world, fn) {
  if (world.sourceError) return undefined;
  try { return await fn(); } catch (err) { if (err instanceof ApiUnreachable) { world.sourceError = err.message; return undefined; } throw err; }
}
function check(world, description, fn) {
  if (world.sourceError) { world.unobservable(description, 'the source could not be reached -- ' + world.sourceError); return; }
  const r = fn(); world.check(description, r.passed, r.detail);
}
const j = (v) => JSON.stringify(v);

async function postLines(world, lines, token, { date = books.bizDay, key } = {}) {
  const body = { entry_date: date, lines };
  if (key) body.idempotency_key = key;
  await act(world, async () => { world.api = await books.post('/journal-entries', body, token ? { token } : {}); if (world.api.status === 201 || world.api.status === 200) world.entry = world.api.body; });
}
const twoLine = (dr, cr, amt) => [{ account_id: dr, side: 'debit', amount_cents: amt }, { account_id: cr, side: 'credit', amount_cents: amt }];

When('the accountant posts Dr account {int} Cr account {int} for {int}', async function (dr, cr, amt) { await postLines(this, twoLine(dr, cr, amt), this.token); });
When('the accountant posts Dr account {int} Cr account {int} for {int} dated {word}', async function (dr, cr, amt, date) { await postLines(this, twoLine(dr, cr, amt), this.token, { date }); });
When('the accountant posts a split entry debiting account {int} by {int} and account {int} by {int} crediting account {int} by {int}', async function (d1, a1, d2, a2, cr, ac) { await postLines(this, [{ account_id: d1, side: 'debit', amount_cents: a1 }, { account_id: d2, side: 'debit', amount_cents: a2 }, { account_id: cr, side: 'credit', amount_cents: ac }], this.token); });
When('the accountant posts an unbalanced entry of Dr {int} Cr {int}', async function (dr, cr) { await postLines(this, [{ account_id: 1, side: 'debit', amount_cents: dr }, { account_id: 9, side: 'credit', amount_cents: cr }], this.token); });
When('the accountant posts a single-line entry', async function () { await postLines(this, [{ account_id: 1, side: 'debit', amount_cents: 1000 }], this.token); });
When('an anonymous caller posts Dr account {int} Cr account {int} for {int}', async function (dr, cr, amt) { await postLines(this, twoLine(dr, cr, amt), null); });
When('a forged token posts Dr account {int} Cr account {int} for {int}', async function (dr, cr, amt) { await postLines(this, twoLine(dr, cr, amt), 'usr_forged000000000000000000'); });
When('the accountant posts Dr account {int} Cr account {int} for {int} with key {string}', async function (dr, cr, amt, key) { await postLines(this, twoLine(dr, cr, amt), this.token, { key }); this.firstEntry = this.api; this.lastLines = twoLine(dr, cr, amt); });
When('the accountant posts again with key {string}', async function (key) { await act(this, async () => { this.api = await books.post('/journal-entries', { entry_date: books.bizDay, lines: this.lastLines, idempotency_key: key }, { token: this.token }); this.secondEntry = this.api; }); });

When('the accountant reads the entry', async function () { await act(this, async () => { this.api = await books.get('/journal-entries/' + this.entry.id, { token: this.token }); }); });
When('the accountant lists the entries', async function () { await act(this, async () => { this.api = await books.get('/journal-entries', { token: this.token }); }); });

Then('the entry is posted', function () {
  check(this, 'entry posted', () => ({ passed: !!this.api && this.api.status === 201, detail: this.api ? this.api.status + ' ' + j(this.api.body) : 'no response' }));
});
Then('the entry is refused', function () {
  check(this, 'entry refused', () => ({ passed: !!this.api && this.api.status >= 400, detail: this.api ? this.api.status + ' ' + j(this.api.body) : 'no response' }));
});
Then('the entry response balances', function () {
  check(this, 'entry response balances', () => { const e = this.entry; if (!e || !e.lines) return { passed: false, detail: this.api ? this.api.status + ' ' + j(this.api.body) : 'no entry' }; const d = e.lines.filter((l) => l.side === 'debit').reduce((a, l) => a + l.amount_cents, 0); const c = e.lines.filter((l) => l.side === 'credit').reduce((a, l) => a + l.amount_cents, 0); return { passed: e.lines.length >= 2 && d === c, detail: `debit ${d}, credit ${c}` }; });
});
Then('the entry has a number', function () {
  check(this, 'entry has a number', () => ({ passed: !!this.entry && Number.isInteger(this.entry.entry_no) && this.entry.entry_no >= 1, detail: 'entry_no ' + (this.entry && this.entry.entry_no) }));
});
Then('the entry lists {int} lines', function (n) {
  check(this, 'entry lists ' + n + ' lines', () => ({ passed: !!this.entry && this.entry.lines.length === n, detail: this.entry ? this.entry.lines.length + ' lines' : 'no entry' }));
});
Then('the entry reads back with balanced lines', function () {
  check(this, 'entry reads back balanced', () => { const e = this.api && this.api.body; if (!e || !e.lines) return { passed: false, detail: 'no body' }; const d = e.lines.filter((l) => l.side === 'debit').reduce((a, l) => a + l.amount_cents, 0); const c = e.lines.filter((l) => l.side === 'credit').reduce((a, l) => a + l.amount_cents, 0); return { passed: d === c, detail: `debit ${d}, credit ${c}` }; });
});
Then('the entry list includes the posted entry', function () {
  check(this, 'entry list includes posted', () => { const es = this.api && this.api.body && this.api.body.entries; return { passed: Array.isArray(es) && es.some((e) => e.id === this.entry.id), detail: es ? es.length + ' entries' : 'no list' }; });
});
Then('both posts are the same entry', function () {
  check(this, 'idempotent post same entry', () => { const a = this.firstEntry && this.firstEntry.body, b = this.secondEntry && this.secondEntry.body; return { passed: !!a && !!b && a.id === b.id, detail: `first ${a && a.id}, second ${b && b.id}` }; });
});

// ---- generic refusals, shared across @books @api tiers ----
Then('the request is refused with code {string}', function (code) {
  check(this, 'refused with code ' + code, () => ({ passed: !!this.api && this.api.status >= 400 && this.api.body && this.api.body.code === code, detail: this.api ? this.api.status + ' ' + j(this.api.body) : 'no response' }));
});
Then('the request is refused with status {int}', function (status) {
  check(this, 'refused with status ' + status, () => ({ passed: !!this.api && this.api.status === status, detail: this.api ? this.api.status + ' ' + j(this.api.body) : 'no response' }));
});

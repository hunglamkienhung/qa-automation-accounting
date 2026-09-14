'use strict';

const { When, Then } = require('@cucumber/cucumber');
const { MiniBooks, ApiUnreachable } = require('../venues/books');

/**
 * Steps for features/be-mini-books-integrity.feature -- the accounting equation,
 * reversals, and gapless numbering under concurrency. The race steps fire N
 * posts at once with Promise.all: distinct entries must all succeed and be
 * numbered gaplessly, or a shared key must collapse to one entry. Setup Givens
 * (a cash sale, the entry is reversed by the admin, the books figures are noted)
 * and several assertions are shared from the db and reports steps.
 */

const books = new MiniBooks();
const twoLine = (dr, cr, amt) => [{ account_id: dr, side: 'debit', amount_cents: amt }, { account_id: cr, side: 'credit', amount_cents: amt }];
let IDEM = 0;

async function act(world, fn) {
  if (world.sourceError) return undefined;
  try { return await fn(); } catch (err) { if (err instanceof ApiUnreachable) { world.sourceError = err.message; return undefined; } throw err; }
}
function check(world, description, fn) {
  if (world.sourceError) { world.unobservable(description, 'the source could not be reached -- ' + world.sourceError); return; }
  const r = fn(); world.check(description, r.passed, r.detail);
}
const j = (v) => JSON.stringify(v);
async function figures(world) {
  const bs = (await books.get('/reports/balance-sheet', { token: world.token })).body;
  const is = (await books.get('/reports/income-statement', { token: world.token })).body;
  return { assets: bs.assets, liabilities: bs.liabilities, equity: bs.equity, net_income: bs.net_income, revenue: is.revenue, expenses: is.expenses };
}

// ---------------------------------------------------------------- reversals

When('the admin reverses the entry', async function () { await act(this, async () => { this.api = await books.post(`/journal-entries/${this.entry.id}/reverse`, undefined, { token: books.adminToken }); }); });
When('the admin reverses the reversal', async function () { await act(this, async () => { this.api = await books.post(`/journal-entries/${this.reversal.id}/reverse`, undefined, { token: books.adminToken }); }); });
When('the accountant tries to reverse the entry', async function () { await act(this, async () => { this.api = await books.post(`/journal-entries/${this.entry.id}/reverse`, undefined, { token: this.token }); }); });
When('the admin reverses entry {int}', async function (id) { await act(this, async () => { this.api = await books.post(`/journal-entries/${id}/reverse`, undefined, { token: books.adminToken }); }); });

// ---------------------------------------------------------------- the races

async function raceDistinct(world, n) {
  await act(world, async () => {
    world.raceBefore = world.store.count('journal_entries');
    const jobs = Array.from({ length: n }, () => books.post('/journal-entries', { entry_date: books.bizDay, lines: twoLine(books.acc.CASH, books.acc.SALES, 10) }, { token: books.seedBook }));
    const results = await Promise.all(jobs);
    world.raceStatuses = results.map((r) => r.status);
    world.raceNos = results.map((r) => r.body && r.body.entry_no).filter((x) => x != null);
    world.raceN = n;
  });
}
When('{int} accountants post distinct entries at once', async function (n) { await raceDistinct(this, n); });
When('{int} accountants post the same entry with one key at once', async function (n) {
  const key = 'race-idem-' + (IDEM++);
  await act(this, async () => {
    const jobs = Array.from({ length: n }, () => books.post('/journal-entries', { entry_date: books.bizDay, lines: twoLine(books.acc.CASH, books.acc.SALES, 100), idempotency_key: key }, { token: books.seedBook }));
    const results = await Promise.all(jobs);
    this.raceIds = results.map((r) => r.body && r.body.id).filter((x) => x != null);
    this.raceN = n;
  });
});

// ---------------------------------------------------------------- assertions

Then('the figures are back to what was noted', async function () {
  if (this.sourceError) { this.unobservable('figures restored', this.sourceError); return; }
  const now = await act(this, () => figures(this));
  check(this, 'figures restored after reversal', () => ({ passed: !!now && j(now) === j(this.notedFig), detail: 'noted ' + j(this.notedFig) + ' now ' + j(now) }));
});
Then('every racing post succeeds', function () {
  check(this, 'every racing post 201', () => { const s = this.raceStatuses || []; const ok = s.filter((x) => x === 201).length; return { passed: ok === this.raceN, detail: `${ok}/${s.length} were 201` }; });
});
Then('the entry numbers are gapless and unique', function () {
  check(this, 'entry numbers gapless and unique', () => {
    const max = this.store.get('SELECT COALESCE(MAX(entry_no),0) AS n FROM journal_entries').n;
    const cnt = this.store.count('journal_entries');
    const uniq = new Set(this.raceNos).size === this.raceNos.length;
    return { passed: max === cnt && uniq && this.raceNos.length === this.raceN, detail: `max ${max}, count ${cnt}, ${this.raceNos.length} nos, ${new Set(this.raceNos).size} unique` };
  });
});
Then('{int} entries were added', function (n) {
  check(this, n + ' entries added', () => { const cnt = this.store.count('journal_entries'); return { passed: cnt === this.raceBefore + n, detail: `before ${this.raceBefore}, now ${cnt}` }; });
});
Then('all the racing posts share one entry', function () {
  check(this, 'idempotent race one entry', () => { const ids = this.raceIds || []; const uniq = new Set(ids); return { passed: ids.length === this.raceN && uniq.size === 1, detail: `${ids.length} ids, ${uniq.size} unique` }; });
});
Then('the response status is {int}', function (status) {
  check(this, 'response status ' + status, () => ({ passed: !!this.api && this.api.status === status, detail: this.api ? this.api.status + ' ' + j(this.api.body) : 'no response' }));
});

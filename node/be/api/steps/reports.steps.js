'use strict';

const { Given, When, Then } = require('@cucumber/cucumber');
const { MiniBooks, ApiUnreachable } = require('../venues/books');

/**
 * Steps for features/be-mini-books-reports.feature. Report figures accumulate as
 * the shared books grow, so figure checks are on deltas (note the figures, post,
 * check the change); the accounting invariants (balanced, equation holds, net
 * income = revenue - expenses) are absolute because they hold no matter what
 * else has posted. The "posts Dr .. Cr .." step is shared from journal.steps.js.
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

async function figures(world) {
  const bs = (await books.get('/reports/balance-sheet', { token: world.token })).body;
  const is = (await books.get('/reports/income-statement', { token: world.token })).body;
  return { assets: bs.assets, liabilities: bs.liabilities, equity: bs.equity, net_income: bs.net_income, revenue: is.revenue, expenses: is.expenses };
}

When('the trial balance is fetched', async function () { await act(this, async () => { this.api = await books.get('/reports/trial-balance', { token: this.token }); this.report = this.api.body; }); });
When('the balance sheet is fetched', async function () { await act(this, async () => { this.api = await books.get('/reports/balance-sheet', { token: this.token }); this.report = this.api.body; }); });
When('the income statement is fetched', async function () { await act(this, async () => { this.api = await books.get('/reports/income-statement', { token: this.token }); this.report = this.api.body; }); });
When('the accounting equation is fetched', async function () { await act(this, async () => { this.api = await books.get('/reports/equation', { token: this.token }); this.report = this.api.body; }); });
Given('the books figures are noted', async function () { await act(this, async () => { this.notedFig = await figures(this); }); });

Then('the trial balance is balanced', function () {
  check(this, 'trial balance balanced', () => { const r = this.report; return { passed: !!r && r.balanced === true && r.total_debits === r.total_credits, detail: r ? `Dr ${r.total_debits} Cr ${r.total_credits}` : 'no report' }; });
});
Then('the balance sheet balances', function () {
  check(this, 'balance sheet balances', () => { const r = this.report; return { passed: !!r && r.balanced === true && r.assets === r.liabilities + r.equity + r.net_income, detail: r ? j(r) : 'no report' }; });
});
Then('net income equals revenue minus expenses', function () {
  check(this, 'net income = rev - exp', () => { const r = this.report; return { passed: !!r && r.net_income === r.revenue - r.expenses, detail: r ? j(r) : 'no report' }; });
});
Then('the accounting equation holds', function () {
  check(this, 'accounting equation holds', () => { const r = this.report; return { passed: !!r && r.holds === true && r.assets === r.liabilities + r.equity + r.revenue - r.expenses, detail: r ? j(r) : 'no report' }; });
});
Then('the balance sheet still balances', async function () {
  if (this.sourceError) { this.unobservable('balance sheet still balances', this.sourceError); return; }
  const b = await act(this, () => books.get('/reports/balance-sheet', { token: this.token }));
  check(this, 'balance sheet still balances', () => ({ passed: !!b && b.body && b.body.balanced === true, detail: b && b.body ? j(b.body) : 'no read' }));
});
Then('the accounting equation still holds', async function () {
  if (this.sourceError) { this.unobservable('equation still holds', this.sourceError); return; }
  const e = await act(this, () => books.get('/reports/equation', { token: this.token }));
  check(this, 'equation still holds', () => ({ passed: !!e && e.body && e.body.holds === true, detail: e && e.body ? j(e.body) : 'no read' }));
});
Then('the trial balance shows account {int} with a debit balance', function (id) {
  check(this, 'trial balance debit row', () => { const acc = books.acc; const codeById = { [acc.CASH]: '1000', [acc.OWNER_CAPITAL]: '3000' }; const code = codeById[id]; const row = (this.report && this.report.rows || []).find((r) => r.code === code); return { passed: !!row && row.debit > 0 && row.credit === 0, detail: row ? j(row) : 'no row for ' + code }; });
});
Then('the trial balance shows account {int} with a credit balance', function (id) {
  check(this, 'trial balance credit row', () => { const codeById = { 7: '3000', 1: '1000' }; const code = codeById[id]; const row = (this.report && this.report.rows || []).find((r) => r.code === code); return { passed: !!row && row.credit > 0 && row.debit === 0, detail: row ? j(row) : 'no row for ' + code }; });
});

// ---- figure deltas ----
async function figureDelta(world, key, delta) {
  if (world.sourceError) { world.unobservable(`${key} moved by ${delta}`, world.sourceError); return; }
  const nowFig = await act(world, () => figures(world));
  check(world, `reported ${key} moved by ${delta}`, () => { const before = world.notedFig[key]; const now = nowFig[key]; return { passed: now - before === delta, detail: `before ${before}, now ${now}, change ${now - before}` }; });
}
Then('reported {word} rose by {int}', async function (word, n) { await figureDelta(this, word, n); });
Then('reported {word} fell by {int}', async function (word, n) { await figureDelta(this, word, -n); });
Then('reported net income rose by {int}', async function (n) { await figureDelta(this, 'net_income', n); });
Then('reported net income fell by {int}', async function (n) { await figureDelta(this, 'net_income', -n); });

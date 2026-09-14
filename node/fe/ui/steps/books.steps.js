'use strict';

const { Given, When, Then } = require('@cucumber/cucumber');
const { BooksPage, ScreenNotReady } = require('../pages/books');
const { ApiUnreachable } = require('../../../be/api/venues/books');

/**
 * Steps for features/fe-mini-books.feature -- the only steps in this domain that
 * drive a browser. The comparison figures come from the store (this.store,
 * opened by the @books Before hook) and the rows. The accountant/cash-sale setup
 * Givens are shared from the be steps.
 */

const money = (c) => (c / 100).toFixed(2);
const num = (s) => Number(String(s).replace(/[^0-9.-]/g, ''));
const cents = (s) => Math.round(num(s) * 100);   // parse a dollar string back to integer cents for exact comparison

Given('the home page is open', { timeout: 90_000 }, async function () {
  this.booksPage = new BooksPage(this.page);
  await this.fetchOrBlock([ScreenNotReady], async () => { await this.booksPage.open('/'); this.screen.accounts = await this.booksPage.accounts(); });
});

async function screen(world, description, fn) {
  if (world.sourceError) { world.unobservable(description, 'the source could not be reached -- ' + world.sourceError); return; }
  let r;
  try { r = await fn(); } catch (err) { if (err instanceof ScreenNotReady || err instanceof ApiUnreachable) { world.unobservable(description, err.message); return; } throw err; }
  world.check(description, r.passed, r.detail);
}

// ---------------------------------------------------------------- navigation

When('the account page for account {int} is opened', { timeout: 90_000 }, async function (id) { await this.fetchOrBlock([ScreenNotReady], async () => { await this.booksPage.open('/account/' + id); this.screen.account = await this.booksPage.account().catch(() => null); this.screen.accountId = id; }); });
When('the entry page is opened', { timeout: 90_000 }, async function () { await this.fetchOrBlock([ScreenNotReady], async () => { await this.booksPage.open('/entry/' + this.entry.id); this.screen.entry = await this.booksPage.entry().catch(() => null); }); });
When('the entry page for {int} is opened', { timeout: 90_000 }, async function (id) { await this.fetchOrBlock([ScreenNotReady], async () => { await this.booksPage.open('/entry/' + id); this.screen.entry = await this.booksPage.entry().catch(() => null); }); });
When('the trial balance page is opened', { timeout: 90_000 }, async function () { await this.fetchOrBlock([ScreenNotReady], async () => { await this.booksPage.open('/trial-balance'); this.screen.tb = await this.booksPage.trialBalance().catch(() => null); }); });
When('the balance sheet page is opened', { timeout: 90_000 }, async function () { await this.fetchOrBlock([ScreenNotReady], async () => { await this.booksPage.open('/balance-sheet'); this.screen.bs = await this.booksPage.balanceSheet().catch(() => null); }); });
When('the admin page is opened', { timeout: 90_000 }, async function () { await this.fetchOrBlock([ScreenNotReady], async () => { await this.booksPage.open('/admin'); this.screen.admin = await this.booksPage.admin().catch(() => null); }); });

// ---------------------------------------------------------------- chart of accounts

Then('the home page lists at least the sixteen seeded accounts', async function () {
  await screen(this, 'home lists seeded accounts', async () => { const ids = this.screen.accounts.map((a) => a.id); const missing = []; for (let i = 1; i <= 16; i++) if (!ids.includes(i)) missing.push(i); return { passed: missing.length === 0, detail: missing.length ? 'missing ' + missing.join(',') : ids.length + ' accounts' }; });
});
Then('every account row shows a code, a name and a type', async function () {
  await screen(this, 'account rows show code/name/type', async () => { const bad = this.screen.accounts.filter((a) => !/^\d{4}$/.test(a.code) || !a.name || !['asset', 'liability', 'equity', 'revenue', 'expense'].includes(a.type)); return { passed: bad.length === 0 && this.screen.accounts.length > 0, detail: bad.length ? JSON.stringify(bad.slice(0, 2)) : this.screen.accounts.length + ' rows' }; });
});
Then('every account balance on screen is a number', async function () {
  await screen(this, 'account balances are numbers', async () => { const bad = this.screen.accounts.filter((a) => !/^-?\d+\.\d{2}$/.test(a.balanceText)); return { passed: bad.length === 0, detail: bad.length ? JSON.stringify(bad.slice(0, 2).map((a) => a.balanceText)) : 'all numeric' }; });
});
Then('the home page shows an account of every type', async function () {
  await screen(this, 'home shows five types', async () => { const types = new Set(this.screen.accounts.map((a) => a.type)); const want = ['asset', 'liability', 'equity', 'revenue', 'expense']; const missing = want.filter((t) => !types.has(t)); return { passed: missing.length === 0, detail: missing.length ? 'missing ' + missing.join(',') : [...types].join(',') }; });
});

// ---------------------------------------------------------------- an account

Then('the account page balance equals the stored balance', async function () {
  await screen(this, 'account page balance == stored', async () => { const a = this.screen.account; const bal = this.store.accountBalance(this.screen.accountId); return { passed: !!a && a.balanceText === money(bal), detail: a ? a.balanceText + ' vs ' + money(bal) : 'no page' }; });
});
Then('the account page shows code {string} and type {string}', async function (code, type) {
  await screen(this, 'account page code/type', async () => ({ passed: !!this.screen.account && this.screen.account.codeText === code && this.screen.account.typeText === type, detail: this.screen.account ? this.screen.account.codeText + '/' + this.screen.account.typeText : 'no page' }));
});
Then('the page reports not found', async function () {
  await screen(this, 'page not found', async () => { const txt = await this.page.textContent('body'); return { passed: /no such/i.test(txt), detail: txt.slice(0, 60) }; });
});

// ---------------------------------------------------------------- an entry

Then('the entry lines on screen show a debit and a credit of the same amount', async function () {
  await screen(this, 'entry lines balanced on screen', async () => { const ls = this.screen.entry && this.screen.entry.lines; if (!ls) return { passed: false, detail: 'no page' }; const d = ls.find((l) => l.side === 'debit'); const c = ls.find((l) => l.side === 'credit'); return { passed: !!d && !!c && ls.length === 2 && d.amount === c.amount, detail: d && c ? `debit ${d.amount}, credit ${c.amount}` : 'missing a side' }; });
});
Then('the entry page shows status {string}', async function (status) {
  await screen(this, 'entry status ' + status, async () => ({ passed: !!this.screen.entry && this.screen.entry.statusText === status, detail: this.screen.entry ? this.screen.entry.statusText : 'no page' }));
});

// ---------------------------------------------------------------- reports

Then('the trial balance page shows the debits equal the credits', async function () {
  await screen(this, 'trial balance debits == credits', async () => { const t = this.screen.tb; return { passed: !!t && cents(t.debitsText) === cents(t.creditsText), detail: t ? t.debitsText + ' vs ' + t.creditsText : 'no page' }; });
});
Then('the trial balance page shows it balanced', async function () {
  await screen(this, 'trial balance balanced', async () => ({ passed: !!this.screen.tb && this.screen.tb.balancedText === 'balanced', detail: this.screen.tb ? this.screen.tb.balancedText : 'no page' }));
});
Then('the balance sheet page shows Assets equal Liabilities plus Equity plus Net income', async function () {
  await screen(this, 'balance sheet identity on screen', async () => { const b = this.screen.bs; if (!b) return { passed: false, detail: 'no page' }; return { passed: cents(b.assetsText) === cents(b.liabilitiesText) + cents(b.equityText) + cents(b.netIncomeText), detail: `A ${b.assetsText} = L ${b.liabilitiesText} + E ${b.equityText} + NI ${b.netIncomeText}` }; });
});
Then('the balance sheet page shows it balanced', async function () {
  await screen(this, 'balance sheet balanced', async () => ({ passed: !!this.screen.bs && this.screen.bs.balancedText === 'balanced', detail: this.screen.bs ? this.screen.bs.balancedText : 'no page' }));
});

// ---------------------------------------------------------------- admin

Then('the admin page shows it balanced', async function () {
  await screen(this, 'admin balanced', async () => ({ passed: !!this.screen.admin && this.screen.admin.balancedText === 'balanced', detail: this.screen.admin ? this.screen.admin.balancedText : 'no page' }));
});
Then('the admin entry count is a positive integer', async function () {
  await screen(this, 'admin entry count', async () => ({ passed: !!this.screen.admin && /^\d+$/.test(this.screen.admin.entriesText) && Number(this.screen.admin.entriesText) > 0, detail: this.screen.admin ? this.screen.admin.entriesText : 'no page' }));
});

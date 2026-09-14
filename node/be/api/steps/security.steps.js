'use strict';

const { When, Then } = require('@cucumber/cucumber');
const { MiniBooks, ApiUnreachable } = require('../venues/books');

/**
 * Steps for features/be-mini-books-security.feature. These probe the API's
 * authorization boundaries -- no token, a forged token, the wrong role. Setup
 * Givens (an accountant, a cash sale) and "the response status is {int}" are
 * shared from the other @books steps; only the adversarial requests and the
 * secret-hygiene assertions are new.
 */

const books = new MiniBooks();
const FORGED = 'usr_forged000000000000000000';
const twoLine = (dr, cr, amt) => [{ account_id: dr, side: 'debit', amount_cents: amt }, { account_id: cr, side: 'credit', amount_cents: amt }];

async function send(world, method, path, opts = {}) {
  if (world.sourceError) return;
  try { world.api = await books.request(method, path, opts); } catch (err) { if (err instanceof ApiUnreachable) { world.sourceError = err.message; return; } throw err; }
}
function check(world, description, fn) {
  if (world.sourceError) { world.unobservable(description, 'the source could not be reached -- ' + world.sourceError); return; }
  const r = fn(); world.check(description, r.passed, r.detail);
}
const j = (v) => JSON.stringify(v);
function leaksToken(obj, adminToken) { const text = j(obj || {}); return /"usr_[A-Za-z0-9_-]{8,}"/.test(text) || text.includes('"' + adminToken + '"'); }

// ---------------------------------------------------------------- adversarial requests

When('an entry is posted with no token', async function () { await send(this, 'POST', '/journal-entries', { body: { entry_date: books.bizDay, lines: twoLine(1, 9, 1000) } }); });
When('an entry is posted with a forged token', async function () { await send(this, 'POST', '/journal-entries', { token: FORGED, body: { entry_date: books.bizDay, lines: twoLine(1, 9, 1000) } }); });
When('entry {int} is read with no token', async function (id) { await send(this, 'GET', '/journal-entries/' + id); });
When('the admin entry list is read with the accountant\'s token', async function () { await send(this, 'GET', '/admin/entries', { token: books.seedBook }); });
When('the admin overview is read with the accountant\'s token', async function () { await send(this, 'GET', '/admin/overview', { token: books.seedBook }); });
When('the admin overview is read with a token that extends the admin token', async function () { await send(this, 'GET', '/admin/overview', { token: books.adminToken + 'x' }); });
When('the trial balance is read with no token', async function () { await send(this, 'GET', '/reports/trial-balance'); });
When('the chart of accounts is read with no token', async function () { await send(this, 'GET', '/accounts'); });
When('an accountant registers', async function () { await send(this, 'POST', '/users', { body: { name: 'Sec Accountant' } }); });

// ---------------------------------------------------------------- generic assertions

Then('the response is an error with code {string}', function (code) {
  check(this, 'error code ' + code, () => ({ passed: !!this.api && this.api.body && this.api.body.code === code, detail: this.api && this.api.body ? j(this.api.body) : 'no body' }));
});
Then('the response carries a token', function () {
  check(this, 'response carries a token', () => { const t = (this.api && this.api.body || {}).token; return { passed: typeof t === 'string' && t.length > 0, detail: 'token ' + (t ? 'present' : 'absent') }; });
});

// ---------------------------------------------------------------- secret hygiene

Then('the entry response carries no bearer token', function () { check(this, 'entry body has no token', () => ({ passed: !leaksToken(this.entry, books.adminToken), detail: leaksToken(this.entry, books.adminToken) ? 'TOKEN LEAKED' : 'clean' })); });
Then('the accounts response carries no bearer token', function () { check(this, 'accounts body has no token', () => ({ passed: !leaksToken(this.api && this.api.body, books.adminToken), detail: leaksToken(this.api && this.api.body, books.adminToken) ? 'TOKEN LEAKED' : 'clean' })); });
Then('the report response carries no bearer token', function () { check(this, 'report body has no token', () => ({ passed: !leaksToken(this.api && this.api.body, books.adminToken), detail: leaksToken(this.api && this.api.body, books.adminToken) ? 'TOKEN LEAKED' : 'clean' })); });

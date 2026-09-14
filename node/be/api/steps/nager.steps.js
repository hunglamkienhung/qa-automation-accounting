'use strict';

const { When, Then } = require('@cucumber/cucumber');
const nager = require('../venues/nager');

/**
 * Steps for features/be-nager-api.feature. The business-day steps are pure and
 * deterministic. The live steps read Nager.Date; a transport failure sets
 * sourceError and grades Blocked. One flow feeds a real holiday list into the
 * business-day rule to compute a settlement date -- the date a business would
 * post or settle on -- skipping weekends and public holidays, end to end.
 */

async function live(world, fn) {
  if (world.sourceError) return undefined;
  try { return await fn(); } catch (err) { if (err instanceof nager.NagerUnreachable) { world.sourceError = err.message; return undefined; } throw err; }
}
function check(world, description, fn) {
  if (world.sourceError) { world.unobservable(description, 'the source could not be reached -- ' + world.sourceError); return; }
  const r = fn(); world.check(description, r.passed, r.detail);
}
const j = (v) => JSON.stringify(v);

// ---------------------------------------------------------------- pure business-day rule

When('the weekend flag of {word} is checked', function (date) { this.weekend = nager.isWeekend(date); });
When('the business day after {word} is computed with no holidays', function (date) { this.businessDay = nager.nextBusinessDay(date, new Set()); });
Then('it is a weekend', function () { this.check('is a weekend', this.weekend === true, 'weekend ' + this.weekend); });
Then('it is a weekday', function () { this.check('is a weekday', this.weekend === false, 'weekend ' + this.weekend); });
Then('the business day is {word}', function (expected) { this.check('business day == ' + expected, this.businessDay === expected, 'got ' + this.businessDay); });

// ---------------------------------------------------------------- live holidays

When('the holidays for {int} in {word} are fetched', { timeout: 30_000 }, async function (year, country) { await live(this, async () => { this.hol = (await nager.holidays(year, country)).body; }); });
When('the holidays for {int} in {word} are fetched again', { timeout: 30_000 }, async function (year, country) { await live(this, async () => { this.hol2 = (await nager.holidays(year, country)).body; }); });
When('the available countries are fetched', { timeout: 30_000 }, async function () { await live(this, async () => { this.countries = (await nager.availableCountries()).body; }); });
When('the settlement date after {word} in {word} is computed', { timeout: 30_000 }, async function (date, country) { await live(this, async () => { const list = (await nager.holidays(2024, country)).body; this.holSet = nager.holidaySet(list); this.settleFrom = date; this.settle = nager.nextBusinessDay(date, this.holSet); }); });

Then('the holiday list is non-empty', function () { check(this, 'holiday list non-empty', () => ({ passed: Array.isArray(this.hol) && this.hol.length > 0, detail: (this.hol || []).length + ' holidays' })); });
Then('the holiday list has {int} entries', function (n) { check(this, 'holiday list has ' + n, () => ({ passed: Array.isArray(this.hol) && this.hol.length === n, detail: (this.hol || []).length + ' holidays' })); });
Then('the list includes a holiday on {word}', function (date) { check(this, 'holiday on ' + date, () => ({ passed: Array.isArray(this.hol) && this.hol.some((h) => h.date === date), detail: this.hol ? this.hol.map((h) => h.date).join(',').slice(0, 80) : 'no list' })); });
Then('every holiday has a date and a name', function () { check(this, 'every holiday has date + name', () => { const bad = (this.hol || []).filter((h) => !/^\d{4}-\d{2}-\d{2}$/.test(h.date) || !(h.name && h.name.length)); return { passed: (this.hol || []).length > 0 && bad.length === 0, detail: bad.length ? 'bad ' + j(bad.slice(0, 2)) : (this.hol || []).length + ' ok' }; }); });
Then('both holiday reads return identical dates', function () { check(this, 'holiday list stable', () => ({ passed: j((this.hol || []).map((h) => h.date)) === j((this.hol2 || []).map((h) => h.date)), detail: 'a ' + (this.hol || []).length + ' b ' + (this.hol2 || []).length })); });
Then('the available countries include {word} and {word}', function (a, b) { check(this, 'countries include ' + a + ',' + b, () => { const codes = (this.countries || []).map((c) => c.countryCode); return { passed: codes.includes(a) && codes.includes(b), detail: codes.length + ' countries' }; }); });

Then('the settlement date is {word}', function (expected) { check(this, 'settlement date == ' + expected, () => ({ passed: this.settle === expected, detail: 'from ' + this.settleFrom + ' -> ' + this.settle })); });
Then('the settlement date is a business day', function () { check(this, 'settlement is a business day', () => ({ passed: nager.isBusinessDay(this.settle, this.holSet), detail: this.settle + ' weekend? ' + nager.isWeekend(this.settle) + ' holiday? ' + this.holSet.has(this.settle) })); });

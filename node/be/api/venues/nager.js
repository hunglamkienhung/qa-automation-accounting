'use strict';

/**
 * Nager.Date's public holiday API: date.nager.at. No key, read-only.
 *
 * A past year's holiday list is settled and never changes, so those are
 * asserted by value and compared across two reads. A transport failure, a
 * 5xx/429, or a non-JSON body is NagerUnreachable, which grades Blocked: the
 * calendar service being unreachable is not the calendar being wrong.
 *
 * `nextBusinessDay` is a pure function -- the QA-side settlement rule that finds
 * the first business day after a date, skipping weekends and public holidays. It
 * takes no network, so the scenarios that exercise it are deterministic; the
 * live tier feeds a real holiday list through it.
 */

const BASE = (process.env.NAGER_URL || 'https://date.nager.at/api/v3').replace(/\/+$/, '');
const TIMEOUT_MS = 25_000;

class NagerUnreachable extends Error {}

async function request(path) {
  const init = { method: 'GET', headers: { accept: 'application/json' }, signal: AbortSignal.timeout(TIMEOUT_MS) };
  let res;
  try { res = await fetch(BASE + path, init); } catch (err) { throw new NagerUnreachable('GET ' + path + ' -- ' + (err.cause && err.cause.code ? err.cause.code : (err.name || err.message))); }
  const text = await res.text();
  if (res.status >= 500 || res.status === 429) throw new NagerUnreachable('GET ' + path + ' -- HTTP ' + res.status);
  let body; try { body = JSON.parse(text); } catch { body = null; }
  if (body === null || typeof body !== 'object') throw new NagerUnreachable('GET ' + path + ' -- expected JSON, got ' + text.slice(0, 40).replace(/\s+/g, ' ') + '…');
  return { httpStatus: res.status, body };
}

const holidays = (year = 2024, country = 'US') => request('/PublicHolidays/' + year + '/' + country);
const availableCountries = () => request('/AvailableCountries');

// ---- pure business-day arithmetic (UTC, no timezone drift) ----
function addDays(dateStr, n) { const d = new Date(dateStr + 'T00:00:00Z'); d.setUTCDate(d.getUTCDate() + n); return d.toISOString().slice(0, 10); }
function isWeekend(dateStr) { const day = new Date(dateStr + 'T00:00:00Z').getUTCDay(); return day === 0 || day === 6; }
function isBusinessDay(dateStr, holidaySet) { return !isWeekend(dateStr) && !holidaySet.has(dateStr); }
/** The first business day strictly after `dateStr`, skipping weekends and holidays. */
function nextBusinessDay(dateStr, holidaySet) { let d = addDays(dateStr, 1); while (!isBusinessDay(d, holidaySet)) d = addDays(d, 1); return d; }
/** Set of holiday date strings from a Nager holiday list. */
function holidaySet(list) { return new Set((list || []).map((h) => h.date)); }

module.exports = { BASE, NagerUnreachable, request, holidays, availableCountries, addDays, isWeekend, isBusinessDay, nextBusinessDay, holidaySet };

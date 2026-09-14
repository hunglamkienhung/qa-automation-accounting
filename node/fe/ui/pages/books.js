'use strict';

/**
 * Page objects for the mini-books app surfaces. The server renders small,
 * labelled HTML pages -- the chart of accounts, an account, a journal entry, and
 * the trial-balance and balance-sheet reports. Each page object reads by label
 * so the assertions are about the accounting, not the markup. A page that never
 * loads (service down) surfaces as ScreenNotReady, which the steps turn into
 * Blocked.
 */

const BASE = (process.env.MINI_BOOKS_URL || 'http://127.0.0.1:8170').replace(/\/+$/, '');

class ScreenNotReady extends Error {}

class BooksPage {
  constructor(page) { this.page = page; this.base = BASE; }

  async open(path) {
    try { await this.page.goto(this.base + path, { waitUntil: 'domcontentloaded', timeout: 15_000 }); }
    catch (err) { throw new ScreenNotReady('mini-books page ' + path + ' did not load: ' + err.message); }
  }

  async accounts() {
    await this.page.waitForSelector('ul.accounts li.account', { timeout: 15_000 }).catch(() => { throw new ScreenNotReady('home never rendered'); });
    return this.page.$$eval('ul.accounts li.account', (els) => els.map((el) => ({
      id: Number(el.getAttribute('data-id')),
      code: el.querySelector('.code') ? el.querySelector('.code').textContent.trim() : '',
      name: el.querySelector('.name') ? el.querySelector('.name').textContent.trim() : '',
      type: el.querySelector('.type') ? el.querySelector('.type').textContent.trim() : '',
      balanceText: el.querySelector('.balance') ? el.querySelector('.balance').textContent.trim() : '',
    })));
  }

  async account() {
    await this.page.waitForSelector('h1.account-name', { timeout: 15_000 }).catch(() => { throw new ScreenNotReady('account page never rendered'); });
    return {
      nameText: await this.page.$eval('h1.account-name', (e) => e.textContent.trim()),
      codeText: await this.page.$eval('.code', (e) => e.textContent.trim()),
      typeText: await this.page.$eval('.type', (e) => e.textContent.trim()),
      balanceText: await this.page.$eval('.balance', (e) => e.textContent.trim()),
    };
  }

  async entry() {
    await this.page.waitForSelector('h1.entry-id', { timeout: 15_000 }).catch(() => { throw new ScreenNotReady('entry page never rendered'); });
    return {
      idText: await this.page.$eval('h1.entry-id', (e) => e.textContent.trim()),
      dateText: await this.page.$eval('.date', (e) => e.textContent.trim()),
      statusText: await this.page.$eval('.status', (e) => e.textContent.trim()),
      lines: await this.page.$$eval('ul.lines li.line', (els) => els.map((el) => ({ code: el.querySelector('.code') ? el.querySelector('.code').textContent.trim() : '', side: el.querySelector('.side') ? el.querySelector('.side').textContent.trim() : '', amount: el.querySelector('.amount') ? el.querySelector('.amount').textContent.trim() : '' }))),
    };
  }

  async trialBalance() {
    await this.page.waitForSelector('p.balanced', { timeout: 15_000 }).catch(() => { throw new ScreenNotReady('trial balance never rendered'); });
    return { debitsText: await this.page.$eval('.debits', (e) => e.textContent.trim()), creditsText: await this.page.$eval('.credits', (e) => e.textContent.trim()), balancedText: await this.page.$eval('.balanced', (e) => e.textContent.trim()) };
  }

  async balanceSheet() {
    await this.page.waitForSelector('p.balanced', { timeout: 15_000 }).catch(() => { throw new ScreenNotReady('balance sheet never rendered'); });
    return {
      assetsText: await this.page.$eval('.assets', (e) => e.textContent.trim()),
      liabilitiesText: await this.page.$eval('.liabilities', (e) => e.textContent.trim()),
      equityText: await this.page.$eval('.equity', (e) => e.textContent.trim()),
      netIncomeText: await this.page.$eval('.net-income', (e) => e.textContent.trim()),
      balancedText: await this.page.$eval('.balanced', (e) => e.textContent.trim()),
    };
  }

  async admin() {
    await this.page.waitForSelector('p.balanced', { timeout: 15_000 }).catch(() => { throw new ScreenNotReady('admin page never rendered'); });
    return { entriesText: await this.page.$eval('.entries', (e) => e.textContent.trim()), balancedText: await this.page.$eval('.balanced', (e) => e.textContent.trim()) };
  }
}

module.exports = { BooksPage, ScreenNotReady, BASE };

'use strict';

const fs = require('fs');
const path = require('path');
const { DatabaseSync } = require('node:sqlite');

/**
 * Read-only access to the mini-books SQLite file -- the same file the service
 * writes. The DB tier asserts on its rows; the API tier reads them to compare
 * with HTTP responses. A missing file is DbUnreachable and grades Blocked.
 */

const DB_FILE = process.env.MINI_BOOKS_DB
  || path.join(__dirname, '..', '..', '..', 'services', 'mini-books', 'data', 'mini-books.db');
const SCHEMA = path.join(__dirname, '..', '..', '..', 'services', 'mini-books', 'db', 'schema.sql');
const DEBIT_NORMAL = new Set(['asset', 'expense']);

class DbUnreachable extends Error {}

class Store {
  constructor(file = DB_FILE) {
    if (!fs.existsSync(file)) throw new DbUnreachable('no store at ' + file + ' -- start mini-books (services/mini-books/serve.sh up)');
    this.file = file;
    try { this.db = new DatabaseSync(file, { readOnly: true }); } catch (err) { throw new DbUnreachable('cannot open ' + file + ': ' + err.message); }
  }
  close() { try { this.db.close(); } catch { /* already closed */ } }
  all(sql, ...p) { return this.db.prepare(sql).all(...p); }
  get(sql, ...p) { return this.db.prepare(sql).get(...p); }
  count(table, where = '', ...p) { return Number(this.get(`SELECT COUNT(*) AS n FROM ${table} ${where}`, ...p).n); }
  tables() { return this.all("SELECT name FROM sqlite_master WHERE type = 'table' ORDER BY name").map((r) => r.name); }

  /** The lines of one entry, oldest first. */
  lines(entryId) { return this.all('SELECT * FROM lines WHERE entry_id = ? ORDER BY id', entryId); }
  /** Grand totals of every debit and every credit line -- must be equal. */
  grandTotals() { return this.get("SELECT COALESCE(SUM(CASE WHEN side='debit' THEN amount_cents ELSE 0 END),0) AS debit, COALESCE(SUM(CASE WHEN side='credit' THEN amount_cents ELSE 0 END),0) AS credit FROM lines"); }
  /** Natural (normal-sign) balance of an account by id. */
  accountBalance(id) {
    const a = this.get('SELECT type FROM accounts WHERE id = ?', id);
    const t = this.get("SELECT COALESCE(SUM(CASE WHEN side='debit' THEN amount_cents ELSE 0 END),0) AS debit, COALESCE(SUM(CASE WHEN side='credit' THEN amount_cents ELSE 0 END),0) AS credit FROM lines WHERE account_id = ?", id);
    return DEBIT_NORMAL.has(a.type) ? t.debit - t.credit : t.credit - t.debit;
  }
  /** Total natural balance across all accounts of a type. */
  typeTotal(type) {
    let s = 0;
    for (const a of this.all('SELECT id FROM accounts WHERE type = ?', type)) s += this.accountBalance(a.id);
    return s;
  }
}

/** A throwaway in-memory store with the schema applied, for constraint checks. */
function throwaway() {
  const db = new DatabaseSync(':memory:');
  db.exec('PRAGMA foreign_keys = ON');
  db.exec(fs.readFileSync(SCHEMA, 'utf8').replace(/PRAGMA journal_mode = WAL;/, ''));
  return db;
}

module.exports = { Store, DbUnreachable, DB_FILE, throwaway };

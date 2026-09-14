"""Page objects for the mini-books app surfaces. Mirror of node/fe/ui/pages/books.js.
Reads by label so the assertions are about the accounting, not the markup. A page
that never loads raises ScreenNotReady (grades Blocked).
"""

from __future__ import annotations

import os

BASE = os.environ.get("MINI_BOOKS_URL", "http://127.0.0.1:8170").rstrip("/")


class ScreenNotReady(Exception):
    pass


class BooksPage:
    def __init__(self, page) -> None:
        self.page = page
        self.base = BASE

    def open(self, path):
        try:
            self.page.goto(self.base + path, wait_until="domcontentloaded", timeout=15000)
        except Exception as err:  # noqa: BLE001
            raise ScreenNotReady(f"mini-books page {path} did not load: {err}") from err

    def accounts(self):
        try:
            self.page.wait_for_selector("ul.accounts li.account", timeout=15000)
        except Exception as err:  # noqa: BLE001
            raise ScreenNotReady("home never rendered") from err
        return self.page.eval_on_selector_all("ul.accounts li.account", """els => els.map(el => ({
            id: Number(el.getAttribute('data-id')),
            code: el.querySelector('.code') ? el.querySelector('.code').textContent.trim() : '',
            name: el.querySelector('.name') ? el.querySelector('.name').textContent.trim() : '',
            type: el.querySelector('.type') ? el.querySelector('.type').textContent.trim() : '',
            balanceText: el.querySelector('.balance') ? el.querySelector('.balance').textContent.trim() : '',
        }))""")

    def account(self):
        try:
            self.page.wait_for_selector("h1.account-name", timeout=15000)
        except Exception as err:  # noqa: BLE001
            raise ScreenNotReady("account page never rendered") from err
        return {
            "nameText": self.page.eval_on_selector("h1.account-name", "e => e.textContent.trim()"),
            "codeText": self.page.eval_on_selector(".code", "e => e.textContent.trim()"),
            "typeText": self.page.eval_on_selector(".type", "e => e.textContent.trim()"),
            "balanceText": self.page.eval_on_selector(".balance", "e => e.textContent.trim()"),
        }

    def entry(self):
        try:
            self.page.wait_for_selector("h1.entry-id", timeout=15000)
        except Exception as err:  # noqa: BLE001
            raise ScreenNotReady("entry page never rendered") from err
        return {
            "idText": self.page.eval_on_selector("h1.entry-id", "e => e.textContent.trim()"),
            "dateText": self.page.eval_on_selector(".date", "e => e.textContent.trim()"),
            "statusText": self.page.eval_on_selector(".status", "e => e.textContent.trim()"),
            "lines": self.page.eval_on_selector_all("ul.lines li.line", """els => els.map(el => ({
                code: el.querySelector('.code') ? el.querySelector('.code').textContent.trim() : '',
                side: el.querySelector('.side') ? el.querySelector('.side').textContent.trim() : '',
                amount: el.querySelector('.amount') ? el.querySelector('.amount').textContent.trim() : '',
            }))"""),
        }

    def trial_balance(self):
        try:
            self.page.wait_for_selector("p.balanced", timeout=15000)
        except Exception as err:  # noqa: BLE001
            raise ScreenNotReady("trial balance never rendered") from err
        return {
            "debitsText": self.page.eval_on_selector(".debits", "e => e.textContent.trim()"),
            "creditsText": self.page.eval_on_selector(".credits", "e => e.textContent.trim()"),
            "balancedText": self.page.eval_on_selector(".balanced", "e => e.textContent.trim()"),
        }

    def balance_sheet(self):
        try:
            self.page.wait_for_selector("p.balanced", timeout=15000)
        except Exception as err:  # noqa: BLE001
            raise ScreenNotReady("balance sheet never rendered") from err
        return {
            "assetsText": self.page.eval_on_selector(".assets", "e => e.textContent.trim()"),
            "liabilitiesText": self.page.eval_on_selector(".liabilities", "e => e.textContent.trim()"),
            "equityText": self.page.eval_on_selector(".equity", "e => e.textContent.trim()"),
            "netIncomeText": self.page.eval_on_selector(".net-income", "e => e.textContent.trim()"),
            "balancedText": self.page.eval_on_selector(".balanced", "e => e.textContent.trim()"),
        }

    def admin(self):
        try:
            self.page.wait_for_selector("p.balanced", timeout=15000)
        except Exception as err:  # noqa: BLE001
            raise ScreenNotReady("admin page never rendered") from err
        return {
            "entriesText": self.page.eval_on_selector(".entries", "e => e.textContent.trim()"),
            "balancedText": self.page.eval_on_selector(".balanced", "e => e.textContent.trim()"),
        }

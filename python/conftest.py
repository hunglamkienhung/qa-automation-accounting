"""Domain wiring for pytest: the shared recorder, @case:N binding, and the
step plugins for every tier. The Node stack mirrors this in support/world.js.
"""

from __future__ import annotations

import pytest

from qa_core.recorder import qa, pytest_bdd_apply_tag, pytest_bdd_after_scenario  # noqa: F401

pytest_plugins = [
    "be.db.steps.books_steps",
    "be.api.steps.journal_steps",
    "be.api.steps.reports_steps",
    "be.api.steps.integrity_steps",
    "be.api.steps.security_steps",
    "be.api.steps.nager_steps",
]


def _case_id_of(node):
    marker = node.get_closest_marker("case_id")
    if marker is not None:
        return marker.args[0]
    for mark in node.iter_markers():
        if mark.name.startswith("case:"):
            return mark.name.split(":", 1)[1]
    return None


@pytest.fixture(autouse=True)
def bind_case(request, qa):
    case_id = _case_id_of(request.node)
    if case_id is None:
        return
    qa.case(case_id)
    for slot in ("store", "account", "entry", "report", "api"):
        setattr(qa, slot, None)
    qa.screen = {}

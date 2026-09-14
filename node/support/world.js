"use strict";

// Wire the shared Cucumber harness to this domain. The World is the core
// Recorder plus the slots this domain fills: the mini-books DB, an HTTP
// response, and the screen for one of the app pages.
require("@portfolio/core/harness/cucumber").install({
  browserTag: "@fe",
  viewport: { width: 1440, height: 900 },
  extendWorld(world) {
    world.store = null;    // rows read from the mini-books SQLite
    world.account = null;  // an account under test
    world.entry = null;    // a journal entry just posted
    world.report = null;   // a report body just fetched
    world.api = null;      // an HTTP response (mini-books or the live Nager.Date)
    world.screen = {};     // values read off an app page
  },
});

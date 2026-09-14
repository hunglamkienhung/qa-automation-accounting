# Double-entry accounting — test cases

1000 cases across a self-written mini-books service (a real SQLite store behind the chart of accounts, journal entries, reversals and the financial reports) and the live Nager.Date public-holiday API. Generated from `../features/*.feature` by `build.js`; do not edit by hand.

## mini-books-db (190)

| ID | Layer | Priority | Title |
|---|---|---|---|
| 1 | BE/DB | High | The store has the documented tables |
| 2 | BE/DB | High | An account type is one of the five |
| 3 | BE/DB | High | A line references a real entry and account |
| 4 | BE/DB | High | A line side is a debit or a credit |
| 5 | BE/DB | High | A line amount is positive |
| 6 | BE/DB | High | An entry status is posted or reversed |
| 7 | BE/DB | Medium | An account active flag is a boolean |
| 8 | BE/DB | High | An entry number is unique |
| 9 | BE/DB | Medium | An account code is unique |
| 10 | BE/DB | Medium | An entry idempotency key is unique |
| 11 | BE/DB | Medium | Seeding twice leaves the same rows |
| 12 | BE/DB | High | The seeded books already balance |
| 13 | BE/DB | High | The chart of accounts covers all five types |
| 14 | BE/DB | Medium | The opening entry is a balanced pair |
| 15 | BE/DB | High | A cash sale writes a balanced two-line entry |
| 16 | BE/DB | High | The cash sale debits Cash and credits Sales Revenue |
| 17 | BE/DB | High | Paying rent debits Rent Expense and credits Cash |
| 18 | BE/DB | High | A cash sale raises Cash and Sales by the amount |
| 19 | BE/DB | High | Paying rent lowers Cash and raises Rent Expense |
| 20 | BE/DB | High | An owner investment raises Cash and Owner Capital |
| 21 | BE/DB | High | Posting keeps the whole ledger balanced |
| 22 | BE/DB | High | An entry is given the next number |
| 23 | BE/DB | High | Entry numbers are gapless |
| 24 | BE/DB | Medium | A repeated post with one key writes one entry |
| 25 | BE/DB | High | A reversal writes the original lines with their sides swapped |
| 26 | BE/DB | High | A reversal keeps the whole ledger balanced |
| 27 | BE/DB | Medium | No line references a missing entry or account |
| 28 | BE/DB | High | Every entry has at least two lines and balances |
| 29 | BE/DB | Medium | A balanced entry Dr <dr> Cr <cr> for <amount> writes two balanced lines |
| 30 | BE/DB | Medium | A balanced entry Dr <dr> Cr <cr> for <amount> writes two balanced lines |
| 31 | BE/DB | Medium | A balanced entry Dr <dr> Cr <cr> for <amount> writes two balanced lines |
| 32 | BE/DB | Medium | A balanced entry Dr <dr> Cr <cr> for <amount> writes two balanced lines |
| 33 | BE/DB | Medium | A balanced entry Dr <dr> Cr <cr> for <amount> writes two balanced lines |
| 34 | BE/DB | Medium | A balanced entry Dr <dr> Cr <cr> for <amount> writes two balanced lines |
| 35 | BE/DB | Medium | A balanced entry Dr <dr> Cr <cr> for <amount> writes two balanced lines |
| 36 | BE/DB | Medium | A balanced entry Dr <dr> Cr <cr> for <amount> writes two balanced lines |
| 37 | BE/DB | Medium | A balanced entry Dr <dr> Cr <cr> for <amount> writes two balanced lines |
| 38 | BE/DB | Medium | A balanced entry Dr <dr> Cr <cr> for <amount> writes two balanced lines |
| 39 | BE/DB | Medium | A balanced entry Dr <dr> Cr <cr> for <amount> writes two balanced lines |
| 40 | BE/DB | Medium | A balanced entry Dr <dr> Cr <cr> for <amount> writes two balanced lines |
| 41 | BE/DB | Medium | Debiting a <type> account (<dr>) and crediting Cash moves it by its normal sign |
| 42 | BE/DB | Medium | Debiting a <type> account (<dr>) and crediting Cash moves it by its normal sign |
| 43 | BE/DB | Medium | Debiting a <type> account (<dr>) and crediting Cash moves it by its normal sign |
| 44 | BE/DB | Medium | Debiting a <type> account (<dr>) and crediting Cash moves it by its normal sign |
| 45 | BE/DB | Medium | Crediting a <type> account (<cr>) and debiting Cash moves it by its normal sign |
| 46 | BE/DB | Medium | Crediting a <type> account (<cr>) and debiting Cash moves it by its normal sign |
| 47 | BE/DB | Medium | Crediting a <type> account (<cr>) and debiting Cash moves it by its normal sign |
| 48 | BE/DB | Medium | Crediting a <type> account (<cr>) and debiting Cash moves it by its normal sign |
| 398 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 399 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 400 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 401 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 402 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 403 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 404 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 405 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 406 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 407 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 408 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 409 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 410 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 411 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 412 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 413 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 414 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 415 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 416 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 417 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 418 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 419 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 420 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 421 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 422 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 423 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 424 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 425 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 426 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 427 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 428 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 429 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 430 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 431 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 432 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 433 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 434 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 435 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 436 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 437 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 438 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 439 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 512 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 513 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 514 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 515 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 516 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 517 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 518 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 519 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 520 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 521 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 522 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 523 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 524 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 525 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 526 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 527 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 528 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 529 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 530 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 531 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 532 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 533 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 534 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 535 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 536 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 537 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 538 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 539 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 540 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 541 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 542 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 543 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 544 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 545 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 546 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 547 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 548 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 549 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 550 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 551 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 552 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 553 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 554 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 555 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 556 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 557 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 558 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 559 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 560 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 561 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 562 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 563 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 564 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 565 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 566 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 567 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 568 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 569 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 570 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 571 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 572 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 573 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 574 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 575 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 576 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 577 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 578 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 579 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 580 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 581 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 582 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 583 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 584 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 585 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 586 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 587 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 588 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 589 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 590 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 591 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 592 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 593 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 594 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 595 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 596 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 597 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 598 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 599 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 600 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 601 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 602 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 603 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 604 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 605 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 606 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 607 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 608 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 609 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 610 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |
| 611 | BE/DB | Medium | More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair |

## mini-books-journal (224)

| ID | Layer | Priority | Title |
|---|---|---|---|
| 49 | BE/API | High | A balanced two-line entry posts |
| 50 | BE/API | High | A posted entry is given a number and two lines |
| 51 | BE/API | High | A three-line entry that balances posts |
| 52 | BE/API | Medium | A posted entry can be read back |
| 53 | BE/API | Medium | The entry list includes what was posted |
| 54 | BE/API | High | An entry whose debits do not equal its credits is refused |
| 55 | BE/API | High | An entry with a single line is refused |
| 56 | BE/API | High | An entry dated on a weekend is refused |
| 57 | BE/API | Medium | An entry with a malformed date is a bad request |
| 58 | BE/API | High | An entry touching an archived account is refused |
| 59 | BE/API | High | An entry mixing currencies is refused |
| 60 | BE/API | Medium | An entry to an account that does not exist is not found |
| 61 | BE/API | Medium | An entry with a zero amount is a bad request |
| 62 | BE/API | Medium | An entry with a negative amount is a bad request |
| 63 | BE/API | High | Posting without a token is unauthenticated |
| 64 | BE/API | High | A forged token cannot post |
| 65 | BE/API | High | A repeated post with one key makes one entry |
| 66 | BE/API | Medium | An entry dated <date> (<what>) is <verdict> |
| 67 | BE/API | Medium | An entry dated <date> (<what>) is <verdict> |
| 68 | BE/API | Medium | An entry dated <date> (<what>) is <verdict> |
| 69 | BE/API | Medium | An entry dated <date> (<what>) is <verdict> |
| 70 | BE/API | Medium | An entry dated <date> (<what>) is <verdict> |
| 71 | BE/API | Medium | An entry dated <date> (<what>) is <verdict> |
| 72 | BE/API | Medium | An entry dated <date> (<what>) is <verdict> |
| 73 | BE/API | Medium | An entry dated <date> (<what>) is <verdict> |
| 74 | BE/API | Medium | An entry dated <date> (<what>) is <verdict> |
| 75 | BE/API | Medium | An entry dated <date> (<what>) is <verdict> |
| 76 | BE/API | Medium | Booking <name> (Dr <dr> Cr <cr> for <amount>) posts and balances |
| 77 | BE/API | Medium | Booking <name> (Dr <dr> Cr <cr> for <amount>) posts and balances |
| 78 | BE/API | Medium | Booking <name> (Dr <dr> Cr <cr> for <amount>) posts and balances |
| 79 | BE/API | Medium | Booking <name> (Dr <dr> Cr <cr> for <amount>) posts and balances |
| 80 | BE/API | Medium | Booking <name> (Dr <dr> Cr <cr> for <amount>) posts and balances |
| 81 | BE/API | Medium | Booking <name> (Dr <dr> Cr <cr> for <amount>) posts and balances |
| 82 | BE/API | Medium | Booking <name> (Dr <dr> Cr <cr> for <amount>) posts and balances |
| 83 | BE/API | Medium | Booking <name> (Dr <dr> Cr <cr> for <amount>) posts and balances |
| 84 | BE/API | Medium | Booking <name> (Dr <dr> Cr <cr> for <amount>) posts and balances |
| 85 | BE/API | Medium | Booking <name> (Dr <dr> Cr <cr> for <amount>) posts and balances |
| 86 | BE/API | Medium | Booking <name> (Dr <dr> Cr <cr> for <amount>) posts and balances |
| 87 | BE/API | Medium | Booking <name> (Dr <dr> Cr <cr> for <amount>) posts and balances |
| 88 | BE/API | Medium | Booking <name> (Dr <dr> Cr <cr> for <amount>) posts and balances |
| 89 | BE/API | Medium | Booking <name> (Dr <dr> Cr <cr> for <amount>) posts and balances |
| 90 | BE/API | Medium | Booking <name> (Dr <dr> Cr <cr> for <amount>) posts and balances |
| 91 | BE/API | Medium | Booking <name> (Dr <dr> Cr <cr> for <amount>) posts and balances |
| 92 | BE/API | Medium | Booking <name> (Dr <dr> Cr <cr> for <amount>) posts and balances |
| 93 | BE/API | Medium | Booking <name> (Dr <dr> Cr <cr> for <amount>) posts and balances |
| 94 | BE/API | Medium | Booking <name> (Dr <dr> Cr <cr> for <amount>) posts and balances |
| 95 | BE/API | Medium | Booking <name> (Dr <dr> Cr <cr> for <amount>) posts and balances |
| 96 | BE/API | Medium | Booking <name> (Dr <dr> Cr <cr> for <amount>) posts and balances |
| 97 | BE/API | Medium | Booking <name> (Dr <dr> Cr <cr> for <amount>) posts and balances |
| 98 | BE/API | Medium | Booking <name> (Dr <dr> Cr <cr> for <amount>) posts and balances |
| 99 | BE/API | Medium | Booking <name> (Dr <dr> Cr <cr> for <amount>) posts and balances |
| 100 | BE/API | Medium | Booking <name> (Dr <dr> Cr <cr> for <amount>) posts and balances |
| 264 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 265 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 266 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 267 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 268 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 269 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 270 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 271 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 272 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 273 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 274 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 275 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 276 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 277 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 278 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 279 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 280 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 281 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 282 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 283 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 284 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 285 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 286 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 287 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 288 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 289 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 290 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 291 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 292 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 293 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 294 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 295 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 296 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 297 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 298 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 299 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 300 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 301 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 302 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 303 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 304 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 305 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 306 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 307 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 308 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 309 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 310 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 311 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 312 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 313 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 314 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 315 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 316 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 317 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 318 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 319 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 320 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 321 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 322 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 323 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 324 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 325 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 326 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 327 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 328 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 329 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 330 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 331 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 332 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 333 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 334 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 335 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 612 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 613 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 614 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 615 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 616 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 617 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 618 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 619 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 620 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 621 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 622 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 623 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 624 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 625 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 626 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 627 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 628 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 629 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 630 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 631 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 632 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 633 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 634 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 635 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 636 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 637 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 638 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 639 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 640 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 641 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 642 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 643 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 644 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 645 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 646 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 647 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 648 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 649 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 650 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 651 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 652 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 653 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 654 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 655 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 656 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 657 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 658 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 659 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 660 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 661 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 662 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 663 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 664 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 665 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 666 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 667 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 668 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 669 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 670 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 671 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 672 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 673 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 674 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 675 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 676 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 677 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 678 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 679 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 680 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 681 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 682 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 683 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 684 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 685 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 686 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 687 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 688 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 689 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 690 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 691 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 692 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 693 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 694 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 695 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 696 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 697 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 698 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 699 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 700 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 701 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 702 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 703 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 704 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 705 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 706 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 707 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 708 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 709 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 710 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |
| 711 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> posts and balances |

## mini-books-reports (217)

| ID | Layer | Priority | Title |
|---|---|---|---|
| 101 | BE/API | High | The trial balance's debits equal its credits |
| 102 | BE/API | High | The balance sheet balances |
| 103 | BE/API | High | Net income is revenue less expenses |
| 104 | BE/API | High | The accounting equation holds |
| 105 | BE/API | High | The trial balance stays balanced after a cash sale |
| 106 | BE/API | High | The balance sheet stays balanced after a purchase on credit |
| 107 | BE/API | High | The equation holds after paying an expense |
| 108 | BE/API | Medium | The trial balance lists a debit balance for an asset |
| 109 | BE/API | Medium | The trial balance lists a credit balance for equity |
| 110 | BE/API | Medium | Booking <name> moves reported <figure> by <sign><amount> |
| 111 | BE/API | Medium | Booking <name> moves reported <figure> by <sign><amount> |
| 112 | BE/API | Medium | Booking <name> moves reported <figure> by <sign><amount> |
| 113 | BE/API | Medium | Booking <name> moves reported <figure> by <sign><amount> |
| 114 | BE/API | Medium | Booking <name> moves reported <figure> by <sign><amount> |
| 115 | BE/API | Medium | Booking <name> moves reported <figure> by <sign><amount> |
| 116 | BE/API | Medium | Booking <name> moves reported <figure> by <sign><amount> |
| 117 | BE/API | Medium | Booking <name> moves reported <figure> by <sign><amount> |
| 118 | BE/API | Medium | Booking <name> moves reported <figure> by <sign><amount> |
| 119 | BE/API | Medium | Booking <name> moves reported <figure> by <sign><amount> |
| 120 | BE/API | Medium | Booking <name> moves reported <figure> by <sign><amount> |
| 121 | BE/API | Medium | Booking <name> moves reported <figure> by <sign><amount> |
| 122 | BE/API | Medium | Booking <name> moves reported <figure> by <sign><amount> |
| 123 | BE/API | Medium | Booking <name> moves reported <figure> by <sign><amount> |
| 124 | BE/API | Medium | Booking <name> moves reported <figure> by <sign><amount> |
| 125 | BE/API | Medium | Booking <name> moves reported <figure> by <sign><amount> |
| 126 | BE/API | Medium | Booking <name> moves reported <figure> by <sign><amount> |
| 127 | BE/API | Medium | Booking <name> moves reported <figure> by <sign><amount> |
| 128 | BE/API | Medium | Booking <name> moves reported net income by <amount> |
| 129 | BE/API | Medium | Booking <name> moves reported net income by <amount> |
| 130 | BE/API | Medium | Booking <name> moves reported net income by <amount> |
| 131 | BE/API | Medium | Booking <name> moves reported net income by <amount> |
| 132 | BE/API | Medium | Booking <name> moves reported net income by <amount> |
| 133 | BE/API | Medium | Booking <name> moves reported net income by <amount> |
| 134 | BE/API | Medium | Booking <name> leaves reported <figure> unchanged |
| 135 | BE/API | Medium | Booking <name> leaves reported <figure> unchanged |
| 136 | BE/API | Medium | Booking <name> leaves reported <figure> unchanged |
| 137 | BE/API | Medium | Booking <name> leaves reported <figure> unchanged |
| 138 | BE/API | Medium | Booking <name> leaves reported <figure> unchanged |
| 139 | BE/API | Medium | Booking <name> leaves reported <figure> unchanged |
| 140 | BE/API | Medium | Booking <name> leaves reported <figure> unchanged |
| 141 | BE/API | Medium | After booking <name> the books stay balanced and the equation holds |
| 142 | BE/API | Medium | After booking <name> the books stay balanced and the equation holds |
| 143 | BE/API | Medium | After booking <name> the books stay balanced and the equation holds |
| 144 | BE/API | Medium | After booking <name> the books stay balanced and the equation holds |
| 145 | BE/API | Medium | After booking <name> the books stay balanced and the equation holds |
| 146 | BE/API | Medium | After booking <name> the books stay balanced and the equation holds |
| 147 | BE/API | Medium | After booking <name> the books stay balanced and the equation holds |
| 148 | BE/API | Medium | After booking <name> the books stay balanced and the equation holds |
| 149 | BE/API | Medium | After booking <name> the books stay balanced and the equation holds |
| 150 | BE/API | Medium | After booking <name> the books stay balanced and the equation holds |
| 151 | BE/API | Medium | After booking <name> the books stay balanced and the equation holds |
| 152 | BE/API | Medium | After booking <name> the books stay balanced and the equation holds |
| 153 | BE/API | Medium | After booking <name> the books stay balanced and the equation holds |
| 154 | BE/API | Medium | After booking <name> the books stay balanced and the equation holds |
| 155 | BE/API | Medium | After booking <name> the books stay balanced and the equation holds |
| 336 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 337 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 338 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 339 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 340 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 341 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 342 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 343 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 344 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 345 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 346 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 347 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 348 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 349 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 350 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 351 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 352 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 353 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 354 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 355 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 356 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 357 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 358 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 359 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 360 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 361 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 362 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 363 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 364 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 365 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 366 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 367 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 368 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 369 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 370 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 371 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 372 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 373 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 374 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 375 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 376 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 377 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 378 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 379 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 380 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 381 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 382 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 383 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 384 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 385 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 386 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 387 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 388 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 389 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 390 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 391 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 392 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 393 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 394 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 395 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 396 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 397 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 712 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 713 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 714 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 715 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 716 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 717 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 718 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 719 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 720 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 721 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 722 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 723 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 724 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 725 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 726 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 727 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 728 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 729 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 730 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 731 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 732 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 733 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 734 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 735 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 736 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 737 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 738 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 739 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 740 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 741 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 742 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 743 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 744 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 745 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 746 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 747 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 748 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 749 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 750 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 751 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 752 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 753 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 754 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 755 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 756 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 757 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 758 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 759 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 760 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 761 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 762 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 763 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 764 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 765 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 766 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 767 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 768 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 769 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 770 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 771 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 772 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 773 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 774 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 775 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 776 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 777 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 778 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 779 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 780 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 781 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 782 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 783 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 784 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 785 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 786 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 787 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 788 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 789 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 790 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 791 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 792 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 793 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 794 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 795 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 796 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 797 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 798 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 799 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 800 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 801 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 802 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 803 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 804 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 805 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 806 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 807 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 808 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 809 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 810 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 811 | BE/API | Medium | More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding |

## mini-books-integrity (115)

| ID | Layer | Priority | Title |
|---|---|---|---|
| 156 | BE/API | High | A chain of postings keeps the equation holding and the ledger balanced |
| 157 | BE/API | High | A three-line entry keeps the equation holding |
| 158 | BE/API | High | Reversing an entry restores the figures it moved |
| 159 | BE/API | High | A reversal keeps the equation holding |
| 160 | BE/API | High | An entry cannot be reversed twice |
| 161 | BE/API | High | A reversal cannot itself be reversed |
| 162 | BE/API | High | Only the admin may reverse an entry |
| 163 | BE/API | Medium | Reversing an entry that does not exist is not found |
| 164 | BE/API | High | Many entries posting at once are numbered without a gap or a duplicate |
| 165 | BE/API | High | A repeated post racing with one key posts exactly once |
| 166 | BE/API | High | The trial balance stays balanced after a burst of concurrent posting |
| 167 | BE/API | Medium | A burst of <racers> concurrent entries stays gapless |
| 168 | BE/API | Medium | A burst of <racers> concurrent entries stays gapless |
| 169 | BE/API | Medium | A burst of <racers> concurrent entries stays gapless |
| 170 | BE/API | Medium | A burst of <racers> concurrent entries stays gapless |
| 171 | BE/API | Medium | A burst of <racers> concurrent entries stays gapless |
| 172 | BE/API | Medium | <racers> racing idempotent posts make one entry |
| 173 | BE/API | Medium | <racers> racing idempotent posts make one entry |
| 174 | BE/API | Medium | <racers> racing idempotent posts make one entry |
| 175 | BE/API | Medium | A <type> account's balance carries its normal sign |
| 176 | BE/API | Medium | A <type> account's balance carries its normal sign |
| 177 | BE/API | Medium | A <type> account's balance carries its normal sign |
| 178 | BE/API | Medium | A <type> account's balance carries its normal sign |
| 179 | BE/API | Medium | A <type> account's balance carries its normal sign |
| 456 | BE/API | Medium | A larger burst of <racers> concurrent entries stays gapless |
| 457 | BE/API | Medium | A larger burst of <racers> concurrent entries stays gapless |
| 458 | BE/API | Medium | A larger burst of <racers> concurrent entries stays gapless |
| 459 | BE/API | Medium | A larger burst of <racers> concurrent entries stays gapless |
| 460 | BE/API | Medium | A larger burst of <racers> concurrent entries stays gapless |
| 461 | BE/API | Medium | A larger burst of <racers> concurrent entries stays gapless |
| 462 | BE/API | Medium | A larger burst of <racers> concurrent entries stays gapless |
| 463 | BE/API | Medium | A larger burst of <racers> concurrent entries stays gapless |
| 464 | BE/API | Medium | A larger burst of <racers> concurrent entries stays gapless |
| 465 | BE/API | Medium | A larger burst of <racers> concurrent entries stays gapless |
| 466 | BE/API | Medium | A larger burst of <racers> concurrent entries stays gapless |
| 467 | BE/API | Medium | A larger burst of <racers> concurrent entries stays gapless |
| 468 | BE/API | Medium | More <racers> racing idempotent posts make one entry |
| 469 | BE/API | Medium | More <racers> racing idempotent posts make one entry |
| 470 | BE/API | Medium | More <racers> racing idempotent posts make one entry |
| 471 | BE/API | Medium | More <racers> racing idempotent posts make one entry |
| 472 | BE/API | Medium | More <racers> racing idempotent posts make one entry |
| 473 | BE/API | Medium | More <racers> racing idempotent posts make one entry |
| 474 | BE/API | Medium | More <racers> racing idempotent posts make one entry |
| 475 | BE/API | Medium | More <racers> racing idempotent posts make one entry |
| 476 | BE/API | Medium | More <racers> racing idempotent posts make one entry |
| 477 | BE/API | Medium | More <racers> racing idempotent posts make one entry |
| 932 | BE/API | Medium | <racers> racing idempotent posts make one entry |
| 933 | BE/API | Medium | <racers> racing idempotent posts make one entry |
| 934 | BE/API | Medium | <racers> racing idempotent posts make one entry |
| 935 | BE/API | Medium | <racers> racing idempotent posts make one entry |
| 936 | BE/API | Medium | <racers> racing idempotent posts make one entry |
| 937 | BE/API | Medium | <racers> racing idempotent posts make one entry |
| 938 | BE/API | Medium | <racers> racing idempotent posts make one entry |
| 939 | BE/API | Medium | <racers> racing idempotent posts make one entry |
| 940 | BE/API | Medium | <racers> racing idempotent posts make one entry |
| 941 | BE/API | Medium | <racers> racing idempotent posts make one entry |
| 942 | BE/API | Medium | <racers> racing idempotent posts make one entry |
| 943 | BE/API | Medium | <racers> racing idempotent posts make one entry |
| 944 | BE/API | Medium | <racers> racing idempotent posts make one entry |
| 945 | BE/API | Medium | <racers> racing idempotent posts make one entry |
| 946 | BE/API | Medium | <racers> racing idempotent posts make one entry |
| 947 | BE/API | Medium | <racers> racing idempotent posts make one entry |
| 948 | BE/API | Medium | <racers> racing idempotent posts make one entry |
| 949 | BE/API | Medium | <racers> racing idempotent posts make one entry |
| 950 | BE/API | Medium | <racers> racing idempotent posts make one entry |
| 951 | BE/API | Medium | <racers> racing idempotent posts make one entry |
| 952 | BE/API | Medium | <racers> racing idempotent posts make one entry |
| 953 | BE/API | Medium | <racers> racing idempotent posts make one entry |
| 954 | BE/API | Medium | <racers> racing idempotent posts make one entry |
| 955 | BE/API | Medium | <racers> racing idempotent posts make one entry |
| 956 | BE/API | Medium | <racers> racing idempotent posts make one entry |
| 957 | BE/API | Medium | <racers> racing idempotent posts make one entry |
| 958 | BE/API | Medium | <racers> racing idempotent posts make one entry |
| 959 | BE/API | Medium | <racers> racing idempotent posts make one entry |
| 960 | BE/API | Medium | <racers> racing idempotent posts make one entry |
| 961 | BE/API | Medium | <racers> racing idempotent posts make one entry |
| 962 | BE/API | Medium | <racers> racing idempotent posts make one entry |
| 963 | BE/API | Medium | <racers> racing idempotent posts make one entry |
| 964 | BE/API | Medium | <racers> racing idempotent posts make one entry |
| 965 | BE/API | Medium | <racers> racing idempotent posts make one entry |
| 966 | BE/API | Medium | A larger burst of <racers> concurrent entries stays gapless |
| 967 | BE/API | Medium | A larger burst of <racers> concurrent entries stays gapless |
| 968 | BE/API | Medium | A larger burst of <racers> concurrent entries stays gapless |
| 969 | BE/API | Medium | A larger burst of <racers> concurrent entries stays gapless |
| 970 | BE/API | Medium | A larger burst of <racers> concurrent entries stays gapless |
| 971 | BE/API | Medium | A larger burst of <racers> concurrent entries stays gapless |
| 972 | BE/API | Medium | A larger burst of <racers> concurrent entries stays gapless |
| 973 | BE/API | Medium | A larger burst of <racers> concurrent entries stays gapless |
| 974 | BE/API | Medium | A larger burst of <racers> concurrent entries stays gapless |
| 975 | BE/API | Medium | A larger burst of <racers> concurrent entries stays gapless |
| 976 | BE/API | Medium | A larger burst of <racers> concurrent entries stays gapless |
| 977 | BE/API | Medium | A larger burst of <racers> concurrent entries stays gapless |
| 978 | BE/API | Medium | A larger burst of <racers> concurrent entries stays gapless |
| 979 | BE/API | Medium | A larger burst of <racers> concurrent entries stays gapless |
| 980 | BE/API | Medium | A larger burst of <racers> concurrent entries stays gapless |
| 981 | BE/API | Medium | A larger burst of <racers> concurrent entries stays gapless |
| 982 | BE/API | Medium | A larger burst of <racers> concurrent entries stays gapless |
| 983 | BE/API | Medium | A larger burst of <racers> concurrent entries stays gapless |
| 984 | BE/API | Medium | A larger burst of <racers> concurrent entries stays gapless |
| 985 | BE/API | Medium | A larger burst of <racers> concurrent entries stays gapless |
| 986 | BE/API | Medium | A larger burst of <racers> concurrent entries stays gapless |
| 987 | BE/API | Medium | A larger burst of <racers> concurrent entries stays gapless |
| 988 | BE/API | Medium | A larger burst of <racers> concurrent entries stays gapless |
| 989 | BE/API | Medium | A larger burst of <racers> concurrent entries stays gapless |
| 990 | BE/API | Medium | A larger burst of <racers> concurrent entries stays gapless |
| 991 | BE/API | Medium | A larger burst of <racers> concurrent entries stays gapless |
| 992 | BE/API | Medium | A larger burst of <racers> concurrent entries stays gapless |
| 993 | BE/API | Medium | A larger burst of <racers> concurrent entries stays gapless |
| 994 | BE/API | Medium | A larger burst of <racers> concurrent entries stays gapless |
| 995 | BE/API | Medium | A larger burst of <racers> concurrent entries stays gapless |
| 996 | BE/API | Medium | A larger burst of <racers> concurrent entries stays gapless |
| 997 | BE/API | Medium | A larger burst of <racers> concurrent entries stays gapless |
| 998 | BE/API | Medium | A larger burst of <racers> concurrent entries stays gapless |
| 999 | BE/API | Medium | A larger burst of <racers> concurrent entries stays gapless |
| 1000 | BE/API | Medium | A larger burst of <racers> concurrent entries stays gapless |

## mini-books-security (15)

| ID | Layer | Priority | Title |
|---|---|---|---|
| 180 | BE/API | High | Posting an entry requires a token |
| 181 | BE/API | High | A forged token cannot post |
| 182 | BE/API | High | Reading an entry requires a token |
| 183 | BE/API | High | An accountant cannot reverse an entry |
| 184 | BE/API | High | The admin entry list rejects an accountant token |
| 185 | BE/API | High | The admin overview rejects an accountant token |
| 186 | BE/API | High | A token that only extends the admin token is rejected |
| 187 | BE/API | High | The trial balance requires a token |
| 188 | BE/API | Medium | The chart of accounts is public reference data |
| 189 | BE/API | High | An accountant may post an entry |
| 190 | BE/API | High | The admin may reverse an entry |
| 191 | BE/API | Medium | Accountant onboarding is open and issues a token |
| 192 | BE/API | Medium | An entry response never carries a bearer token |
| 193 | BE/API | Medium | An account response never carries a bearer token |
| 194 | BE/API | Medium | The trial balance never carries a bearer token |

## mini-books-fe (37)

| ID | Layer | Priority | Title |
|---|---|---|---|
| 195 | FE/UI | High | The home page lists the seeded chart of accounts |
| 196 | FE/UI | Medium | Each account row shows a code, a name and a type |
| 197 | FE/UI | Medium | Every account balance is a number |
| 198 | FE/UI | Medium | The chart of accounts has an account of every type on screen |
| 199 | FE/UI | High | An account page shows the balance from the rows |
| 200 | FE/UI | Medium | An account page shows its code and type |
| 201 | FE/UI | Low | An unknown account page is not found |
| 202 | FE/UI | High | An entry page shows a balanced pair of lines |
| 203 | FE/UI | Medium | An entry page shows its date and status |
| 204 | FE/UI | Medium | A reversed entry page shows it reversed |
| 205 | FE/UI | Low | An unknown entry page is not found |
| 206 | FE/UI | High | The trial balance page shows debits equal to credits |
| 207 | FE/UI | High | The trial balance stays balanced on screen after a posting |
| 208 | FE/UI | High | The balance sheet page balances |
| 209 | FE/UI | High | The balance sheet stays balanced on screen after a purchase on credit |
| 210 | FE/UI | Medium | The admin page shows a balanced set of books |
| 211 | FE/UI | Medium | The admin entry count is a positive integer |
| 212 | FE/UI | Medium | The account page for <acc> shows the stored balance |
| 213 | FE/UI | Medium | The account page for <acc> shows the stored balance |
| 214 | FE/UI | Medium | The account page for <acc> shows the stored balance |
| 215 | FE/UI | Medium | The account page for <acc> shows the stored balance |
| 440 | FE/UI | Medium | The account page for <acc> after posting shows the stored balance |
| 441 | FE/UI | Medium | The account page for <acc> after posting shows the stored balance |
| 442 | FE/UI | Medium | The account page for <acc> after posting shows the stored balance |
| 443 | FE/UI | Medium | The account page for <acc> after posting shows the stored balance |
| 444 | FE/UI | Medium | The account page for <acc> after posting shows the stored balance |
| 445 | FE/UI | Medium | The account page for <acc> after posting shows the stored balance |
| 446 | FE/UI | Medium | The account page for <acc> after posting shows the stored balance |
| 447 | FE/UI | Medium | The account page for <acc> after posting shows the stored balance |
| 448 | FE/UI | Medium | The account page for <acc> after posting shows the stored balance |
| 449 | FE/UI | Medium | The account page for <acc> after posting shows the stored balance |
| 450 | FE/UI | Medium | The account page for <acc> after posting shows the stored balance |
| 451 | FE/UI | Medium | The account page for <acc> after posting shows the stored balance |
| 452 | FE/UI | Medium | The account page for <acc> after posting shows the stored balance |
| 453 | FE/UI | Medium | The account page for <acc> after posting shows the stored balance |
| 454 | FE/UI | Medium | The account page for <acc> after posting shows the stored balance |
| 455 | FE/UI | Medium | The account page for <acc> after posting shows the stored balance |

## nager-api (202)

| ID | Layer | Priority | Title |
|---|---|---|---|
| 216 | BE/API | High | A Saturday is a weekend |
| 217 | BE/API | High | A Monday is a weekday |
| 218 | BE/API | Medium | The business day after <date> with no holidays is <expected> |
| 219 | BE/API | Medium | The business day after <date> with no holidays is <expected> |
| 220 | BE/API | Medium | The business day after <date> with no holidays is <expected> |
| 221 | BE/API | Medium | The business day after <date> with no holidays is <expected> |
| 222 | BE/API | Medium | The business day after <date> with no holidays is <expected> |
| 223 | BE/API | Medium | The business day after <date> with no holidays is <expected> |
| 224 | BE/API | Medium | The business day after <date> with no holidays is <expected> |
| 225 | BE/API | Medium | The business day after <date> with no holidays is <expected> |
| 226 | BE/API | Medium | The business day after <date> with no holidays is <expected> |
| 227 | BE/API | Medium | The business day after <date> with no holidays is <expected> |
| 228 | BE/API | Medium | The business day after <date> with no holidays is <expected> |
| 229 | BE/API | Medium | The business day after <date> with no holidays is <expected> |
| 230 | BE/API | Medium | The business day after <date> with no holidays is <expected> |
| 231 | BE/API | Medium | The business day after <date> with no holidays is <expected> |
| 232 | BE/API | Medium | The business day after <date> with no holidays is <expected> |
| 233 | BE/API | Medium | The business day after <date> with no holidays is <expected> |
| 234 | BE/API | Medium | The business day after <date> with no holidays is <expected> |
| 235 | BE/API | Medium | The business day after <date> with no holidays is <expected> |
| 236 | BE/API | Medium | The business day after <date> with no holidays is <expected> |
| 237 | BE/API | Medium | The business day after <date> with no holidays is <expected> |
| 238 | BE/API | High | The US holiday list answers for 2024 |
| 239 | BE/API | High | The US 2024 holiday list has the expected number of entries |
| 240 | BE/API | High | Independence Day is in the US 2024 list |
| 241 | BE/API | High | Christmas Day is in the US 2024 list |
| 242 | BE/API | Medium | New Year's Day is in the US 2024 list |
| 243 | BE/API | Medium | Thanksgiving is in the US 2024 list |
| 244 | BE/API | Medium | Every holiday has a date and a name |
| 245 | BE/API | High | The holiday list is stable across two reads |
| 246 | BE/API | Medium | The UK holiday list answers for 2024 |
| 247 | BE/API | Low | The available-countries list includes the US and the UK |
| 248 | BE/API | Medium | Settlement after <date> in the US is <expected> |
| 249 | BE/API | Medium | Settlement after <date> in the US is <expected> |
| 250 | BE/API | Medium | Settlement after <date> in the US is <expected> |
| 251 | BE/API | Medium | Settlement after <date> in the US is <expected> |
| 252 | BE/API | Medium | Settlement after <date> in the US is <expected> |
| 253 | BE/API | Medium | Settlement after <date> in the US is <expected> |
| 254 | BE/API | Medium | Settlement after <date> in the US is <expected> |
| 255 | BE/API | Medium | Settlement after <date> in the US is <expected> |
| 256 | BE/API | Medium | Settlement after <date> in the US is <expected> |
| 257 | BE/API | Medium | Settlement after <date> in the US is <expected> |
| 258 | BE/API | Medium | Settlement after <date> in the US is <expected> |
| 259 | BE/API | Medium | Settlement after <date> in the US is <expected> |
| 260 | BE/API | Medium | Settlement after <date> in the US is <expected> |
| 261 | BE/API | Medium | Settlement after <date> in the US is <expected> |
| 262 | BE/API | Medium | Settlement after <date> in the US is <expected> |
| 263 | BE/API | Medium | Settlement after <date> in the US is <expected> |
| 478 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 479 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 480 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 481 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 482 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 483 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 484 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 485 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 486 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 487 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 488 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 489 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 490 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 491 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 492 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 493 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 494 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 495 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 496 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 497 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 498 | BE/API | Medium | More settlement: after <date> in the US is <expected> |
| 499 | BE/API | Medium | More settlement: after <date> in the US is <expected> |
| 500 | BE/API | Medium | More settlement: after <date> in the US is <expected> |
| 501 | BE/API | Medium | More settlement: after <date> in the US is <expected> |
| 502 | BE/API | Medium | More settlement: after <date> in the US is <expected> |
| 503 | BE/API | Medium | More settlement: after <date> in the US is <expected> |
| 504 | BE/API | Medium | More settlement: after <date> in the US is <expected> |
| 505 | BE/API | Medium | More settlement: after <date> in the US is <expected> |
| 506 | BE/API | Medium | More settlement: after <date> in the US is <expected> |
| 507 | BE/API | Medium | More settlement: after <date> in the US is <expected> |
| 508 | BE/API | Medium | More settlement: after <date> in the US is <expected> |
| 509 | BE/API | Medium | More settlement: after <date> in the US is <expected> |
| 510 | BE/API | Medium | More settlement: after <date> in the US is <expected> |
| 511 | BE/API | Medium | More settlement: after <date> in the US is <expected> |
| 812 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 813 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 814 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 815 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 816 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 817 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 818 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 819 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 820 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 821 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 822 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 823 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 824 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 825 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 826 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 827 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 828 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 829 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 830 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 831 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 832 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 833 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 834 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 835 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 836 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 837 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 838 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 839 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 840 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 841 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 842 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 843 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 844 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 845 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 846 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 847 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 848 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 849 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 850 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 851 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 852 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 853 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 854 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 855 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 856 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 857 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 858 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 859 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 860 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 861 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 862 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 863 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 864 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 865 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 866 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 867 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 868 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 869 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 870 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 871 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 872 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 873 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 874 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 875 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 876 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 877 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 878 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 879 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 880 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 881 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 882 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 883 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 884 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 885 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 886 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 887 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 888 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 889 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 890 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 891 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 892 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 893 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 894 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 895 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 896 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 897 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 898 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 899 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 900 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 901 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 902 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 903 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 904 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 905 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 906 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 907 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 908 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 909 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 910 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 911 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 912 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 913 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 914 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 915 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 916 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 917 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 918 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 919 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 920 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 921 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 922 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 923 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 924 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 925 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 926 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 927 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 928 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 929 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 930 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |
| 931 | BE/API | Medium | More: the business day after <date> with no holidays is <expected> |

# Double-entry accounting — test cases

1000 cases across a self-written mini-books service (a real SQLite store behind the chart of accounts, journal entries, reversals and the financial reports) and the live Nager.Date public-holiday API. Generated from `../features/*.feature` by `build.js`; do not edit by hand.

## mini-books-db (180)

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
| 832 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 833 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 834 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 835 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 836 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 837 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 838 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 839 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 840 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 841 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 842 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 843 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 844 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 845 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 846 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 847 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 848 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 849 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 850 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 851 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 852 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 853 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 854 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 855 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 856 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 857 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 858 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 859 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 860 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 861 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 862 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 863 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 864 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 865 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 866 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 867 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 868 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 869 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 870 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 871 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 872 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 873 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 874 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 875 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 876 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 877 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 878 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 879 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 880 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 881 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 882 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 883 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 884 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 885 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 886 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 887 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 888 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 889 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 890 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 891 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 892 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 893 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 894 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 895 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 896 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 897 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 898 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 899 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 900 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 901 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 902 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 903 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 904 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 905 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 906 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 907 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 908 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 909 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 910 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 911 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 912 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 913 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 914 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 915 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 916 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 917 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 918 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 919 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 920 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |
| 921 | BE/DB | Medium | Bulk balanced entry Dr <dr> Cr <cr> for <amount> |

## mini-books-journal (304)

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
| 512 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 513 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 514 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 515 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 516 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 517 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 518 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 519 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 520 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 521 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 522 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 523 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 524 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 525 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 526 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 527 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 528 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 529 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 530 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 531 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 532 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 533 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 534 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 535 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 536 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 537 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 538 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 539 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 540 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 541 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 542 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 543 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 544 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 545 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 546 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 547 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 548 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 549 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 550 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 551 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 552 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 553 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 554 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 555 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 556 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 557 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 558 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 559 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 560 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 561 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 562 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 563 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 564 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 565 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 566 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 567 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 568 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 569 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 570 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 571 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 572 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 573 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 574 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 575 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 576 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 577 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 578 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 579 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 580 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 581 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 582 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 583 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 584 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 585 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 586 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 587 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 588 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 589 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 590 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 591 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 592 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 593 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 594 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 595 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 596 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 597 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 598 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 599 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 600 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 601 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 602 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 603 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 604 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 605 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 606 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 607 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 608 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 609 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 610 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 611 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 612 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 613 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 614 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 615 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 616 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 617 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 618 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 619 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 620 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 621 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 622 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 623 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 624 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 625 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 626 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 627 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 628 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 629 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 630 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 631 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 632 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 633 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 634 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 635 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 636 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 637 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 638 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 639 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 640 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 641 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 642 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 643 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 644 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 645 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 646 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 647 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 648 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 649 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 650 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 651 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 652 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 653 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 654 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 655 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 656 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 657 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 658 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 659 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 660 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 661 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 662 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 663 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 664 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 665 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 666 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 667 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 668 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 669 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 670 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 671 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 672 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 673 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 674 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 675 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 676 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 677 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 678 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 679 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 680 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 681 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 682 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 683 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 684 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 685 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 686 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 687 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 688 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 689 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 690 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |
| 691 | BE/API | Medium | Bulk balanced posting Dr <dr> Cr <cr> for <amount> |

## mini-books-reports (257)

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
| 692 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 693 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 694 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 695 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 696 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 697 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 698 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 699 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 700 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 701 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 702 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 703 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 704 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 705 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 706 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 707 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 708 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 709 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 710 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 711 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 712 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 713 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 714 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 715 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 716 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 717 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 718 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 719 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 720 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 721 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 722 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 723 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 724 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 725 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 726 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 727 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 728 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 729 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 730 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 731 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 732 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 733 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 734 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 735 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 736 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 737 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 738 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 739 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 740 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 741 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 742 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 743 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 744 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 745 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 746 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 747 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 748 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 749 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 750 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 751 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 752 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 753 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 754 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 755 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 756 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 757 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 758 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 759 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 760 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 761 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 762 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 763 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 764 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 765 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 766 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 767 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 768 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 769 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 770 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 771 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 772 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 773 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 774 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 775 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 776 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 777 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 778 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 779 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 780 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 781 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 782 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 783 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 784 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 785 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 786 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 787 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 788 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 789 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 790 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 791 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 792 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 793 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 794 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 795 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 796 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 797 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 798 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 799 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 800 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 801 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 802 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 803 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 804 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 805 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 806 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 807 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 808 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 809 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 810 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 811 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 812 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 813 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 814 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 815 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 816 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 817 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 818 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 819 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 820 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 821 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 822 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 823 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 824 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 825 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 826 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 827 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 828 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 829 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 830 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |
| 831 | BE/API | Medium | Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding |

## mini-books-integrity (46)

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

## mini-books-fe (56)

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
| 922 | FE/UI | Medium | Bulk account page for <acc> shows the stored balance |
| 923 | FE/UI | Medium | Bulk account page for <acc> shows the stored balance |
| 924 | FE/UI | Medium | Bulk account page for <acc> shows the stored balance |
| 925 | FE/UI | Medium | Bulk account page for <acc> shows the stored balance |
| 926 | FE/UI | Medium | Bulk account page for <acc> shows the stored balance |
| 927 | FE/UI | Medium | Bulk account page for <acc> shows the stored balance |
| 928 | FE/UI | Medium | Bulk account page for <acc> shows the stored balance |
| 929 | FE/UI | Medium | Bulk account page for <acc> shows the stored balance |
| 930 | FE/UI | Medium | Bulk account page for <acc> shows the stored balance |
| 931 | FE/UI | Medium | Bulk account page for <acc> shows the stored balance |
| 932 | FE/UI | Medium | Bulk account page for <acc> shows the stored balance |
| 933 | FE/UI | Medium | Bulk account page for <acc> shows the stored balance |
| 934 | FE/UI | Medium | Bulk account page for <acc> shows the stored balance |
| 935 | FE/UI | Medium | Bulk account page for <acc> shows the stored balance |
| 936 | FE/UI | Medium | Bulk account page for <acc> shows the stored balance |
| 937 | FE/UI | Medium | Bulk account page for <acc> shows the stored balance |
| 938 | FE/UI | Medium | Bulk account page for <acc> shows the stored balance |
| 939 | FE/UI | Medium | Bulk account page for <acc> shows the stored balance |
| 940 | FE/UI | Medium | Bulk account page for <acc> shows the stored balance |

## nager-api (142)

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
| 941 | BE/API | Medium | Bulk: the business day after <date> with no holidays is <expected> |
| 942 | BE/API | Medium | Bulk: the business day after <date> with no holidays is <expected> |
| 943 | BE/API | Medium | Bulk: the business day after <date> with no holidays is <expected> |
| 944 | BE/API | Medium | Bulk: the business day after <date> with no holidays is <expected> |
| 945 | BE/API | Medium | Bulk: the business day after <date> with no holidays is <expected> |
| 946 | BE/API | Medium | Bulk: the business day after <date> with no holidays is <expected> |
| 947 | BE/API | Medium | Bulk: the business day after <date> with no holidays is <expected> |
| 948 | BE/API | Medium | Bulk: the business day after <date> with no holidays is <expected> |
| 949 | BE/API | Medium | Bulk: the business day after <date> with no holidays is <expected> |
| 950 | BE/API | Medium | Bulk: the business day after <date> with no holidays is <expected> |
| 951 | BE/API | Medium | Bulk: the business day after <date> with no holidays is <expected> |
| 952 | BE/API | Medium | Bulk: the business day after <date> with no holidays is <expected> |
| 953 | BE/API | Medium | Bulk: the business day after <date> with no holidays is <expected> |
| 954 | BE/API | Medium | Bulk: the business day after <date> with no holidays is <expected> |
| 955 | BE/API | Medium | Bulk: the business day after <date> with no holidays is <expected> |
| 956 | BE/API | Medium | Bulk: the business day after <date> with no holidays is <expected> |
| 957 | BE/API | Medium | Bulk: the business day after <date> with no holidays is <expected> |
| 958 | BE/API | Medium | Bulk: the business day after <date> with no holidays is <expected> |
| 959 | BE/API | Medium | Bulk: the business day after <date> with no holidays is <expected> |
| 960 | BE/API | Medium | Bulk: the business day after <date> with no holidays is <expected> |
| 961 | BE/API | Medium | Bulk: the business day after <date> with no holidays is <expected> |
| 962 | BE/API | Medium | Bulk: the business day after <date> with no holidays is <expected> |
| 963 | BE/API | Medium | Bulk: the business day after <date> with no holidays is <expected> |
| 964 | BE/API | Medium | Bulk: the business day after <date> with no holidays is <expected> |
| 965 | BE/API | Medium | Bulk: the business day after <date> with no holidays is <expected> |
| 966 | BE/API | Medium | Bulk: the business day after <date> with no holidays is <expected> |
| 967 | BE/API | Medium | Bulk: the business day after <date> with no holidays is <expected> |
| 968 | BE/API | Medium | Bulk: the business day after <date> with no holidays is <expected> |
| 969 | BE/API | Medium | Bulk: the business day after <date> with no holidays is <expected> |
| 970 | BE/API | Medium | Bulk: the business day after <date> with no holidays is <expected> |
| 971 | BE/API | Medium | Bulk: the business day after <date> with no holidays is <expected> |
| 972 | BE/API | Medium | Bulk: the business day after <date> with no holidays is <expected> |
| 973 | BE/API | Medium | Bulk: the business day after <date> with no holidays is <expected> |
| 974 | BE/API | Medium | Bulk: the business day after <date> with no holidays is <expected> |
| 975 | BE/API | Medium | Bulk: the business day after <date> with no holidays is <expected> |
| 976 | BE/API | Medium | Bulk: the business day after <date> with no holidays is <expected> |
| 977 | BE/API | Medium | Bulk: the business day after <date> with no holidays is <expected> |
| 978 | BE/API | Medium | Bulk: the business day after <date> with no holidays is <expected> |
| 979 | BE/API | Medium | Bulk: the business day after <date> with no holidays is <expected> |
| 980 | BE/API | Medium | Bulk: the business day after <date> with no holidays is <expected> |
| 981 | BE/API | Medium | Bulk settlement: after <date> in the US is <expected> |
| 982 | BE/API | Medium | Bulk settlement: after <date> in the US is <expected> |
| 983 | BE/API | Medium | Bulk settlement: after <date> in the US is <expected> |
| 984 | BE/API | Medium | Bulk settlement: after <date> in the US is <expected> |
| 985 | BE/API | Medium | Bulk settlement: after <date> in the US is <expected> |
| 986 | BE/API | Medium | Bulk settlement: after <date> in the US is <expected> |
| 987 | BE/API | Medium | Bulk settlement: after <date> in the US is <expected> |
| 988 | BE/API | Medium | Bulk settlement: after <date> in the US is <expected> |
| 989 | BE/API | Medium | Bulk settlement: after <date> in the US is <expected> |
| 990 | BE/API | Medium | Bulk settlement: after <date> in the US is <expected> |
| 991 | BE/API | Medium | Bulk settlement: after <date> in the US is <expected> |
| 992 | BE/API | Medium | Bulk settlement: after <date> in the US is <expected> |
| 993 | BE/API | Medium | Bulk settlement: after <date> in the US is <expected> |
| 994 | BE/API | Medium | Bulk settlement: after <date> in the US is <expected> |
| 995 | BE/API | Medium | Bulk settlement: after <date> in the US is <expected> |
| 996 | BE/API | Medium | Bulk settlement: after <date> in the US is <expected> |
| 997 | BE/API | Medium | Bulk settlement: after <date> in the US is <expected> |
| 998 | BE/API | Medium | Bulk settlement: after <date> in the US is <expected> |
| 999 | BE/API | Medium | Bulk settlement: after <date> in the US is <expected> |
| 1000 | BE/API | Medium | Bulk settlement: after <date> in the US is <expected> |

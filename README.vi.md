# qa-automation-accounting

![Pytest-BDD](https://img.shields.io/badge/Pytest--BDD-tests-0A9EDC?logo=pytest&logoColor=white)
![Cucumber](https://img.shields.io/badge/Cucumber-BDD-23D96C?logo=cucumber&logoColor=white)
![Playwright](https://img.shields.io/badge/Playwright-E2E-2EAD33?logo=playwright&logoColor=white)
![SQLite](https://img.shields.io/badge/SQLite-store-003B57?logo=sqlite&logoColor=white)
![Python](https://img.shields.io/badge/Python-3.12-3776AB?logo=python&logoColor=white)
![Node](https://img.shields.io/badge/Node-24-5FA04E?logo=nodedotjs&logoColor=white)
[![CI](https://github.com/hunglamkienhung/qa-automation-accounting/actions/workflows/ci.yml/badge.svg)](https://github.com/hunglamkienhung/qa-automation-accounting/actions/workflows/ci.yml)

Bộ QA automation cho một domain **kế toán ghi sổ kép**, dựng như một hệ thống chạy
được chứ không phải slide trình chiếu. Một bộ sổ sách — hệ thống tài khoản, các bút
toán nhật ký, và ba báo cáo tài chính — được giữ đúng luật kế toán: mọi bút toán
phải cân, nên phương trình kế toán luôn đúng và bảng cân đối thử luôn có Nợ = Có.
Được kiểm ở **mọi tầng nó có** (database, API, giao diện) bởi **hai stack độc lập**
(Node + Cucumber, Python + pytest-bdd) cùng đọc **một** bộ Gherkin và phải cho
**cùng một kết luận cho mọi case**.

Không cần tài khoản, không cần key, không cần dịch vụ trả phí. Clone về là chạy.

[English](README.md) · [Chấm điểm](docs/GRADING.md) ·
[Gherkin](docs/GHERKIN.md) · [Định dạng hàng đợi](docs/QUEUE-FORMAT.md)

## Hai hệ thống được kiểm

| Hệ thống | Truy cập | Là gì |
|---|---|---|
| **mini-books** | đọc + ghi, DB thật | Backend kế toán ghi sổ kép nhỏ trong `services/mini-books`: một file SQLite, chỉ dùng thư viện chuẩn của Node, REST API cho hệ thống tài khoản, bút toán nhật ký, đảo bút toán và bảng cân đối thử, bảng cân đối kế toán, báo cáo KQKD, cùng các trang HTML gắn nhãn cho Playwright. |
| **date.nager.at** | chỉ đọc, live | API ngày lễ công, không cần key. Danh sách lễ một năm quá khứ dùng để tính ngày ghi sổ/thanh toán theo ngày làm việc; không ai chỉnh cho nó "pass" được. |

**1000 case**, mỗi case một ID bất biến, chạy trên **cả hai** stack và đối chiếu
từng case. Mọi tầng dịch vụ có đều được kiểm ở đúng tầng đó:

| Tầng | Đích | Case | Ở đâu |
|---|---|---|---|
| DB | SQLite mini-books, đọc trực tiếp | 190 | `be/db` |
| API | bút toán nhật ký — Nợ = Có, ít nhất hai dòng, ngày làm việc, tài khoản active, một tiền tệ, idempotency | 224 | `be/api` |
| API | báo cáo tài chính — cân đối thử, cân đối kế toán, KQKD, số dư theo loại | 217 | `be/api` |
| API | toàn vẹn sổ cái — phương trình kế toán, đảo bút toán, đánh số liên tục dưới đồng thời | 115 | `be/api` |
| API | ranh giới phân quyền (security) | 15 | `be/api` |
| API | Nager.Date + ngày làm việc dựng trên nó | 202 | `be/api` |
| FE | các trang app mini-books (Playwright) | 37 | `fe/ui` |
| | **Tổng** | **1000** | |

## Các luật nó thực thi

`mini-books` là nơi có các đường **ghi**, và nó cố ý chính xác.

- Một tài khoản thuộc một trong **năm loại** (tài sản, nợ phải trả, vốn chủ,
  doanh thu, chi phí), quyết định **tính chất số dư** — tài sản và chi phí dư Nợ;
  nợ phải trả, vốn chủ và doanh thu dư Có.
- Một **bút toán nhật ký** là tập các dòng Nợ và Có có **Nợ = Có**, bằng xu nguyên,
  ghi vào **ngày làm việc** (cuối tuần bị từ chối), lên **tài khoản active** cùng
  một **tiền tệ**, và **idempotent theo khóa**. Tầng journal ghi các giao dịch
  hằng ngày của một doanh nghiệp nhỏ — bán thu tiền, bán chịu, trả tiền thuê, mua
  hàng tồn kho chịu, vay, chủ góp vốn — và từ chối những bút toán một kế toán tuyệt
  đối không được nhận.
- Vì mọi bút toán cân, các **báo cáo** luôn đúng luật kế toán: bảng cân đối thử có
  Nợ = Có, **bảng cân đối kế toán cân** (Tài sản = Nợ phải trả + Vốn + Lợi nhuận),
  **lợi nhuận = doanh thu − chi phí**, và **phương trình kế toán** đúng. Tầng
  reports kiểm các bất biến này sau mọi kiểu ghi sổ, và kiểm mỗi con số báo cáo dịch
  đúng bằng số tiền một giao dịch phải làm nó dịch.
- Một **lần đảo** (chỉ admin) ghi các dòng gốc với Nợ/Có đảo lại và khôi phục các
  con số nó hủy; không thể đảo hai lần hay đảo một bản đảo.

## Bất biến đáng giá cả repo, và đồng thời

Ghi sổ kép nghĩa là sổ sách luôn cân sau mọi lần ghi — và vẫn nhất quán **dưới đồng
thời**. Mỗi bút toán được đánh số trong một giao dịch `BEGIN IMMEDIATE` bằng
`MAX(entry_no) + 1`, nên khi nhiều bút toán ghi cùng lúc, nhật ký được đánh số bằng
một **dãy liên tục, không trùng** (đúng mối lo kế toán thật — không thiếu/không lặp
số hiệu), và một lần ghi lặp cùng khóa idempotency ghi đúng một lần. Tầng integrity
chứng minh cả hai bằng đua thật — `Promise.all` ở Node, thread pool ở Python.

## Hai ý đáng dừng lại một phút

**Một bộ Gherkin, hai stack, một kết luận.** `features/*.feature` dùng chung.
`node/` chạy bằng Cucumber; `python/` chạy chính các file đó bằng pytest-bdd. Một
case lệch nhau tự nó là một phát hiện, và build fail vì điều đó.

**Failed > Blocked > Passed, và sự cố hạ tầng không bao giờ là fail.** Một case
Failed chỉ khi một mệnh đề quan sát được là sai. Khi nguồn live (Nager.Date, một
service đang tắt) không truy cập được, case là **Blocked**, không phải Failed. Cổng
CI kiểm *hình dạng* lượt chạy so với `fixtures/expected-results.json`. Xem
[docs/GRADING.md](docs/GRADING.md).

## Chạy trong 30 giây

```bash
# lõi chấm điểm dùng chung, cả hai stack
cd core/node && node --test "selftest/*.test.js"
cd ../python && pip install -e . && python -m pytest selftest -q
```

## Chạy cả bộ

Mỗi bước dưới đây đúng là thứ CI chạy (`scripts/*.sh`), nên chạy tay cũng được.

```bash
# backend, một stack, không cần trình duyệt (seed mini-books, rồi DB + journal + reports + integrity + security + Nager.Date)
bash scripts/run-be.sh node       # hoặc: python

# các trang app (tự cài chromium)
bash scripts/run-fe.sh node       # hoặc: python

# cả bộ, rồi verify hình dạng lượt chạy so với baseline
bash scripts/gate.sh node
```

Chạy tay từng tầng:

```bash
( cd services/mini-books && bash serve.sh up )    # service seed mới
cd node && QA_DOMAIN_ROOT=.. npx cucumber-js --tags "@be and @reports"
```

Yêu cầu: Node ≥ 22.13 (cho `node:sqlite`) và Python ≥ 3.11. Script FE tự cài trình
duyệt. Có sẵn devcontainer đủ bộ trong
[.devcontainer/](.devcontainer/devcontainer.json). Có bộ load-test Locust trong
[perf/](perf/README.md).

## Bố cục

```
core/            một lõi chấm điểm/hàng đợi/báo cáo/bugflow, vendored vào repo này
services/
  mini-books/    SQLite + REST + HTML — sổ sách ghi kép được kiểm
features/        một bộ Gherkin, dùng chung cả hai stack
fixtures/        testcases.json (ID) · expected-results.json (hình dạng)
node/  python/   hai stack: be/{db,api} fe/ui
testcases/       catalogue sinh từ features (không bao giờ lệch)
perf/            một bộ load-test Locust có cổng pass/fail
scripts/         đúng các lệnh CI chạy; tái lập được bằng tay
docs/            luật chấm điểm, quy ước Gherkin, định dạng hàng đợi
.github/workflows/ci.yml
```

## Ghi chú

- Các assert về số dư, con số báo cáo và ngày thanh toán không đọc lại con số của
  chính service — chúng **tự tính lại** rồi so, nên một lỗi đấu nối hay làm tròn sẽ
  lộ ra thành lệch. Vì tài khoản seed tích lũy qua các scenario, kiểm số dư và con
  số dùng **delta** (ghi lại, ghi sổ, xem gì đổi), còn các bất biến kế toán (cân,
  phương trình đúng) là tuyệt đối.
- Ghi sổ kép được kiểm từ ba phía: tầng API ghi bút toán và đọc báo cáo; tầng DB đọc
  thẳng `lines` và các tổng lớn; tầng FE đọc hệ thống tài khoản và các trang báo cáo
  rồi đối chiếu với cùng các dòng.
- Catalogue được sinh từ các file feature bởi `testcases/build.js`, nên không thể
  lệch khỏi thứ thực sự chạy — CI kiểm bằng `--check`.

## Phạm vi trung thực

Tầng nguồn-live (Nager.Date) phụ thuộc bên thứ ba có thể chậm hoặc không truy cập
được; các case đó chấm **Blocked**, không phải Failed, khi điều đó xảy ra, và luật
ngày làm việc dựng trên nó là một hàm thuần được kiểm tất định không cần mạng.
Service mini-books tự viết thì hoàn toàn tất định và là nơi kiểm ghi sổ kép, năm loại
tài khoản, các báo cáo tài chính, đảm bảo đánh số không nhảy và ranh giới phân quyền.

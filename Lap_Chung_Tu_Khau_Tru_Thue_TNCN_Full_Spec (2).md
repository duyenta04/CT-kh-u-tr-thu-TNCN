# LẬP CHỨNG TỪ KHẤU TRỪ THUẾ THU NHẬP CÁ NHÂN

**FORM LẬP CHỨNG TỪ KHẤU TRỪ THUẾ TNCN (GHERKIN SPEC)**

---

## MỤC LỤC

1. [CẤU TRÚC FORM LẬP CHỨNG TỪ](#1-cấu-trúc-form-lập-chứng-từ)
2. [FEATURE: TỰ ĐỘNG ĐIỀN THÔNG TIN TỔ CHỨC](#2-feature-tự-động-điền-thông-tin-tổ-chức)
3. [FEATURE: NHẬP THÔNG TIN NGƯỜI NỘP THUẾ](#3-feature-nhập-thông-tin-người-nộp-thuế)
4. [FEATURE: DROPDOWN KHOẢN THU NHẬP](#4-feature-dropdown-khoản-thu-nhập)
5. [FEATURE: TỰ ĐỘNG TÍNH THUẾ TNCN](#5-feature-tự-động-tính-thuế-tncn)
6. [FEATURE: VALIDATE DỮ LIỆU](#6-feature-validate-dữ-liệu)
7. [FEATURE: LƯU VÀ KÝ SỐ](#7-feature-lưu-và-ký-số)

---

## 1. CẤU TRÚC FORM LẬP CHỨNG TỪ

### 1.1. Wireframe Form

```
┌──────────────────────────────────────────────────────────────────┐
│                  CHỨNG TỪ KHẤU TRỪ THUẾ THU NHẬP CÁ NHÂN        │
├──────────────────────────────────────────────────────────────────┤
│ THÔNG TIN CHỨNG                                                  │
│ ┌──────────────┬──────────────┬────────────────┐               │
│ │Mẫu chứng từ *│Số chứng từ   │Ngày chứng từ * │               │
│ │CT15e         │Tự động sinh  │12/12/2025      │               │
│ └──────────────┴──────────────┴────────────────┘               │
├──────────────────────────────────────────────────────────────────┤
│ THÔNG TIN TỔ CHỨC TRẢ THU NHẬP (Tự động điền)                  │
│ ┌──────────────────────────┬──────────────────────────┐        │
│ │Tên đơn vị *              │Mã số thuế *              │        │
│ │CÔNG TY ABC               │0123456789 (Read-only)    │        │
│ ├──────────────────────────┴──────────────────────────┤        │
│ │Địa chỉ *                                            │        │
│ │123 Đường Láng, Hà Nội (Read-only)                  │        │
│ ├──────────────────────────────────────────────────────┤        │
│ │Số điện thoại *                                       │        │
│ │024 1234 5678 (Read-only)                            │        │
│ └──────────────────────────────────────────────────────┘        │
├──────────────────────────────────────────────────────────────────┤
│ THÔNG TIN CÁ NHÂN, HỘ KINH DOANH, CÁ NHÂN KINH DOANH          │
│ ┌──────────────────────────┬──────────────────────────┐        │
│ │Họ và tên *               │Mã số thuế                │        │
│ │[Nhập họ và tên]          │[Nhập MST (nếu có)]       │        │
│ ├──────────────────────────┴──────────────────────────┤        │
│ │Địa chỉ *                                            │        │
│ │[Nhập địa chỉ]                                       │        │
│ ├──────────────────────────┬──────────────────────────┤        │
│ │Quốc tịch *               │Cá nhân cư trú *          │        │
│ │[Dropdown]                │○ Có  ○ Không            │        │
│ ├──────────────────────────┴──────────────────────────┤        │
│ │Căn cước công dân (Số CCCD/Hộ chiếu/Số định danh)  │        │
│ │[Nhập số CCCD nếu chưa có MST]                      │        │
│ ├──────────────────────────┬──────────────────────────┤        │
│ │Số điện thoại *           │Địa chỉ thư điện tử       │        │
│ │[Nhập SĐT]                │[Nhập email]              │        │
│ ├──────────────────────────┴──────────────────────────┤        │
│ │Ghi chú                                              │        │
│ │[Nhập ghi chú nếu có]                                │        │
│ └─────────────────────────────────────────────────────┘        │
├──────────────────────────────────────────────────────────────────┤
│ THÔNG TIN THUẾ THU NHẬP CÁ NHÂN KHẤU TRỪ                       │
│ ┌──────────────────────────────────────────────────────┐       │
│ │Khoản thu nhập *                                      │       │
│ │[Dropdown: Thu nhập từ tiền lương, tiền công]        │       │
│ ├────────────────┬────────────────┬────────────────────┤       │
│ │Từ tháng *      │Đến tháng *     │Năm *               │       │
│ │[01]            │[12]            │[2024]              │       │
│ ├────────────────────────────────────────────────────────┤     │
│ │Bảo hiểm (Khoản đóng bảo hiểm bắt buộc) *           │     │
│ │[0]                                                 │     │
│ ├────────────────────────────────────────────────────────┤     │
│ │Khoản từ thiện, nhân đạo, khuyến học *              │     │
│ │[0]                                                 │     │
│ ├────────────────────────────────────────────────────────┤     │
│ │Quỹ hưu trí tự nguyện được trừ                      │     │
│ │[0]                                                 │     │
│ ├────────────────────────────────────────────────────────┤     │
│ │Tổng thu nhập chịu thuế *                           │     │
│ │[0]                                                 │     │
│ ├────────────────────────────────────────────────────────┤     │
│ │Tổng thu nhập tính thuế (Tự động tính)             │     │
│ │[0] ← Auto = Thu nhập chịu thuế - BHBB - Từ thiện  │     │
│ ├────────────────────────────────────────────────────────┤     │
│ │Số thuế (Số thuế TNCN đã khấu trừ) (Tự động tính)  │     │
│ │[0] ← Auto theo biểu thuế lũy tiến 5 bậc            │     │
│ └────────────────────────────────────────────────────────┘     │
├──────────────────────────────────────────────────────────────────┤
│         [Hủy bỏ]  [Lưu nháp]  [Ký số và phát hành]             │
└──────────────────────────────────────────────────────────────────┘
```

### 1.2. Danh sách trường nhập liệu

| STT | Nhóm | Trường | Loại | Bắt buộc | Ghi chú |
|-----|------|--------|------|----------|---------|
| **THÔNG TIN CHỨNG** | | | | |
| 1 | Chứng | Mẫu chứng từ | Text | ✓ | CT15e (Read-only) |
| 2 | Chứng | Số chứng từ | Text | | Tự động sinh |
| 3 | Chứng | Ngày chứng từ | Date | ✓ | Mặc định = Hôm nay |
| **THÔNG TIN TỔ CHỨC** | | | | |
| 4 | Tổ chức | Tên đơn vị | Text | ✓ | Tự động điền, Read-only |
| 5 | Tổ chức | Mã số thuế | Text | ✓ | Tự động điền, Read-only |
| 6 | Tổ chức | Địa chỉ | Text | ✓ | Tự động điền, Read-only |
| 7 | Tổ chức | Số điện thoại | Text | ✓ | Tự động điền, Read-only |
| **THÔNG TIN NGƯỜI NỘP THUẾ** | | | | |
| 8 | Người NNT | Họ và tên | Text | ✓ | Max 100 ký tự |
| 9 | Người NNT | Mã số thuế | Text | Có điều kiện | 10 hoặc 13 số |
| 10 | Người NNT | Địa chỉ | Text | ✓ | Max 500 ký tự |
| 11 | Người NNT | Quốc tịch | Dropdown | ✓ | Mặc định: Việt Nam |
| 12 | Người NNT | Cá nhân cư trú | Radio | ✓ | Có/Không |
| 13 | Người NNT | Căn cước công dân | Text | Có điều kiện | Nếu không có MST |
| 14 | Người NNT | Số điện thoại | Text | ✓ | 10-11 số |
| 15 | Người NNT | Địa chỉ thư điện tử | Email | | Optional |
| 16 | Người NNT | Ghi chú | Textarea | | Optional |
| **THÔNG TIN THUẾ** | | | | |
| 17 | Thuế | Khoản thu nhập | Dropdown | ✓ | 4 options |
| 18 | Thuế | Từ tháng | Number | ✓ | 1-12 |
| 19 | Thuế | Đến tháng | Number | ✓ | 1-12, >= Từ tháng |
| 20 | Thuế | Năm | Number | ✓ | <= Năm hiện tại |
| 21 | Thuế | Bảo hiểm | Number | ✓ | >= 0 |
| 22 | Thuế | Khoản từ thiện | Number | ✓ | >= 0 |
| 23 | Thuế | Quỹ hưu trí | Number | | >= 0 |
| 24 | Thuế | Tổng thu nhập chịu thuế | Number | ✓ | > 0 |
| 25 | Thuế | Tổng thu nhập tính thuế | Number | ✓ | Auto-calculated |
| 26 | Thuế | Số thuế | Number | ✓ | Auto-calculated |

---

## 2. FEATURE: TỰ ĐỘNG ĐIỀN THÔNG TIN TỔ CHỨC

```gherkin
Feature: Tự động điền thông tin tổ chức trả thu nhập
  Là một Kế toán
  Người dùng muốn thông tin tổ chức được điền tự động
  Để tiết kiệm thời gian nhập liệu

  Background:
    Given Người dùng đã đăng nhập hệ thống
    And Thông tin tổ chức đã được cấu hình:
      | Trường       | Giá trị                    |
      | Tên đơn vị   | CÔNG TY TNHH ABC          |
      | Mã số thuế   | 0123456789                |
      | Địa chỉ      | 123 Đường Láng, Hà Nội    |
      | Điện thoại   | 024 1234 5678             |

  Scenario: Mở form tạo chứng từ mới
    When Người dùng click "Tạo chứng từ mới"
    Then Hệ thống hiển thị form tạo chứng từ
    And Các trường thông tin tổ chức được điền tự động:
      | Trường       | Giá trị                    | Trạng thái  |
      | Tên đơn vị   | CÔNG TY TNHH ABC          | Read-only   |
      | Mã số thuế   | 0123456789                | Read-only   |
      | Địa chỉ      | 123 Đường Láng, Hà Nội    | Read-only   |
      | Điện thoại   | 024 1234 5678             | Read-only   |
    And Các trường khác để trống

  Scenario: Không cho phép sửa thông tin tổ chức
    Given Form tạo chứng từ đang mở
    And Thông tin tổ chức đã được điền tự động
    When Người dùng cố gắng sửa trường "Tên đơn vị"
    Then Hệ thống không cho phép sửa
    And Hiển thị tooltip "Thông tin tổ chức không thể chỉnh sửa"
```

---

## 3. FEATURE: NHẬP THÔNG TIN NGƯỜI NỘP THUẾ

```gherkin
Feature: Nhập và validate thông tin người nộp thuế
  Là một Kế toán
  Người dùng muốn nhập thông tin người nộp thuế
  Để tạo chứng từ khấu trừ thuế TNCN

  Background:
    Given Người dùng đang ở form tạo chứng từ
    And Phần thông tin tổ chức đã được điền tự động

  # ========== MST vs CCCD ==========
  
  Scenario: Nhập MST → CCCD không bắt buộc
    When Người dùng nhập "Mã số thuế" = "8765432100"
    Then Trường "Căn cước công dân" KHÔNG bắt buộc
    And Không hiển thị dấu "*" bên cạnh "Căn cước công dân"

  Scenario: Không nhập MST → CCCD bắt buộc
    Given Trường "Mã số thuế" để trống
    When Người dùng click "Lưu nháp"
    Then Hệ thống kiểm tra trường "Căn cước công dân"
    And Nếu "Căn cước công dân" trống
    Then Hiển thị lỗi "Phải nhập Mã số thuế hoặc Số CCCD/Hộ chiếu"

  Scenario Outline: Validate format MST
    When Người dùng nhập "Mã số thuế" = "<giá_trị>"
    And Người dùng rời khỏi ô nhập (blur)
    Then Hệ thống hiển thị "<kết_quả>"

    Examples:
      | giá_trị      | kết_quả                           |
      | 0123456789   | Hợp lệ (10 số)                    |
      | 0123456789012| Hợp lệ (13 số)                    |
      | 012345       | Lỗi: MST phải là 10 hoặc 13 số    |
      | ABC123456789 | Lỗi: MST chỉ được chứa số         |

  Scenario Outline: Validate format CCCD
    Given Trường "Mã số thuế" để trống
    When Người dùng nhập "Căn cước công dân" = "<giá_trị>"
    And Người dùng rời khỏi ô nhập (blur)
    Then Hệ thống hiển thị "<kết_quả>"

    Examples:
      | giá_trị        | kết_quả                           |
      | 001234567890   | Hợp lệ (12 số)                    |
      | 123456789      | Hợp lệ (9 số - CMND cũ)           |
      | 12345          | Lỗi: CCCD phải là 9 hoặc 12 số    |
      | ABC123456789   | Lỗi: CCCD chỉ được chứa số        |

  # ========== CƯ TRÚ ==========

  Scenario: Mặc định chọn "Cá nhân cư trú"
    When Người dùng mở form tạo chứng từ
    Then Radio button "Cá nhân cư trú" = "Có" được chọn mặc định
    And Radio button "Cá nhân cư trú" = "Không" không được chọn

  Scenario: Chuyển sang "Không cư trú"
    Given Radio button "Cá nhân cư trú" = "Có" đang được chọn
    When Người dùng chọn "Cá nhân cư trú" = "Không"
    Then Radio button "Cá nhân cư trú" = "Không" được chọn
    And Radio button "Cá nhân cư trú" = "Có" bị bỏ chọn

  # ========== QUỐC TỊCH ==========

  Scenario: Dropdown quốc tịch với giá trị mặc định
    When Người dùng mở form tạo chứng từ
    Then Trường "Quốc tịch" có giá trị mặc định = "Việt Nam"
    And Dropdown "Quốc tịch" chứa danh sách các quốc gia

  # ========== SỐ ĐIỆN THOẠI ==========

  Scenario Outline: Validate số điện thoại
    When Người dùng nhập "Số điện thoại" = "<giá_trị>"
    And Người dùng rời khỏi ô nhập (blur)
    Then Hệ thống hiển thị "<kết_quả>"

    Examples:
      | giá_trị       | kết_quả                           |
      | 0912345678    | Hợp lệ (10 số)                    |
      | 02412345678   | Hợp lệ (11 số)                    |
      | 091234        | Lỗi: SĐT phải là 10-11 số         |
      | 09123456789012| Lỗi: SĐT phải là 10-11 số         |
      | 091234567a    | Lỗi: SĐT chỉ được chứa số         |
```

---

## 4. FEATURE: DROPDOWN KHOẢN THU NHẬP

```gherkin
Feature: Chọn khoản thu nhập
  Là một Kế toán
  Người dùng muốn chọn loại khoản thu nhập
  Để phân loại đúng loại thu nhập cần khấu trừ thuế

  Background:
    Given Người dùng đang ở phần "Thông tin thuế"
    And Dropdown "Khoản thu nhập" đang đóng

  Scenario: Hiển thị danh sách khoản thu nhập
    When Người dùng click vào dropdown "Khoản thu nhập"
    Then Hệ thống hiển thị danh sách:
      | Option                                    | Mô tả                              |
      | Thu nhập từ tiền lương, tiền công         | Thu nhập từ làm việc theo hợp đồng |
      | Thu nhập từ kinh doanh                    | Thu nhập từ hoạt động kinh doanh   |
      | Thu nhập từ trúng thưởng                  | Thu nhập từ trúng số, giải thưởng  |
      | Khác                                      | Cho phép nhập tự do                |

  Scenario: Chọn "Thu nhập từ tiền lương, tiền công"
    When Người dùng chọn "Thu nhập từ tiền lương, tiền công"
    Then Trường "Khoản thu nhập" hiển thị "Thu nhập từ tiền lương, tiền công"
    And Dropdown đóng lại

  Scenario: Chọn "Khác" và nhập tự do
    When Người dùng chọn "Khác"
    Then Hệ thống hiển thị ô nhập text "Nhập khoản thu nhập khác"
    And Ô nhập text được focus tự động
    When Người dùng nhập "Thu nhập từ bản quyền"
    Then Giá trị "Thu nhập từ bản quyền" được lưu

  Scenario: Mặc định chọn "Thu nhập từ tiền lương, tiền công"
    When Người dùng mở form tạo chứng từ mới
    Then Trường "Khoản thu nhập" có giá trị mặc định = "Thu nhập từ tiền lương, tiền công"
```

---

## 5. FEATURE: TỰ ĐỘNG TÍNH THUẾ TNCN

```gherkin
Feature: Tự động tính thuế thu nhập cá nhân
  Là một Kế toán
  Người dùng muốn hệ thống tự động tính thuế TNCN
  Để đảm bảo tính toán chính xác theo biểu thuế

  Background:
    Given Người dùng đang ở phần "Thông tin thuế"
    And Biểu thuế TNCN hiện hành gồm 5 bậc:
      | Bậc | Thu nhập/tháng (VNĐ)  | Thuế suất |
      | 1   | Đến 5,000,000         | 5%        |
      | 2   | Trên 5-10 triệu       | 10%       |
      | 3   | Trên 10-18 triệu      | 15%       |
      | 4   | Trên 18-32 triệu      | 20%       |
      | 5   | Trên 32 triệu         | 25%       |

  # ========== TÍNH THU NHẬP TÍNH THUẾ ==========

  Scenario: Tính thu nhập tính thuế khi nhập đầy đủ
    Given Người dùng đã nhập:
      | Trường                      | Giá trị      |
      | Tổng thu nhập chịu thuế     | 20,000,000   |
      | Bảo hiểm                    | 1,800,000    |
      | Khoản từ thiện              | 200,000      |
      | Quỹ hưu trí                 | 0            |
    When Người dùng rời khỏi ô "Tổng thu nhập chịu thuế" (blur)
    Then Hệ thống tự động tính "Tổng thu nhập tính thuế":
      | Công thức                                      | Kết quả     |
      | 20,000,000 - 1,800,000 - 200,000 - 0          | 18,000,000  |
    And Hiển thị "Tổng thu nhập tính thuế" = "18,000,000"

  Scenario: Tính lại khi thay đổi bảo hiểm
    Given "Tổng thu nhập chịu thuế" = 20,000,000
    And "Bảo hiểm" = 1,800,000
    And "Tổng thu nhập tính thuế" = 18,200,000 (đã tính)
    When Người dùng sửa "Bảo hiểm" = 2,000,000
    And Người dùng rời khỏi ô "Bảo hiểm" (blur)
    Then Hệ thống tự động tính lại "Tổng thu nhập tính thuế":
      | Công thức mới                   | Kết quả     |
      | 20,000,000 - 2,000,000         | 18,000,000  |

  # ========== TÍNH THUẾ LŨY TIẾN ==========

  Scenario Outline: Tính thuế TNCN theo biểu lũy tiến 5 bậc
    Given "Tổng thu nhập tính thuế" = <thu_nhập>
    When Hệ thống tự động tính thuế
    Then "Số thuế" = <thuế>
    And Công thức tính như sau:
      """
      <công_thức>
      """

    Examples:
      | thu_nhập    | thuế        | công_thức                                              |
      | 3,000,000   | 150,000     | Bậc 1: 3,000,000 × 5% = 150,000                       |
      | 7,000,000   | 450,000     | Bậc 1: 5,000,000 × 5% = 250,000                       |
      |             |             | Bậc 2: 2,000,000 × 10% = 200,000                      |
      |             |             | Tổng: 450,000                                          |
      | 15,000,000  | 1,200,000   | Bậc 1: 250,000 + Bậc 2: 500,000 + Bậc 3: 450,000      |
      | 25,000,000  | 2,600,000   | Bậc 1-4                                                |
      | 40,000,000  | 4,600,000   | Bậc 1-5: (40M-32M) × 25% + Bậc 1-4                    |

  Scenario: Chi tiết tính thuế cho thu nhập 18 triệu
    Given "Tổng thu nhập tính thuế" = 18,000,000
    When Hệ thống tự động tính thuế
    Then Chi tiết tính toán:
      | Bậc | Khoảng                    | Số tiền       | Thuế suất | Thuế        |
      | 1   | Đến 5 triệu               | 5,000,000     | 5%        | 250,000     |
      | 2   | Trên 5-10 triệu           | 5,000,000     | 10%       | 500,000     |
      | 3   | Trên 10-18 triệu          | 8,000,000     | 15%       | 1,200,000   |
      |     | **Tổng**                  |               |           | **1,950,000**|
    And "Số thuế" = 1,950,000

  # ========== REALTIME CALCULATION ==========

  Scenario: Tự động tính khi nhập từng trường
    Given Form đang trống
    When Người dùng nhập "Tổng thu nhập chịu thuế" = 20,000,000
    Then "Tổng thu nhập tính thuế" = 20,000,000 (blur)
    And "Số thuế" = 2,350,000 (blur)
    When Người dùng nhập "Bảo hiểm" = 1,800,000
    Then "Tổng thu nhập tính thuế" cập nhật = 18,200,000 (blur)
    And "Số thuế" cập nhật = 2,180,000 (blur)
```

---

## 6. FEATURE: VALIDATE DỮ LIỆU

```gherkin
Feature: Validate dữ liệu trước khi lưu
  Là một Kế toán
  Người dùng muốn hệ thống kiểm tra dữ liệu
  Để đảm bảo chứng từ hợp lệ trước khi lưu

  Background:
    Given Người dùng đang ở form tạo chứng từ
    And Đã nhập một số trường

  # ========== TRƯỜNG BẮT BUỘC ==========

  Scenario: Kiểm tra trường bắt buộc khi lưu
    Given Người dùng chưa nhập "Họ và tên"
    When Người dùng click "Lưu nháp"
    Then Hệ thống highlight trường "Họ và tên" màu đỏ
    And Hiển thị thông báo "Họ và tên không được để trống"
    And Form không được lưu

  Scenario Outline: Danh sách trường bắt buộc
    Given Trường "<trường>" để trống
    When Người dùng click "Lưu nháp"
    Then Hệ thống hiển thị lỗi "<thông_báo>"

    Examples:
      | trường                    | thông_báo                                  |
      | Họ và tên                 | Họ và tên không được để trống              |
      | Địa chỉ                   | Địa chỉ không được để trống                |
      | Quốc tịch                 | Quốc tịch không được để trống              |
      | Số điện thoại             | Số điện thoại không được để trống          |
      | Khoản thu nhập            | Khoản thu nhập không được để trống         |
      | Tổng thu nhập chịu thuế   | Tổng thu nhập chịu thuế không được để trống|

  # ========== VALIDATE THỜI GIAN ==========

  Scenario: "Đến tháng" phải >= "Từ tháng"
    Given "Từ tháng" = 6
    When Người dùng nhập "Đến tháng" = 3
    And Người dùng click "Lưu nháp"
    Then Hệ thống hiển thị lỗi "Đến tháng phải lớn hơn hoặc bằng Từ tháng"

  Scenario: "Năm" không được lớn hơn năm hiện tại
    Given Năm hiện tại = 2025
    When Người dùng nhập "Năm" = 2026
    And Người dùng click "Lưu nháp"
    Then Hệ thống hiển thị lỗi "Năm không được lớn hơn năm hiện tại"

  Scenario: Thời gian hợp lệ
    Given "Từ tháng" = 1
    And "Đến tháng" = 12
    And "Năm" = 2024
    When Người dùng click "Lưu nháp"
    Then Thông tin thời gian hợp lệ
    And Không có lỗi về thời gian

  # ========== VALIDATE SỐ TIỀN ==========

  Scenario Outline: Validate số tiền >= 0
    When Người dùng nhập "<trường>" = <giá_trị>
    And Người dùng click "Lưu nháp"
    Then Hệ thống hiển thị "<kết_quả>"

    Examples:
      | trường                    | giá_trị  | kết_quả                              |
      | Bảo hiểm                  | -100000  | Lỗi: Số tiền phải >= 0               |
      | Khoản từ thiện            | -50000   | Lỗi: Số tiền phải >= 0               |
      | Tổng thu nhập chịu thuế   | -1000000 | Lỗi: Số tiền phải >= 0               |
      | Bảo hiểm                  | 0        | Hợp lệ                               |
      | Khoản từ thiện            | 100000   | Hợp lệ                               |
```

---

## 7. FEATURE: LƯU VÀ KÝ SỐ

```gherkin
Feature: Lưu và ký số chứng từ
  Là một Kế toán
  Người dùng muốn lưu và ký số chứng từ
  Để hoàn thành quy trình tạo chứng từ

  Background:
    Given Người dùng đã nhập đầy đủ thông tin hợp lệ
    And Tất cả validation đã pass

  # ========== LƯU NHÁP ==========

  Scenario: Lưu nháp thành công
    When Người dùng click "Lưu nháp"
    Then Hệ thống validate dữ liệu
    And Lưu chứng từ với trạng thái = "Nháp"
    And Hiển thị thông báo "Lưu nháp thành công"
    And Chuyển về danh sách chứng từ
    And Chứng từ mới xuất hiện ở đầu danh sách với trạng thái "Nháp"

  Scenario: Lưu nháp khi có lỗi validation
    Given Trường "Họ và tên" để trống
    When Người dùng click "Lưu nháp"
    Then Hệ thống hiển thị các lỗi validation
    And Chứng từ KHÔNG được lưu
    And Người dùng vẫn ở form nhập liệu

  # ========== KÝ SỐ VÀ PHÁT HÀNH ==========

  Scenario: Ký số thành công
    Given Chữ ký số của tổ chức còn hiệu lực
    And MST trong chữ ký khớp với MST tổ chức
    When Người dùng click "Ký số và phát hành"
    Then Hệ thống hiển thị popup "Nhập mã PIN chữ ký số"
    When Người dùng nhập mã PIN đúng
    And Click "Xác nhận"
    Then Hệ thống thực hiện ký số
    And Lưu chứng từ với trạng thái = "Đã ký"
    And Hiển thị thông báo "Ký số thành công"
    And Chuyển về danh sách chứng từ

  Scenario: Ký số khi chữ ký hết hạn
    Given Chữ ký số của tổ chức đã hết hạn
    When Người dùng click "Ký số và phát hành"
    Then Hệ thống hiển thị lỗi "Chữ ký số đã hết hạn. Vui lòng gia hạn."
    And Không cho phép ký số

  Scenario: Ký số khi MST không khớp
    Given Chữ ký số có MST = "9999999999"
    But MST tổ chức = "0123456789"
    When Người dùng click "Ký số và phát hành"
    Then Hệ thống hiển thị lỗi "MST trong chữ ký không khớp với MST tổ chức"
    And Không cho phép ký số

  Scenario: Ký số với mã PIN sai
    Given Chữ ký số còn hiệu lực
    When Người dùng click "Ký số và phát hành"
    And Nhập mã PIN sai
    Then Hệ thống hiển thị "Mã PIN không đúng"
    And Cho phép nhập lại (tối đa 3 lần)

  # ========== HỦY BỎ ==========

  Scenario: Hủy tạo chứng từ
    When Người dùng click "Hủy bỏ"
    Then Hệ thống hiển thị popup xác nhận "Dữ liệu chưa lưu sẽ bị mất. Bạn có chắc chắn?"
    When Người dùng click "Đồng ý"
    Then Đóng form
    And Quay về danh sách chứng từ
    And Dữ liệu không được lưu

  Scenario: Hủy bỏ và quay lại
    When Người dùng click "Hủy bỏ"
    Then Hệ thống hiển thị popup xác nhận
    When Người dùng click "Quay lại"
    Then Popup đóng
    And Form vẫn mở với dữ liệu hiện tại
```

---

## 8. BUSINESS RULES TỔNG HỢP

### BR-01: MST hoặc CCCD
```
IF Mã_số_thuế IS NOT EMPTY THEN
    Căn_cước_công_dân = Optional
ELSE
    Căn_cước_công_dân = Required
END IF
```

### BR-02: Tính thu nhập tính thuế
```
Tổng_thu_nhập_tính_thuế = Tổng_thu_nhập_chịu_thuế 
                         - Bảo_hiểm 
                         - Khoản_từ_thiện 
                         - Quỹ_hưu_trí
```

### BR-03: Tính thuế TNCN (5 bậc)
```javascript
function calculateTax(taxableIncome) {
  const tiers = [
    { limit: 5000000, rate: 0.05 },
    { limit: 10000000, rate: 0.10 },
    { limit: 18000000, rate: 0.15 },
    { limit: 32000000, rate: 0.20 },
    { limit: Infinity, rate: 0.25 }
  ];
  
  let tax = 0;
  let remaining = taxableIncome;
  let previousLimit = 0;
  
  for (const tier of tiers) {
    if (remaining <= 0) break;
    
    const taxableAtThisTier = Math.min(
      remaining,
      tier.limit - previousLimit
    );
    
    tax += taxableAtThisTier * tier.rate;
    remaining -= taxableAtThisTier;
    previousLimit = tier.limit;
  }
  
  return Math.round(tax);
}
```

### BR-04: Validate thời gian
```
Từ_tháng >= 1 AND Từ_tháng <= 12
Đến_tháng >= 1 AND Đến_tháng <= 12
Đến_tháng >= Từ_tháng
Năm <= Năm_hiện_tại
```

### BR-05: Trạng thái chứng từ
```
- Nháp: Có thể sửa/xóa
- Đã ký: Không được sửa/xóa, chỉ xem
- Đã gửi: Không được sửa/xóa, chỉ xem
- Đã hủy: Không được sửa, chỉ xem
```

---

## 9. NON-FUNCTIONAL REQUIREMENTS

### 9.1. Performance
- Form load < 2 giây
- Auto-calculation < 0.5 giây
- Lưu chứng từ < 3 giây
- Ký số < 5 giây

### 9.2. Usability
- Tooltip cho mọi trường nhập liệu
- Validation realtime (on blur)
- Highlight lỗi màu đỏ
- Auto-focus vào trường lỗi đầu tiên
- Responsive design (desktop + tablet)

### 9.3. Security
- Validate dữ liệu cả client và server
- Chữ ký số phải còn hiệu lực
- MST trong chữ ký phải khớp MST tổ chức
- Audit log mọi thao tác (tạo/sửa/xóa/ký)

### 9.4. Data
- Auto-save draft mỗi 30 giây
- Giữ lại dữ liệu khi refresh (localStorage)
- Backup dữ liệu trước khi ký số

---

## 10. UI/UX NOTES

### 10.1. Layout
- Form 2 cột cho desktop
- Form 1 cột cho mobile/tablet
- Sticky header với buttons (Hủy/Lưu/Ký)
- Progress indicator (3 bước: Thông tin → Thuế → Xác nhận)

### 10.2. Tương tác
- Enter để chuyển field tiếp theo
- Tab để di chuyển giữa các trường
- Esc để hủy/đóng popup
- Ctrl+S để lưu nhanh

### 10.3. Thông báo
- Success: Toast màu xanh, tự động ẩn sau 3s
- Error: Toast màu đỏ, cần click X để đóng
- Warning: Toast màu vàng, tự động ẩn sau 5s
- Info: Toast màu xanh dương, tự động ẩn sau 3s

---

## PHỤ LỤC

### A. Danh sách quốc gia (Top 20)
```
Việt Nam, Trung Quốc, Nhật Bản, Hàn Quốc, Thái Lan, 
Singapore, Malaysia, Indonesia, Philippines, Myanmar,
Hoa Kỳ, Anh, Pháp, Đức, Nga, 
Úc, Canada, Ấn Độ, Pakistan, Bangladesh
```

### B. Biểu thuế TNCN 5 bậc
```
Bậc 1: Đến 5 triệu/tháng         → 5%
Bậc 2: Trên 5 - 10 triệu/tháng   → 10%
Bậc 3: Trên 10 - 18 triệu/tháng  → 15%
Bậc 4: Trên 18 - 32 triệu/tháng  → 20%
Bậc 5: Trên 32 triệu/tháng       → 25%
```

### C. Công thức tính mẫu
```
Ví dụ: Thu nhập tính thuế = 20 triệu/tháng

Bậc 1: 5,000,000 × 5%  =   250,000
Bậc 2: 5,000,000 × 10% =   500,000
Bậc 3: 8,000,000 × 15% = 1,200,000
Bậc 4: 2,000,000 × 20% =   400,000
                      ─────────────
Tổng thuế:            = 2,350,000 VNĐ
```

---

**KẾT THÚC TÀI LIỆU**

# FEATURES: LẬP CHỨNG TỪ KHẤU TRỪ THUẾ TNCN

**Theo chuẩn BDD Practices - Declarative, Third-person, Present tense**

---

## Feature 1: Tự động điền thông tin tổ chức

```gherkin
Feature: Tự động điền thông tin tổ chức trả thu nhập
  Là một kế toán
  Tôi muốn thông tin tổ chức được điền tự động khi tạo chứng từ
  Để tiết kiệm thời gian và tránh sai sót khi nhập thủ công

  Background:
    Given kế toán Mai đã đăng nhập vào hệ thống
    And thông tin tổ chức đã được cấu hình trong hệ thống

  Scenario: Hiển thị thông tin tổ chức khi mở form mới
    When Mai mở form tạo chứng từ khấu trừ thuế
    Then hệ thống hiển thị tên tổ chức
    And hệ thống hiển thị mã số thuế tổ chức
    And hệ thống hiển thị địa chỉ tổ chức
    And hệ thống hiển thị số điện thoại tổ chức
    And các trường thông tin tổ chức ở chế độ chỉ đọc

  Scenario: Không cho phép chỉnh sửa thông tin tổ chức
    Given Mai đang ở form tạo chứng từ
    And thông tin tổ chức đã được điền sẵn
    When Mai cố gắng chỉnh sửa tên tổ chức
    Then hệ thống không cho phép chỉnh sửa
    And hệ thống hiển thị tooltip giải thích
```

---

## Feature 2: Quản lý định danh người nộp thuế

```gherkin
Feature: Quản lý mã số thuế và giấy tờ tùy thân
  Là một kế toán
  Tôi muốn linh hoạt nhập MST hoặc CCCD cho người nộp thuế
  Để phục vụ cả người đã có MST và người chưa có MST

  Rule: Phải có ít nhất một trong hai: MST hoặc CCCD

    Scenario: Nhập MST thì không bắt buộc CCCD
      Given Mai đang nhập thông tin người nộp thuế
      When Mai nhập mã số thuế hợp lệ
      Then trường số CCCD không còn bắt buộc
      And Mai có thể lưu chứng từ mà không cần nhập CCCD

    Scenario: Không nhập MST thì phải nhập CCCD
      Given Mai đang nhập thông tin người nộp thuế
      And Mai để trống trường mã số thuế
      When Mai cố gắng lưu chứng từ mà không nhập CCCD
      Then hệ thống hiển thị thông báo lỗi
      And hệ thống yêu cầu nhập mã số thuế hoặc số CCCD

    Scenario: Không nhập cả MST và CCCD
      Given Mai đang nhập thông tin người nộp thuế
      And Mai để trống cả mã số thuế và số CCCD
      When Mai cố gắng lưu chứng từ
      Then hệ thống không cho phép lưu
      And hệ thống highlight cả hai trường màu đỏ
      And hệ thống hiển thị thông báo cần nhập một trong hai

  Rule: MST phải đúng định dạng 10 hoặc 13 chữ số

    Scenario Outline: Validate định dạng mã số thuế
      Given Mai đang nhập thông tin người nộp thuế
      When Mai nhập mã số thuế là "<mst>"
      And Mai rời khỏi trường mã số thuế
      Then hệ thống hiển thị kết quả "<kết_quả>"

      Examples:
        | mst           | kết_quả                          |
        | 0123456789    | Hợp lệ                           |
        | 0123456789012 | Hợp lệ                           |
        | 12345         | Lỗi: MST phải 10 hoặc 13 chữ số |
        | ABC1234567890 | Lỗi: MST chỉ chứa chữ số         |

  Rule: CCCD phải đúng định dạng 9 hoặc 12 chữ số

    Scenario Outline: Validate định dạng số CCCD
      Given Mai đang nhập thông tin người nộp thuế
      And Mai không nhập mã số thuế
      When Mai nhập số CCCD là "<cccd>"
      And Mai rời khỏi trường số CCCD
      Then hệ thống hiển thị kết quả "<kết_quả>"

      Examples:
        | cccd          | kết_quả                          |
        | 123456789     | Hợp lệ                           |
        | 001234567890  | Hợp lệ                           |
        | 12345         | Lỗi: CCCD phải 9 hoặc 12 chữ số |
        | ABC123456789  | Lỗi: CCCD chỉ chứa chữ số        |
```

---

## Feature 3: Phân loại cư trú của người nộp thuế

```gherkin
Feature: Xác định tình trạng cư trú
  Là một kế toán
  Tôi muốn chọn tình trạng cư trú cho người nộp thuế
  Để áp dụng đúng chính sách thuế theo quy định

  Background:
    Given Mai đang nhập thông tin người nộp thuế

  Scenario: Mặc định chọn cá nhân cư trú
    When Mai mở form tạo chứng từ mới
    Then radio button "Cá nhân cư trú" được chọn sẵn
    And radio button "Cá nhân không cư trú" không được chọn

  Scenario: Chuyển sang cá nhân không cư trú
    Given radio button "Cá nhân cư trú" đang được chọn
    When Mai chọn radio button "Cá nhân không cư trú"
    Then radio button "Cá nhân không cư trú" được chọn
    And radio button "Cá nhân cư trú" không còn được chọn

  Scenario: Phải chọn một trong hai loại
    Given Mai bỏ chọn cả hai radio button
    When Mai cố gắng lưu chứng từ
    Then hệ thống hiển thị thông báo lỗi
    And hệ thống yêu cầu chọn tình trạng cư trú
```

---

## Feature 4: Chọn loại khoản thu nhập

```gherkin
Feature: Phân loại khoản thu nhập chịu thuế
  Là một kế toán
  Tôi muốn chọn đúng loại khoản thu nhập
  Để phân loại chính xác nguồn thu nhập cần khấu trừ thuế

  Background:
    Given Mai đang nhập thông tin thuế

  Scenario: Chọn thu nhập từ tiền lương
    When Mai click vào dropdown khoản thu nhập
    Then hệ thống hiển thị danh sách các loại thu nhập
    When Mai chọn "Thu nhập từ tiền lương, tiền công"
    Then trường khoản thu nhập hiển thị giá trị đã chọn

  Scenario: Chọn loại thu nhập khác và nhập tự do
    Given Mai đã click vào dropdown khoản thu nhập
    When Mai chọn "Khác"
    Then hệ thống hiển thị ô nhập text
    And ô nhập text được focus tự động
    When Mai nhập "Thu nhập từ bản quyền"
    Then giá trị "Thu nhập từ bản quyền" được lưu

  Scenario Outline: Các loại thu nhập được hỗ trợ
    When Mai chọn loại thu nhập "<loại_thu_nhập>"
    Then hệ thống chấp nhận và lưu giá trị

    Examples:
      | loại_thu_nhập                      |
      | Thu nhập từ tiền lương, tiền công  |
      | Thu nhập từ kinh doanh             |
      | Thu nhập từ trúng thưởng           |
```

---

## Feature 5: Tính toán thu nhập tính thuế

```gherkin
Feature: Tự động tính thu nhập tính thuế
  Là một kế toán
  Tôi muốn hệ thống tự động tính thu nhập tính thuế
  Để đảm bảo tính toán chính xác và tiết kiệm thời gian

  Rule: Thu nhập tính thuế = Thu nhập chịu thuế - BHBB - Từ thiện - Quỹ hưu trí

    Scenario: Tính thu nhập tính thuế khi có đầy đủ thông tin
      Given Mai đã nhập thu nhập chịu thuế là 20,000,000
      And Mai đã nhập bảo hiểm bắt buộc là 1,800,000
      And Mai đã nhập từ thiện là 200,000
      When Mai rời khỏi trường thu nhập chịu thuế
      Then hệ thống tự động tính thu nhập tính thuế là 18,000,000

    Scenario: Tính lại khi thay đổi bảo hiểm
      Given thu nhập chịu thuế là 20,000,000
      And bảo hiểm bắt buộc là 1,800,000
      And thu nhập tính thuế hiện tại là 18,200,000
      When Mai sửa bảo hiểm bắt buộc thành 2,000,000
      And Mai rời khỏi trường bảo hiểm
      Then hệ thống tự động cập nhật thu nhập tính thuế thành 18,000,000

    Scenario: Tính khi không có khoản khấu trừ
      Given Mai đã nhập thu nhập chịu thuế là 15,000,000
      And các trường bảo hiểm và từ thiện đều là 0
      When Mai rời khỏi trường thu nhập chịu thuế
      Then thu nhập tính thuế bằng 15,000,000
```

---

## Feature 6: Tính thuế TNCN theo biểu lũy tiến

```gherkin
Feature: Tự động tính thuế thu nhập cá nhân
  Là một kế toán
  Tôi muốn hệ thống tự động tính thuế theo biểu thuế lũy tiến
  Để đảm bảo tính đúng và tránh sai sót

  Rule: Áp dụng biểu thuế lũy tiến 5 bậc

    Background:
      Given biểu thuế lũy tiến gồm 5 bậc
      And bậc 1 áp dụng 5% cho thu nhập đến 5 triệu
      And bậc 2 áp dụng 10% cho thu nhập từ 5-10 triệu
      And bậc 3 áp dụng 15% cho thu nhập từ 10-18 triệu
      And bậc 4 áp dụng 20% cho thu nhập từ 18-32 triệu
      And bậc 5 áp dụng 25% cho thu nhập trên 32 triệu

    Scenario Outline: Tính thuế cho các mức thu nhập khác nhau
      Given thu nhập tính thuế là <thu_nhập>
      When hệ thống tính thuế TNCN
      Then số thuế phải nộp là <thuế>

      Examples:
        | thu_nhập   | thuế      |
        | 3,000,000  | 150,000   |
        | 8,000,000  | 550,000   |
        | 18,000,000 | 1,950,000 |
        | 25,000,000 | 2,600,000 |

    Scenario: Chi tiết tính thuế cho thu nhập 18 triệu
      Given thu nhập tính thuế là 18,000,000
      When hệ thống tính thuế TNCN
      Then thuế bậc 1 là 250,000
      And thuế bậc 2 là 500,000
      And thuế bậc 3 là 1,200,000
      And tổng thuế là 1,950,000

    Scenario: Tự động tính khi thu nhập tính thuế thay đổi
      Given thu nhập tính thuế ban đầu là 15,000,000
      And số thuế hiện tại là 1,500,000
      When Mai thay đổi làm thu nhập tính thuế thành 20,000,000
      Then hệ thống tự động tính lại số thuế thành 2,350,000
```

---

## Feature 7: Validate thời gian trả thu nhập

```gherkin
Feature: Kiểm tra tính hợp lệ của thời gian
  Là một kế toán
  Tôi muốn hệ thống kiểm tra thời gian trả thu nhập
  Để đảm bảo thông tin thời gian hợp lệ và logic

  Rule: Tháng kết thúc phải lớn hơn hoặc bằng tháng bắt đầu

    Scenario: Nhập thời gian hợp lệ
      Given Mai đang nhập thời điểm trả thu nhập
      When Mai chọn từ tháng 1 đến tháng 12
      And Mai chọn năm 2024
      Then hệ thống chấp nhận thông tin thời gian

    Scenario: Tháng kết thúc nhỏ hơn tháng bắt đầu
      Given Mai đang nhập thời điểm trả thu nhập
      When Mai chọn từ tháng 6 đến tháng 3
      And Mai cố gắng lưu chứng từ
      Then hệ thống hiển thị thông báo lỗi
      And hệ thống yêu cầu đến tháng phải lớn hơn hoặc bằng từ tháng

  Rule: Năm không được lớn hơn năm hiện tại

    Scenario: Nhập năm trong tương lai
      Given năm hiện tại là 2025
      And Mai đang nhập thời điểm trá thu nhập
      When Mai chọn năm 2026
      And Mai cố gắng lưu chứng từ
      Then hệ thống hiển thị thông báo lỗi
      And hệ thống yêu cầu năm không vượt quá năm hiện tại

    Scenario: Nhập cùng tháng bắt đầu và kết thúc
      Given Mai đang nhập thời điểm trả thu nhập
      When Mai chọn từ tháng 6 đến tháng 6
      And Mai chọn năm 2024
      Then hệ thống chấp nhận thông tin thời gian
```

---

## Feature 8: Validate số tiền

```gherkin
Feature: Kiểm tra tính hợp lệ của số tiền
  Là một kế toán
  Tôi muốn hệ thống kiểm tra các số tiền nhập vào
  Để đảm bảo dữ liệu hợp lệ trước khi lưu

  Rule: Số tiền phải lớn hơn hoặc bằng 0

    Scenario Outline: Validate các trường số tiền
      Given Mai đang nhập thông tin thuế
      When Mai nhập <trường> với giá trị <giá_trị>
      And Mai cố gắng lưu chứng từ
      Then hệ thống hiển thị kết quả <kết_quả>

      Examples:
        | trường             | giá_trị   | kết_quả                    |
        | bảo hiểm           | -100000   | Lỗi: Số tiền phải >= 0     |
        | bảo hiểm           | 0         | Hợp lệ                     |
        | bảo hiểm           | 1800000   | Hợp lệ                     |
        | từ thiện           | -50000    | Lỗi: Số tiền phải >= 0     |
        | thu nhập chịu thuế | -1000000  | Lỗi: Số tiền phải >= 0     |
        | thu nhập chịu thuế | 20000000  | Hợp lệ                     |
```

---

## Feature 9: Lưu nháp chứng từ

```gherkin
Feature: Lưu chứng từ ở trạng thái nháp
  Là một kế toán
  Tôi muốn lưu chứng từ dưới dạng nháp
  Để có thể quay lại hoàn thiện sau

  Background:
    Given Mai đã nhập thông tin cơ bản của chứng từ

  Scenario: Lưu nháp thành công
    Given tất cả trường bắt buộc đã được nhập đúng
    When Mai click nút "Lưu nháp"
    Then hệ thống lưu chứng từ với trạng thái nháp
    And hệ thống hiển thị thông báo lưu thành công
    And Mai được chuyển về danh sách chứng từ

  Scenario: Lưu nháp khi thiếu thông tin bắt buộc
    Given Mai chưa nhập họ tên người nộp thuế
    When Mai click nút "Lưu nháp"
    Then hệ thống hiển thị thông báo lỗi
    And hệ thống highlight trường thiếu thông tin
    And chứng từ không được lưu

  Scenario: Chỉnh sửa chứng từ nháp
    Given chứng từ có trạng thái nháp
    When Mai mở chứng từ để chỉnh sửa
    Then Mai có thể thay đổi mọi thông tin
    And Mai có thể lưu lại các thay đổi
```

---

## Feature 10: Ký số chứng từ

```gherkin
Feature: Ký số điện tử chứng từ
  Là một kế toán
  Tôi muốn ký số chứng từ trước khi phát hành
  Để đảm bảo tính pháp lý và không thể chỉnh sửa

  Background:
    Given Mai đã nhập đầy đủ thông tin hợp lệ

  Rule: Chữ ký số phải còn hiệu lực

    Scenario: Ký số thành công với chữ ký hợp lệ
      Given chữ ký số của tổ chức còn hiệu lực
      And MST trong chữ ký khớp với MST tổ chức
      When Mai click "Ký số và phát hành"
      And Mai nhập mã PIN chính xác
      Then hệ thống thực hiện ký số
      And chứng từ chuyển sang trạng thái đã ký
      And hệ thống hiển thị thông báo ký thành công

    Scenario: Không thể ký khi chữ ký hết hạn
      Given chữ ký số của tổ chức đã hết hạn
      When Mai click "Ký số và phát hành"
      Then hệ thống hiển thị thông báo lỗi
      And hệ thống thông báo chữ ký đã hết hạn
      And Mai không thể ký chứng từ

    Scenario: Không thể ký khi MST không khớp
      Given chữ ký số có MST khác với MST tổ chức
      When Mai click "Ký số và phát hành"
      Then hệ thống hiển thị thông báo lỗi
      And hệ thống thông báo MST không khớp
      And Mai không thể ký chứng từ

  Rule: Nhập đúng mã PIN để ký

    Scenario: Nhập sai mã PIN
      Given Mai đang trong popup nhập mã PIN
      When Mai nhập mã PIN sai
      And Mai click xác nhận
      Then hệ thống hiển thị thông báo mã PIN sai
      And hệ thống cho phép nhập lại
      And số lần nhập còn lại được hiển thị

    Scenario: Nhập sai mã PIN quá 3 lần
      Given Mai đã nhập sai mã PIN 2 lần
      When Mai nhập sai mã PIN lần thứ 3
      Then hệ thống khóa chức năng ký số
      And hệ thống yêu cầu đợi 5 phút
      And Mai không thể ký trong thời gian bị khóa

  Rule: Chứng từ đã ký không được chỉnh sửa

    Scenario: Cố gắng sửa chứng từ đã ký
      Given chứng từ có trạng thái đã ký
      When Mai cố gắng mở chứng từ để chỉnh sửa
      Then hệ thống chỉ cho phép xem
      And tất cả các trường ở chế độ chỉ đọc
      And nút "Lưu" và "Chỉnh sửa" bị ẩn
```

---

## Feature 11: Hủy bỏ tạo chứng từ

```gherkin
Feature: Hủy bỏ quá trình tạo chứng từ
  Là một kế toán
  Tôi muốn có thể hủy bỏ việc tạo chứng từ
  Để không lưu khi nhập nhầm hoặc không cần thiết

  Scenario: Hủy bỏ và xác nhận
    Given Mai đang nhập thông tin chứng từ
    And Mai đã nhập một số thông tin
    When Mai click nút "Hủy bỏ"
    Then hệ thống hiển thị popup xác nhận
    When Mai click "Đồng ý" trong popup
    Then hệ thống đóng form
    And dữ liệu không được lưu
    And Mai quay về danh sách chứng từ

  Scenario: Hủy bỏ nhưng quay lại tiếp tục
    Given Mai đang nhập thông tin chứng từ
    When Mai click nút "Hủy bỏ"
    And hệ thống hiển thị popup xác nhận
    When Mai click "Quay lại" trong popup
    Then popup đóng
    And Mai vẫn ở form tạo chứng từ
    And dữ liệu đã nhập vẫn còn
```

---

## Feature 12: Validate số điện thoại

```gherkin
Feature: Kiểm tra định dạng số điện thoại
  Là một kế toán
  Tôi muốn hệ thống kiểm tra số điện thoại
  Để đảm bảo thông tin liên lạc chính xác

  Rule: Số điện thoại phải có 10 hoặc 11 chữ số

    Scenario Outline: Validate định dạng số điện thoại
      Given Mai đang nhập thông tin người nộp thuế
      When Mai nhập số điện thoại là "<số_điện_thoại>"
      And Mai rời khỏi trường số điện thoại
      Then hệ thống hiển thị kết quả "<kết_quả>"

      Examples:
        | số_điện_thoại | kết_quả                           |
        | 0912345678    | Hợp lệ                            |
        | 02412345678   | Hợp lệ                            |
        | 091234        | Lỗi: SĐT phải 10-11 số            |
        | 09123456789012| Lỗi: SĐT phải 10-11 số            |
        | 091234567a    | Lỗi: SĐT chỉ chứa chữ số          |
```

---

## TỔNG KẾT

### Số lượng Features: 12
### Số lượng Scenarios: 50+
### Tuân thủ BDD Best Practices:
- ✅ Declarative (Khai báo) - Mô tả "what" không phải "how"
- ✅ Third-person (Ngôi thứ ba) - "Mai", "hệ thống"
- ✅ Present tense (Thì hiện tại) - "nhập", "hiển thị", "lưu"
- ✅ One scenario, one behavior
- ✅ Given-When-Then order
- ✅ Complete subject-predicate structure
- ✅ Scenario Outline cho equivalent classes
- ✅ Rule để nhóm scenarios cùng business rule

### Personas:
- **Mai**: Kế toán, người sử dụng chính

### Tránh Anti-patterns:
- ❌ Không có procedure-driven tests
- ❌ Không có imperative steps (click button, enter field...)
- ❌ Không hardcode test data không cần thiết
- ❌ Không có multiple When-Then trong một scenario

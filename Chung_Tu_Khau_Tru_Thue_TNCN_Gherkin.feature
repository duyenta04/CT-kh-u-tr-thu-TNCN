# Feature: Chứng từ khấu trừ thuế thu nhập cá nhân (TNCN)

## Background
Tổ chức trả thu nhập cần phát hành chứng từ khấu trừ thuế TNCN điện tử cho cá nhân, hộ kinh doanh, cá nhân kinh doanh theo Nghị định 70/2025/NĐ-CP.

---

## Feature: Tạo chứng từ khấu trừ thuế TNCN

### Rule: Chứng từ phải có đầy đủ thông tin tổ chức, người nộp thuế và thuế khấu trừ

#### Scenario: Tạo chứng từ mới thành công
  Given kế toán đã đăng nhập vào hệ thống
  And thông tin tổ chức đã được cấu hình sẵn
  When kế toán tạo chứng từ khấu trừ thuế TNCN mới
  And kế toán nhập đầy đủ thông tin người nộp thuế
  And kế toán nhập thông tin khoản thu nhập và thuế
  And kế toán lưu chứng từ
  Then hệ thống tạo chứng từ với trạng thái "Nháp"
  And chứng từ được lưu trong danh sách

#### Scenario: Không thể tạo chứng từ khi thiếu thông tin bắt buộc
  Given kế toán đang tạo chứng từ khấu trừ thuế TNCN
  When kế toán bỏ trống trường "Họ và tên" người nộp thuế
  And kế toán nhấn "Lưu"
  Then hệ thống hiển thị thông báo lỗi "Họ và tên không được để trống"
  And chứng từ không được lưu

---

## Feature: Quản lý thông tin người nộp thuế

### Rule: Người nộp thuế phải có MST hoặc giấy tờ tùy thân

#### Scenario: Nhập thông tin người có MST
  Given kế toán đang nhập thông tin người nộp thuế
  When kế toán nhập mã số thuế "0123456789"
  Then trường "Số CMND/CCCD/Hộ chiếu" không bắt buộc
  And kế toán có thể lưu chứng từ

#### Scenario: Nhập thông tin người chưa có MST
  Given kế toán đang nhập thông tin người nộp thuế
  And trường "Mã số thuế" để trống
  When kế toán nhập số CCCD "001234567890"
  Then hệ thống chấp nhận thông tin
  And kế toán có thể lưu chứng từ

#### Scenario Outline: Validate mã số thuế và giấy tờ tùy thân
  Given kế toán đang nhập thông tin người nộp thuế
  When kế toán nhập <trường> với giá trị "<giá trị>"
  And kế toán nhấn "Lưu"
  Then hệ thống hiển thị thông báo "<kết quả>"

  Examples:
    | trường              | giá trị          | kết quả                                      |
    | Mã số thuế          |                  | Phải nhập MST hoặc giấy tờ tùy thân         |
    | Mã số thuế          | 0123             | MST không đúng định dạng                     |
    | Mã số thuế          | 0123456789       | Hợp lệ                                       |
    | Số CCCD             | 12345            | Số CMND/CCCD không hợp lệ                    |
    | Số CCCD             | 001234567890     | Hợp lệ                                       |

---

## Feature: Phân loại cá nhân cư trú và không cư trú

### Rule: Phải chọn một trong hai loại: cư trú hoặc không cư trú

#### Scenario: Chọn loại cá nhân cư trú (mặc định)
  Given kế toán đang tạo chứng từ mới
  When hệ thống hiển thị form thông tin người nộp thuế
  Then checkbox "Cá nhân cư trú" được chọn mặc định
  And checkbox "Cá nhân không cư trú" không được chọn

#### Scenario: Chuyển đổi sang cá nhân không cư trú
  Given checkbox "Cá nhân cư trú" đang được chọn
  When kế toán chọn checkbox "Cá nhân không cư trú"
  Then checkbox "Cá nhân cư trú" bị bỏ chọn
  And chỉ "Cá nhân không cư trú" được chọn

#### Scenario: Không được bỏ trống cả hai checkbox
  Given kế toán đang nhập thông tin người nộp thuế
  When kế toán bỏ chọn cả hai checkbox
  And kế toán nhấn "Lưu"
  Then hệ thống hiển thị thông báo "Phải chọn loại cá nhân"
  And chứng từ không được lưu

---

## Feature: Tính toán thuế thu nhập cá nhân

### Rule: Tổng thu nhập tính thuế = Thu nhập chịu thuế - BHBB - Từ thiện

#### Scenario: Tính thu nhập tính thuế tự động
  Given kế toán đang nhập thông tin thuế
  When kế toán nhập "Tổng thu nhập chịu thuế" là "20,000,000"
  And kế toán nhập "Khoản đóng BHBB" là "1,800,000"
  And kế toán nhập "Khoản đóng từ thiện" là "200,000"
  Then hệ thống tự động tính "Tổng thu nhập tính thuế" là "18,000,000"

#### Scenario: Tính thu nhập khi không có khấu trừ
  Given kế toán đang nhập thông tin thuế
  When kế toán nhập "Tổng thu nhập chịu thuế" là "15,000,000"
  And kế toán để trống "Khoản đóng BHBB"
  And kế toán để trống "Khoản đóng từ thiện"
  Then hệ thống tự động tính "Tổng thu nhập tính thuế" là "15,000,000"

---

## Feature: Tính thuế TNCN theo biểu thuế lũy tiến

### Rule: Áp dụng biểu thuế 5 bậc hiện hành

#### Scenario Outline: Tính thuế theo từng bậc thu nhập
  Given thu nhập tính thuế hàng tháng là <thu_nhập>
  When hệ thống tính thuế TNCN
  Then số thuế phải nộp là <thuế>
  And thuế suất áp dụng là <thuế_suất>

  Examples:
    | thu_nhập    | thuế        | thuế_suất                |
    | 3,000,000   | 150,000     | Bậc 1: 5%                |
    | 7,000,000   | 450,000     | Bậc 1: 5%, Bậc 2: 10%    |
    | 15,000,000  | 1,200,000   | Bậc 1-3                  |
    | 25,000,000  | 2,600,000   | Bậc 1-4                  |
    | 40,000,000  | 4,600,000   | Bậc 1-5                  |

#### Scenario: Tính thuế cho thu nhập 20 triệu/tháng
  Given thu nhập tính thuế là "20,000,000" VNĐ
  When hệ thống áp dụng biểu thuế lũy tiến
  Then thuế bậc 1 (5 triệu × 5%) là "250,000" VNĐ
  And thuế bậc 2 (5 triệu × 10%) là "500,000" VNĐ
  And thuế bậc 3 (8 triệu × 15%) là "1,200,000" VNĐ
  And thuế bậc 4 (2 triệu × 20%) là "400,000" VNĐ
  And tổng thuế phải nộp là "2,350,000" VNĐ

---

## Feature: Validate định dạng dữ liệu đầu vào

### Rule: Các trường phải đúng định dạng quy định

#### Scenario Outline: Validate số điện thoại
  Given kế toán đang nhập thông tin liên hệ
  When kế toán nhập số điện thoại "<số_điện_thoại>"
  And kế toán nhấn "Lưu"
  Then hệ thống hiển thị kết quả "<kết_quả>"

  Examples:
    | số_điện_thoại | kết_quả                           |
    | 0912345678    | Hợp lệ                            |
    | 0912          | Số điện thoại không đúng định dạng |
    | abcdefghij    | Số điện thoại không đúng định dạng |
    | 091234567890  | Số điện thoại không đúng định dạng |

#### Scenario Outline: Validate số tiền
  Given kế toán đang nhập thông tin thuế
  When kế toán nhập "<trường>" với giá trị "<giá_trị>"
  And kế toán nhấn "Lưu"
  Then hệ thống hiển thị "<kết_quả>"

  Examples:
    | trường                   | giá_trị   | kết_quả            |
    | Thu nhập chịu thuế       | 10000000  | Hợp lệ             |
    | Thu nhập chịu thuế       | -5000000  | Số tiền phải >= 0  |
    | Thu nhập chịu thuế       | abc       | Số tiền không hợp lệ |
    | Khoản đóng BHBB          | 1500000   | Hợp lệ             |

---

## Feature: Gửi chứng từ cho người nhận

### Rule: Chứng từ phải được ký số trước khi gửi

#### Scenario: Gửi chứng từ đã ký số thành công
  Given chứng từ có trạng thái "Đã ký"
  When kế toán nhấn "Gửi cho người nhận"
  And kế toán chọn phương thức gửi "Email"
  Then hệ thống gửi email chứa file PDF chứng từ
  And hệ thống gửi link tra cứu chứng từ
  And trạng thái chứng từ chuyển sang "Đã gửi"

#### Scenario: Không thể gửi chứng từ chưa ký
  Given chứng từ có trạng thái "Nháp"
  When kế toán nhấn "Gửi cho người nhận"
  Then hệ thống hiển thị thông báo "Chứng từ chưa được ký số"
  And chứng từ không được gửi

---

## Feature: Ký số chứng từ

### Rule: Chứng từ phải có chữ ký số hợp lệ của tổ chức

#### Scenario: Ký số chứng từ thành công
  Given chứng từ có trạng thái "Nháp"
  And chữ ký số của tổ chức còn hiệu lực
  And MST trong chữ ký số khớp với MST tổ chức
  When kế toán nhấn "Ký số"
  And kế toán nhập mã PIN chữ ký số
  Then hệ thống ký số thành công
  And trạng thái chứng từ chuyển sang "Đã ký"
  And chứng từ hiển thị chữ ký điện tử

#### Scenario: Không thể ký khi chữ ký số hết hạn
  Given chứng từ có trạng thái "Nháp"
  And chữ ký số của tổ chức đã hết hạn
  When kế toán nhấn "Ký số"
  Then hệ thống hiển thị thông báo "Chữ ký số đã hết hạn"
  And chứng từ không được ký

#### Scenario: Không thể ký khi MST không khớp
  Given chứng từ có trạng thái "Nháp"
  And MST trong chữ ký số là "9999999999"
  But MST tổ chức là "0123456789"
  When kế toán nhấn "Ký số"
  Then hệ thống hiển thị thông báo "MST không khớp"
  And chứng từ không được ký

---

## Feature: Tra cứu chứng từ

### Rule: Người nhận có thể tra cứu chứng từ bằng mã tra cứu

#### Scenario: Tra cứu chứng từ thành công
  Given người nhận có mã tra cứu hợp lệ
  When người nhận truy cập trang tra cứu
  And người nhận nhập mã tra cứu
  And người nhận nhấn "Tra cứu"
  Then hệ thống hiển thị thông tin chứng từ
  And người nhận có thể xem PDF chứng từ
  And người nhận có thể tải xuống chứng từ

#### Scenario: Không tra cứu được với mã không hợp lệ
  Given người nhận có mã tra cứu không tồn tại
  When người nhận nhập mã tra cứu
  And người nhận nhấn "Tra cứu"
  Then hệ thống hiển thị "Không tìm thấy chứng từ"

---

## Feature: Chỉnh sửa và hủy chứng từ

### Rule: Chỉ chứng từ ở trạng thái "Nháp" mới được chỉnh sửa

#### Scenario: Chỉnh sửa chứng từ nháp
  Given chứng từ có trạng thái "Nháp"
  When kế toán nhấn "Chỉnh sửa"
  And kế toán thay đổi thông tin
  And kế toán nhấn "Lưu"
  Then hệ thống cập nhật thông tin chứng từ
  And chứng từ vẫn ở trạng thái "Nháp"

#### Scenario: Không thể chỉnh sửa chứng từ đã ký
  Given chứng từ có trạng thái "Đã ký"
  When kế toán cố gắng chỉnh sửa chứng từ
  Then hệ thống hiển thị thông báo "Chứng từ đã ký không được sửa"
  And button "Chỉnh sửa" bị ẩn

#### Scenario: Hủy chứng từ nháp
  Given chứng từ có trạng thái "Nháp"
  When kế toán nhấn "Hủy"
  And kế toán xác nhận hủy
  Then trạng thái chứng từ chuyển sang "Đã hủy"
  And chứng từ không thể chỉnh sửa

---

## Feature: Ghi log hành động

### Rule: Mọi thao tác với chứng từ đều được ghi log

#### Scenario: Ghi log khi tạo chứng từ
  Given kế toán "Nguyễn Văn A" đăng nhập từ IP "192.168.1.100"
  When kế toán tạo chứng từ mới
  And kế toán lưu chứng từ
  Then hệ thống ghi log với thông tin sau:
    | Trường      | Giá trị                              |
    | Người dùng  | Nguyễn Văn A                         |
    | Hành động   | Tạo chứng từ khấu trừ thuế TNCN      |
    | Chức năng   | Chứng từ khấu trừ thuế TNCN          |
    | Nội dung    | Mã chứng từ: CT001, Người nhận: ...  |
    | Thời gian   | [Server timestamp]                   |
    | IP          | 192.168.1.100                        |

#### Scenario: Ghi log khi ký số
  Given kế toán "Trần Thị B" ký số chứng từ "CT002"
  When hệ thống ký số thành công
  Then hệ thống ghi log hành động "Ký số chứng từ CT002"
  And log chứa thông tin người ký và thời gian ký

---

## Feature: Kiểm soát quyền truy cập

### Rule: Chỉ người có quyền mới được tạo và quản lý chứng từ

#### Scenario: Tạo chứng từ với quyền hợp lệ
  Given người dùng có quyền "Register electronic document issuance"
  When người dùng truy cập chức năng tạo chứng từ
  Then hệ thống cho phép tạo chứng từ mới

#### Scenario: Không cho phép tạo chứng từ khi không có quyền
  Given người dùng không có quyền "Register electronic document issuance"
  When người dùng cố truy cập chức năng tạo chứng từ
  Then hệ thống hiển thị thông báo "Bạn không có quyền thực hiện"
  And người dùng bị chuyển về trang chủ

---

## Feature: Xuất và in chứng từ

### Rule: Chứng từ có thể được xuất ra PDF hoặc in trực tiếp

#### Scenario: Xuất chứng từ ra PDF
  Given chứng từ có trạng thái "Đã ký"
  When kế toán nhấn "Tải xuống PDF"
  Then hệ thống tạo file PDF chứng từ
  And file PDF chứa đầy đủ thông tin chứng từ
  And file PDF có chữ ký điện tử
  And file PDF có QR code

#### Scenario: In chứng từ trực tiếp
  Given chứng từ đang được xem chi tiết
  When kế toán nhấn "In"
  Then hệ thống mở cửa sổ in
  And nội dung in hiển thị đúng format chứng từ

---

## Feature: Quản lý danh sách chứng từ

### Rule: Danh sách hiển thị các chứng từ với thông tin tóm tắt

#### Scenario: Xem danh sách chứng từ
  Given kế toán có 10 chứng từ trong hệ thống
  When kế toán truy cập trang danh sách chứng từ
  Then hệ thống hiển thị 10 chứng từ
  And mỗi chứng từ hiển thị: Số, Người nhận, Số tiền thuế, Trạng thái, Ngày tạo

#### Scenario: Tìm kiếm chứng từ theo tên người nhận
  Given hệ thống có nhiều chứng từ
  When kế toán nhập từ khóa "Nguyễn Văn A"
  And kế toán nhấn "Tìm kiếm"
  Then hệ thống chỉ hiển thị chứng từ có người nhận là "Nguyễn Văn A"
  And thời gian tìm kiếm dưới 1 giây

#### Scenario: Lọc chứng từ theo trạng thái
  Given danh sách có chứng từ với nhiều trạng thái
  When kế toán chọn filter "Trạng thái: Đã ký"
  Then hệ thống chỉ hiển thị chứng từ có trạng thái "Đã ký"

---

## Feature: Thời điểm trả thu nhập

### Rule: Thời điểm phải là khoảng thời gian hợp lệ

#### Scenario: Nhập thời điểm trả thu nhập hợp lệ
  Given kế toán đang nhập thời điểm trả thu nhập
  When kế toán chọn "Từ tháng: 01"
  And kế toán chọn "Đến tháng: 12"
  And kế toán chọn "Năm: 2024"
  Then hệ thống chấp nhận thông tin

#### Scenario: Tháng kết thúc không được nhỏ hơn tháng bắt đầu
  Given kế toán đang nhập thời điểm trả thu nhập
  When kế toán chọn "Từ tháng: 06"
  And kế toán chọn "Đến tháng: 03"
  And kế toán nhấn "Lưu"
  Then hệ thống hiển thị "Tháng kết thúc phải lớn hơn hoặc bằng tháng bắt đầu"

#### Scenario: Năm không được lớn hơn năm hiện tại
  Given năm hiện tại là 2025
  And kế toán đang nhập thời điểm trả thu nhập
  When kế toán chọn "Năm: 2026"
  And kế toán nhấn "Lưu"
  Then hệ thống hiển thị "Năm không được lớn hơn năm hiện tại"

---

## Feature: Hiệu suất hệ thống

### Rule: Hệ thống phải đáp ứng trong thời gian quy định

#### Scenario: Tải form tạo chứng từ
  Given kế toán truy cập chức năng tạo chứng từ
  When hệ thống load form
  Then thời gian load dưới 2 giây
  And form hiển thị đầy đủ các trường

#### Scenario: Tính toán thuế tự động
  Given kế toán đang nhập thông tin thuế
  When kế toán nhập xong "Thu nhập chịu thuế"
  Then hệ thống tự động tính "Thu nhập tính thuế" trong vòng 0.5 giây
  And hệ thống tự động tính "Thuế phải nộp" trong vòng 0.5 giây

---

## Feature: Tự động điền thông tin tổ chức

### Rule: Thông tin tổ chức được lấy từ cấu hình

#### Scenario: Tự động điền thông tin tổ chức khi tạo mới
  Given thông tin tổ chức đã được cấu hình:
    | Trường                     | Giá trị                          |
    | Tên tổ chức                | CÔNG TY CỔ PHẦN MISA            |
    | Mã số thuế                 | 0101243150                      |
    | Địa chỉ                    | Tầng 9, tòa nhà Technosoft...   |
    | Điện thoại                 | 024 3562 6308                   |
  When kế toán tạo chứng từ mới
  Then các trường thông tin tổ chức được điền tự động
  And các trường này ở chế độ "read-only"

---

## Non-functional Requirements (Yêu cầu phi chức năng)

### Performance (Hiệu suất)
```gherkin
Scenario: Thời gian phản hồi
  Then form tạo chứng từ phải load trong < 2 giây
  And tự động tính toán phải hoàn thành trong < 0.5 giây
  And tìm kiếm chứng từ phải trả kết quả trong < 1 giây
```

### Security (Bảo mật)
```gherkin
Scenario: Kiểm tra bảo mật
  Then hệ thống phải kiểm tra quyền trước mọi thao tác
  And chữ ký số phải được validate
  And dữ liệu phải được mã hóa khi truyền tải
  And chứng từ đã ký không được phép sửa
```

### Usability (Khả năng sử dụng)
```gherkin
Scenario: Trải nghiệm người dùng
  Then các trường phải có tooltip/gợi ý
  And validation lỗi hiển thị tức thời
  And hỗ trợ autocomplete cho nhập liệu nhanh
  And giao diện responsive trên mọi thiết bị
```

---

## Glossary (Thuật ngữ)

- **TNCN**: Thu nhập cá nhân
- **MST**: Mã số thuế
- **CCCD**: Căn cước công dân
- **BHBB**: Bảo hiểm bắt buộc (BHXH, BHYT, BHTN)
- **CQT**: Cơ quan quản lý thuế
- **Chứng từ khấu trừ**: Chứng từ ghi nhận việc tổ chức đã khấu trừ thuế TNCN khi trả thu nhập cho cá nhân

---

## Business Rules Summary

1. **BR-01**: Phải có MST hoặc giấy tờ tùy thân
2. **BR-02**: Phải chọn loại cá nhân (cư trú hoặc không cư trú)
3. **BR-03**: Thu nhập tính thuế = Thu nhập chịu thuế - BHBB - Từ thiện
4. **BR-04**: Thuế TNCN tính theo biểu thuế lũy tiến 5 bậc
5. **BR-05**: Chỉ chứng từ "Nháp" mới được chỉnh sửa
6. **BR-06**: Chứng từ phải được ký số trước khi gửi
7. **BR-07**: Chữ ký số phải còn hiệu lực và MST phải khớp
8. **BR-08**: Mọi thao tác đều được ghi log đầy đủ

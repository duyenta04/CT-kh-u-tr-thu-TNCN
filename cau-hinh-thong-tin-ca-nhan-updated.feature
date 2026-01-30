@certificate @individual-info @template-editing
Feature: Cấu hình thông tin cá nhân, hộ kinh doanh, cá nhân kinh doanh
  
  Là một Kế toán
  Tôi muốn cấu hình các trường thông tin cá nhân hiển thị trên chứng từ
  Để thu thập đúng thông tin cần thiết theo quy định pháp lý

  Background: Người dùng đang cấu hình thông tin cá nhân
    Given Người dùng đã chọn mẫu chứng từ
    And Người dùng đang ở trang "Chỉnh sửa mẫu"
    And Tab "Nội dung hóa đơn" đang được chọn
    And Section "Thông tin cá nhân, hộ kinh doanh, cá nhân kinh doanh" đang mở

  # ============================================================
  # PHẦN 1: HIỂN THỊ MẶC ĐỊNH - TRƯỜNG BẮT BUỘC VÀ TÙY CHỌN
  # ============================================================

  @happy-path @smoke @default-display
  Scenario: Hiển thị các trường thông tin cá nhân mặc định
    When Section được tải lên
    Then Hệ thống hiển thị 8 trường thông tin
    And 4 trường BẮT BUỘC được đánh dấu chọn và không thể tắt:
      | Trường            | Bắt buộc | Checkbox |              Ghi chú                                    |
      | Họ và tên         | Có       | Checked & Disabled | Bắt buộc                                      |
      | Mã số thuế        | Có       | Checked & Disabled | Bắt buộc (Nếu có)                             |
      | Địa chỉ           | Có       | Checked & Disabled | Bắt buộc                                      |
      | Cá nhân cư trú    | Có       | Checked & Disabled | Bắt buộc (Nếu có) - Có/Không                  |

    And 4 trường TÙY CHỌN không được chọn mặc định:
      | Trường                | Bắt buộc | Checkbox | Ghi chú                                           |
      | Quốc tịch             | Không    | Unchecked | Nếu người nộp thuế không phải quốc tịch Việt Nam |
      | CCCD/HC               | Không    | Unchecked | Nếu không có MST thì require trường này          |
      | Địa chỉ thư điện tử   | Không    | Unchecked | Không bắt buộc                                   |
      | Ghi chú               | Không    | Unchecked | Nếu mẫu có thông tin cần in lên trường này       |

  # ============================================================
  # PHẦN 2: TRƯỜNG BẮT BUỘC - KHÔNG THỂ TẮT
  # ============================================================

  @required-fields @validation
  Scenario: Không thể tắt các trường bắt buộc
    Given 4 trường bắt buộc đang được checked và disabled
    When Người dùng cố gắng click vào checkbox của bất kỳ trường bắt buộc nào
    Then Checkbox vẫn ở trạng thái checked
    And Không có thay đổi nào xảy ra
    And Trường vẫn hiển thị trong preview

  # ============================================================
  # PHẦN 3: TRƯỜNG "CÁ NHÂN CƯ TRÚ" - DROPDOWN BẮT BUỘC
  # ============================================================

  @required-fields @resident-status
  Scenario: Trường "Cá nhân cư trú" luôn hiển thị với dropdown
    Given Trường "Cá nhân cư trú" là trường bắt buộc
    When Section được tải lên
    Then Checkbox "Cá nhân cư trú" đã checked và disabled
    And Dropdown "Cá nhân cư trú" hiển thị với 2 options:
      | Option value | Option text            |
      | "Có"         | Có                     |
      | "Không"      | Không                  |

  @resident-status
  Scenario: Chọn giá trị "Có" cho cá nhân cư trú
    Given Dropdown "Cá nhân cư trú" đang ở giá trị mặc định
    When Người dùng chọn "Có" từ dropdown
    Then Dropdown hiển thị giá trị "Có"
    And Preview cập nhật hiển thị "Cá nhân cư trú: Có"

  @resident-status
  Scenario: Chọn giá trị "Không" cho cá nhân cư trú
    Given Dropdown "Cá nhân cư trú" đang ở giá trị mặc định
    When Người dùng chọn "Không" từ dropdown
    Then Dropdown hiển thị giá trị "Không"
    And Preview cập nhật hiển thị "Cá nhân cư trú: Không"

  # ============================================================
  # PHẦN 4: TRƯỜNG TÙY CHỌN - CÓ THỂ BẬT/TẮT
  # ============================================================

  @optional-fields @toggle
  Scenario: Bật hiển thị trường tùy chọn "Quốc tịch"
    Given Trường "Quốc tịch" đang bị ẩn
    And Checkbox "Quốc tịch" không được check
    When Người dùng đánh dấu chọn checkbox "Quốc tịch"
    Then Preview hiển thị trường "Quốc tịch" với giá trị trống

  @optional-fields @toggle
  Scenario: Tắt trường tùy chọn "Địa chỉ thư điện tử"
    Given Trường "Địa chỉ thư điện tử" đang được hiển thị
    And Checkbox "Địa chỉ thư điện tử" đã được check
    When Người dùng bỏ chọn checkbox "Địa chỉ thư điện tử"
    Then Trường "Địa chỉ thư điện tử" biến mất khỏi preview
    And Checkbox chuyển sang unchecked

  @optional-fields @toggle
  Scenario: Bật trường "Ghi chú"
    Given Trường "Ghi chú" đang bị ẩn
    When Người dùng đánh dấu chọn "Ghi chú"
    Then Preview hiển thị trường "Ghi chú"
    
  # ============================================================
  # PHẦN 5: SẮP XẾP LẠI THỨ TỰ
  # ============================================================

  @field-reorder
  Scenario: Sắp xếp lại thứ tự trường bắt buộc
    Given Danh sách có 5 trường bắt buộc theo thứ tự mặc định
    When Người dùng kéo trường "CCCD/HC" lên vị trí sau "Địa chỉ"
    Then Danh sách trong settings cập nhật thứ tự:
      | Thứ tự | Trường         |
      | 1      | Họ và tên      |
      | 2      | Mã số thuế     |
      | 3      | Địa chỉ        |
      | 4      | CCCD/HC        |
      | 5      | Cá nhân cư trú |
    And Preview cũng cập nhật thứ tự hiển thị tương ứng
    And Checkbox vẫn checked và disabled

  @field-reorder
  Scenario: Sắp xếp trường tùy chọn giữa các trường bắt buộc
    Given Trường "Quốc tịch" đã được bật
    When Người dùng kéo "Quốc tịch" lên giữa "Mã số thuế" và "Địa chỉ"
    Then Thứ tự được cập nhật
    And Preview hiển thị theo thứ tự mới
    And Trạng thái checkbox của tất cả trường không thay đổi

  # ============================================================
  # PHẦN 6: VALIDATION DỮ LIỆU
  # ============================================================

  @data-validation @cccd
  Scenario: Validate định dạng số CCCD hợp lệ
    Given Trường "CCCD/HC" đang được hiển thị
    When Người dùng nhập "001099012345" vào trường CCCD
    And Người dùng rời khỏi trường (blur)
    Then Hệ thống chấp nhận giá trị hợp lệ (12 chữ số)
    And Preview hiển thị số CCCD đã nhập
    And Không có thông báo lỗi

  @data-validation @cccd
  Scenario: Từ chối số CCCD không hợp lệ
    Given Trường "CCCD/HC" đang được hiển thị
    When Người dùng nhập "abc123" vào trường CCCD
    And Người dùng rời khỏi trường
    Then Hệ thống hiển thị lỗi "Số CCCD không hợp lệ"
    And Input field có border màu đỏ
    And Không cập nhật giá trị vào preview

  @data-validation @email
  Scenario: Validate định dạng email hợp lệ
    Given Trường "Địa chỉ thư điện tử" đã được bật
    When Người dùng nhập "nguyenvana@email.com"
    And Người dùng rời khỏi trường
    Then Hệ thống chấp nhận email hợp lệ
    And Preview hiển thị địa chỉ email
    And Không có thông báo lỗi

  @data-validation @email
  Scenario: Từ chối email không hợp lệ
    Given Trường "Địa chỉ thư điện tử" đã được bật
    When Người dùng nhập "invalid-email"
    And Người dùng rời khỏi trường
    Then Hệ thống hiển thị lỗi "Email không đúng định dạng"
    And Input field có border màu đỏ
    And Không cập nhật giá trị vào preview

  # ============================================================
  # PHẦN 7: VALIDATION KHI LƯU MẪU
  # ============================================================

  @validation @save-template
  Scenario: Không thể lưu mẫu khi bỏ chọn tất cả trường
    Given Người dùng đã bỏ chọn tất cả trường tùy chọn
    And 5 trường bắt buộc vẫn checked (không thể tắt)
    When Người dùng nhấn nút "Lưu"
    Then Mẫu được lưu thành công
    And Chỉ có 5 trường bắt buộc hiển thị trong preview

  @validation @save-template
  Scenario: Đảm bảo ít nhất 5 trường bắt buộc luôn có
    Given Hệ thống đang kiểm tra trước khi lưu
    When Validation chạy
    Then Luôn có đúng 5 trường bắt buộc được checked
    And Không thể có trường hợp ít hơn 5 trường

  # ============================================================
  # PHẦN 8: TƯƠNG TÁC VỚI DỮ LIỆU MẪU
  # ============================================================

  @sample-data @toggle-on
  Scenario: Bật dữ liệu mẫu điền vào trường bắt buộc
    Given Toggle "Dữ liệu mẫu" đang tắt
    When Người dùng bật toggle "Dữ liệu mẫu"
    Then Các trường bắt buộc được điền dữ liệu:
      | Trường            | Giá trị mẫu                                    |
      | Họ và tên         | Nguyễn Văn A                                   |
      | Mã số thuế        | 0123456789012                                  |
      | Địa chỉ           | Số 456, Phường Láng Hạ, Quận Đống Đa, Hà Nội  |
      | Cá nhân cư trú    | Có                                             |
      | CCCD/HC           | 001099012345                                   |
    And Các trường tùy chọn đang bật cũng được điền dữ liệu (nếu có)

  @sample-data @toggle-off
  Scenario: Tắt dữ liệu mẫu xóa giá trị nhưng giữ trường hiển thị
    Given Toggle "Dữ liệu mẫu" đang bật
    And Tất cả trường bắt buộc đã có dữ liệu mẫu
    When Người dùng tắt toggle "Dữ liệu mẫu"
    Then Giá trị trong tất cả các input bị xóa
    And 5 trường bắt buộc VẪN hiển thị trong preview (chỉ xóa value)
    And Các trường tùy chọn đang bật cũng xóa giá trị nhưng vẫn hiển thị

  # ============================================================
  # PHẦN 9: VALIDATION LOGIC MST VÀ CCCD
  # ============================================================

  @validation @business-logic
  Scenario: Logic "MST HOẶC CCCD" khi phát hành chứng từ
    Given Người dùng đang phát hành chứng từ từ mẫu đã lưu
    And Trường "Mã số thuế" để trống
    And Trường "CCCD/HC" cũng để trống
    When Người dùng nhấn "Phát hành"
    Then Hiển thị lỗi "Phải có ít nhất Mã số thuế HOẶC CCCD/HC"
    And Không cho phép phát hành chứng từ

  @validation @business-logic
  Scenario: Phát hành thành công khi có MST
    Given Trường "Họ và tên" = "Nguyễn Văn A"
    And Trường "Địa chỉ" = "Hà Nội"
    And Trường "Mã số thuế" = "0123456789012"
    And Trường "CCCD/HC" để trống
    And Trường "Cá nhân cư trú" = "Có"
    When Người dùng phát hành chứng từ
    Then Chứng từ được phát hành thành công
    And Không có lỗi validation

  @validation @business-logic
  Scenario: Phát hành thành công khi có CCCD
    Given Trường "Họ và tên" = "Nguyễn Văn B"
    And Trường "Địa chỉ" = "TP HCM"
    And Trường "Mã số thuế" để trống
    And Trường "CCCD/HC" = "001099012345"
    And Trường "Cá nhân cư trú" = "Không"
    When Người dùng phát hành chứng từ
    Then Chứng từ được phát hành thành công

  @validation @business-logic
  Scenario: Bắt buộc chọn giá trị dropdown "Cá nhân cư trú"
    Given Tất cả trường bắt buộc đã điền
    And Dropdown "Cá nhân cư trú" đang ở giá trị mặc định (chưa chọn)
    When Người dùng phát hành chứng từ
    Then Hiển thị lỗi "Phải chọn tình trạng cá nhân cư trú"
    And Focus vào dropdown "Cá nhân cư trú"
    And Không cho phép phát hành

  # ============================================================
  # PHẦN 10: EDGE CASES
  # ============================================================

  @edge-case
  Scenario: Không thể thay đổi trạng thái trường bắt buộc qua DevTools
    Given Người dùng mở DevTools
    When Người dùng xóa attribute "disabled" khỏi checkbox "Họ và tên"
    And Cố gắng uncheck checkbox
    Then JavaScript validation ngăn chặn thay đổi
    And Checkbox tự động check lại
    And Hiển thị warning trong console

  @edge-case
  Scenario: Kéo thả vẫn hoạt động với trường bắt buộc
    Given Trường "Họ và tên" có checkbox disabled
    When Người dùng kéo icon "⋮⋮" của trường "Họ và tên"
    Then Icon drag vẫn hoạt động bình thường
    And Có thể thay đổi vị trí của trường
    And Checkbox vẫn giữ trạng thái checked & disabled

  @edge-case
  Scenario: Tất cả trường tùy chọn bị tắt
    Given Cả 3 trường tùy chọn đều unchecked
    When Người dùng xem preview
    Then Chỉ có 5 trường bắt buộc hiển thị
    And Preview vẫn hợp lệ
    And Có thể lưu mẫu thành công

@certificate @template-management
Feature: Quản lý mẫu chứng từ khấu trừ thuế TNCN
  
  Là một Kế toán
  Tôi muốn tạo và tùy chỉnh mẫu chứng từ khấu trừ thuế
  Để sử dụng cho việc phát hành chứng từ cho nhân viên theo đúng quy định

  # ============================================================
  # PHẦN 1: CHỌN MẪU CHỨNG TỪ
  # ============================================================

  Background: Người dùng truy cập trang chọn mẫu
    Given Người dùng đã đăng nhập vào hệ thống
    And Người dùng đang ở trang "Chọn mẫu chứng từ"

  @happy-path @smoke @template-selection
  Scenario: Chọn mẫu chứng từ khấu trừ thuế TNCN thành công
    Given Hệ thống hiển thị danh sách mẫu chứng từ
    When Người dùng chọn mẫu "Chứng từ điện tử khấu trừ thuế TNCN"
    Then Mẫu được đánh dấu là đã chọn
    And Nút "Tiếp tục" được kích hoạt

  @happy-path @template-selection
  Scenario: Xem trước mẫu chứng từ trước khi chọn
    Given Hệ thống hiển thị mẫu "Chứng từ điện tử khấu trừ thuế TNCN"
    When Người dùng xem preview mẫu chứng từ
    Then Preview hiển thị đầy đủ 3 phần chính
    And Watermark "MẪU CHỨNG TỪ" xuất hiện trên preview

  @happy-path @template-selection
  Scenario: Chuyển sang bước chỉnh sửa sau khi chọn mẫu
    Given Người dùng đã chọn mẫu "Chứng từ điện tử khấu trừ thuế TNCN"
    When Người dùng nhấn nút "Tiếp tục"
    Then Hệ thống chuyển đến trang "Chỉnh sửa mẫu"
    And Progress bar hiển thị bước 2 là đang hoạt động

  @filter @template-selection
  Scenario: Lọc mẫu theo loại chứng từ
    Given Sidebar hiển thị bộ lọc "Chứng từ"
    When Người dùng chọn "CT ĐT khấu trừ thuế TNCN" từ dropdown
    Then Hệ thống hiển thị các mẫu phù hợp
    And Badge hiển thị số lượng mẫu tìm thấy

  @filter @template-selection
  Scenario: Lọc mẫu theo khổ giấy
    Given Bộ lọc "Khổ giấy" hiển thị các tùy chọn
    When Người dùng chọn "A4 dọc"
    Then Hệ thống chỉ hiển thị các mẫu khổ A4 dọc
    And Preview mẫu có tỷ lệ khung hình đúng với A4

  @error-handling @template-selection
  Scenario: Thử tiếp tục khi chưa chọn mẫu
    Given Người dùng chưa chọn bất kỳ mẫu nào
    When Người dùng nhấn nút "Tiếp tục"
    Then Hệ thống hiển thị thông báo lỗi "Vui lòng chọn một mẫu chứng từ"
    And Người dùng vẫn ở trang "Chọn mẫu chứng từ"

  @navigation @template-selection
  Scenario: Hủy chọn mẫu và quay lại
    Given Người dùng đang ở trang "Chọn mẫu chứng từ"
    When Người dùng nhấn nút đóng
    Then Hệ thống hiển thị dialog xác nhận thoát
    And Khi người dùng xác nhận
    Then Hệ thống quay về màn hình trước đó

  # ============================================================
  # PHẦN 2: CẤU HÌNH THÔNG TIN TỔ CHỨC
  # ============================================================

  Background: Người dùng đang cấu hình thông tin tổ chức
    Given Người dùng đã chọn mẫu chứng từ
    And Người dùng đang ở trang "Chỉnh sửa mẫu"
    And Tab "Nội dung hóa đơn" đang được chọn
    And Section "Thông tin tổ chức trả thu nhập" đang mở

  @happy-path @smoke @organization-info
  Scenario: Hiển thị các trường thông tin tổ chức mặc định
    When Section được tải lên
    Then Hệ thống hiển thị 4 trường thông tin mặc định
    And Tất cả các trường đều được đánh dấu chọn
    And Preview hiển thị đầy đủ thông tin tổ chức

  @field-toggle @organization-info
  Scenario: Ẩn trường thông tin không cần thiết
    Given Trường "Điện thoại" đang được hiển thị
    When Người dùng bỏ chọn checkbox "Điện thoại"
    Then Trường "Điện thoại" biến mất khỏi preview
    And Các trường khác vẫn giữ nguyên vị trí

  @field-toggle @organization-info
  Scenario: Hiển thị lại trường đã ẩn
    Given Trường "Điện thoại" đang bị ẩn
    When Người dùng đánh dấu chọn checkbox "Điện thoại"
    Then Trường "Điện thoại" xuất hiện trở lại trong preview
    And Vị trí hiển thị đúng theo thứ tự danh sách

  @field-reorder @organization-info
  Scenario: Sắp xếp lại thứ tự hiển thị các trường
    Given Danh sách trường có thứ tự ban đầu
    When Người dùng kéo trường "Điện thoại" lên vị trí thứ 2
    Then Danh sách trường cập nhật thứ tự mới
    And Preview hiển thị các trường theo thứ tự mới

  @data-input @organization-info
  Scenario: Nhập dữ liệu vào trường thông tin
    Given Trường "Tên đơn vị" đang trống
    When Người dùng nhập "CÔNG TY TNHH ABC" vào trường
    And Người dùng rời khỏi trường nhập liệu
    Then Preview cập nhật hiển thị "CÔNG TY TNHH ABC"
    And Dữ liệu được lưu tự động

  @field-addition @organization-info
  Scenario: Thêm trường thông tin bổ sung
    Given Danh sách chỉ có 4 trường mặc định
    When Người dùng nhấn nút "Thêm thông tin"
    Then Hệ thống hiển thị danh sách các trường có thể thêm
    When Người dùng chọn trường "Email"
    Then Trường "Email" được thêm vào cuối danh sách
    And Trường mới mặc định ở trạng thái ẩn

  @validation @organization-info
  Scenario: Ngăn chặn ẩn tất cả các trường tổ chức
    Given Có 4 trường đang được hiển thị
    When Người dùng cố gắng bỏ chọn tất cả các trường
    Then Hệ thống hiển thị cảnh báo "Cần có ít nhất một trường thông tin tổ chức"
    And Không cho phép bỏ chọn trường cuối cùng

  # ============================================================
  # PHẦN 3: CẤU HÌNH THÔNG TIN CÁ NHÂN
  # ============================================================

  Background: Người dùng đang cấu hình thông tin cá nhân
    Given Người dùng đã chọn mẫu chứng từ
    And Người dùng đang ở trang "Chỉnh sửa mẫu"
    And Tab "Nội dung hóa đơn" đang được chọn
    And Section "Thông tin cá nhân, hộ kinh doanh, cá nhân kinh doanh" đang mở

  @happy-path @smoke @individual-info
  Scenario: Hiển thị các trường thông tin cá nhân mặc định
    When Section được tải lên
    Then Hệ thống hiển thị 10 trường thông tin
    And 3 trường đầu tiên được đánh dấu chọn mặc định
    And 7 trường còn lại ở trạng thái không chọn

  @field-toggle @individual-info
  Scenario: Bật hiển thị trường cá nhân cư trú
    Given Trường "Cá nhân cư trú" đang bị ẩn
    When Người dùng đánh dấu chọn "Cá nhân cư trú"
    Then Preview hiển thị trường "Cá nhân cư trú" với giá trị trống
    And Dropdown trong settings có 2 tùy chọn: "Có" và "Không"

  @field-toggle @individual-info
  Scenario: Chọn giá trị cho trường cá nhân cư trú
    Given Trường "Cá nhân cư trú" đang được hiển thị
    When Người dùng chọn "Có" từ dropdown
    Then Preview hiển thị "Cá nhân cư trú: Có"

  @field-toggle @individual-info
  Scenario: Chọn giá trị không cư trú
    Given Trường "Cá nhân cư trú" đang được hiển thị
    When Người dùng chọn "Không" từ dropdown
    Then Preview hiển thị "Cá nhân cư trú: Không"

  @field-reorder @individual-info
  Scenario: Thay đổi thứ tự hiển thị trường cá nhân
    Given Danh sách trường có thứ tự mặc định
    When Người dùng kéo trường "CCCD/HC" lên sau trường "Địa chỉ"
    Then Danh sách trong settings cập nhật thứ tự mới
    And Preview cũng cập nhật thứ tự hiển thị tương ứng

  @data-validation @individual-info
  Scenario: Validate định dạng số CCCD hợp lệ
    Given Trường "CCCD/HC" đang được hiển thị
    When Người dùng nhập "001099012345" vào trường CCCD
    Then Hệ thống chấp nhận giá trị hợp lệ
    And Preview hiển thị số CCCD đã nhập

  @data-validation @individual-info
  Scenario: Từ chối số CCCD không hợp lệ
    Given Trường "CCCD/HC" đang được hiển thị
    When Người dùng nhập "abc123" vào trường CCCD
    Then Hệ thống hiển thị lỗi "Số CCCD không hợp lệ"
    And Không cập nhật giá trị vào preview

  @data-validation @individual-info
  Scenario: Validate định dạng email hợp lệ
    Given Trường "Email" đang được hiển thị
    When Người dùng nhập "nguyenvana@email.com"
    Then Hệ thống chấp nhận email hợp lệ
    And Preview hiển thị địa chỉ email

  @data-validation @individual-info
  Scenario: Từ chối email không hợp lệ
    Given Trường "Email" đang được hiển thị
    When Người dùng nhập "invalid-email"
    Then Hệ thống hiển thị lỗi "Email không đúng định dạng"
    And Không cập nhật giá trị vào preview

  @validation @individual-info
  Scenario: Đảm bảo có ít nhất một trường cá nhân được chọn
    Given Có 3 trường đang được hiển thị
    When Người dùng cố gắng bỏ chọn tất cả các trường
    Then Hệ thống hiển thị cảnh báo "Cần có ít nhất một trường thông tin cá nhân"
    And Không cho phép bỏ chọn trường cuối cùng

  # ============================================================
  # PHẦN 4: TOGGLE DỮ LIỆU MẪU
  # ============================================================

  Background: Người dùng đang xem preview mẫu
    Given Người dùng đã chọn mẫu chứng từ
    And Người dùng đang ở trang "Chỉnh sửa mẫu"
    And Preview đang hiển thị mẫu chứng từ

  @happy-path @smoke @sample-data
  Scenario: Trạng thái mặc định khi mới vào trang
    When Trang "Chỉnh sửa mẫu" được tải lên lần đầu
    Then Toggle "Dữ liệu mẫu" ở trạng thái tắt
    And Phần thông tin tổ chức hiển thị đầy đủ dữ liệu
    And Phần thông tin cá nhân không có giá trị
    And Phần thông tin thuế không có giá trị
    And Phần chữ ký không hiển thị ngày tháng

  @toggle-on @sample-data
  Scenario: Bật dữ liệu mẫu
    Given Toggle "Dữ liệu mẫu" đang tắt
    When Người dùng bật toggle "Dữ liệu mẫu"
    Then Toggle chuyển sang trạng thái bật
    And Phần thông tin tổ chức giữ nguyên dữ liệu
    And Phần thông tin cá nhân hiển thị dữ liệu mẫu đầy đủ
    And Phần thông tin thuế hiển thị các giá trị mẫu
    And Phần chữ ký hiển thị "Hà Nội, ngày 28 tháng 03 năm 2024"

  @toggle-on @sample-data
  Scenario: Dữ liệu mẫu đồng bộ với settings panel
    Given Toggle "Dữ liệu mẫu" đang tắt
    When Người dùng bật toggle "Dữ liệu mẫu"
    Then Các trường input trong settings panel được điền tự động
    And Giá trị trong settings khớp với dữ liệu hiển thị trên preview

  @toggle-off @sample-data
  Scenario: Tắt dữ liệu mẫu
    Given Toggle "Dữ liệu mẫu" đang bật
    And Dữ liệu mẫu đang hiển thị trên preview
    When Người dùng tắt toggle "Dữ liệu mẫu"
    Then Toggle chuyển sang trạng thái tắt
    And Phần thông tin tổ chức giữ nguyên
    And Phần thông tin cá nhân xóa sạch giá trị
    And Phần thông tin thuế xóa sạch giá trị
    And Phần chữ ký ẩn ngày tháng
    And Các input trong settings panel bị xóa sạch

  @visual @sample-data
  Scenario: Toggle có giao diện iOS-style
    When Người dùng xem toggle "Dữ liệu mẫu"
    Then Toggle có kích thước 44x24 pixels
    And Khi tắt thì có màu nền xám
    And Khi bật thì có màu nền xanh
    And Vòng tròn trượt mượt mà khi chuyển trạng thái

  @data-completeness @sample-data
  Scenario: Dữ liệu mẫu phần cá nhân đầy đủ
    Given Toggle "Dữ liệu mẫu" được bật
    When Hệ thống hiển thị dữ liệu mẫu phần cá nhân
    Then Trường "Họ và tên" hiển thị "Nguyễn Văn A"
    And Trường "Mã số thuế" hiển thị "0123456789012"
    And Trường "Địa chỉ" hiển thị địa chỉ đầy đủ
    And Trường "Quốc tịch" hiển thị "Việt Nam"
    And Trường "Cá nhân cư trú" hiển thị "Có"
    And Các trường khác đều có giá trị phù hợp

  @data-completeness @sample-data
  Scenario: Dữ liệu mẫu phần thuế đầy đủ
    Given Toggle "Dữ liệu mẫu" được bật
    When Hệ thống hiển thị dữ liệu mẫu phần thuế
    Then Trường "Khoản thu nhập" hiển thị loại thu nhập cụ thể
    And Trường "Bảo hiểm" hiển thị số tiền với định dạng đúng
    And Trường "Thời điểm" hiển thị "01 - 12 - 2024"
    And Các trường tính toán hiển thị đúng kết quả

  # ============================================================
  # PHẦN 5: TÙY CHỈNH GIAO DIỆN
  # ============================================================

  Background: Người dùng đang tùy chỉnh giao diện
    Given Người dùng đã chọn mẫu chứng từ
    And Người dùng đang ở trang "Chỉnh sửa mẫu"
    And Tab "Giao diện & màu sắc" đang được chọn

  @font-selection @styling
  Scenario: Chọn phông chữ cho chứng từ
    Given Section "Phông chữ và màu sắc" đang mở
    When Người dùng mở dropdown "Phông chữ"
    Then Hệ thống hiển thị 4 font chữ khả dụng
    And Font hiện tại được đánh dấu

  @font-selection @styling
  Scenario: Thay đổi phông chữ
    Given Phông chữ hiện tại là "Arial"
    When Người dùng chọn "Times New Roman"
    Then Preview cập nhật toàn bộ text sang Times New Roman
    And Dropdown hiển thị Times New Roman là font đang chọn

  @color-selection @styling
  Scenario: Chọn màu chữ
    Given Color picker "Màu chữ" đang đóng
    When Người dùng mở color picker "Màu chữ"
    Then Hệ thống hiển thị 5 màu cơ bản
    And Màu đang chọn có viền highlight

  @color-selection @styling
  Scenario: Thay đổi màu chữ
    Given Màu chữ hiện tại là đen
    When Người dùng chọn màu xanh dương
    Then Preview cập nhật toàn bộ text sang màu xanh
    And Color picker highlight màu xanh đã chọn

  @color-selection @styling
  Scenario: Thay đổi màu viền
    Given Màu viền hiện tại là đen
    When Người dùng chọn màu tím cho viền
    Then Preview cập nhật viền header sang màu tím
    And Viền các section cũng đổi sang màu tím
    And Viền dòng ngăn cách cập nhật màu tương ứng

  @logo-upload @styling
  Scenario: Upload logo thành công
    Given Section "Logo" đang mở
    When Người dùng chọn file logo hợp lệ kích thước 1.5MB
    Then Logo được tải lên thành công
    And Preview hiển thị logo ở vị trí mặc định
    And Khu vực upload hiển thị thumbnail logo

  @logo-upload @validation @styling
  Scenario: Từ chối file logo quá lớn
    Given Khu vực upload logo đang trống
    When Người dùng chọn file logo 3MB
    Then Hệ thống hiển thị lỗi "Kích thước file không được vượt quá 2MB"
    And File không được tải lên
    And Khu vực upload giữ nguyên trạng thái trống

  @logo-upload @validation @styling
  Scenario: Từ chối file logo sai định dạng
    Given Khu vực upload logo đang trống
    When Người dùng chọn file PDF làm logo
    Then Hệ thống hiển thị lỗi "Định dạng file không hợp lệ"
    And File không được tải lên

  @logo-position @styling
  Scenario: Thay đổi vị trí logo
    Given Logo đã được tải lên
    And Logo đang ở góc trên trái
    When Người dùng chọn vị trí "Góc trên phải"
    Then Preview di chuyển logo sang góc phải
    And Layout header tự động điều chỉnh

  @watermark @styling
  Scenario: Upload watermark logo
    Given Section "Watermark" đang mở
    When Người dùng tải lên logo watermark
    Then Preview hiển thị watermark ở giữa chứng từ
    And Watermark có độ nghiêng âm 15 độ
    And Watermark có độ mờ mặc định 15%

  @watermark @styling
  Scenario: Điều chỉnh độ mờ watermark
    Given Watermark đang hiển thị
    And Slider độ mờ đang ở 15%
    When Người dùng kéo slider sang 50%
    Then Preview cập nhật watermark với độ mờ 50%
    And Label hiển thị "50%"

  @watermark @styling
  Scenario: Tăng độ mờ watermark lên tối đa
    Given Watermark đang hiển thị với độ mờ 15%
    When Người dùng kéo slider sang 100%
    Then Watermark hiển thị hoàn toàn đậm
    And Không còn trong suốt

  @watermark @styling
  Scenario: Giảm độ mờ watermark về tối thiểu
    Given Watermark đang hiển thị với độ mờ 50%
    When Người dùng kéo slider về 0%
    Then Watermark trở nên hoàn toàn trong suốt
    And Không nhìn thấy trên preview

  @decoration @styling
  Scenario: Tạo viền cho chứng từ
    Given Section "Ảnh nền và viền" đang mở
    When Người dùng nhấn nút "Tạo viền"
    Then Hệ thống thêm viền trang trí xung quanh chứng từ
    And Nút đổi thành "Xóa viền"

  @decoration @styling
  Scenario: Xóa viền đã tạo
    Given Chứng từ đang có viền trang trí
    When Người dùng nhấn nút "Xóa viền"
    Then Viền trang trí bị xóa khỏi preview
    And Nút đổi lại thành "Tạo viền"

  # ============================================================
  # PHẦN 6: LƯU VÀ XEM TRƯỚC
  # ============================================================

  Background: Người dùng chuẩn bị lưu mẫu
    Given Người dùng đã chọn mẫu chứng từ
    And Người dùng đang ở trang "Chỉnh sửa mẫu"
    And Người dùng đã hoàn thành cấu hình mẫu

  @validation @save
  Scenario: Kiểm tra điều kiện trước khi lưu
    Given Tất cả trường thông tin đã được cấu hình đúng
    When Người dùng nhấn nút "Lưu"
    Then Hệ thống kiểm tra có ít nhất 1 trường tổ chức
    And Hệ thống kiểm tra có ít nhất 1 trường cá nhân
    And Hệ thống kiểm tra logo không vượt quá 2MB
    And Hệ thống kiểm tra không có lỗi validation

  @validation @error-handling @save
  Scenario: Ngăn lưu khi thiếu trường tổ chức
    Given Tất cả trường tổ chức đều bị bỏ chọn
    When Người dùng nhấn nút "Lưu"
    Then Hệ thống hiển thị lỗi "Cần có ít nhất một trường thông tin tổ chức"
    And Mẫu không được lưu
    And Focus chuyển đến section thông tin tổ chức

  @validation @error-handling @save
  Scenario: Ngăn lưu khi thiếu trường cá nhân
    Given Tất cả trường cá nhân đều bị bỏ chọn
    When Người dùng nhấn nút "Lưu"
    Then Hệ thống hiển thị lỗi "Cần có ít nhất một trường thông tin cá nhân"
    And Mẫu không được lưu
    And Focus chuyển đến section thông tin cá nhân

  @validation @error-handling @save
  Scenario: Ngăn lưu khi logo quá lớn
    Given Logo có kích thước 3MB
    When Người dùng nhấn nút "Lưu"
    Then Hệ thống hiển thị lỗi "Kích thước file logo không được vượt quá 2MB"
    And Mẫu không được lưu

  @happy-path @smoke @save
  Scenario: Lưu mẫu thành công
    Given Tất cả validation đều pass
    When Người dùng nhấn nút "Lưu"
    Then Hệ thống lưu cấu hình mẫu vào cơ sở dữ liệu
    And Hiển thị thông báo "Lưu mẫu thành công"
    And Chuyển về trang danh sách mẫu

  @auto-save @save
  Scenario: Tự động lưu nháp khi chỉnh sửa
    Given Người dùng đang chỉnh sửa mẫu
    When Người dùng thay đổi bất kỳ cài đặt nào
    And Hệ thống đợi 5 giây
    Then Bản nháp được lưu tự động
    And Hiển thị indicator "Đã lưu nháp"

  @auto-save @save
  Scenario: Khôi phục bản nháp khi quay lại
    Given Người dùng đã thoát giữa chừng trước đó
    And Có bản nháp đã được lưu
    When Người dùng quay lại trang "Chỉnh sửa mẫu"
    Then Hệ thống hiển thị dialog "Bạn có muốn khôi phục bản nháp?"
    When Người dùng chọn "Có"
    Then Hệ thống tải cấu hình từ bản nháp
    And Tất cả settings được khôi phục như cũ

  @auto-save @save
  Scenario: Từ chối khôi phục bản nháp
    Given Có bản nháp đã được lưu
    And Dialog khôi phục đang hiển thị
    When Người dùng chọn "Không"
    Then Hệ thống xóa bản nháp
    And Bắt đầu với mẫu rỗng mặc định

  @auto-save @save
  Scenario: Xóa bản nháp sau khi lưu thành công
    Given Có bản nháp đang lưu
    When Người dùng lưu mẫu thành công
    Then Hệ thống xóa bản nháp khỏi storage
    And Không hiển thị dialog khôi phục lần sau

  @preview
  Scenario: Mở chế độ xem trước đầy đủ
    Given Người dùng đã cấu hình xong mẫu
    When Người dùng nhấn nút "Xem trước"
    Then Hệ thống mở modal xem trước toàn màn hình
    And Mẫu hiển thị với kích thước thực tế
    And Không có watermark "MẪU CHỨNG TỪ"
    And Hiển thị đầy đủ như bản in

  @preview
  Scenario: Đóng chế độ xem trước
    Given Modal xem trước đang mở
    When Người dùng nhấn nút "Đóng"
    Then Modal đóng lại
    And Quay về trang "Chỉnh sửa mẫu"

  @export-pdf
  Scenario: Xuất mẫu ra file PDF
    Given Modal xem trước đang mở
    When Người dùng nhấn nút "Xuất PDF"
    Then Hệ thống tạo file PDF với kích thước A4
    And File được tải về máy người dùng
    And Tên file có định dạng "ChungTu_MauSo_03TNCN_{timestamp}.pdf"

  @export-pdf
  Scenario: PDF có chất lượng cao
    Given Hệ thống đang tạo file PDF
    Then PDF có orientation portrait
    And PDF có font được nhúng đầy đủ
    And PDF có độ phân giải 300 DPI
    And PDF giữ nguyên định dạng và màu sắc

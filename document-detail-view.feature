Feature: Xem chi tiết chứng từ từ danh sách
  Là người dùng hệ thống
  Tôi muốn xem thông tin chi tiết của chứng từ
  Để có thể nắm rõ thông tin và thực hiện các thao tác liên quan

  Background:
    Given người dùng đã đăng nhập vào hệ thống
    And người dùng đang ở trang danh sách chứng từ

  # Truy cập chi tiết chứng từ
  Scenario: Xem chi tiết chứng từ từ danh sách
    Given danh sách có chứng từ với mã số "123456"
    When người dùng nhấn vào chứng từ "123456"
    Then hệ thống hiển thị chi tiết chứng từ
    And thông tin cá nhân và hộ kinh doanh được hiển thị
    And thông tin thuế thu nhập cá nhân khấu trừ được hiển thị

  # Hiển thị thông tin cá nhân
  Scenario: Hiển thị thông tin cá nhân người nhận
    Given người dùng đang xem chi tiết chứng từ
    When hệ thống tải thông tin chi tiết
    Then mã số thuế cá nhân được hiển thị
    And thông tin cá nhân bao gồm họ tên, địa chỉ, quốc tịch, giới tính được hiển thị
    And thông tin liên hệ bao gồm số điện thoại và email được hiển thị

  Scenario: Hiển thị thông tin hộ kinh doanh
    Given người dùng đang xem chi tiết chứng từ của cá nhân có hộ kinh doanh
    When hệ thống tải thông tin chi tiết
    Then số CCCD/HC chứng minh kinh doanh cá nhân được hiển thị
    And mã số thuế hộ kinh doanh được hiển thị

  # Hiển thị thông tin thuế
  Scenario: Hiển thị thông tin thuế thu nhập
    Given người dùng đang xem chi tiết chứng từ
    When hệ thống tải thông tin thuế
    Then khoản thu nhập được hiển thị
    And thời điểm nộp thuế được hiển thị
    And các khoản tiền bao gồm thu nhập, khấu trừ và đóng thuế được hiển thị
    And tổng thu nhập chịu thuế và tổng thu nhập đã thuế được hiển thị

  # Các nút thao tác theo trạng thái
  Scenario: Hiển thị nút thao tác cho chứng từ Nhập
    Given có chứng từ ở trạng thái "Nhập"
    When người dùng xem chi tiết chứng từ
    Then các nút "Xóa", "Sao chép", "Tải xuống" được hiển thị
    And các nút "Chỉnh sửa", "Gửi email", "Phát hành" được hiển thị

  Scenario: Hiển thị nút thao tác cho chứng từ Phát hành lỗi
    Given có chứng từ ở trạng thái "Phát hành lỗi"
    When người dùng xem chi tiết chứng từ
    Then các nút "Sao chép", "Tải xuống" được hiển thị
    But nút "Xóa" không được hiển thị

  Scenario: Hiển thị nút thao tác cho chứng từ CQT kiểm tra không hợp lệ
    Given có chứng từ ở trạng thái "CQT kiểm tra không hợp lệ"
    When người dùng xem chi tiết chứng từ
    Then các nút "Sao chép", "Tải xuống" được hiển thị
    But nút "Xóa" không được hiển thị

  Scenario: Hiển thị nút thao tác và xử lý cho chứng từ Đã gửi CQT
    Given có chứng từ ở trạng thái "Đã gửi CQT"
    When người dùng xem chi tiết chứng từ
    Then các nút "Sao chép", "Tải xuống", "Gửi email" được hiển thị
    And nút dropdown "Xử lý chứng từ" được hiển thị
    And nút dropdown chứa các tùy chọn "Gửi thông báo sai sót tới CQT", "Điều chỉnh chứng từ", "Thay thế chứng từ"

  # Thao tác Xóa chứng từ
  Scenario: Xóa chứng từ ở trạng thái Nhập
    Given người dùng đang xem chi tiết chứng từ ở trạng thái "Nhập"
    When người dùng nhấn nút "Xóa"
    And người dùng xác nhận xóa
    Then chứng từ bị xóa khỏi hệ thống
    And người dùng được chuyển về trang danh sách chứng từ
    And chứng từ không còn hiển thị trong danh sách

  Scenario: Không thể xóa chứng từ đã gửi CQT
    Given người dùng đang xem chi tiết chứng từ ở trạng thái "Đã gửi CQT"
    When người dùng xem các nút thao tác
    Then nút "Xóa" không được hiển thị

  # Thao tác Sao chép chứng từ
  Scenario: Sao chép chứng từ
    Given người dùng đang xem chi tiết chứng từ
    When người dùng nhấn nút "Sao chép"
    Then một bản sao của chứng từ được tạo với trạng thái "Nhập"
    And bản sao có thông tin giống chứng từ gốc
    And người dùng được chuyển đến trang chỉnh sửa bản sao

  # Thao tác Tải xuống
  Scenario: Tải xuống chứng từ
    Given người dùng đang xem chi tiết chứng từ
    When người dùng nhấn nút "Tải xuống"
    Then file PDF của chứng từ được tải về máy người dùng

  # Thao tác Chỉnh sửa
  Scenario: Chỉnh sửa chứng từ ở trạng thái Nhập
    Given người dùng đang xem chi tiết chứng từ ở trạng thái "Nhập"
    When người dùng nhấn nút "Chỉnh sửa"
    Then người dùng được chuyển đến trang chỉnh sửa chứng từ
    And người dùng có thể cập nhật thông tin chứng từ

  Scenario: Không thể chỉnh sửa chứng từ đã gửi CQT
    Given người dùng đang xem chi tiết chứng từ ở trạng thái "Đã gửi CQT"
    When người dùng xem các nút thao tác
    Then nút "Chỉnh sửa" không được hiển thị

  # Thao tác Gửi email
  Scenario: Gửi email chứng từ
    Given người dùng đang xem chi tiết chứng từ
    When người dùng nhấn nút "Gửi email"
    Then hệ thống mở form gửi email
    And email đính kèm file PDF chứng từ
    And người dùng có thể nhập địa chỉ email người nhận

  # Thao tác Phát hành
  Scenario: Phát hành chứng từ ở trạng thái Nhập
    Given người dùng đang xem chi tiết chứng từ ở trạng thái "Nhập"
    And thông tin chứng từ đã đầy đủ và hợp lệ
    When người dùng nhấn nút "Phát hành"
    And người dùng xác nhận phát hành
    Then chứng từ được gửi lên cơ quan thuế
    And trạng thái chứng từ chuyển sang "Đã gửi CQT"

  Scenario: Không thể phát hành chứng từ với thông tin không đầy đủ
    Given người dùng đang xem chi tiết chứng từ ở trạng thái "Nhập"
    And chứng từ có các trường thông tin bắt buộc còn trống
    When người dùng nhấn nút "Phát hành"
    Then hệ thống hiển thị thông báo lỗi các trường bắt buộc
    And chứng từ không được phát hành

  # Xử lý chứng từ đã gửi CQT
  Scenario: Gửi thông báo sai sót tới CQT
    Given người dùng đang xem chi tiết chứng từ ở trạng thái "Đã gửi CQT"
    When người dùng nhấn vào nút dropdown "Xử lý chứng từ"
    And người dùng chọn "Gửi thông báo sai sót tới CQT"
    And người dùng nhập nội dung sai sót
    And người dùng xác nhận gửi
    Then thông báo sai sót được gửi đến cơ quan thuế
    And hệ thống lưu lại lịch sử gửi thông báo

  Scenario: Điều chỉnh chứng từ
    Given người dùng đang xem chi tiết chứng từ ở trạng thái "Đã gửi CQT"
    When người dùng nhấn vào nút dropdown "Xử lý chứng từ"
    And người dùng chọn "Điều chỉnh chứng từ"
    Then hệ thống tạo một chứng từ điều chỉnh mới
    And chứng từ điều chỉnh liên kết với chứng từ gốc
    And người dùng được chuyển đến trang chỉnh sửa chứng từ điều chỉnh

  Scenario: Thay thế chứng từ
    Given người dùng đang xem chi tiết chứng từ ở trạng thái "Đã gửi CQT"
    When người dùng nhấn vào nút dropdown "Xử lý chứng từ"
    And người dùng chọn "Thay thế chứng từ"
    Then hệ thống tạo một chứng từ thay thế mới
    And chứng từ thay thế liên kết với chứng từ gốc
    And người dùng được chuyển đến trang chỉnh sửa chứng từ thay thế

  # Lịch sử truyền nhận với CQT
  Scenario: Xem lịch sử truyền nhận với CQT
    Given người dùng đang xem chi tiết chứng từ đã gửi CQT
    When người dùng chuyển sang tab "Lịch sử truyền nhận"
    Then danh sách các lần gửi nhận với CQT được hiển thị
    And mỗi bản ghi hiển thị thời gian, trạng thái và nội dung

  # Tính chất chứng từ với đầy đủ thông tin
  Scenario: Hiển thị đầy đủ thông tin chứng từ với các trường dữ liệu
    Given người dùng đang xem chi tiết chứng từ "123456"
    When hệ thống tải thông tin chi tiết
    Then các thông tin sau được hiển thị đầy đủ:
      | Trường thông tin                     | Giá trị ví dụ                                    |
      | Ngày chứng từ                        | 07/05/2024 15:41                                 |
      | Số chứng từ                          | 00005423                                         |
      | Mẫu chứng từ                         | 1C25YY                                           |
      | Mã số thuế cá nhân                   | 001196088999                                     |
      | Số CCCD/HC                           | 001196088999                                     |
      | Địa chỉ                              | Phòng 803 Khu phức hợp TimeCity, Phường Hai Bà Trưng, TP. Hà Nội |
      | Quốc tịch                            | Việt Nam                                         |
      | Cá nhân cư trú                       | Có                                               |
      | Số điện thoại                        | 0968999888                                       |
      | Email                                | tuanphuong@gmail.com                             |
      | Khoản thu nhập                       | Tiền lương, tiền công                            |
      | Thời điểm nộp thuế                   | Từ tháng 2 đến tháng 10, năm 2025               |
      | Thu nhập                             | 1,000,000                                        |
      | Khấu trừ thuế                        | 1,000,000                                        |
      | Đưa hóa đơn người được trả           | 1,000,000                                        |
      | Tổng thu nhập chịu thuế              | 1,000,000                                        |
      | Tổng thu nhập đã thuế                | 1,000,000                                        |
      | Số thuế                              | 1,000,000                                        |

  # Kiểm tra quyền hạn
  Scenario Outline: Kiểm soát quyền thao tác theo vai trò và trạng thái
    Given người dùng có vai trò <role>
    And có chứng từ ở trạng thái <status>
    When người dùng xem chi tiết chứng từ
    Then người dùng <can_edit> chỉnh sửa
    And người dùng <can_delete> xóa
    And người dùng <can_publish> phát hành
    And người dùng <can_handle> xử lý chứng từ CQT

    Examples:
      | role     | status                      | can_edit  | can_delete | can_publish | can_handle |
      | admin    | Nhập                        | có thể    | có thể     | có thể      | không thể  |
      | admin    | Đã gửi CQT                  | không thể | không thể  | không thể   | có thể     |
      | manager  | Nhập                        | có thể    | có thể     | có thể      | không thể  |
      | manager  | Đã gửi CQT                  | không thể | không thể  | không thể   | có thể     |
      | user     | Nhập                        | có thể    | không thể  | không thể   | không thể  |
      | user     | Đã gửi CQT                  | không thể | không thể  | không thể   | không thể  |

  # Xử lý lỗi
  Scenario: Hiển thị thông báo khi không tải được chi tiết chứng từ
    Given người dùng đang ở danh sách chứng từ
    When người dùng nhấn vào một chứng từ
    And hệ thống không thể tải thông tin chi tiết
    Then hệ thống hiển thị thông báo lỗi
    And người dùng có thể thử lại hoặc quay về danh sách

  Scenario: Hiển thị cảnh báo khi chứng từ đang được xử lý
    Given có chứng từ đang trong quá trình gửi CQT
    When người dùng xem chi tiết chứng từ
    Then hệ thống hiển thị thông báo chứng từ đang xử lý
    And các nút thao tác bị vô hiệu hóa cho đến khi hoàn tất xử lý

Feature: Quản lý danh sách mẫu chứng từ
  Là người dùng hệ thống
  Tôi muốn quản lý danh sách mẫu chứng từ
  Để có thể tạo, sử dụng và ngừng sử dụng các mẫu chứng từ theo nhu cầu

  Background:
    Given người dùng đã đăng nhập vào hệ thống
    And người dùng đang ở trang quản lý mẫu chứng từ

  # Xem danh sách mẫu chứng từ
  Scenario: Hiển thị danh sách mẫu chứng từ
    Given hệ thống có các mẫu chứng từ đã được tạo
    When người dùng truy cập trang quản lý mẫu
    Then danh sách mẫu chứng từ được hiển thị
    And mỗi mẫu hiển thị tên mẫu và trạng thái sử dụng

  # Tạo mẫu chứng từ mới
  Scenario: Tạo mẫu chứng từ mới thành công
    When người dùng nhấn nút "Tạo mẫu chứng từ"
    And người dùng nhập thông tin mẫu chứng từ hợp lệ
    And người dùng xác nhận tạo mẫu
    Then mẫu chứng từ mới được tạo thành công
    And mẫu mới xuất hiện trong danh sách mẫu

  # Xem chi tiết mẫu chứng từ
  Scenario: Xem chi tiết mẫu chứng từ
    Given hệ thống có mẫu chứng từ "Mẫu draft 2 - CTT56AB/2026/E"
    When người dùng chọn xem mẫu "Mẫu draft 2 - CTT56AB/2026/E"
    Then nội dung chi tiết của mẫu được hiển thị
    And người dùng thấy các nút "Sao chép" và "Chỉnh sửa"

  # Sao chép mẫu chứng từ
  Scenario: Sao chép mẫu chứng từ hiện có
    Given người dùng đang xem mẫu chứng từ "Mẫu draft 2 - CTT56AB/2026/E"
    When người dùng nhấn nút "Sao chép"
    And người dùng nhập tên cho mẫu sao chép
    And người dùng xác nhận sao chép
    Then một bản sao của mẫu được tạo thành công
    And bản sao xuất hiện trong danh sách mẫu

  # Chỉnh sửa mẫu chứng từ
  Scenario: Chỉnh sửa nội dung mẫu chứng từ
    Given người dùng đang xem mẫu chứng từ "Mẫu draft 2 - CTT56AB/2026/E"
    When người dùng nhấn nút "Chỉnh sửa"
    And người dùng thay đổi nội dung mẫu
    And người dùng lưu thay đổi
    Then nội dung mẫu được cập nhật thành công
    And mẫu vẫn giữ nguyên trạng thái sử dụng hiện tại

  # Ngừng sử dụng mẫu chứng từ
  Scenario: Ngừng sử dụng mẫu chứng từ đang hoạt động
    Given có mẫu chứng từ "Mẫu MTT - 2C25MTB" đang ở trạng thái "Đang sử dụng"
    When người dùng nhấn vào biểu tượng ba chấm của mẫu
    And người dùng chọn tùy chọn "Ngừng sử dụng"
    And người dùng xác nhận ngừng sử dụng
    Then trạng thái mẫu chuyển sang "Ngừng sử dụng"
    And mẫu vẫn hiển thị trong danh sách
    And mẫu không thể được chọn để tạo chứng từ mới

  Scenario: Kích hoạt lại mẫu chứng từ đã ngừng sử dụng
    Given có mẫu chứng từ đang ở trạng thái "Ngừng sử dụng"
    When người dùng nhấn vào biểu tượng ba chấm của mẫu
    And người dùng chọn tùy chọn "Sử dụng"
    And người dùng xác nhận kích hoạt lại
    Then trạng thái mẫu chuyển sang "Đang sử dụng"
    And mẫu có thể được chọn để tạo chứng từ mới

  # Xóa mẫu chứng từ
  Scenario: Xóa mẫu chứng từ chưa được sử dụng
    Given có mẫu chứng từ chưa được sử dụng để tạo chứng từ nào
    When người dùng nhấn vào biểu tượng ba chấm của mẫu
    And người dùng chọn tùy chọn "Xóa mẫu"
    And người dùng xác nhận xóa
    Then mẫu bị xóa khỏi hệ thống
    And mẫu không còn hiển thị trong danh sách

  Scenario: Không thể xóa mẫu đã được sử dụng
    Given có mẫu chứng từ đã được sử dụng để tạo ít nhất một chứng từ
    When người dùng nhấn vào biểu tượng ba chấm của mẫu
    Then tùy chọn "Xóa mẫu" không hiển thị
    Or tùy chọn "Xóa mẫu" bị vô hiệu hóa

  # Tìm kiếm và lọc mẫu
  Scenario: Tìm kiếm mẫu chứng từ theo tên
    Given hệ thống có nhiều mẫu chứng từ
    When người dùng nhập từ khóa "MTT" vào ô tìm kiếm
    Then chỉ các mẫu có tên chứa "MTT" được hiển thị

  Scenario: Lọc mẫu theo trạng thái sử dụng
    Given hệ thống có mẫu ở cả trạng thái "Đang sử dụng" và "Ngừng sử dụng"
    When người dùng chọn lọc theo trạng thái "Đang sử dụng"
    Then chỉ các mẫu đang được sử dụng được hiển thị

  # Phân loại và tổ chức mẫu
  Scenario: Xem mẫu theo danh mục
    Given hệ thống có các danh mục mẫu như "Mẫu chứng từ thanh toán", "Mẫu cơ bản", "Chứng từ khấu trừ thuế TNCN"
    When người dùng chọn danh mục "Mẫu chứng từ thanh toán"
    Then chỉ các mẫu thuộc danh mục "Mẫu chứng từ thanh toán" được hiển thị

  # Sử dụng mẫu để tạo chứng từ
  Scenario: Tạo chứng từ từ mẫu đang sử dụng
    Given có mẫu "Mẫu draft 2 - CTT56AB/2026/E" ở trạng thái "Đang sử dụng"
    When người dùng chọn tạo chứng từ từ mẫu này
    Then chứng từ mới được tạo dựa trên nội dung của mẫu
    And người dùng có thể chỉnh sửa thông tin cụ thể của chứng từ

  Scenario: Không thể tạo chứng từ từ mẫu đã ngừng sử dụng
    Given có mẫu ở trạng thái "Ngừng sử dụng"
    When người dùng cố gắng tạo chứng từ từ mẫu này
    Then hệ thống hiển thị thông báo mẫu không khả dụng
    And chứng từ không được tạo

  # Kiểm tra quyền hạn
  Scenario Outline: Kiểm soát quyền truy cập các chức năng quản lý mẫu
    Given người dùng có vai trò <role>
    When người dùng truy cập trang quản lý mẫu
    Then người dùng <can_create> tạo mẫu mới
    And người dùng <can_edit> chỉnh sửa mẫu
    And người dùng <can_delete> xóa mẫu
    And người dùng <can_toggle> thay đổi trạng thái mẫu

    Examples:
      | role          | can_create | can_edit | can_delete | can_toggle |
      | admin         | có thể     | có thể   | có thể     | có thể     |
      | manager       | có thể     | có thể   | không thể  | có thể     |
      | user          | không thể  | không thể| không thể  | không thể  |

  # Xử lý lỗi và validation
  Scenario: Không thể tạo mẫu với tên trùng lặp
    Given hệ thống đã có mẫu với tên "Mẫu MTT - 2C26MQQ"
    When người dùng tạo mẫu mới với tên "Mẫu MTT - 2C26MQQ"
    Then hệ thống hiển thị thông báo lỗi tên mẫu đã tồn tại
    And mẫu mới không được tạo

  Scenario: Không thể lưu mẫu với thông tin không hợp lệ
    When người dùng tạo hoặc chỉnh sửa mẫu
    And người dùng để trống các trường bắt buộc
    And người dùng cố gắng lưu mẫu
    Then hệ thống hiển thị thông báo các trường bắt buộc
    And mẫu không được lưu

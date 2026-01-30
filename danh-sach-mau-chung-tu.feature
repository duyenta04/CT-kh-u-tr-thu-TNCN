@certificate @template-list @template-management
Feature: Quản lý danh sách mẫu chứng từ
  
  Là một Kế toán
  Tôi muốn xem và quản lý các mẫu chứng từ đã tạo
  Để dễ dàng chọn và sử dụng lại cho các lần phát hành tiếp theo

  # ============================================================
  # PHẦN 1: LƯU MẪU VÀ CHUYỂN VỀ DANH SÁCH
  # ============================================================

  Background: Người dùng đang hoàn tất cấu hình mẫu
    Given Người dùng đã chọn mẫu chứng từ
    And Người dùng đang ở trang "Chỉnh sửa mẫu"
    And Người dùng đã hoàn thành cấu hình mẫu

  @happy-path @smoke @save-redirect
  Scenario: Lưu mẫu mới và chuyển về danh sách
    Given Người dùng đang tạo mẫu mới lần đầu
    And Tất cả validation đều pass
    When Người dùng nhấn nút "Lưu"
    Then Hệ thống lưu mẫu vào cơ sở dữ liệu
    And Hiển thị thông báo "Lưu mẫu thành công"
    And Tự động chuyển về trang "Danh sách mẫu chứng từ"
    And Mẫu vừa tạo xuất hiện trong danh sách

  @happy-path @save-redirect
  Scenario: Cập nhật mẫu hiện có và quay về danh sách
    Given Người dùng đang chỉnh sửa mẫu đã tồn tại
    And Người dùng đã thay đổi một số cấu hình
    When Người dùng nhấn nút "Lưu"
    Then Hệ thống cập nhật mẫu trong cơ sở dữ liệu
    And Hiển thị thông báo "Cập nhật mẫu thành công"
    And Chuyển về trang "Danh sách mẫu chứng từ"
    And Mẫu hiển thị với thông tin đã cập nhật

  @naming @save-redirect
  Scenario: Lưu mẫu với tên tùy chỉnh
    Given Người dùng đang tạo mẫu mới
    And Trường "Tên chứng từ" có giá trị "Mẫu TNCN Tháng 01/2024"
    When Người dùng nhấn nút "Lưu"
    Then Mẫu được lưu với tên "Mẫu TNCN Tháng 01/2024"
    And Tên mẫu hiển thị trong danh sách

  @timestamp @save-redirect
  Scenario: Mẫu mới được ghi nhận thời gian tạo
    Given Người dùng đang tạo mẫu mới
    When Người dùng nhấn nút "Lưu" vào ngày 30/01/2025
    Then Mẫu được lưu với ngày tạo "30/01/2025"
    And Thời gian tạo hiển thị trong danh sách mẫu

  @timestamp @save-redirect
  Scenario: Mẫu được cập nhật thời gian chỉnh sửa
    Given Người dùng đang chỉnh sửa mẫu đã tồn tại từ ngày 15/01/2025
    When Người dùng lưu thay đổi vào ngày 30/01/2025
    Then Mẫu cập nhật ngày tạo gần nhất 30/01/2025
  

  # ============================================================
  # PHẦN 2: HIỂN THỊ DANH SÁCH MẪU
  # ============================================================

  Background: Người dùng truy cập danh sách mẫu
    Given Người dùng đã đăng nhập vào hệ thống
    And Người dùng đang ở trang "Danh sách mẫu chứng từ"

  @happy-path @smoke @list-display
  Scenario: Hiển thị danh sách mẫu chứng từ
    Given Hệ thống có 5 mẫu chứng từ đã được tạo
    When Trang được tải lên
    Then Danh sách hiển thị tất cả 5 mẫu
    And Mỗi mẫu hiển thị đầy đủ thông tin cơ bản

  @list-display
  Scenario: Thông tin hiển thị trên mỗi mẫu
    Given Danh sách có mẫu "Mẫu TNCN Tháng 01/2024"
    When Người dùng xem thông tin mẫu
    Then Hiển thị tên mẫu "Mẫu TNCN Tháng 01/2024"
    And Hiển thị loại chứng từ "Chứng từ khấu trừ thuế TNCN"
    And Hiển thị thumbnail preview mẫu
    And Hiển thị ngày tạo "15/01/2025"
    And Hiển thị ngày chỉnh sửa cuối "30/01/2025"
    And Hiển thị trạng thái "Đang hoạt động"

  @list-display @sorting
  Scenario: Sắp xếp danh sách theo thời gian tạo mới nhất
    Given Danh sách có các mẫu với thời gian tạo khác nhau
    When Trang được tải lên với sắp xếp mặc định
    Then Mẫu mới nhất hiển thị ở vị trí đầu tiên
    And Mẫu cũ nhất hiển thị ở vị trí cuối cùng

  @list-display @sorting
  Scenario: Sắp xếp danh sách theo tên
    Given Danh sách có nhiều mẫu
    When Người dùng chọn sắp xếp theo "Tên (A-Z)"
    Then Danh sách được sắp xếp theo thứ tự alphabet
    And Mẫu có tên bắt đầu bằng "A" hiển thị trước mẫu bắt đầu bằng "Z"

  @list-display @empty-state
  Scenario: Hiển thị trạng thái rỗng khi chưa có mẫu
    Given Hệ thống chưa có mẫu chứng từ nào
    When Người dùng truy cập trang danh sách
    Then Hiển thị thông báo "Chưa có mẫu chứng từ nào"
    And Hiển thị nút "Tạo mẫu mới"
    And Hiển thị hướng dẫn cách tạo mẫu đầu tiên

  @list-display @thumbnail
  Scenario: Hiển thị thumbnail preview của mẫu
    Given Mẫu đã được lưu với cấu hình đầy đủ
    When Danh sách hiển thị mẫu
    Then Thumbnail hiển thị bản xem trước thu nhỏ
    And Thumbnail có tỷ lệ A4 (210:297)
    And Thumbnail hiển thị logo và layout chính
    And Watermark "MẪU CHỨNG TỪ" xuất hiện trên thumbnail

  # ============================================================
  # PHẦN 3: TÁC VỤ VỚI MẪU TRONG DANH SÁCH
  # ============================================================

  Background: Người dùng đang xem danh sách mẫu
    Given Người dùng đang ở trang "Danh sách mẫu chứng từ"
    And Danh sách có ít nhất 1 mẫu

  @action @edit
  Scenario: Chỉnh sửa mẫu từ danh sách
    Given Người dùng xem mẫu "Mẫu TNCN Tháng 01/2024"
    When Người dùng nhấn nút "Chỉnh sửa"
    Then Hệ thống chuyển đến trang "Chỉnh sửa mẫu"
    And Tất cả cấu hình của mẫu được tải lên
    And Preview hiển thị đúng với mẫu đã lưu

  @action @duplicate
  Scenario: Nhân bản mẫu hiện có
    Given Người dùng xem mẫu "Mẫu TNCN Tháng 01/2024"
    When Người dùng nhấn nút "Nhân bản"
    Then Hệ thống tạo bản sao của mẫu
    And Bản sao có tên "Bản sao - Mẫu TNCN Tháng 01/2024"
    And Bản sao xuất hiện trong danh sách
    And Bản sao có cấu hình giống hệt mẫu gốc

  @action @delete
  Scenario: Xóa mẫu khỏi danh sách
    Given Người dùng xem mẫu "Mẫu TNCN Tháng 01/2024"
    When Người dùng nhấn nút "Xóa"
    Then Hệ thống hiển thị dialog xác nhận "Bạn có chắc chắn muốn xóa mẫu này?"
    When Người dùng xác nhận "Xóa"
    Then Mẫu bị xóa khỏi cơ sở dữ liệu
    And Mẫu biến mất khỏi danh sách
    And Hiển thị thông báo "Đã xóa mẫu thành công"

  @action @delete @error-handling
  Scenario: Hủy xóa mẫu
    Given Dialog xác nhận xóa đang hiển thị
    When Người dùng nhấn nút "Hủy"
    Then Dialog đóng lại
    And Mẫu vẫn còn trong danh sách
    And Không có thay đổi nào xảy ra

  @action @set-default
  Scenario: Đặt mẫu làm mặc định
    Given Người dùng xem mẫu "Mẫu TNCN Tháng 01/2024"
    When Người dùng nhấn nút "Đặt làm mặc định"
    Then Mẫu được đánh dấu là mặc định
    And Badge "Mặc định" xuất hiện trên mẫu
    And Các mẫu khác bỏ đánh dấu mặc định

  @action @preview
  Scenario: Xem preview chi tiết mẫu từ danh sách
    Given Người dùng xem mẫu "Mẫu TNCN Tháng 01/2024"
    When Người dùng nhấn vào thumbnail hoặc nút "Xem"
    Then Hệ thống mở modal preview toàn màn hình
    And Preview hiển thị mẫu với kích thước thực tế
    And Hiển thị đầy đủ như bản in

  @action @export
  Scenario: Xuất mẫu ra PDF từ danh sách
    Given Người dùng xem mẫu "Mẫu TNCN Tháng 01/2024"
    When Người dùng nhấn nút "Xuất PDF"
    Then Hệ thống tạo file PDF từ mẫu
    And File được tải về với tên "Mau-TNCN-Thang-01-2024.pdf"
    And PDF giữ nguyên định dạng và màu sắc của mẫu

  # ============================================================
  # PHẦN 4: TÌM KIẾM VÀ LỌC MẪU
  # ============================================================

  Background: Người dùng cần tìm mẫu cụ thể
    Given Người dùng đang ở trang "Danh sách mẫu chứng từ"
    And Danh sách có nhiều mẫu chứng từ

  @search
  Scenario: Tìm kiếm mẫu theo tên
    Given Thanh tìm kiếm đang trống
    When Người dùng nhập "Tháng 01" vào thanh tìm kiếm
    Then Danh sách chỉ hiển thị các mẫu có tên chứa "Tháng 01"
    And Các mẫu không khớp bị ẩn

  @search @empty-result
  Scenario: Tìm kiếm không có kết quả
    Given Thanh tìm kiếm đang trống
    When Người dùng nhập "Không tồn tại" vào thanh tìm kiếm
    Then Hiển thị thông báo "Không tìm thấy mẫu nào"
    And Gợi ý "Thử tìm kiếm với từ khóa khác"

  @filter
  Scenario: Lọc mẫu theo loại chứng từ
    Given Danh sách có cả mẫu TNCN và mẫu TMĐT
    When Người dùng chọn filter "Loại chứng từ: TNCN"
    Then Danh sách chỉ hiển thị mẫu chứng từ TNCN
    And Mẫu TMĐT bị ẩn

  @filter
  Scenario: Lọc mẫu theo trạng thái
    Given Danh sách có mẫu đang hoạt động và đã vô hiệu hóa
    When Người dùng chọn filter "Trạng thái: Đang hoạt động"
    Then Danh sách chỉ hiển thị mẫu đang hoạt động
    And Mẫu vô hiệu hóa bị ẩn

  @filter @clear
  Scenario: Xóa tất cả bộ lọc
    Given Người dùng đã áp dụng nhiều bộ lọc
    And Danh sách đang hiển thị kết quả đã lọc
    When Người dùng nhấn nút "Xóa bộ lọc"
    Then Tất cả bộ lọc được reset
    And Danh sách hiển thị lại tất cả mẫu

  # ============================================================
  # PHẦN 5: TRẠNG THÁI VÀ QUẢN LÝ MẪU
  # ============================================================

  Background: Quản lý trạng thái mẫu
    Given Người dùng đang ở trang "Danh sách mẫu chứng từ"

  @status @active
  Scenario: Mẫu mới luôn ở trạng thái đang hoạt động
    Given Người dùng vừa tạo mẫu mới
    When Mẫu xuất hiện trong danh sách
    Then Trạng thái mẫu là "Đang hoạt động"
    And Badge màu xanh hiển thị "Đang hoạt động"

  @status @deactivate
  Scenario: Vô hiệu hóa mẫu
    Given Mẫu "Mẫu TNCN Tháng 01/2024" đang hoạt động
    When Người dùng nhấn nút "Vô hiệu hóa"
    Then Hệ thống hiển thị dialog xác nhận
    When Người dùng xác nhận
    Then Trạng thái mẫu chuyển thành "Vô hiệu hóa"
    And Badge màu xám hiển thị "Vô hiệu hóa"
    And Mẫu không thể được sử dụng để phát hành chứng từ

  @status @reactivate
  Scenario: Kích hoạt lại mẫu đã vô hiệu hóa
    Given Mẫu "Mẫu TNCN Tháng 01/2024" đang vô hiệu hóa
    When Người dùng nhấn nút "Kích hoạt"
    Then Trạng thái mẫu chuyển thành "Đang hoạt động"
    And Mẫu có thể được sử dụng để phát hành chứng từ

  @usage-count
  Scenario: Hiển thị số lần sử dụng mẫu
    Given Mẫu "Mẫu TNCN Tháng 01/2024" đã được dùng 15 lần
    When Danh sách hiển thị thông tin mẫu
    Then Hiển thị "Đã sử dụng: 15 lần"
    And Con số cập nhật mỗi khi mẫu được dùng phát hành chứng từ

  @usage-count
  Scenario: Mẫu mới có số lần sử dụng bằng 0
    Given Người dùng vừa tạo mẫu mới
    When Mẫu xuất hiện trong danh sách
    Then Hiển thị "Đã sử dụng: 0 lần"

  # ============================================================
  # PHẦN 6: PHÂN TRANG VÀ TẢI DỮ LIỆU
  # ============================================================

  Background: Danh sách có nhiều mẫu
    Given Người dùng đang ở trang "Danh sách mẫu chứng từ"

  @pagination
  Scenario: Hiển thị phân trang khi có nhiều mẫu
    Given Hệ thống có 25 mẫu chứng từ
    And Mỗi trang hiển thị 10 mẫu
    When Trang được tải lên
    Then Trang 1 hiển thị 10 mẫu đầu tiên
    And Hiển thị điều hướng "Trang 1 / 3"
    And Nút "Trang tiếp" được kích hoạt

  @pagination
  Scenario: Chuyển sang trang tiếp theo
    Given Người dùng đang ở trang 1
    When Người dùng nhấn nút "Trang tiếp"
    Then Hệ thống tải trang 2
    And Hiển thị 10 mẫu tiếp theo
    And Hiển thị "Trang 2 / 3"

  @pagination
  Scenario: Vô hiệu hóa nút khi ở trang cuối
    Given Người dùng đang ở trang 3 (trang cuối)
    Then Nút "Trang tiếp" bị vô hiệu hóa
    And Nút "Trang trước" được kích hoạt

  @loading
  Scenario: Hiển thị loading khi đang tải danh sách
    Given Người dùng truy cập trang danh sách
    When Dữ liệu đang được tải từ server
    Then Hiển thị loading indicator
    And Hiển thị text "Đang tải mẫu chứng từ..."
    When Dữ liệu tải xong
    Then Loading indicator biến mất
    And Danh sách mẫu hiển thị

  @error-handling
  Scenario: Xử lý lỗi khi không tải được danh sách
    Given Người dùng truy cập trang danh sách
    When Xảy ra lỗi kết nối server
    Then Hiển thị thông báo lỗi "Không thể tải danh sách mẫu"
    And Hiển thị nút "Thử lại"
    When Người dùng nhấn "Thử lại"
    Then Hệ thống tải lại danh sách

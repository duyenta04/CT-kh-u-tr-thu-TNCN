Feature: Nhập thông tin chung của chứng từ
  Là một Kế toán
  Người dùng muốn nhập thông tin chung
  Để xác định và quản lý chứng từ

  Background:
    Given Người dùng đã đăng nhập hệ thống
    And Hệ thống có danh sách mẫu chứng từ đã đăng ký

  # ========== MẪU CHỨNG TỪ ==========
  
  Scenario: Hiển thị dropdown mẫu chứng từ
    When Người dùng mở form tạo chứng từ mới
    Then Hiển thị dropdown "Mẫu chứng từ"
    And Dropdown chứa các mẫu đã đăng ký
    And Chưa có giá trị mặc định được chọn

  Scenario: Danh sách mẫu chứng từ có sẵn
    Given Hệ thống có các mẫu chứng từ đã đăng ký:
      | Mẫu chứng từ      | 
      | 03/TNCN CT/25E    | 
      | 03/TNCN CT/26E    |
    When Người dùng click vào dropdown "Mẫu chứng từ"
    Then Hệ thống hiển thị danh sách mẫu chứng từ đã đăng ký
    And Danh sách chứa:
      | 03/TNCN CT/25E |
      | 03/TNCN CT/26E |

  Scenario: Chọn mẫu chứng từ thành công
    Given Dropdown "Mẫu chứng từ" đang mở
    When Người dùng chọn "03/TNCN CT/25E"
    Then Trường "Mẫu chứng từ" hiển thị "03/TNCN CT/25E"
    And Dropdown đóng lại

  Scenario: Validate bắt buộc chọn mẫu chứng từ
    Given Trường "Mẫu chứng từ" chưa được chọn
    When Người dùng click "Lưu nháp"
    Then Hệ thống hiển thị lỗi "Mẫu chứng từ không được để trống"
    And Focus vào dropdown "Mẫu chứng từ"

  # ========== SỐ CHỨNG TỪ ==========
  
  Scenario: Tự động sinh số chứng từ khi chọn mẫu
    Given Người dùng đã chọn mẫu "03/TNCN CT/25E"
    And Số chứng từ cuối cùng của mẫu này là "0000099"
    When Người dùng rời khỏi dropdown "Mẫu chứng từ" (blur)
    Then Hệ thống tự động điền "Số chứng từ" = "0000100"

  Scenario: Số chứng từ được sinh theo từng mẫu riêng biệt
    Given Mẫu "03/TNCN CT/25E" có số cuối là "0000150"
    And Mẫu "03/TNCN CT/26E" có số cuối là "0000050"
    When Người dùng chọn mẫu "03/TNCN CT/26E"
    Then Số chứng từ tự động sinh = "0000051"
    And KHÔNG phải "0000151"

  Scenario: Cho phép trùng số chứng từ giữa các mẫu khác nhau
    Given Mẫu "03/TNCN CT/25E" đã có chứng từ số "0000100"
    When Người dùng chọn mẫu "03/TNCN CT/26E"
    And Nhập "Số chứng từ" = "0000100"
    And Click "Lưu nháp"
    Then Hệ thống chấp nhận (không báo lỗi trùng)
    And Lưu nháp chứng từ thành công

  # ========== NGÀY CHỨNG TỪ ==========

  Scenario: Chọn ngày từ date picker
    Given Trường "Ngày chứng từ" hiển thị Placeholder "Chọn ngày"
    When Người dùng click vào "Chọn ngày"
    Then Hệ thống hiển thị date picker
    And Ngày hiện tại được highlight
    When Người dùng chọn ngày "15/01/2026"
    Then Trường "Ngày chứng từ" cập nhật thành "15/01/2026"
    And Date picker đóng lại

  # ========== TƯƠNG TÁC GIỮA CÁC TRƯỜNG ==========
  
  Scenario: Thay đổi mẫu chứng từ cập nhật số chứng từ
    Given Người dùng đã chọn mẫu "03/TNCN CT/25E"
    And Số chứng từ được sinh tự động "0000100"
    When Người dùng đổi mẫu thành "03/TNCN CT/26E"
    And Số chứng từ cuối của "03/TNCN CT/26E" là "0000050"
    Then Số chứng từ tự động cập nhật thành "0000051"

# language: vi
@certificate-create
Feature: Lập chứng từ khấu trừ thuế thu nhập cá nhân
  Để ghi nhận việc khấu trừ thuế cho cá nhân và hộ kinh doanh
  Với vai trò kế toán
  Tôi cần lập chứng từ khấu trừ thuế thu nhập cá nhân

  Background:
    Given kế toán đã đăng nhập vào hệ thống
    And kế toán có quyền quản lý chứng từ
    And hệ thống có các mẫu chứng từ đã đăng ký

  Rule: Chọn mẫu chứng từ

    @template-selection
    Scenario: Hiển thị danh sách mẫu đã đăng ký
      When kế toán bắt đầu lập chứng từ mới
      Then hệ thống hiển thị các mẫu chứng từ đã đăng ký

    @template-selection
    Scenario: Chọn mẫu chứng từ
      Given kế toán đang lập chứng từ mới
      When kế toán chọn mẫu "03/TNCN CT/25E"
      Then mẫu chứng từ được đặt là "03/TNCN CT/25E"

    @template-selection @validation
    Scenario: Yêu cầu chọn mẫu chứng từ
      Given kế toán đang lập chứng từ
      And chưa chọn mẫu chứng từ
      When kế toán lưu chứng từ
      Then hệ thống hiển thị lỗi "Mẫu chứng từ không được để trống"

  Rule: Số chứng từ tự động

    @auto-number
    Scenario: Tự động sinh số chứng từ khi chọn mẫu
      Given kế toán đã chọn mẫu "03/TNCN CT/25E"
      And số chứng từ cuối cùng của mẫu này là "0000099"
      When kế toán xác nhận chọn mẫu
      Then số chứng từ tự động là "0000100"

    @auto-number
    Scenario: Số chứng từ riêng biệt cho từng mẫu
      Given mẫu "03/TNCN CT/25E" có số cuối là "0000150"
      And mẫu "03/TNCN CT/26E" có số cuối là "0000050"
      When kế toán chọn mẫu "03/TNCN CT/26E"
      Then số chứng từ tự động là "0000051"

    @auto-number
    Scenario: Cho phép trùng số giữa các mẫu khác nhau
      Given mẫu "03/TNCN CT/25E" đã có chứng từ số "0000100"
      And kế toán đang lập chứng từ với mẫu "03/TNCN CT/26E"
      When kế toán nhập số chứng từ "0000100"
      And kế toán lưu chứng từ
      Then chứng từ được lưu thành công

    @auto-number
    Scenario: Cập nhật số khi thay đổi mẫu
      Given kế toán đã chọn mẫu "03/TNCN CT/25E"
      And số chứng từ hiện tại là "0000100"
      When kế toán đổi sang mẫu "03/TNCN CT/26E"
      And mẫu "03/TNCN CT/26E" có số cuối là "0000050"
      Then số chứng từ tự động cập nhật thành "0000051"

  Rule: Chọn ngày chứng từ

    @date-selection
    Scenario: Chọn ngày chứng từ
      Given kế toán đang lập chứng từ
      When kế toán chọn ngày "15/01/2026"
      Then ngày chứng từ được đặt là "15/01/2026"

  Rule: Tra cứu thông tin người nộp thuế

    @taxpayer-lookup
    Scenario: Tra cứu thành công từ mã số thuế
      Given kế toán đang nhập thông tin người nộp thuế
      When kế toán tra cứu mã số thuế "8765432100"
      Then hệ thống điền tự động thông tin người nộp thuế

    @taxpayer-lookup
    Scenario: Tra cứu không tìm thấy
      Given kế toán đang nhập thông tin người nộp thuế
      When kế toán tra cứu mã số thuế không tồn tại
      Then hệ thống thông báo không tìm thấy
      And cho phép nhập thủ công

  Rule: Thông tin người nộp thuế

    @taxpayer-info @validation
    Scenario: Yêu cầu có mã số thuế hoặc CCCD
      Given kế toán đang lập chứng từ
      And không có mã số thuế
      And không có số CCCD
      When kế toán lưu chứng từ
      Then hệ thống hiển thị lỗi "Phải nhập Mã số thuế hoặc Số CCCD"

    @taxpayer-info @validation
    Scenario Outline: Kiểm tra định dạng mã số thuế
      Given kế toán đang nhập mã số thuế
      When kế toán nhập mã số thuế <value>
      Then hệ thống <result>

      Examples:
        | value         | result                               |
        | 0123456789    | chấp nhận (10 số)                    |
        | 0123456789012 | chấp nhận (13 số)                    |
        | 012345        | hiển thị lỗi "MST phải 10 hoặc 13 số"|
        | ABC123        | hiển thị lỗi "MST chỉ chứa số"       |

    @taxpayer-info @validation
    Scenario: Yêu cầu chọn cá nhân cư trú
      Given kế toán đang lập chứng từ
      And chưa chọn cá nhân cư trú
      When kế toán lưu chứng từ
      Then hệ thống hiển thị lỗi "Phải chọn Cá nhân cư trú"

    @taxpayer-info @validation
    Scenario Outline: Yêu cầu các trường bắt buộc
      Given kế toán đang lập chứng từ
      And trường <field> để trống
      When kế toán lưu chứng từ
      Then hệ thống hiển thị lỗi <error_message>

      Examples:
        | field         | error_message                        |
        | Họ và tên     | Họ và tên không được để trống        |
        | Địa chỉ       | Địa chỉ không được để trống          |
        | Quốc tịch     | Quốc tịch không được để trống        |
        | Số điện thoại | Số điện thoại không được để trống    |

  Rule: Khoản thu nhập

    @income-type
    Scenario: Chọn loại thu nhập
      Given kế toán đang nhập thông tin thuế
      When kế toán chọn loại thu nhập "Thu nhập từ tiền lương, tiền công"
      Then loại thu nhập được đặt là "Thu nhập từ tiền lương, tiền công"

    @income-type
    Scenario: Nhập khoản thu nhập khác
      Given kế toán đang nhập thông tin thuế
      When kế toán chọn "Khác"
      And kế toán nhập khoản thu nhập "Thu nhập từ đầu tư"
      Then khoản thu nhập được ghi nhận là "Thu nhập từ đầu tư"

    @income-type @validation
    Scenario: Yêu cầu chọn khoản thu nhập
      Given kế toán đang lập chứng từ
      And chưa chọn khoản thu nhập
      When kế toán lưu chứng từ
      Then hệ thống hiển thị lỗi "Khoản thu nhập không được để trống"

  Rule: Tính toán thuế tự động

    @tax-calculation
    Scenario: Tính thu nhập tính thuế
      Given thu nhập chịu thuế là 30,000,000 VNĐ
      And bảo hiểm là 3,150,000 VNĐ
      And giảm trừ gia cảnh là 11,000,000 VNĐ
      When hệ thống tính toán
      Then thu nhập tính thuế là 15,850,000 VNĐ

    @tax-calculation
    Scenario: Tính số thuế theo biểu lũy tiến
      Given thu nhập tính thuế là 15,850,000 VNĐ
      When hệ thống tính số thuế
      Then số thuế là 1,627,500 VNĐ

    @tax-calculation
    Scenario: Cập nhật khi thay đổi bảo hiểm
      Given thu nhập chịu thuế là 30,000,000 VNĐ
      And bảo hiểm ban đầu là 2,000,000 VNĐ
      And thu nhập tính thuế đang là 17,000,000 VNĐ
      When kế toán thay đổi bảo hiểm thành 3,150,000 VNĐ
      Then thu nhập tính thuế tự động cập nhật thành 15,850,000 VNĐ
      And số thuế tự động cập nhật thành 1,627,500 VNĐ

    @tax-calculation
    Scenario: Cập nhật khi nhập quỹ hưu trí
      Given thu nhập chịu thuế là 30,000,000 VNĐ
      And bảo hiểm là 3,150,000 VNĐ
      And thu nhập tính thuế đang là 15,850,000 VNĐ
      When kế toán nhập quỹ hưu trí tự nguyện 1,000,000 VNĐ
      Then thu nhập tính thuế tự động cập nhật thành 14,850,000 VNĐ
      And số thuế tự động cập nhật

    @tax-calculation @edge-case
    Scenario: Thu nhập tính thuế không âm
      Given thu nhập chịu thuế là 2,000,000 VNĐ
      And các khoản giảm trừ lớn hơn thu nhập
      When hệ thống tính toán
      Then thu nhập tính thuế là 0 VNĐ
      And số thuế là 0 VNĐ

    @tax-calculation
    Scenario: Làm tròn số thuế
      Given thu nhập tính thuế có số lẻ
      When hệ thống tính số thuế
      Then số thuế được làm tròn đến đơn vị VNĐ

  Rule: Tính thuế cho nhiều tháng

    @multi-month
    Scenario: Tính thuế cho cả năm
      Given kế toán chọn từ tháng 1 đến tháng 12
      And năm là 2025
      And thu nhập chịu thuế mỗi tháng là 30,000,000 VNĐ
      When hệ thống tính toán
      Then số thuế mỗi tháng là 1,627,500 VNĐ
      And tổng số thuế cả năm là 19,530,000 VNĐ

    @multi-month
    Scenario: Tính thuế cho một tháng
      Given kế toán chọn từ tháng 6 đến tháng 6
      And thu nhập chịu thuế là 30,000,000 VNĐ
      When hệ thống tính toán
      Then số thuế là 1,627,500 VNĐ

  Rule: Validation thời gian

    @validation @time
    Scenario: Đến tháng phải lớn hơn hoặc bằng từ tháng
      Given kế toán nhập từ tháng 6
      When kế toán nhập đến tháng 3
      And kế toán lưu chứng từ
      Then hệ thống hiển thị lỗi "Đến tháng phải lớn hơn hoặc bằng Từ tháng"

    @validation @time
    Scenario: Năm không được lớn hơn năm hiện tại
      Given năm hiện tại là 2025
      When kế toán nhập năm 2026
      And kế toán lưu chứng từ
      Then hệ thống hiển thị lỗi "Năm không được lớn hơn năm hiện tại"

  Rule: Validation số tiền

    @validation @amount
    Scenario Outline: Số tiền phải không âm
      Given kế toán đang nhập thông tin thuế
      When kế toán nhập <field> là <value>
      And kế toán lưu chứng từ
      Then hệ thống <result>

      Examples:
        | field                   | value    | result                             |
        | Bảo hiểm                | -100000  | hiển thị lỗi "Số tiền phải >= 0"   |
        | Khoản từ thiện          | -50000   | hiển thị lỗi "Số tiền phải >= 0"   |
        | Tổng thu nhập chịu thuế | -1000000 | hiển thị lỗi "Số tiền phải >= 0"   |
        | Bảo hiểm                | 0        | chấp nhận                          |
        | Khoản từ thiện          | 100000   | chấp nhận                          |

  Rule: Thông tin tổ chức tự động

    @organization-info
    Scenario: Điền tự động thông tin tổ chức
      Given kế toán bắt đầu lập chứng từ
      Then thông tin tổ chức được điền tự động
        | Tên đơn vị    |
        | Mã số thuế    |
        | Địa chỉ       |
        | Số điện thoại |

    @organization-info
    Scenario: Không cho phép sửa thông tin tổ chức
      Given kế toán đang lập chứng từ
      When kế toán thử sửa thông tin tổ chức
      Then các trường thông tin tổ chức không thể chỉnh sửa

  Rule: Lưu chứng từ

    @save
    Scenario: Lưu nháp chứng từ hợp lệ
      Given kế toán đã điền đầy đủ thông tin bắt buộc
      When kế toán lưu nháp
      Then chứng từ được lưu với trạng thái nháp

    @save @xml
    Scenario: Lưu dữ liệu theo định dạng XML
      Given kế toán đã hoàn tất chứng từ
      And thu nhập tính thuế là 15,850,000 VNĐ
      And số thuế là 1,627,500 VNĐ
      When kế toán lưu chứng từ
      Then dữ liệu được lưu theo định dạng XML
      And thu nhập tính thuế được lưu là 15850000
      And số thuế được lưu là 1627500

  Rule: Hiệu năng

    @performance
    Scenario: Tính toán thuế nhanh
      Given kế toán nhập đầy đủ thông tin
      When hệ thống tính toán thuế
      Then kết quả hiển thị trong vòng 1 giây

  Rule: Bảo mật

    @security
    Scenario: Kiểm tra quyền truy cập
      Given người dùng không có quyền quản lý chứng từ
      When người dùng cố truy cập chức năng lập chứng từ
      Then hệ thống từ chối truy cập

  Rule: Trải nghiệm người dùng

    @usability
    Scenario: Hiển thị gợi ý cho trường phức tạp
      Given kế toán đang lập chứng từ
      When kế toán di chuột qua trường phức tạp
      Then hệ thống hiển thị gợi ý

    @usability
    Scenario: Validation ngay lập tức
      Given kế toán đang nhập dữ liệu
      When kế toán nhập giá trị không hợp lệ
      Then hệ thống hiển thị lỗi ngay lập tức

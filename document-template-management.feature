@document-template
Feature: Quản lý mẫu chứng từ khấu trừ thuế thu nhập cá nhân
  Với vai trò một Kế toán
  Tôi muốn tạo và quản lý mẫu chứng từ khấu trừ thuế TNCN
  Để phát hành chứng từ cho nhân viên theo quy định pháp luật

  Background:
    Given tôi đã đăng nhập với vai trò Kế toán
    And tôi có quyền "Quản lý mẫu chứng từ điện tử"

  # ============================================================
  # FEATURE 1: CHỌN MẪU CHỨNG TỪ
  # ============================================================

  Rule: Hiển thị và lựa chọn mẫu chứng từ
  @template-selection @ui
  Scenario: Hiển thị màn hình chọn mẫu chứng từ
    Given tôi đang ở màn hình "Chọn mẫu chứng từ"
    When trang được load
    Then progress bar hiển thị:
      | Bước | Trạng thái | Label           |
      | 1    | Active     | Chọn mẫu        |
      | 2    | Inactive   | Chỉnh sửa mẫu   |

  @template-selection @ui
  Scenario: Hiển thị bộ lọc chứng từ
    Given tôi đang ở màn hình "Chọn mẫu chứng từ"
    When trang được load
    Then sidebar hiển thị các bộ lọc sau:
      | Tên filter | Loại         | Options                                                      |
      | Chứng từ   | Dropdown     | CT ĐT khấu trừ thuế TNCN, CT ĐT khấu trừ thuế TMĐT, Biên lai |
      | Loại mẫu   | Dropdown     | Mẫu cơ bản                                                   |
      | Ngôn ngữ   | Button group | Tiếng Việt, Song ngữ Việt - Anh                              |
      | Khổ giấy   | Button group | A4 dọc, A4 ngang, A5 ngang                                   |
    And filter "Chứng từ" có giá trị mặc định = "CT ĐT khấu trừ thuế TNCN"
    And filter "Loại mẫu" có giá trị mặc định = "Mẫu cơ bản"
    And filter "Ngôn ngữ" có giá trị mặc định = "Tiếng Việt"
    And filter "Khổ giấy" có giá trị mặc định = "A4 dọc"

  @template-selection @ui
  Scenario: Hiển thị mẫu chứng từ theo filter mặc định
    Given filter được set theo giá trị mặc định
    When trang được load
    Then khu vực preview hiển thị:
      | Element     | Content                                         |
      | Header text | Chọn mẫu chứng từ phù hợp với đơn vị để tiếp tục |
      | Badge       | 1 mẫu chứng từ                                  |

  @template-selection @ui
  Scenario: Click vào mẫu chứng từ
    Given template card đang hiển thị
    When tôi click vào mẫu chứng từ
    Then mẫu chứng từ được highlight (border xanh hoặc shadow tăng)
    And nút "Tiếp tục" ở header được enable

  @template-selection @validation
  Scenario: Click nút "Tiếp tục" khi chưa chọn template
    Given chưa có template nào được chọn
    When tôi click nút "Tiếp tục"
    Then hiển thị thông báo lỗi "Vui lòng chọn một mẫu chứng từ"
    And không chuyển sang bước tiếp theo

  @template-selection @navigation
  Scenario: Click nút "Tiếp tục" sau khi chọn template
    Given template "Mẫu cơ bản 01" đã được chọn
    When tôi click nút "Tiếp tục"
    Then chuyển sang màn hình "Chỉnh sửa mẫu"
    And progress bar cập nhật:
      | Bước | Trạng thái |
      | 1    | Inactive   |
      | 2    | Active     |

  @template-selection @filter
  Scenario: Thay đổi filter ngôn ngữ
    Given đang hiển thị template với filter mặc định
    When tôi thay đổi filter "Ngôn ngữ" thành "Song ngữ Việt - Anh"
    Then template preview cập nhật hiển thị cả tiếng Việt và tiếng Anh
    And giữ nguyên template đã chọn (nếu có)

  @template-selection @navigation
  Scenario: Click nút đóng khi đang chọn mẫu
    Given tôi đang ở màn hình "Chọn mẫu chứng từ"
    When tôi click nút "✕"
    Then hiển thị dialog xác nhận "Bạn có chắc chắn muốn thoát?"
    When tôi xác nhận "Đồng ý"
    Then quay về màn hình trước đó

  # ============================================================
  # FEATURE 2: TÙY CHỈNH THÔNG TIN TỔ CHỨC TRẢ THU NHẬP
  # ============================================================

  Rule: Cấu hình thông tin tổ chức trả thu nhập
  @organization-info @ui
  Scenario: Hiển thị danh sách trường thông tin tổ chức mặc định
    Given tôi đang ở màn hình "Chỉnh sửa mẫu"
    And tab "Nội dung hóa đơn" đang active
    And section "Thông tin tổ chức trả thu nhập" đang mở
    When section được load
    Then hiển thị danh sách trường với các trường mặc định:
      | Checkbox | Label       | Input value              |
      | ✓        | Tên đơn vị  | [Giá trị từ hệ thống]    |
      | ✓        | Mã số thuế  | [Giá trị từ hệ thống]    |
      | ✓        | Địa chỉ     | [Giá trị từ hệ thống]    |
      | ✓        | Điện thoại  | [Giá trị từ hệ thống]    |
    And button "+ Thêm thông tin" hiển thị phía dưới

  @organization-info @toggle
  Scenario: Ẩn trường thông tin tổ chức
    Given trường "Điện thoại" đang được check
    And preview hiển thị trường "Điện thoại"
    When tôi uncheck checkbox "Điện thoại"
    Then preview ẨN trường "Điện thoại"
    And thứ tự các trường khác không thay đổi

  @organization-info @toggle
  Scenario: Hiển thị lại trường đã ẩn
    Given trường "Điện thoại" đang bị uncheck
    And preview KHÔNG hiển thị trường "Điện thoại"
    When tôi check checkbox "Điện thoại"
    Then preview HIỂN THỊ lại trường "Điện thoại"
    And vị trí hiển thị theo thứ tự trong danh sách

  # ============================================================
  # FEATURE 3: TÙY CHỈNH THÔNG TIN CÁ NHÂN
  # ============================================================

  Rule: Cấu hình thông tin cá nhân, hộ kinh doanh, cá nhân kinh doanh
  @personal-info @ui
  Scenario: Hiển thị các trường thông tin cá nhân mặc định
    Given tôi đã chọn mẫu chứng từ
    And tôi đang ở trang "Chỉnh sửa mẫu"
    And tab "Nội dung hóa đơn" đang được chọn
    And section "Thông tin cá nhân, hộ kinh doanh, cá nhân kinh doanh" đang mở
    When section được tải lên
    Then hệ thống hiển thị 8 trường thông tin
    And 4 trường BẮT BUỘC được đánh dấu chọn và không thể tắt:
      | Trường          | Bắt buộc | Checkbox             | Ghi chú                        |
      | Họ và tên       | Có       | Checked & Disabled   | Bắt buộc                       |
      | Mã số thuế      | Có       | Checked & Disabled   | Bắt buộc (Nếu có)              |
      | Địa chỉ         | Có       | Checked & Disabled   | Bắt buộc                       |
      | Cá nhân cư trú  | Có       | Checked & Disabled   | Bắt buộc (Nếu có) - Có/Không  |
    And 4 trường TÙY CHỌN không được chọn mặc định:
      | Trường              | Bắt buộc | Checkbox   | Ghi chú                                              |
      | Quốc tịch           | Không    | Unchecked  | Nếu người nộp thuế không phải quốc tịch Việt Nam     |
      | CCCD/HC             | Không    | Unchecked  | Nếu không có MST thì require trường này              |
      | Địa chỉ thư điện tử | Không    | Unchecked  | Không bắt buộc                                       |
      | Ghi chú             | Không    | Unchecked  | Nếu mẫu có thông tin cần in lên trường này           |

  @personal-info @required-fields @validation
  Scenario: Không thể tắt các trường bắt buộc
    Given 4 trường bắt buộc đang được checked và disabled
    When tôi cố gắng click vào checkbox của bất kỳ trường bắt buộc nào
    Then checkbox vẫn ở trạng thái checked
    And không có thay đổi nào xảy ra
    And trường vẫn hiển thị trong preview

  @personal-info @required-fields @resident-status
  Scenario: Trường "Cá nhân cư trú" luôn hiển thị với dropdown
    Given trường "Cá nhân cư trú" là trường bắt buộc
    When section được tải lên
    Then checkbox "Cá nhân cư trú" đã checked và disabled
    And dropdown "Cá nhân cư trú" hiển thị với 2 options:
      | Option value | Option text |
      | Có           | Có          |
      | Không        | Không       |

  @personal-info @resident-status
  Scenario Outline: Chọn giá trị cá nhân cư trú
    Given dropdown "Cá nhân cư trú" đang ở giá trị mặc định
    When tôi chọn "<option>" từ dropdown
    Then dropdown hiển thị giá trị "<option>"
    And preview cập nhật hiển thị "Cá nhân cư trú: <display_value>"

    Examples:
      | option | display_value |
      | Có     | Có            |
      | Không  | Không         |

  @personal-info @optional-fields @toggle
  Scenario: Bật hiển thị trường tùy chọn "Quốc tịch"
    Given trường "Quốc tịch" đang bị ẩn
    And checkbox "Quốc tịch" không được check
    When tôi đánh dấu chọn checkbox "Quốc tịch"
    Then preview hiển thị trường "Quốc tịch" với giá trị trống

  @personal-info @optional-fields @toggle
  Scenario: Tắt trường tùy chọn "Địa chỉ thư điện tử"
    Given trường "Địa chỉ thư điện tử" đang được hiển thị
    And checkbox "Địa chỉ thư điện tử" đã được check
    When tôi bỏ chọn checkbox "Địa chỉ thư điện tử"
    Then trường "Địa chỉ thư điện tử" biến mất khỏi preview
    And checkbox chuyển sang unchecked

  @personal-info @optional-fields @toggle
  Scenario: Bật trường "Ghi chú"
    Given trường "Ghi chú" đang bị ẩn
    When tôi đánh dấu chọn "Ghi chú"
    Then preview hiển thị trường "Ghi chú"

  # ============================================================
  # FEATURE 4: DỮ LIỆU MẪU
  # ============================================================

  Rule: Toggle dữ liệu mẫu để xem trước
  @sample-data @ui
  Scenario: Trạng thái mặc định của toggle dữ liệu mẫu
    Given tôi đang ở màn hình "Chỉnh sửa mẫu"
    And preview đang hiển thị template
    When trang được load
    Then toggle "Dữ liệu mẫu" ở trạng thái OFF
    And phần I (Thông tin tổ chức) hiển thị đầy đủ dữ liệu:
      | Trường       | Giá trị                                    |
      | Tên tổ chức  | CÔNG TY TNHH ABC                           |
      | Mã số thuế   | 0123456789                                 |
      | Địa chỉ      | Số 123, Đường Láng, Quận Đống Đa, Hà Nội  |
      | Điện thoại   | 024 1234 5678                              |
    And phần II (Thông tin cá nhân) KHÔNG hiển thị giá trị
    And phần III (Thông tin thuế) KHÔNG hiển thị giá trị
    And phần chữ ký KHÔNG hiển thị ngày tháng

  @sample-data @toggle
  Scenario: Bật toggle "Dữ liệu mẫu"
    Given toggle "Dữ liệu mẫu" đang OFF
    When tôi bật toggle "Dữ liệu mẫu"
    Then phần I giữ nguyên (luôn hiển thị)
    And phần II hiển thị dữ liệu mẫu:
      | Trường          | Giá trị                                       |
      | Họ và tên       | Nguyễn Văn A                                  |
      | Mã số thuế      | 0123456789012                                 |
      | Địa chỉ         | Số 456, Phường Láng Hạ, Quận Đống Đa, Hà Nội |
      | Quốc tịch       | Việt Nam                                      |
      | Cá nhân cư trú  | ☑                                             |
      | CCCD            | 001099012345                                  |
      | Số điện thoại   | 0987654321                                    |
      | Email           | nguyenvana@email.com                          |
      | Ghi chú         | Nhân viên văn phòng                           |
    And phần III hiển thị dữ liệu mẫu:
      | Trường             | Giá trị                                |
      | Khoản thu nhập     | Thu nhập từ tiền lương, tiền công      |
      | Bảo hiểm           | 3,491,250.00 VNĐ                       |
      | Từ thiện           | 0.00                                   |
      | Từ tháng           | 01                                     |
      | Đến tháng          | 12                                     |
      | Năm                | 2024                                   |
      | Thu nhập chịu thuế | 160,937,013.00 VNĐ                     |
      | Thu nhập tính thuế | 157,445,763.00 VNĐ                     |
      | Số thuế            | 5,451,003.00                           |
    And chữ ký hiển thị "Hà Nội, ngày 28 tháng 03 năm 2024"

  @sample-data @sync
  Scenario: Đồng bộ dữ liệu mẫu với Settings
    Given toggle "Dữ liệu mẫu" đang ON
    And dữ liệu mẫu đang hiển thị trong preview
    When tôi mở Settings panel
    Then các input trong Settings được điền tương ứng:
      | Trường      | Giá trị trong Settings                        |
      | Họ và tên   | Nguyễn Văn A                                  |
      | Mã số thuế  | 0123456789012                                 |
      | Địa chỉ     | Số 456, Phường Láng Hạ, Quận Đống Đa, Hà Nội |

  @sample-data @toggle
  Scenario: Tắt toggle "Dữ liệu mẫu"
    Given toggle "Dữ liệu mẫu" đang ON
    And dữ liệu mẫu đang hiển thị
    When tôi tắt toggle
    Then phần I giữ nguyên dữ liệu
    And phần II xóa tất cả giá trị (chỉ còn label)
    And phần III xóa tất cả giá trị (chỉ còn label)
    And chữ ký ẨN ngày tháng
    And Settings panel: Clear tất cả input (trừ phần I)

  # ============================================================
  # FEATURE 5: QUẢN LÝ DANH SÁCH MẪU CHỨNG TỪ
  # ============================================================

  Rule: Lưu và quản lý danh sách mẫu
  @template-save @api
  Scenario: Lưu mẫu mới và chuyển về danh sách
    Given tôi đang tạo mẫu mới lần đầu
    And tôi đã hoàn thành cấu hình mẫu
    And tất cả validation đều pass
    When tôi nhấn nút "Lưu"
    Then hệ thống lưu mẫu vào cơ sở dữ liệu
    And hiển thị thông báo "Lưu mẫu thành công"
    And tự động chuyển về trang "Danh sách mẫu chứng từ"
    And mẫu vừa tạo xuất hiện trong danh sách

  @template-save @api
  Scenario: Cập nhật mẫu hiện có và quay về danh sách
    Given tôi đang chỉnh sửa mẫu đã tồn tại
    And tôi đã thay đổi một số cấu hình
    When tôi nhấn nút "Lưu"
    Then hệ thống cập nhật mẫu trong cơ sở dữ liệu
    And hiển thị thông báo "Cập nhật mẫu thành công"
    And chuyển về trang "Danh sách mẫu chứng từ"
    And mẫu hiển thị với thông tin đã cập nhật

  @template-save @naming
  Scenario: Lưu mẫu với tên tùy chỉnh
    Given tôi đang tạo mẫu mới
    And trường "Tên chứng từ" có giá trị "Mẫu TNCN Tháng 01/2024"
    When tôi nhấn nút "Lưu"
    Then mẫu được lưu với tên "Mẫu TNCN Tháng 01/2024"
    And tên mẫu hiển thị trong danh sách

  @template-save @timestamp
  Scenario: Mẫu mới được ghi nhận thời gian tạo
    Given tôi đang tạo mẫu mới
    When tôi nhấn nút "Lưu" vào ngày 30/01/2025
    Then mẫu được lưu với ngày tạo "30/01/2025"
    And thời gian tạo hiển thị trong danh sách mẫu

  @template-save @timestamp
  Scenario: Mẫu được cập nhật thời gian chỉnh sửa
    Given tôi đang chỉnh sửa mẫu đã tồn tại từ ngày 15/01/2025
    When tôi lưu thay đổi vào ngày 30/01/2025
    Then mẫu cập nhật ngày tạo gần nhất 30/01/2025

  # ============================================================
  # CẤU TRÚC MẪU CHỨNG TỪ - VALIDATION
  # ============================================================

  Rule: Validation cấu trúc chứng từ khấu trừ thuế TNCN
  @template-structure @validation
  Scenario: Mẫu số 03/TNCN có cấu trúc hợp lệ
    Given tôi đang tạo chứng từ mẫu số 03/TNCN
    When hệ thống validate cấu trúc
    Then các trường sau phải có mặt:
      | Section | Trường                    | Kiểu dữ liệu | Bắt buộc |
      | I       | Tên chứng từ              | Chuỗi (100)  | ✓        |
      | I       | Mẫu số chứng từ           | Chuỗi (7)    | ✓        |
      | I       | Ký hiệu chứng từ          | Chuỗi (6)    | ✓        |
      | I       | Số chứng từ               | Số (7)       | ✓        |
      | II      | Tên đơn vị                | Chuỗi (400)  | ✓        |
      | II      | Mã số thuế                | Chuỗi (14)   | ✓        |
      | II      | Địa chỉ                   | Chuỗi (400)  | ✓        |
      | II      | Số điện thoại             | Chuỗi (20)   |          |
      | III     | Họ và tên                 | Chuỗi (400)  | ✓        |
      | III     | Địa chỉ                   | Chuỗi (400)  | ✓        |
      | III     | Quốc tịch                 | Chuỗi (100)  |          |
      | III     | Cá nhân cư trú            | Số (0/1)     | ✓        |
      | III     | CCCD/Hộ chiếu             | Chuỗi (20)   | ✓        |
      | III     | Số điện thoại             | Chuỗi (20)   | ✓        |
      | III     | Email                     | Email        |          |
      | III     | Ghi chú                   | Chuỗi        |          |
      | IV      | Khoản thu nhập            | Chuỗi        | ✓        |
      | IV      | Từ tháng                  | Số (1-12)    | ✓        |
      | IV      | Đến tháng                 | Số (1-12)    | ✓        |
      | IV      | Năm                       | Số (4)       | ✓        |
      | IV      | Bảo hiểm                  | Số           | ✓        |
      | IV      | Khoản từ thiện            | Số           | ✓        |
      | IV      | Thu nhập chịu thuế        | Số           | ✓        |
      | IV      | Thu nhập tính thuế        | Số           | ✓        |
      | IV      | Số thuế                   | Số           | ✓        |

  @template-structure @validation
  Scenario: Ký hiệu chứng từ phải đúng format
    Given tôi đang tạo chứng từ mẫu số 03/TNCN
    When hệ thống tự động generate ký hiệu chứng từ
    Then ký hiệu chứng từ phải có format "CT/YYE"
    And hai ký tự đầu là "CT/" (chữ viết tắt của chứng từ)
    And hai ký tự tiếp theo là 2 chữ số năm lập chứng từ (YY)
    And ký tự cuối là "E" (thể hiện hình thức điện tử)

  @template-structure @validation
  Scenario Outline: Validate ký hiệu chứng từ theo năm
    Given tôi đang tạo chứng từ vào năm <year>
    When hệ thống tự động generate ký hiệu chứng từ
    Then ký hiệu chứng từ là "<expected_symbol>"

    Examples:
      | year | expected_symbol |
      | 2024 | CT/24E          |
      | 2025 | CT/25E          |
      | 2026 | CT/26E          |

  @template-structure @auto-generate
  Scenario: Số chứng từ được tự động sinh khi phát hành
    Given tôi đang phát hành chứng từ mới
    When hệ thống tạo chứng từ
    Then số chứng từ được tự động sinh
    And số chứng từ có tối đa 7 chữ số

  @template-structure @data-source
  Scenario: Thông tin tổ chức được lấy từ thông tin đơn vị
    Given tôi đang tạo chứng từ mới
    When hệ thống load thông tin tổ chức trả thu nhập
    Then các trường sau được tự động điền từ "Thông tin đơn vị":
      | Trường         | Nguồn dữ liệu      |
      | Tên đơn vị     | Thông tin đơn vị   |
      | Mã số thuế     | Thông tin đơn vị   |
      | Địa chỉ        | Thông tin đơn vị   |
      | Số điện thoại  | Thông tin đơn vị   |

  @template-structure @dropdown
  Scenario: Khoản thu nhập có danh mục dropdown
    Given tôi đang điền thông tin thuế TNCN
    When tôi click vào trường "Khoản thu nhập"
    Then hiển thị dropdown với các options:
      | Option                                   |
      | Thu nhập từ tiền lương, tiền công        |
      | Thu nhập từ kinh doanh                   |
      | Thu nhập từ trúng thưởng                 |
      | Thu nhập khác                            |

  @template-structure @validation
  Scenario Outline: Validate tháng hợp lệ
    Given tôi đang điền thông tin thời gian trả thu nhập
    When tôi nhập "<field>" với giá trị "<value>"
    Then hệ thống <validation_result>

    Examples:
      | field     | value | validation_result                             |
      | Từ tháng  | 1     | chấp nhận giá trị                             |
      | Từ tháng  | 12    | chấp nhận giá trị                             |
      | Từ tháng  | 0     | từ chối với lỗi "Tháng phải từ 1 đến 12"      |
      | Từ tháng  | 13    | từ chối với lỗi "Tháng phải từ 1 đến 12"      |
      | Đến tháng | 6     | chấp nhận giá trị                             |
      | Đến tháng | 15    | từ chối với lỗi "Tháng phải từ 1 đến 12"      |

  @template-structure @validation
  Scenario: Validate năm là 4 chữ số
    Given tôi đang điền thông tin thời gian trả thu nhập
    When tôi nhập trường "Năm" với giá trị "2024"
    Then hệ thống chấp nhận giá trị
    When tôi nhập trường "Năm" với giá trị "24"
    Then hệ thống từ chối với lỗi "Năm phải có 4 chữ số"

  # ============================================================
  # YÊU CẦU PHI CHỨC NĂNG
  # ============================================================

  Rule: Yêu cầu về chữ ký số
  @digital-signature @requirement
  Scenario: Chứng từ điện tử phải có chữ ký số
    Given tôi đang tạo chứng từ khấu trừ thuế TNCN
    When tôi hoàn thành điền thông tin
    Then hệ thống yêu cầu chữ ký số/chữ ký điện tử của tổ chức trả thu nhập
    And chứng từ chỉ hợp lệ khi có chữ ký số

  Rule: Template chuẩn theo quy định
  @compliance @requirement
  Scenario: Mẫu số 03/TNCN tuân thủ NĐ 70/2025
    Given hệ thống cung cấp mẫu chứng từ khấu trừ thuế TNCN
    Then mẫu phải tuân thủ theo Nghị định 70/2025/NĐ-CP
    And có đầy đủ các trường thông tin theo quy định
    And cấu trúc template không thể thay đổi các trường bắt buộc

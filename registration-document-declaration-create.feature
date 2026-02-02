@document-declaration-create
Feature: Tạo mới tờ khai đăng ký/thay đổi thông tin sử dụng chứng từ điện tử
  Với vai trò một NNT
  Tôi muốn tạo tờ khai đăng ký/thay đổi thông tin sử dụng chứng từ điện tử
  Để có thể đăng ký hoặc thay đổi việc sử dụng chứng từ điện tử với cơ quan thuế

  Background:
    Given tôi đã đăng nhập với vai trò NNT
    And tôi có quyền "Đăng ký phát hành chứng từ điện tử"

  @business-rules @api
  Scenario Outline: Luôn cho phép chọn các option gửi tờ khai SD chứng từ điện tử
    Given tôi đang ở màn hình danh sách tờ khai
    When tôi tiến hành lập tờ khai mới
    Then hệ thống mở form tạo tờ khai mới với "<type_form>" được tùy chọn

    Examples:
      | type_form          |
      | Đăng ký mới        |
      | Thay đổi thông tin |

  Rule: Xác định loại tờ khai dựa trên lịch sử đăng ký
  @business-rules @api
  Scenario: Tự động đặt loại tờ khai là "Đăng ký mới" khi chưa có tờ khai nào
    Given người dùng đã đăng nhập vào hệ thống
    And chưa có tờ khai nào được tạo cho tài khoản này
    When người dùng tạo tờ khai mới
    Then hệ thống tự động đặt "type_form" = 1 (Đăng ký mới)
    And các tùy chọn trên form đăng ký được tự động chọn theo giá trị mặc định
      | Đối tượng phát hành | Tổ chức, cá nhân phát hành (checked)                                                               |
      | Loại hình sử dụng   | Chứng từ điện tử khấu trừ thuế thu nhập cá nhân (checked)                                          |
      | Hình thức gửi dữ liệu | Thông qua tổ chức cung cấp dịch vụ hóa đơn điện tử được Tổng cục Thuế ủy thác (checked) |

  @business-rules @api
  Scenario: Tự động đặt loại tờ khai là "Thay đổi thông tin" khi đã có tờ khai cũ trong hệ thống
    Given người dùng đã đăng nhập vào hệ thống
    And tài khoản đã tồn tại ít nhất 1 tờ khai thuộc type bất kỳ
    When người dùng tạo tờ khai mới
    Then hệ thống tự động đặt "type_form" = 2 (Thay đổi thông tin)

  Rule: Tự động điền thông tin đơn vị
  @auto-fill @api
  Scenario Outline: Tự động fill thông tin đơn vị khi tạo tờ khai mới
    Given tôi đang ở màn hình danh sách tờ khai
    When tôi tiến hành lập tờ khai mới
    Then hệ thống mở form tạo tờ khai mới
    And các trường "<company_field>" tại mục "Thông tin đơn vị" của tờ khai được tự động lấy từ "<company_info>" trong phân hệ "Thông tin đơn vị"

    Examples:
      | company_field        | company_info         |
      | Tên đơn vị           | Tên đơn vị           |
      | Mã số thuế           | Mã số thuế           |
      | Cơ quan thuế quản lý | Cơ quan thuế quản lý |

  @auto-fill @api
  Scenario: Không thể sửa các trường thuộc section "Thông tin đơn vị"
    Given người dùng đang ở form lập tờ khai đăng ký SD chứng từ điện tử
    When người dùng bấm sửa các "company_field" thuộc phần "Thông tin đơn vị"
    Then hệ thống không cho sửa các trường này

    Examples:
      | company_field        |
      | Tên đơn vị           |
      | Mã số thuế           |
      | Cơ quan thuế quản lý |

  Rule: Tự động fill thông tin từ tờ khai gần nhất
  @auto-fill @api
  Scenario Outline: Tự động fill thông tin tờ khai gần nhất khi tạo mới tờ khai
    Given người dùng đang ở màn hình danh sách tờ khai
    And đã có tối thiểu 1 tờ khai trong danh sách
    When người dùng tiến hành lập tờ khai mới
    Then hệ thống mở form tạo tờ khai mới
    And các trường thông tin "<other_field>" không thuộc "Thông tin đơn vị" được tự động fill từ dữ liệu tờ khai gần nhất

    Examples:
      | other_field                |
      | Đối tượng phát hành        |
      | Loại hình sử dụng          |
      | Hình thức gửi dữ liệu      |
      | Thông tin chữ ký số        |

  Rule: Đối tượng phát hành
  @business-rules @api
  Scenario: Phải chọn ít nhất một đối tượng phát hành
    Given người dùng đang ở form tạo tờ khai
    When người dùng không chọn bất kỳ đối tượng phát hành nào
    And người dùng nộp tờ khai
    Then hệ thống từ chối yêu cầu
    And hiển thị thông báo lỗi "Phải chọn ít nhất một đối tượng phát hành"

  Rule: Loại hình sử dụng chứng từ điện tử
  @business-rules @api
  Scenario: Phải chọn ít nhất một loại chứng từ điện tử
    Given người dùng đang ở form tạo tờ khai
    When người dùng không chọn bất kỳ loại chứng từ điện tử nào
    And người dùng nộp tờ khai
    Then hệ thống từ chối yêu cầu
    And hiển thị thông báo lỗi "Phải chọn ít nhất một loại chứng từ điện tử"

  @business-rules @ui
  Scenario: Hiển thị các loại biên lai con khi chọn Biên lai điện tử
    Given người dùng đang ở form tạo tờ khai
    When người dùng chọn checkbox "Biên lai điện tử"
    Then hệ thống hiển thị các loại biên lai con:
      | Biên lai thu thuế, phí, lệ phí không in sẵn mệnh giá |
      | Biên lai thu thuế, phí, lệ phí in sẵn mệnh giá       |
      | Biên lai thu thuế, phí, lệ phí                       |

  @business-rules @ui
  Scenario: Ẩn các loại biên lai con khi bỏ chọn Biên lai điện tử
    Given người dùng đang ở form tạo tờ khai
    And đã chọn checkbox "Biên lai điện tử"
    When người dùng bỏ chọn checkbox "Biên lai điện tử"
    Then hệ thống ẩn tất cả các loại biên lai con

  Rule: Hình thức gửi dữ liệu
  @business-rules @api
  Scenario: Phải chọn ít nhất một hình thức gửi dữ liệu
    Given người dùng đang ở form tạo tờ khai
    When người dùng không chọn bất kỳ hình thức gửi dữ liệu nào
    And người dùng nộp tờ khai
    Then hệ thống từ chối yêu cầu
    And hiển thị thông báo lỗi "Phải chọn ít nhất một hình thức gửi dữ liệu"

  Rule: Validation thông tin liên hệ
  @validation @required-fields @api
  Scenario Outline: Các trường thông tin liên hệ bắt buộc phải nhập
    Given người dùng đang tạo mới tờ khai
    When người dùng không nhập "<field>"
    And người dùng nộp tờ khai
    Then hệ thống từ chối yêu cầu
    And hiển thị thông báo lỗi "<error_message>"

    Examples:
      | field               | error_message                            |
      | Người liên hệ       | Người liên hệ không được để trống        |
      | Điện thoại liên hệ  | Điện thoại liên hệ không được để trống   |
      | Địa chỉ liên hệ     | Địa chỉ liên hệ không được để trống      |
      | Email               | Địa chỉ email không được để trống        |

  @validation @format @api
  Scenario Outline: Không thể lưu với dữ liệu không hợp lệ
    Given người dùng đang tạo mới tờ khai
    When người dùng nhập "<field>" với giá trị "<invalid_value>"
    And người dùng nộp tờ khai
    Then hệ thống từ chối yêu cầu
    And hiển thị thông báo lỗi "<expected_error>"

    Examples:
      | field              | invalid_value                            | expected_error                |
      | Số điện thoại      | abc123, 123                              | Số điện thoại không hợp lệ    |
      | Email              | invalid-email, abc@, @abc,a b@c, abc@gmail.h | Email không đúng định dạng |

  Rule: Validation độ dài
  @validation @length @api
  Scenario Outline: Độ dài trường vượt giới hạn
    Given người dùng đã đăng nhập vào hệ thống
    When người dùng tạo tờ khai với "<field>" có độ dài vượt quá "<giới_hạn>" ký tự
    Then hệ thống từ chối yêu cầu
    And hiển thị thông báo lỗi "<error_message>"

    Examples:
      | field              | giới_hạn | error_message                                        |
      | Tên đơn vị         | 400      | Tên người nộp thuế không được vượt quá 400 ký tự     |
      | Mã số thuế         | 14       | Mã số thuế không được vượt quá 14 ký tự              |
      | Người liên hệ      | 100      | Tên người liên hệ không được vượt quá 100 ký tự      |
      | Điện thoại liên hệ | 20       | Số điện thoại không được vượt quá 20 ký tự           |
      | Địa chỉ liên hệ    | 400      | Địa chỉ không được vượt quá 400 ký tự                |
      | Email              | 100      | Email không được vượt quá 100 ký tự                  |

  Rule: Xử lý chữ ký số
  @signature @api
  Scenario: Tạo tờ khai với danh sách chữ ký số hợp lệ
    Given người dùng đã đăng nhập vào hệ thống
    And người dùng cung cấp danh sách chữ ký số hợp lệ
    And chữ ký số còn hiệu lực
    And mã số thuế trong chứng thư số khớp với mã số thuế của đơn vị
    When người dùng tạo tờ khai mới
    Then hệ thống tạo tờ khai thành công

  @signature @api
  Scenario: Tạo tờ khai không có chữ ký số
    Given người dùng đã đăng nhập vào hệ thống
    And người dùng không cung cấp chữ ký số
    When người dùng nộp tờ khai
    Then hệ thống từ chối yêu cầu
    And hiển thị thông báo lỗi "Phải có ít nhất một chữ ký số hợp lệ"

  @signature @ui
  Scenario: Thêm chữ ký số vào tờ khai
    Given người dùng đang ở form tạo tờ khai
    When người dùng click nút "Thêm chữ ký số"
    Then hệ thống hiển thị dialog/modal chọn chữ ký số
    When người dùng chọn chữ ký số từ danh sách chữ ký số đã đăng ký trong hệ thống
    Then chữ ký số được thêm vào danh sách
    And danh sách chữ ký số hiển thị các thông tin:
      | Tổ chức chứng thực CKS |
      | Số Serial CKS          |
      | Hiệu lực từ ngày       |
      | Hiệu lực đến ngày      |
      | Hình thức đăng ký      |

  Rule: Loại đăng ký phải rõ ràng
  @validation @type-form @api
  Scenario Outline: Loại đăng ký hợp lệ
    Given người dùng đã đăng nhập vào hệ thống
    When người dùng tạo tờ khai với loại đăng ký "<type_form>"
    Then hệ thống chấp nhận yêu cầu
    And hệ thống tạo tờ khai thành công

    Examples:
      | type_form | mô_tả                                                      |
      | 1         | Đăng ký mới sử dụng chứng từ điện tử                       |
      | 2         | Thay đổi thông tin đăng ký sử dụng chứng từ điện tử        |

  @validation @type-form @api
  Scenario: Loại đăng ký không hợp lệ
    Given người dùng đã đăng nhập vào hệ thống
    When người dùng tạo tờ khai với "<type_form>" không phải là "1" hoặc "2"
    Then hệ thống từ chối yêu cầu
    And hiển thị thông báo lỗi "Loại đăng ký không hợp lệ"

  Rule: Gửi tờ khai cho CQT
  @submission @api
  Scenario: Tạo tờ khai mới và gửi trực tiếp cho cơ quan thuế
    Given tôi đang ở form tạo tờ khai mới
    And đã điền đầy đủ thông tin bắt buộc
    And pass tất cả validation rules
    When tôi click "Nộp tờ khai cho CQT"
    Then hệ thống validate dữ liệu
    And tờ khai mới sẽ được tạo với trạng thái "Đã gửi CQT"
    And hệ thống gửi XML sang CQT qua SOAP protocol
    And tôi sẽ thấy thông báo thành công "Đã gửi CQT"
    And tôi sẽ được chuyển về trang danh sách tờ khai
    And tờ khai sẽ xuất hiện trong danh sách với ngày lập

  @submission @api
  Scenario: Hủy tạo tờ khai mới
    Given tôi đang ở form tạo tờ khai mới
    When tôi click nút "Hủy bỏ" hoặc đóng form tạo tờ khai
    Then tôi sẽ được chuyển về trang danh sách tờ khai
    And không có tờ khai mới nào được tạo

  Rule: Xử lý phản hồi từ CQT
  @response-handling @api
  Scenario Outline: Xử lý thông điệp 110 - Tiếp nhận tờ khai
    Given hệ thống đã có tờ khai ở trạng thái "Đã gửi CQT"
    When hệ thống nhận được thông điệp 110 với thẻ THop = "<THop_value>" từ CQT
    Then tờ khai chuyển trạng thái sang "<new_status>"

    Examples:
      | THop_value | new_status          | mô_tả                                                                     |
      | 1          | Chờ CQT duyệt       | Trường hợp tiếp nhận Tờ khai đăng ký sử dụng chứng từ điện tử             |
      | 2          | CQT không tiếp nhận | Trường hợp không tiếp nhận Tờ khai đăng ký sử dụng chứng từ điện tử       |
      | 3          | Chờ CQT duyệt       | Trường hợp tiếp nhận Tờ khai thay đổi thông tin sử dụng chứng từ điện tử  |
      | 4          | CQT không tiếp nhận | Trường hợp không tiếp nhận Tờ khai thay đổi thông tin sử dụng chứng từ điện tử |

  @response-handling @api
  Scenario Outline: Xử lý thông điệp 111 - Chấp nhận tờ khai
    Given hệ thống đã có tờ khai ở trạng thái "Chờ CQT duyệt"
    When hệ thống nhận được thông điệp 111 với thẻ THop = "<THop_value>" từ CQT
    Then tờ khai chuyển trạng thái sang "<new_status>"

    Examples:
      | THop_value | new_status          | mô_tả                                                           |
      | 1          | CQT chấp nhận       | Trường hợp chấp nhận đăng ký/thay đổi thông tin sử dụng chứng từ điện tử |
      | 2          | CQT không tiếp nhận | Trường hợp không tiếp nhận Tờ khai đăng ký sử dụng chứng từ điện tử     |

  @response-handling @api
  Scenario: Xử lý lỗi gửi tờ khai
    Given hệ thống đã có tờ khai ở trạng thái "Đã gửi CQT"
    When có lỗi xảy ra trong quá trình gửi tờ khai lên CQT
    Then hệ thống cập nhật trạng thái tờ khai thành "Gửi lỗi"
    And lưu thông tin lỗi chi tiết
    And cho phép người dùng nộp lại tờ khai

  Rule: Xem chi tiết và hành động theo trạng thái
  @view-details @ui
  Scenario: Xem chi tiết tờ khai
    Given tôi đang ở danh sách tờ khai
    When tôi click vào một tờ khai trong danh sách
    Then hệ thống hiển thị trang chi tiết tờ khai với đầy đủ thông tin đã khai báo

  @view-details @ui
  Scenario Outline: Hiển thị button/action theo trạng thái tờ khai
    Given tôi đang xem chi tiết tờ khai
    And tờ khai có trạng thái "<status>"
    Then hệ thống hiển thị các button/action "<available_actions>"

    Examples:
      | status              | available_actions                                    |
      | Chờ CQT duyệt       | Đóng                                                 |
      | Gửi lỗi             | Đóng, Nộp tờ khai cho CQT                            |
      | CQT chấp nhận       | Đóng                                                 |
      | CQT không chấp nhận | Đóng, Lập tờ khai mới (cho phép xem chi tiết lỗi)    |

  Rule: Quản lý danh sách tờ khai
  @list-view @ui
  Scenario: Truy cập danh sách tờ khai
    Given tôi đã đăng nhập với vai trò NNT
    And tôi có quyền "Đăng ký phát hành chứng từ điện tử"
    When tôi click vào mục "Đăng ký SD chứng từ điện tử"
    Then hệ thống hiển thị màn hình "Danh sách tờ khai đăng ký sử dụng chứng từ điện tử"

  @list-view @ui
  Scenario: Hiển thị danh sách tờ khai với đầy đủ thông tin
    Given tôi đang ở danh sách tờ khai
    Then danh sách hiển thị dạng bảng với các cột:
      | Mã tờ khai          |
      | Ngày lập            |
      | Hình thức tờ khai   |
      | Loại chứng từ       |
      | Trạng thái          |
      | Ngày chấp nhận      |
      | Tác vụ              |

  Rule: Hệ thống phải ghi nhận lịch sử thao tác
  @audit @api
  Scenario Outline: Ghi log khi tạo tờ khai thành công
    Given người dùng đã đăng nhập vào hệ thống
    When người dùng tạo tờ khai thành công theo "<type_form>"
    Then hệ thống ghi log với các thông tin <tên_người_sử_dụng>, <hành_động>, <chức_năng>, <nội_dung>, <thời_gian>, <IP> vào audit trail

    Examples:
      | type_form | tên_người_sử_dụng | hành_động                          | chức_năng                          | nội_dung                                                | thời_gian   | IP        |
      | 1         | current user      | Đăng ký sử dụng chứng từ điện tử   | Đăng ký sử dụng chứng từ điện tử   | Đăng ký mới sử dụng chứng từ điện tử                    | server_time | device_IP |
      | 2         | current user      | Đăng ký sử dụng chứng từ điện tử   | Đăng ký sử dụng chứng từ điện tử   | Thay đổi thông tin đăng ký sử dụng chứng từ điện tử     | server_time | device_IP |

  Rule: Trạng thái tờ khai
  @status @api
  Scenario Outline: Các trạng thái hợp lệ của tờ khai chứng từ điện tử
    Given hệ thống quản lý tờ khai chứng từ điện tử
    Then tờ khai có thể ở các trạng thái sau: "<status>" với mô tả "<description>"

    Examples:
      | status              | description                                              |
      | Đã gửi CQT          | Đã nhận được thông điệp kỹ thuật 999, chờ xử lý          |
      | CQT không tiếp nhận | CQT từ chối tiếp nhận                                    |
      | Chờ CQT duyệt       | Đã nhận được thông điệp tiếp nhận của CQT (thông điệp 110) |
      | CQT chấp nhận       | CQT đã chấp nhận                                         |
      | Gửi lỗi             | Lỗi khi gửi lên CQT                                      |

  Rule: Yêu cầu phi chức năng
  @performance @nfr
  Scenario: Yêu cầu về hiệu năng
    Given người dùng đang sử dụng hệ thống
    Then form tạo tờ khai phải load trong dưới 2 giây
    And tự động điền thông tin phải hoàn thành trong dưới 1 giây
    And gửi tờ khai lên CQT timeout sau 30 giây

  @security @nfr
  Scenario: Yêu cầu về bảo mật
    Given người dùng đang thực hiện thao tác trên tờ khai
    Then hệ thống kiểm tra quyền "Đăng ký phát hành mẫu chứng từ điện tử" trước mọi thao tác
    And chữ ký số phải được validate trước khi gửi lên CQT
    And dữ liệu nhạy cảm phải được mã hóa khi lưu trữ và truyền tải

  @usability @nfr
  Scenario: Yêu cầu về khả năng sử dụng
    Given người dùng đang sử dụng form tạo tờ khai
    Then hệ thống hiển thị tooltip/gợi ý cho các trường phức tạp
    And validation lỗi phải hiển thị rõ ràng và tức thời
    And giao diện phải responsive, hỗ trợ các thiết bị di động

# language: vi
@document-declaration-create
Feature: Tạo mới tờ khai đăng ký/thay đổi thông tin sử dụng chứng từ điện tử
  Với vai trò người nộp thuế
  Để có thể đăng ký hoặc thay đổi việc sử dụng chứng từ điện tử với cơ quan thuế
  Người nộp thuế cần tạo và gửi tờ khai đến cơ quan thuế

  Background:
    Given người nộp thuế đã đăng nhập vào hệ thống
    And người nộp thuế có quyền đăng ký phát hành chứng từ điện tử

  Rule: Xác định loại tờ khai dựa trên lịch sử đăng ký

    @business-rules @api
    Scenario: Tạo tờ khai đầu tiên với loại "Đăng ký mới"
      Given chưa có tờ khai nào trong hệ thống
      When người nộp thuế tạo tờ khai mới
      Then hệ thống đặt loại tờ khai là "Đăng ký mới"
      And các tùy chọn được thiết lập theo giá trị mặc định

    @business-rules @api
    Scenario: Tạo tờ khai tiếp theo với loại "Thay đổi thông tin"
      Given đã tồn tại ít nhất một tờ khai trong hệ thống
      When người nộp thuế tạo tờ khai mới
      Then hệ thống đặt loại tờ khai là "Thay đổi thông tin"

    @business-rules @ui
    Scenario: Hiển thị các loại tờ khai có thể chọn
      Given người nộp thuế đang ở danh sách tờ khai
      When người nộp thuế mở form tạo tờ khai
      Then hệ thống hiển thị các tùy chọn loại tờ khai
        | Đăng ký mới        |
        | Thay đổi thông tin |

  Rule: Tự động điền thông tin đơn vị

    @auto-fill @api
    Scenario: Điền tự động thông tin đơn vị từ hồ sơ
      Given người nộp thuế đang tạo tờ khai mới
      When hệ thống mở form tạo tờ khai
      Then thông tin đơn vị được điền tự động từ hồ sơ
        | Tên đơn vị           |
        | Mã số thuế           |
        | Cơ quan thuế quản lý |

    @auto-fill @ui
    Scenario: Không cho phép sửa thông tin đơn vị
      Given người nộp thuế đang ở form tạo tờ khai
      When người nộp thuế cố gắng sửa thông tin đơn vị
      Then hệ thống không cho phép chỉnh sửa các trường này

  Rule: Tự động điền thông tin từ tờ khai gần nhất

    @auto-fill @api
    Scenario: Điền tự động từ tờ khai trước đó
      Given đã tồn tại tờ khai trước đó trong hệ thống
      When người nộp thuế tạo tờ khai mới
      Then thông tin sau được điền tự động từ tờ khai gần nhất
        | Đối tượng phát hành   |
        | Loại hình sử dụng     |
        | Hình thức gửi dữ liệu |
        | Thông tin chữ ký số   |

  Rule: Đối tượng phát hành

    @business-rules @api
    Scenario: Từ chối tờ khai không chọn đối tượng phát hành
      Given người nộp thuế đang tạo tờ khai
      And người nộp thuế không chọn đối tượng phát hành nào
      When người nộp thuế nộp tờ khai
      Then hệ thống hiển thị lỗi "Phải chọn ít nhất một đối tượng phát hành"

  Rule: Loại hình sử dụng chứng từ điện tử

    @business-rules @api
    Scenario: Từ chối tờ khai không chọn loại chứng từ
      Given người nộp thuế đang tạo tờ khai
      And người nộp thuế không chọn loại chứng từ điện tử nào
      When người nộp thuế nộp tờ khai
      Then hệ thống hiển thị lỗi "Phải chọn ít nhất một loại chứng từ điện tử"

    @business-rules @ui
    Scenario: Hiển thị các loại biên lai khi chọn biên lai điện tử
      Given người nộp thuế đang tạo tờ khai
      When người nộp thuế chọn "Biên lai điện tử"
      Then hệ thống hiển thị các loại biên lai con
        | Biên lai thu thuế, phí, lệ phí không in sẵn mệnh giá |
        | Biên lai thu thuế, phí, lệ phí in sẵn mệnh giá       |
        | Biên lai thu thuế, phí, lệ phí                       |

    @business-rules @ui
    Scenario: Ẩn các loại biên lai khi bỏ chọn biên lai điện tử
      Given người nộp thuế đã chọn "Biên lai điện tử"
      And các loại biên lai con đang hiển thị
      When người nộp thuế bỏ chọn "Biên lai điện tử"
      Then hệ thống ẩn tất cả các loại biên lai con

  Rule: Hình thức gửi dữ liệu

    @business-rules @api
    Scenario: Từ chối tờ khai không chọn hình thức gửi dữ liệu
      Given người nộp thuế đang tạo tờ khai
      And người nộp thuế không chọn hình thức gửi dữ liệu nào
      When người nộp thuế nộp tờ khai
      Then hệ thống hiển thị lỗi "Phải chọn ít nhất một hình thức gửi dữ liệu"

  Rule: Validation thông tin liên hệ - Trường bắt buộc

    @validation @required-fields @api
    Scenario Outline: Từ chối tờ khai thiếu thông tin liên hệ bắt buộc
      Given người nộp thuế đang tạo tờ khai
      When người nộp thuế nộp tờ khai mà thiếu <field>
      Then hệ thống hiển thị lỗi <error_message>

      Examples:
        | field               | error_message                            |
        | Người liên hệ       | Người liên hệ không được để trống        |
        | Điện thoại liên hệ  | Điện thoại liên hệ không được để trống   |
        | Địa chỉ liên hệ     | Địa chỉ liên hệ không được để trống      |
        | Email               | Địa chỉ email không được để trống        |

  Rule: Validation thông tin liên hệ - Định dạng

    @validation @format @api
    Scenario: Từ chối số điện thoại không hợp lệ
      Given người nộp thuế đang tạo tờ khai
      When người nộp thuế nhập số điện thoại không hợp lệ
      Then hệ thống hiển thị lỗi "Số điện thoại không hợp lệ"

    @validation @format @api
    Scenario: Từ chối email không đúng định dạng
      Given người nộp thuế đang tạo tờ khai
      When người nộp thuế nhập email không đúng định dạng
      Then hệ thống hiển thị lỗi "Email không đúng định dạng"

  Rule: Validation độ dài trường

    @validation @length @api
    Scenario Outline: Từ chối dữ liệu vượt quá giới hạn
      Given người nộp thuế đang tạo tờ khai
      When người nộp thuế nhập <field> vượt quá <max_length> ký tự
      Then hệ thống hiển thị lỗi <error_message>

      Examples:
        | field              | max_length | error_message                                        |
        | Tên đơn vị         | 400        | Tên người nộp thuế không được vượt quá 400 ký tự     |
        | Mã số thuế         | 14         | Mã số thuế không được vượt quá 14 ký tự              |
        | Người liên hệ      | 100        | Tên người liên hệ không được vượt quá 100 ký tự      |
        | Điện thoại liên hệ | 20         | Số điện thoại không được vượt quá 20 ký tự           |
        | Địa chỉ liên hệ    | 400        | Địa chỉ không được vượt quá 400 ký tự                |
        | Email              | 100        | Email không được vượt quá 100 ký tự                  |

  Rule: Xử lý chữ ký số

    @signature @api
    Scenario: Tạo tờ khai với chữ ký số hợp lệ
      Given người nộp thuế có chữ ký số hợp lệ
      And chữ ký số còn hiệu lực
      And mã số thuế trong chứng thư khớp với mã số thuế đơn vị
      When người nộp thuế tạo tờ khai với chữ ký số này
      Then hệ thống tạo tờ khai thành công

    @signature @api
    Scenario: Từ chối tờ khai không có chữ ký số
      Given người nộp thuế đang tạo tờ khai
      And người nộp thuế không cung cấp chữ ký số
      When người nộp thuế nộp tờ khai
      Then hệ thống hiển thị lỗi "Phải có ít nhất một chữ ký số hợp lệ"

    @signature @ui
    Scenario: Thêm chữ ký số vào tờ khai
      Given người nộp thuế đang tạo tờ khai
      When người nộp thuế thêm chữ ký số hợp lệ
      Then chữ ký số được thêm vào danh sách
      And hệ thống hiển thị thông tin chữ ký số
        | Tổ chức chứng thực CKS |
        | Số Serial CKS          |
        | Hiệu lực từ ngày       |
        | Hiệu lực đến ngày      |
        | Hình thức đăng ký      |

  Rule: Gửi tờ khai cho cơ quan thuế

    @submission @api
    Scenario: Nộp tờ khai hợp lệ cho cơ quan thuế
      Given người nộp thuế đã điền đầy đủ thông tin hợp lệ
      When người nộp thuế nộp tờ khai cho cơ quan thuế
      Then tờ khai được tạo với trạng thái "Đã gửi CQT"
      And hệ thống gửi tờ khai đến cơ quan thuế

    @submission @ui
    Scenario: Hiển thị thông báo sau khi nộp thành công
      Given người nộp thuế đã nộp tờ khai thành công
      Then người nộp thuế thấy thông báo "Đã gửi CQT"
      And người nộp thuế được chuyển về danh sách tờ khai

    @submission @ui
    Scenario: Hiển thị tờ khai mới trong danh sách
      Given người nộp thuế đã nộp tờ khai thành công
      When người nộp thuế xem danh sách tờ khai
      Then tờ khai mới xuất hiện trong danh sách với ngày lập

    @submission @ui
    Scenario: Hủy tạo tờ khai
      Given người nộp thuế đang tạo tờ khai
      When người nộp thuế hủy bỏ thao tác
      Then người nộp thuế quay về danh sách tờ khai
      And không có tờ khai mới nào được tạo

  Rule: Xử lý phản hồi từ cơ quan thuế

    @response-handling @api
    Scenario: Cơ quan thuế chấp nhận tờ khai
      Given tờ khai đang ở trạng thái "Chờ CQT duyệt"
      When hệ thống nhận phản hồi chấp nhận từ cơ quan thuế
      Then tờ khai chuyển sang trạng thái "CQT chấp nhận"

    @response-handling @api
    Scenario: Cơ quan thuế không tiếp nhận tờ khai
      Given tờ khai đang ở trạng thái "Chờ CQT duyệt"
      When hệ thống nhận phản hồi không tiếp nhận từ cơ quan thuế
      Then tờ khai chuyển sang trạng thái "CQT không tiếp nhận"

    @response-handling @api
    Scenario: Xử lý lỗi khi gửi tờ khai
      Given tờ khai đang ở trạng thái "Đã gửi CQT"
      When có lỗi xảy ra khi gửi tờ khai đến cơ quan thuế
      Then hệ thống cập nhật trạng thái thành "Gửi lỗi"
      And hệ thống lưu thông tin lỗi chi tiết
      And người nộp thuế có thể nộp lại tờ khai

  Rule: Xem chi tiết tờ khai

    @view-details @ui
    Scenario: Xem thông tin chi tiết tờ khai
      Given người nộp thuế đang ở danh sách tờ khai
      When người nộp thuế chọn xem một tờ khai
      Then hệ thống hiển thị đầy đủ thông tin đã khai báo

  Rule: Hành động theo trạng thái tờ khai

    @view-details @ui
    Scenario Outline: Hiển thị hành động phù hợp với trạng thái
      Given người nộp thuế đang xem chi tiết tờ khai
      And tờ khai có trạng thái <status>
      Then hệ thống hiển thị các hành động <available_actions>

      Examples:
        | status              | available_actions                          |
        | Chờ CQT duyệt       | Đóng                                       |
        | Gửi lỗi             | Đóng, Nộp lại                              |
        | CQT chấp nhận       | Đóng                                       |
        | CQT không chấp nhận | Đóng, Lập tờ khai mới, Xem chi tiết lỗi    |

  Rule: Quản lý danh sách tờ khai

    @list-view @ui
    Scenario: Truy cập danh sách tờ khai
      Given người nộp thuế có quyền đăng ký phát hành chứng từ điện tử
      When người nộp thuế chọn "Đăng ký SD chứng từ điện tử"
      Then hệ thống hiển thị danh sách tờ khai đăng ký sử dụng chứng từ điện tử

    @list-view @ui
    Scenario: Hiển thị thông tin tờ khai trong danh sách
      Given người nộp thuế đang xem danh sách tờ khai
      Then mỗi tờ khai hiển thị các thông tin
        | Mã tờ khai        |
        | Ngày lập          |
        | Hình thức tờ khai |
        | Loại chứng từ     |
        | Trạng thái        |
        | Ngày chấp nhận    |
        | Tác vụ            |

  Rule: Ghi nhận lịch sử thao tác

    @audit @api
    Scenario: Ghi log khi đăng ký mới thành công
      Given người nộp thuế đã tạo tờ khai đăng ký mới thành công
      Then hệ thống ghi log với thông tin
        | Người dùng    | current_user                           |
        | Hành động     | Đăng ký sử dụng chứng từ điện tử       |
        | Chức năng     | Đăng ký sử dụng chứng từ điện tử       |
        | Nội dung      | Đăng ký mới sử dụng chứng từ điện tử   |
        | Thời gian     | server_time                            |
        | IP            | device_IP                              |

    @audit @api
    Scenario: Ghi log khi thay đổi thông tin thành công
      Given người nộp thuế đã tạo tờ khai thay đổi thông tin thành công
      Then hệ thống ghi log với thông tin
        | Người dùng    | current_user                                       |
        | Hành động     | Đăng ký sử dụng chứng từ điện tử                   |
        | Chức năng     | Đăng ký sử dụng chứng từ điện tử                   |
        | Nội dung      | Thay đổi thông tin đăng ký sử dụng chứng từ điện tử|
        | Thời gian     | server_time                                        |
        | IP            | device_IP                                          |

  Rule: Trạng thái tờ khai

    @status @api
    Scenario Outline: Tờ khai có các trạng thái hợp lệ
      Given hệ thống quản lý tờ khai chứng từ điện tử
      Then tờ khai có thể ở trạng thái <status> với ý nghĩa <description>

      Examples:
        | status              | description                                      |
        | Đã gửi CQT          | Đã gửi thành công, chờ cơ quan thuế xử lý        |
        | CQT không tiếp nhận | Cơ quan thuế từ chối tiếp nhận                   |
        | Chờ CQT duyệt       | Cơ quan thuế đã tiếp nhận, đang xem xét          |
        | CQT chấp nhận       | Cơ quan thuế đã chấp nhận                        |
        | Gửi lỗi             | Có lỗi khi gửi đến cơ quan thuế                  |

  Rule: Yêu cầu phi chức năng - Hiệu năng

    @performance @nfr
    Scenario: Form tạo tờ khai load nhanh
      Given người nộp thuế mở form tạo tờ khai
      Then form hiển thị hoàn tất trong vòng 2 giây

    @performance @nfr
    Scenario: Tự động điền thông tin nhanh chóng
      Given người nộp thuế mở form tạo tờ khai mới
      Then thông tin được điền tự động trong vòng 1 giây

    @performance @nfr
    Scenario: Timeout gửi tờ khai
      Given người nộp thuế nộp tờ khai
      When quá trình gửi vượt quá 30 giây
      Then hệ thống báo timeout và cho phép thử lại

  Rule: Yêu cầu phi chức năng - Bảo mật

    @security @nfr
    Scenario: Kiểm tra quyền trước mọi thao tác
      Given người dùng thực hiện thao tác trên tờ khai
      Then hệ thống kiểm tra quyền "Đăng ký phát hành mẫu chứng từ điện tử"

    @security @nfr
    Scenario: Validate chữ ký số trước khi gửi
      Given người nộp thuế nộp tờ khai với chữ ký số
      Then hệ thống validate chữ ký số trước khi gửi đến cơ quan thuế

    @security @nfr
    Scenario: Mã hóa dữ liệu nhạy cảm
      Given hệ thống lưu trữ hoặc truyền tải dữ liệu tờ khai
      Then dữ liệu nhạy cảm được mã hóa

  Rule: Yêu cầu phi chức năng - Khả năng sử dụng

    @usability @nfr
    Scenario: Hiển thị gợi ý cho trường phức tạp
      Given người nộp thuế đang điền form tạo tờ khai
      When người nộp thuế di chuột qua trường phức tạp
      Then hệ thống hiển thị tooltip hướng dẫn

    @usability @nfr
    Scenario: Hiển thị lỗi validation rõ ràng
      Given người nộp thuế nhập dữ liệu không hợp lệ
      When người nộp thuế rời khỏi trường
      Then hệ thống hiển thị thông báo lỗi rõ ràng ngay lập tức

    @usability @nfr
    Scenario: Giao diện responsive
      Given người nộp thuế truy cập từ thiết bị di động
      When người nộp thuế sử dụng form tạo tờ khai
      Then giao diện tự động điều chỉnh phù hợp với màn hình

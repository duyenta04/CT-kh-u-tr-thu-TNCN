Feature: Tạo và gửi chứng từ khấu trừ thuế thu nhập cá nhân
  Là tổ chức chi trả thu nhập
  Tôi muốn tạo và gửi chứng từ khấu trừ thuế TNCN sang CQT
  Để hoàn thành nghĩa vụ kê khai và khấu trừ thuế thu nhập cá nhân

  Background:
    Given tổ chức chi trả thu nhập đã đăng nhập vào hệ thống
    And tổ chức đã đăng ký sử dụng chứng từ điện tử với CQT
    And chứng thư số của tổ chức còn hiệu lực

# ============================================================
# PHẦN 1: THÔNG TIN CHUNG CHỨNG TỪ (TTChung)
# ============================================================

  Scenario Outline: Hệ thống tạo chứng từ với thông tin chung bắt buộc
    Given tổ chức cần lập chứng từ khấu trừ thuế TNCN
    When hệ thống tạo file XML chứng từ
    Then XML chứa thẻ "<ten_the>" với mô tả "<mo_ta>"
    And thẻ "<ten_the>" có độ dài tối đa "<do_dai>" ký tự
    And thẻ "<ten_the>" có kiểu dữ liệu "<kieu_du_lieu>"
    And tính bắt buộc là "<rang_buoc>"

    Examples: Thông tin chung chứng từ
      | ten_the | mo_ta                          | do_dai | kieu_du_lieu | rang_buoc |
      | PBan    | Phiên bản thông điệp           | 6      | Chuỗi ký tự  | Bắt buộc  |
      | TCTu    | Tên chứng từ                   | 100    | Chuỗi ký tự  | Bắt buộc  |
      | MSCTu   | Mẫu số chứng từ                | 7      | Chuỗi ký tự  | Bắt buộc  |
      | KHCTu   | Ký hiệu chứng từ               | 6      | Chuỗi ký tự  | Bắt buộc  |
      | SCTu    | Số chứng từ                    | 7      | Số           | Bắt buộc  |
      | NLap    | Ngày lập                       | -      | Ngày         | Bắt buộc  |

  Scenario: Tổ chức tạo chứng từ mới với thông tin chung hợp lệ
    Given tổ chức đã điền đầy đủ thông tin bắt buộc
    When tổ chức tạo chứng từ khấu trừ thuế TNCN
    Then chứng từ được tạo với phiên bản "2.1.0"
    And chứng từ có tên "Chứng từ khấu trừ thuế thu nhập cá nhân"
    And chứng từ có mẫu số theo quy định
    And chứng từ có ký hiệu theo đăng ký với CQT
    And chứng từ có số thứ tự tăng dần
    And ngày lập chứng từ là ngày hiện tại

# ============================================================
# PHẦN 2: CHỨNG TỪ THAY THẾ/ĐIỀU CHỈNH (TTCTLQuan)
# ============================================================

  Scenario: Tổ chức tạo chứng từ thay thế cho chứng từ đã phát hành sai
    Given chứng từ gốc "CT001" đã được phát hành
    And chứng từ gốc có thông tin không chính xác
    When tổ chức tạo chứng từ thay thế
    Then chứng từ mới có tính chất "1" (Thay thế)
    And chứng từ mới tham chiếu đến loại chứng từ gốc
    And chứng từ mới chứa ký hiệu mẫu chứng từ gốc
    And chứng từ mới chứa ký hiệu chứng từ gốc
    And chứng từ mới chứa số chứng từ gốc
    And chứng từ mới chứa ngày lập chứng từ gốc

  Scenario: Tổ chức tạo chứng từ điều chỉnh để sửa thông tin
    Given chứng từ gốc "CT002" đã được phát hành
    And một số thông tin trong chứng từ gốc cần điều chỉnh
    When tổ chức tạo chứng từ điều chỉnh
    Then chứng từ mới có tính chất "2" (Điều chỉnh)
    And chứng từ mới liên kết với chứng từ gốc qua thông tin liên quan
    And chứng từ mới có thể thêm ghi chú về nội dung điều chỉnh

  Scenario Outline: Hệ thống validate thông tin chứng từ liên quan
    Given tổ chức đang tạo chứng từ thay thế hoặc điều chỉnh
    When hệ thống tạo XML với thông tin chứng từ liên quan
    Then XML chứa thẻ "<ten_the>" với "<mo_ta>"
    And độ dài tối đa là "<do_dai>"

    Examples: Thông tin chứng từ liên quan
      | ten_the          | mo_ta                                    | do_dai |
      | TCCTu            | Tính chất chứng từ (1: Thay thế, 2: ĐC) | 1      |
      | LHCTLQuan        | Loại chứng từ có liên quan               | 1      |
      | KHMSCTCLQuan     | Ký hiệu mẫu số chứng từ liên quan        | 11     |
      | KHCTCLQuan       | Ký hiệu chứng từ liên quan               | 9      |
      | SCTCLQuan        | Số chứng từ liên quan                    | 8      |
      | NLCTCLQuan       | Ngày lập chứng từ liên quan              | -      |
      | GChu             | Ghi chú                                  | 255    |

# ============================================================
# PHẦN 3: THÔNG TIN TỔ CHỨC CHI TRẢ THU NHẬP (TCTTNhap)
# ============================================================

  Scenario: Hệ thống tự động điền thông tin tổ chức chi trả từ hồ sơ đơn vị
    Given tổ chức đã đăng ký thông tin với CQT
    When hệ thống tạo chứng từ mới
    Then thông tin tổ chức chi trả được tự động điền
    And thông tin bao gồm tên tổ chức
    And thông tin bao gồm mã số thuế
    And thông tin bao gồm địa chỉ
    And thông tin có thể bao gồm số điện thoại (không bắt buộc)

  Scenario Outline: Validate thông tin tổ chức chi trả thu nhập
    Given tổ chức đang điền thông tin chi trả
    When hệ thống validate trường "<ten_the>"
    Then trường có độ dài tối đa "<do_dai>" ký tự
    And trường có tính bắt buộc "<rang_buoc>"

    Examples: Thông tin tổ chức chi trả
      | ten_the | mo_ta           | do_dai | rang_buoc      |
      | Ten     | Tên tổ chức     | 400    | Bắt buộc       |
      | MST     | Mã số thuế      | 14     | Bắt buộc       |
      | DChi    | Địa chỉ         | 400    | Bắt buộc       |
      | SDThoai | Số điện thoại   | 20     | Không bắt buộc |

# ============================================================
# PHẦN 4: THÔNG TIN CÁ NHÂN NHẬN THU NHẬP (NNT)
# ============================================================

  Scenario: Tổ chức nhập thông tin cá nhân cư trú có MST
    Given cá nhân nhận thu nhập là người cư trú
    And cá nhân đã có mã số thuế
    When tổ chức nhập thông tin cá nhân
    Then hệ thống yêu cầu nhập họ và tên
    And hệ thống yêu cầu nhập mã số thuế
    And hệ thống yêu cầu nhập địa chỉ
    And hệ thống yêu cầu đánh dấu "Cá nhân cư trú" = 1
    And hệ thống yêu cầu nhập số điện thoại

  Scenario: Tổ chức nhập thông tin cá nhân không có MST
    Given cá nhân nhận thu nhập chưa có mã số thuế
    When tổ chức nhập thông tin cá nhân
    Then hệ thống yêu cầu nhập căn cước công dân (CCCD/Hộ chiếu)
    And CCCD là bắt buộc khi không có MST
    And hệ thống vẫn yêu cầu các thông tin bắt buộc khác

  Scenario: Tổ chức nhập thông tin cá nhân không cư trú
    Given cá nhân nhận thu nhập là người không cư trú
    When tổ chức nhập thông tin cá nhân
    Then hệ thống đánh dấu "Cá nhân cư trú" = 0
    And hệ thống có thể yêu cầu thông tin quốc tịch
    And thuế suất áp dụng là 20% (thuế suất cố định)

  Scenario Outline: Validate thông tin cá nhân nhận thu nhập
    Given tổ chức đang nhập thông tin người nhận thu nhập
    When hệ thống validate trường "<ten_the>"
    Then trường có độ dài tối đa "<do_dai>"
    And trường có tính bắt buộc "<rang_buoc>"
    And trường có ghi chú "<ghi_chu>"

    Examples: Thông tin người nhận thu nhập
      | ten_the  | mo_ta                    | do_dai | rang_buoc                    | ghi_chu                          |
      | Ten      | Họ và tên                | 400    | Bắt buộc                     | Theo Khoản 18, Điều 1, NĐ 70     |
      | MST      | Mã số thuế               | 14     | Bắt buộc (Nếu có)            | Theo Khoản 18, Điều 1, NĐ 70     |
      | DChi     | Địa chỉ                  | 400    | Bắt buộc                     | Theo Khoản 18, Điều 1, NĐ 70     |
      | QTich    | Quốc tịch                | 400    | Không bắt buộc               | -                                |
      | CNCTru   | Cá nhân cư trú           | 1      | Bắt buộc                     | 0: Không cư trú, 1: Cư trú       |
      | CCCDan   | CCCD/Hộ chiếu            | 20     | Bắt buộc (khi không có MST)  | Theo Khoản 18, Điều 1, NĐ 70     |
      | SDThoai  | Số điện thoại            | 20     | Bắt buộc                     | Theo Khoản 18, Điều 1, NĐ 70     |
      | DCTDTu   | Email                    | 50     | Không bắt buộc               | -                                |
      | GChu     | Ghi chú                  | 255    | Không bắt buộc               | -                                |

# ============================================================
# PHẦN 5: THÔNG TIN THUẾ THU NHẬP CÁ NHÂN KHẤU TRỪ (TTNCNKTru)
# ============================================================

  Scenario: Tổ chức tính thuế cho cá nhân cư trú theo biểu thuế lũy tiến
    Given cá nhân nhận thu nhập là người cư trú
    And tổng thu nhập chịu thuế trong kỳ đã được xác định
    When hệ thống tính thuế thu nhập cá nhân
    Then hệ thống áp dụng biểu thuế lũy tiến 7 bậc
    And hệ thống trừ các khoản giảm trừ hợp lệ
    And hệ thống trừ khoản đóng bảo hiểm bắt buộc
    And hệ thống trừ khoản từ thiện, nhân đạo, khuyến học
    And số thuế khấu trừ được tính theo thu nhập tính thuế

  Scenario: Tổ chức tính thuế cho cá nhân không cư trú
    Given cá nhân nhận thu nhập là người không cư trú
    And tổng thu nhập chịu thuế trong kỳ đã được xác định
    When hệ thống tính thuế thu nhập cá nhân
    Then hệ thống áp dụng thuế suất cố định 20%
    And số thuế khấu trừ = tổng thu nhập chịu thuế × 20%

  Scenario: Tổ chức kê khai đầy đủ thông tin thuế khấu trừ
    Given tổ chức đã xác định thu nhập và thuế khấu trừ
    When tổ chức lập chứng từ
    Then chứng từ chứa khoản thu nhập chi tiết
    And chứng từ chứa tháng bắt đầu trả thu nhập
    And chứng từ chứa tháng cuối cùng trả thu nhập
    And chứng từ chứa năm trả thu nhập
    And chứng từ chứa khoản đóng bảo hiểm bắt buộc
    And chứng từ chứa khoản từ thiện, nhân đạo, khuyến học
    And chứng từ chứa tổng thu nhập chịu thuế
    And chứng từ chứa tổng thu nhập tính thuế
    And chứng từ chứa số thuế đã khấu trừ

  Scenario Outline: Validate thông tin thuế thu nhập khấu trừ
    Given tổ chức đang nhập thông tin thuế
    When hệ thống validate trường "<ten_the>"
    Then trường có định dạng "<dinh_dang>"
    And trường có tính bắt buộc "<rang_buoc>"

    Examples: Thông tin thuế khấu trừ
      | ten_the   | mo_ta                              | dinh_dang     | rang_buoc |
      | KTNhap    | Khoản thu nhập                     | Chuỗi (250)   | Bắt buộc  |
      | TThang    | Từ tháng                           | Số (2)        | Bắt buộc  |
      | DThang    | Đến tháng                          | Số (2)        | Bắt buộc  |
      | Nam       | Năm                                | Số (4)        | Bắt buộc  |
      | BHiem     | Bảo hiểm bắt buộc                  | Số (21,6)     | Bắt buộc  |
      | TThien    | Từ thiện, nhân đạo, khuyến học     | Số (21,6)     | Bắt buộc  |
      | TTNCThue  | Tổng thu nhập chịu thuế            | Số (21,6)     | Bắt buộc  |
      | TTNTThue  | Tổng thu nhập tính thuế            | Số (21,6)     | Bắt buộc  |
      | SThue     | Số thuế đã khấu trừ                | Số (21,6)     | Bắt buộc  |

# ============================================================
# PHẦN 6: CHỮ KÝ SỐ (DSCKS)
# ============================================================

  Scenario: Tổ chức ký số chứng từ trước khi gửi CQT
    Given chứng từ đã được hoàn thiện
    And chứng thư số của tổ chức còn hiệu lực
    When tổ chức thực hiện ký số
    Then chứng từ được ký bằng chữ ký số của tổ chức chi trả
    And chữ ký số được gắn vào thẻ CTu\DSCKS\TCTTNhap
    And chữ ký số ký trên thẻ CTu\DLCTu
    And chữ ký số ký trên thẻ Signature\Object
    And chữ ký số tuân thủ chuẩn XML Digital Signature

  Scenario: Hệ thống cho phép thêm chữ ký số khác (nếu cần)
    Given chứng từ đã có chữ ký chính của tổ chức
    And có yêu cầu thêm chữ ký khác
    When tổ chức thêm chữ ký số bổ sung
    Then chữ ký bổ sung được lưu trong thẻ CTu\DSCKS\CCKSKhac
    And chữ ký bổ sung ký trên thẻ CTu\DLCTu
    And chữ ký bổ sung ký trên thẻ Signature\Object (nếu cần)

# ============================================================
# PHẦN 7: VALIDATION VÀ BUSINESS RULES
# ============================================================

  Scenario: Hệ thống validate tháng bắt đầu và kết thúc hợp lệ
    Given tổ chức đang nhập thời gian trả thu nhập
    When tổ chức nhập từ tháng và đến tháng
    Then từ tháng phải trong khoảng 1-12
    And đến tháng phải trong khoảng 1-12
    And đến tháng phải lớn hơn hoặc bằng từ tháng
    And năm phải là số 4 chữ số

  Scenario: Hệ thống validate số tiền hợp lệ
    Given tổ chức đang nhập các khoản tiền
    When hệ thống validate số tiền
    Then số tiền phải là số dương
    And số tiền có tối đa 21 chữ số
    And phần thập phân có tối đa 6 chữ số
    And tổng thu nhập tính thuế <= tổng thu nhập chịu thuế

  Scenario: Hệ thống validate MST hoặc CCCD bắt buộc
    Given tổ chức đang nhập thông tin cá nhân
    When hệ thống validate thông tin định danh
    Then nếu có MST thì CCCD không bắt buộc
    But nếu không có MST thì CCCD là bắt buộc
    And MST có độ dài tối đa 14 ký tự
    And CCCD có độ dài tối đa 20 ký tự

  Scenario: Hệ thống kiểm tra logic tính thuế
    Given tổ chức đã nhập đầy đủ thông tin thuế
    When hệ thống tính toán
    Then thu nhập tính thuế = thu nhập chịu thuế - bảo hiểm - từ thiện - giảm trừ khác
    And số thuế khấu trừ phải được tính chính xác theo quy định
    And số thuế >= 0

# ============================================================
# PHẦN 8: GỬI CHỨNG TỪ LÊN CQT
# ============================================================

  Scenario: Tổ chức gửi chứng từ hợp lệ lên CQT
    Given chứng từ đã được lập đầy đủ thông tin
    And chứng từ đã được ký số hợp lệ
    When tổ chức gửi chứng từ lên CQT
    Then hệ thống tạo file XML theo cấu trúc quy định
    And hệ thống gửi XML qua kênh đã đăng ký (TCTN/TCTNUT/Cổng CQT)
    And hệ thống nhận mã tiếp nhận từ CQT
    And chứng từ chuyển sang trạng thái "Đã gửi CQT"

  Scenario: CQT chấp nhận chứng từ
    Given chứng từ đã được gửi lên CQT
    When CQT xử lý và chấp nhận chứng từ
    Then hệ thống nhận thông báo chấp nhận từ CQT
    And chứng từ chuyển sang trạng thái "CQT đã chấp nhận"
    And chứng từ được lưu trữ với đầy đủ thông tin
    And cá nhân có thể tra cứu chứng từ qua hệ thống CQT

  Scenario: CQT từ chối chứng từ do sai thông tin
    Given chứng từ đã được gửi lên CQT
    When CQT phát hiện lỗi trong chứng từ
    Then hệ thống nhận thông báo từ chối kèm lý do
    And chứng từ chuyển sang trạng thái "CQT từ chối"
    And tổ chức có thể xem chi tiết lỗi
    And tổ chức có thể tạo chứng từ thay thế hoặc điều chỉnh

# ============================================================
# CẤU TRÚC XML MẪU (COMMENTS)
# ============================================================

# <?xml version="1.0" encoding="UTF-8"?>
# <CTu>
#   <!-- DỮ LIỆU CHỨNG TỪ -->
#   <DLCTu>
#     <!-- THÔNG TIN CHUNG -->
#     <TTChung>
#       <PBan>2.1.0</PBan>
#       <TCTu>Chứng từ khấu trừ thuế thu nhập cá nhân</TCTu>
#       <MSCTu>03/TNCN</MSCTu>
#       <KHCTu>AA/25E</KHCTu>
#       <SCTu>0000001</SCTu>
#       <NLap>2026-02-02</NLap>
#       
#       <!-- THÔNG TIN CHỨNG TỪ LIÊN QUAN (Nếu là thay thế/điều chỉnh) -->
#       <!-- <TTCTLQuan>
#         <TCCTu>1</TCCTu>
#         <LHCTLQuan>1</LHCTLQuan>
#         <KHMSCTCLQuan>03/TNCN-AA/25E</KHMSCTCLQuan>
#         <KHCTCLQuan>AA/25E</KHCTCLQuan>
#         <SCTCLQuan>0000099</SCTCLQuan>
#         <NLCTCLQuan>2026-01-15</NLCTCLQuan>
#         <GChu>Thay thế do sai thông tin thuế</GChu>
#       </TTCTLQuan> -->
#       
#       <!-- THÔNG TIN KHÁC -->
#       <TTKhac/>
#     </TTChung>
#     
#     <!-- NỘI DUNG CHỨNG TỪ -->
#     <NDCTu>
#       <!-- TỔ CHỨC CHI TRẢ THU NHẬP -->
#       <TCTTNhap>
#         <Ten>CÔNG TY CỔ PHẦN CÔNG NGHỆ KIOTVIET</Ten>
#         <MST>0104359717</MST>
#         <DChi>Tầng 6, Tòa nhà Việt Á, 9 Duy Tân, Cầu Giấy, Hà Nội</DChi>
#         <SDThoai>0987654321</SDThoai>
#         <TTKhac/>
#       </TCTTNhap>
#       
#       <!-- NGƯỜI NHẬN THU NHẬP -->
#       <NNT>
#         <Ten>Nguyễn Văn A</Ten>
#         <MST>8888888888</MST>
#         <DChi>123 Đường ABC, Quận 1, TP.HCM</DChi>
#         <QTich>Việt Nam</QTich>
#         <CNCTru>1</CNCTru>
#         <CCCDan>001234567890</CCCDan>
#         <SDThoai>0912345678</SDThoai>
#         <DCTDTu>nguyenvana@example.com</DCTDTu>
#         <GChu/>
#         <TTKhac/>
#       </NNT>
#       
#       <!-- THÔNG TIN THUẾ KHẤU TRỪ -->
#       <TTNCNKTru>
#         <KTNhap>Tiền lương, tiền công</KTNhap>
#         <TThang>1</TThang>
#         <DThang>12</DThang>
#         <Nam>2026</Nam>
#         <BHiem>12000000</BHiem>
#         <TThien>5000000</TThien>
#         <TTNCThue>300000000</TTNCThue>
#         <TTNTThue>272000000</TTNTThue>
#         <SThue>28400000</SThue>
#       </TTNCNKTru>
#     </NDCTu>
#   </DLCTu>
#   
#   <!-- CHỮ KÝ SỐ -->
#   <DSCKS>
#     <!-- CHỮ KÝ CỦA TỔ CHỨC CHI TRẢ -->
#     <TCTTNhap>
#       <Signature xmlns="http://www.w3.org/2000/09/xmldsig#">
#         <!-- XML Digital Signature Structure -->
#         <SignedInfo>...</SignedInfo>
#         <SignatureValue>...</SignatureValue>
#         <KeyInfo>...</KeyInfo>
#         <Object>...</Object>
#       </Signature>
#     </TCTTNhap>
#     
#     <!-- CÁC CHỮ KÝ KHÁC (Nếu có) -->
#     <!-- <CCKSKhac>
#       <Signature xmlns="http://www.w3.org/2000/09/xmldsig#">
#         ...
#       </Signature>
#     </CCKSKhac> -->
#   </DSCKS>
# </CTu>

# ============================================================
# LƯU Ý QUAN TRỌNG
# ============================================================
# 
# 1. CẤU TRÚC CHÍNH:
#    - CTu (Chứng từ) - Thẻ gốc
#    - DLCTu (Dữ liệu chứng từ) - Chứa toàn bộ thông tin
#    - TTChung (Thông tin chung) - Metadata chứng từ
#    - NDCTu (Nội dung chứng từ) - Nội dung chi tiết
#    - DSCKS (Danh sách chữ ký số) - Chữ ký điện tử
#
# 2. PHÂN BIỆT CƯ TRÚ:
#    - Cá nhân cư trú (CNCTru = 1): Thuế lũy tiến 7 bậc (5%-35%)
#    - Cá nhân không cư trú (CNCTru = 0): Thuế cố định 20%
#
# 3. MST VÀ CCCD:
#    - Nếu có MST: CCCD không bắt buộc
#    - Nếu không có MST: CCCD BẮT BUỘC
#
# 4. CHỨNG TỪ THAY THẾ/ĐIỀU CHỈNH:
#    - TCCTu = 1: Thay thế (hủy chứng từ cũ)
#    - TCCTu = 2: Điều chỉnh (giữ chứng từ cũ, bổ sung thay đổi)
#
# 5. ĐỊNH DẠNG SỐ:
#    - Số (21,6): Tối đa 21 chữ số, 6 chữ số thập phân
#    - Ví dụ: 999999999999999.999999
#
# 6. CHỮ KÝ SỐ:
#    - Bắt buộc có chữ ký của tổ chức chi trả (TCTTNhap)
#    - Có thể có thêm chữ ký khác (CCKSKhac)
#    - Tuân thủ XML Digital Signature chuẩn W3C
#
# 7. THỜI GIAN:
#    - TThang, DThang: 1-12
#    - Nam: Năm 4 chữ số
#    - NLap: Format YYYY-MM-DD
#
# 8. VALIDATION:
#    - TTNTThue <= TTNCThue
#    - SThue >= 0
#    - DThang >= TThang (trong cùng năm)

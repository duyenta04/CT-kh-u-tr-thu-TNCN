Feature: Gửi file XML tờ khai đăng ký/thay đổi thông tin sử dụng chứng từ điện tử
  Là người dùng đang tạo tờ khai đăng ký sử dụng chứng từ điện tử khấu trừ thuế TNCN
  Tôi muốn gửi file XML tờ khai sang CQT
  Để hệ thống có thể gửi thông tin tờ khai đăng ký theo quy định

Background:
  Given người dùng đang ở form tạo mới tờ khai sử dụng chứng từ điện tử
  And người dùng đã điền đầy đủ các nội dung bắt buộc
  When người dùng nhấp "Gửi tờ khai cho CQT"
  Then hệ thống gửi file XML sang CQT với cấu trúc theo Quyết định 1306/QĐ-CT

Scenario Outline: Cấu trúc XML - Thông điệp (TDiep) - Phần TTChung
  Given file XML có cấu trúc <TDiep>/<TTChung>
  When hệ thống tạo XML với các trường thông tin chung
  Then XML phải chứa trường "<ten_the>" với "<description>"
  And trường này có độ dài tối đa "<max_length>" ký tự
  And kiểu dữ liệu là "<data_type>"
  And tính bắt buộc là "<required>"
  
  Examples:
  | ten_the   | description              | max_length | data_type   | required | info                                                                                 |
  | PBan      | Phiên bản thông điệp     | 6          | Chuỗi ký tự | Bắt buộc | 2.1.0                                                                                |
  | MNGui     | Mã nơi gửi               | 14         | Chuỗi ký tự | Bắt buộc | MST của NNT (ví dụ: 0104359717)                                                      |
  | MNNhan    | Mã nơi nhận              | 14         | Chuỗi ký tự | Bắt buộc | Mã CQT (ví dụ: T0104359717)                                                          |
  | MLTDiep   | Mã loại thông điệp       | 3          | Số          | Bắt buộc | 100 (Tờ khai đăng ký/thay đổi TT sử dụng chứng từ điện tử)                          |
  | MTDiep    | Mã thông điệp            | 46         | Chuỗi ký tự | Bắt buộc | MNGui + 32 ký tự UUID in hoa (không có dấu -)                                        |
  | MTDTChieu | Mã thông điệp tham chiếu | 46         | Chuỗi ký tự | Tùy chọn | Null đối với tờ khai gửi đi, có giá trị khi nhận phản hồi từ CQT                    |
  | MST       | Mã số thuế               | 14         | Chuỗi ký tự | Bắt buộc | MST của người nộp thuế                                                               |
  | SLuong    | Số lượng tờ khai         | 14         | Số          | Bắt buộc | 1                                                                                    |

Scenario Outline: Thông tin tờ khai - TTChung (Thông tin chung)
  Given XML có phần <DLieu>/<TKhai>/<DLTKhai>/<TTChung>
  When hệ thống điền thông tin chung của tờ khai
  Then XML phải chứa trường "<ten_the>" với "<description>"
  And trường này có độ dài tối đa "<max_length>" ký tự
  And kiểu dữ liệu là "<data_type>"
  And tính bắt buộc là "<required>"
  
  Examples:
  | ten_the     | description                               | max_length | data_type          | required | info                                                                  |
  | PBan        | Phiên bản XML                             | 6          | Chuỗi ký tự        | Bắt buộc | 2.1.0                                                                 |
  | MSo         | Mẫu số tờ khai                            | 15         | Chuỗi ký tự        | Bắt buộc | 01/ĐKTĐ-CTĐT (Mẫu tờ khai đăng ký sử dụng chứng từ điện tử)           |
  | Ten         | Tên tờ khai                               | 200        | Chuỗi ký tự        | Bắt buộc | Tờ khai đăng ký/thay đổi thông tin sử dụng chứng từ điện tử           |
  | HThuc       | Hình thức tờ khai                         | 1          | Số                 | Bắt buộc | 1: Đăng ký mới; 2: Thay đổi thông tin                                 |
  | TNNT        | Tên người nộp thuế                        | 400        | Chuỗi ký tự        | Bắt buộc | Tên đơn vị (từ thông tin đơn vị)                                      |
  | MST         | Mã số thuế                                | 14         | Chuỗi ký tự        | Bắt buộc | MST của đơn vị                                                        |
  | CQTQLy      | Cơ quan thuế quản lý                      | 100        | Chuỗi ký tự        | Bắt buộc | Tên CQT quản lý (ví dụ: Cục Thuế TP Hà Nội)                            |
  | MCQTQLy     | Mã cơ quan thuế quản lý                   | 5          | Chuỗi ký tự        | Bắt buộc | Mã CQT (ví dụ: 01000)                                                 |
  | DCLHe       | Địa chỉ liên hệ                           | 400        | Chuỗi ký tự        | Bắt buộc | Địa chỉ liên hệ (người dùng nhập)                                     |
  | NLHe        | Người liên hệ                             | 100        | Chuỗi ký tự        | Bắt buộc | Tên người liên hệ (người dùng nhập)                                   |
  | DTLHe       | Điện thoại liên hệ                        | 20         | Chuỗi ký tự        | Bắt buộc | Số điện thoại liên hệ                                                 |
  | DCTDTu      | Địa chỉ thư điện tử (Email)               | 100        | Chuỗi ký tự        | Bắt buộc | Email liên hệ                                                         |
  | NLap        | Ngày lập                                  | -          | date               | Bắt buộc | Ngày gửi tờ khai (format: YYYY-MM-DD)                                 |

Scenario Outline: Nội dung tờ khai - Đối tượng phát hành (DTPHanh)
  Given XML có phần <DLieu>/<TKhai>/<DLTKhai>/<NDTKhai>/<DTPHanh>
  When hệ thống cấu hình đối tượng phát hành chứng từ
  Then XML phải chứa trường "<ten_the>" với "<description>"
  And kiểu dữ liệu là "<data_type>"
  And tính bắt buộc là "<required>"
  
  Examples:
  | ten_the     | description                           | data_type                        | required | info                                             |
  | TCNPHanh    | Tổ chức, cá nhân phát hành            | Số (0: không, 1: có)             | Bắt buộc | = 1 nếu checkbox "Tổ chức, cá nhân phát hành"    |
  | CQTPHanh    | Cơ quan thuế phát hành                | Số (0: không, 1: có)             | Bắt buộc | = 1 nếu checkbox "Cơ quan thuế phát hành"        |

Scenario Outline: Nội dung tờ khai - Loại hình sử dụng chứng từ (LHSDung)
  Given XML có phần <DLieu>/<TKhai>/<DLTKhai>/<NDTKhai>/<LHSDung>
  When hệ thống cấu hình các loại chứng từ điện tử sử dụng
  Then XML phải chứa trường "<ten_the>" với "<description>"
  And kiểu dữ liệu là "<data_type>"
  And tính bắt buộc là "<required>"
  
  Examples:
  | ten_the     | description                                                                              | data_type                | required | info                                                      |
  | CTKTrTNCN   | Chứng từ điện tử khấu trừ thuế thu nhập cá nhân                                          | Số (0: không, 1: có)     | Bắt buộc | = 1 nếu checked (mặc định = 1 khi tạo tờ khai mới)        |
  | CTKTrTMDT   | Chứng từ điện tử khấu trừ thuế đối với hoạt động kinh doanh trên nền tảng số            | Số (0: không, 1: có)     | Bắt buộc | = 1 nếu checked                                           |
  | BLaiDTu     | Biên lai điện tử                                                                         | Số (0: không, 1: có)     | Bắt buộc | = 1 nếu checked "Biên lai điện tử"                        |
  
Scenario Outline: Loại biên lai điện tử con (khi chọn BLaiDTu = 1)
  Given XML có phần <DLieu>/<TKhai>/<DLTKhai>/<NDTKhai>/<LHSDung>/<DSBLai>
  When người dùng chọn "Biên lai điện tử" và chọn loại biên lai cụ thể
  Then XML phải chứa trường "<ten_the>" với "<description>"
  And kiểu dữ liệu là "<data_type>"
  And tính bắt buộc là "<required>"
  
  Examples:
  | ten_the         | description                                               | data_type            | required          | info                                                  |
  | BLKMGia         | Biên lai thu thuế, phí, lệ phí không in sẵn mệnh giá      | Số (0: không, 1: có) | Bắt buộc (nếu có) | = 1 nếu checked loại biên lai này                     |
  | BLCMGia         | Biên lai thu thuế, phí, lệ phí in sẵn mệnh giá            | Số (0: không, 1: có) | Bắt buộc (nếu có) | = 1 nếu checked loại biên lai này                     |
  | BLTPLPhi        | Biên lai thu thuế, phí, lệ phí                            | Số (0: không, 1: có) | Bắt buộc (nếu có) | = 1 nếu checked loại biên lai này                     |

Scenario Outline: Hình thức gửi dữ liệu chứng từ điện tử (HTGDLieu)
  Given XML có phần <DLieu>/<TKhai>/<DLTKhai>/<NDTKhai>/<HTGDLieu>
  When hệ thống cấu hình hình thức gửi dữ liệu chứng từ
  Then XML phải chứa trường "<ten_the>" với "<description>"
  And kiểu dữ liệu là "<data_type>"
  And tính bắt buộc là "<required>"
  
  Examples:
  | ten_the     | description                                                                              | data_type            | required | info                                                      |
  | CongTTDTu   | Trên cổng thông tin điện tử của cơ quan thuế                                             | Số (0: không, 1: có) | Bắt buộc | = 1 nếu checked                                           |
  | TCTNUT      | Thông qua tổ chức cung cấp dịch vụ hóa đơn điện tử được Cục Thuế ủy thác                | Số (0: không, 1: có) | Bắt buộc | = 1 nếu checked (mặc định = 1)                            |

Scenario Outline: Danh sách chữ ký số (DSCKS)
  Given XML có phần <DLieu>/<TKhai>/<DLTKhai>/<NDTKhai>/<DSCKS>/<CKS>
  When hệ thống thêm thông tin chữ ký số vào tờ khai
  Then XML phải chứa trường "<ten_the>" với "<description>"
  And trường này có độ dài tối đa "<max_length>" ký tự
  And kiểu dữ liệu là "<data_type>"
  And tính bắt buộc là "<required>"
  
  Examples:
  | ten_the     | description                          | max_length | data_type   | required          | info                                                |
  | STT         | Số thứ tự                            | 5          | Số          | Bắt buộc          | Số thứ tự chữ ký số (1, 2, 3...)                    |
  | TTCGP       | Tên tổ chức chứng thực               | 200        | Chuỗi ký tự | Bắt buộc          | Tên tổ chức cấp chữ ký số (ví dụ: VNPT-CA)         |
  | SSCKS       | Số Serial chữ ký số                  | 50         | Chuỗi ký tự | Bắt buộc          | Serial number của chứng thư số                      |
  | TNgay       | Hiệu lực từ ngày                     | -          | date        | Bắt buộc          | Ngày bắt đầu hiệu lực (format: YYYY-MM-DD)          |
  | DNgay       | Hiệu lực đến ngày                    | -          | date        | Bắt buộc          | Ngày hết hiệu lực (format: YYYY-MM-DD)              |
  | HThuc       | Hình thức đăng ký                    | 1          | Số          | Bắt buộc          | 1: Thêm mới, 2: Gia hạn, 3: Ngừng sử dụng          |

Scenario: Validation - Ràng buộc dữ liệu bắt buộc
  Given người dùng đang điền form tờ khai
  When hệ thống validate dữ liệu trước khi tạo XML
  Then các trường sau PHẢI có giá trị:
    | Field                | Error Message                                     |
    | NLHe                 | Người liên hệ không được để trống                 |
    | DTLHe                | Điện thoại liên hệ không được để trống            |
    | DCLHe                | Địa chỉ liên hệ không được để trống               |
    | DCTDTu               | Email không được để trống                         |
    | DTPHanh              | Phải chọn ít nhất một đối tượng phát hành         |
    | LHSDung              | Phải chọn ít nhất một loại chứng từ điện tử       |
    | HTGDLieu             | Phải chọn ít nhất một hình thức gửi dữ liệu       |
    | DSCKS                | Phải có ít nhất một chữ ký số hợp lệ              |

Scenario: Validation - Format dữ liệu
  Given người dùng đã nhập dữ liệu vào form
  When hệ thống validate format
  Then các trường sau phải đúng định dạng:
    | Field    | Invalid Format          | Error Message                     |
    | DTLHe    | abc123, @#$             | Số điện thoại không hợp lệ        |
    | DCTDTu   | abc@, @abc.com, test    | Email không đúng định dạng        |
    | MST      | > 14 ký tự              | Mã số thuế không được vượt quá 14 ký tự |
    | NLHe     | > 100 ký tự             | Tên người liên hệ không được vượt quá 100 ký tự |
    | DTLHe    | > 20 ký tự              | Số điện thoại không được vượt quá 20 ký tự |
    | DCTDTu   | > 100 ký tự             | Email không được vượt quá 100 ký tự |

Scenario: Validation - Logic đăng ký mới vs thay đổi thông tin
  Given hệ thống đang tạo tờ khai mới
  When kiểm tra lịch sử tờ khai của NNT
  Then xác định HThuc (Hình thức tờ khai):
    | Condition                         | HThuc Value | Description               |
    | Chưa có tờ khai nào               | 1           | Đăng ký mới               |
    | Đã có ít nhất 1 tờ khai           | 2           | Thay đổi thông tin        |

Scenario: Tự động điền từ tờ khai gần nhất (HThuc = 2)
  Given HThuc = 2 (Thay đổi thông tin)
  And đã có tờ khai trước đó được CQT chấp nhận
  When hệ thống tạo tờ khai mới
  Then tự động điền các giá trị sau từ tờ khai gần nhất:
    | Field                | Source                                    |
    | DTPHanh (TCNPHanh)   | Đối tượng phát hành từ tờ khai cũ         |
    | DTPHanh (CQTPHanh)   | Đối tượng phát hành từ tờ khai cũ         |
    | LHSDung              | Các loại chứng từ từ tờ khai cũ           |
    | HTGDLieu             | Hình thức gửi dữ liệu từ tờ khai cũ       |
    | DSCKS                | Danh sách chữ ký số từ tờ khai cũ         |

Scenario: Giá trị mặc định cho tờ khai mới (HThuc = 1)
  Given HThuc = 1 (Đăng ký mới)
  And người dùng tạo tờ khai lần đầu
  When hệ thống khởi tạo form
  Then các giá trị mặc định sau được thiết lập:
    | Field           | Default Value | Description                                           |
    | TCNPHanh        | 1             | Tổ chức, cá nhân phát hành (checked)                  |
    | CTKTrTNCN       | 1             | Chứng từ khấu trừ thuế TNCN (checked)                 |
    | TCTNUT          | 1             | Qua TCTNUT (checked)                                  |

# ============================================================
# CẤU TRÚC XML ĐẦY ĐỦ - TỜ KHAI ĐĂNG KÝ SỬ DỤNG CHỨNG TỪ ĐIỆN TỬ
# ============================================================

#<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
#<TDiep>
#  <!-- PHẦN THÔNG TIN CHUNG THÔNG ĐIỆP -->
#  <TTChung>
#    <PBan>2.1.0</PBan>
#    <MNGui>0104359717</MNGui>
#    <MNNhan>T0104359717</MNNhan>
#    <MLTDiep>100</MLTDiep>
#    <MTDiep>0104359717A1B2C3D4E5F6789012345678901234</MTDiep>
#    <MTDTChieu/>
#    <MST>0104359717</MST>
#    <SLuong>1</SLuong>
#  </TTChung>
#  
#  <!-- PHẦN DỮ LIỆU TỜ KHAI -->
#  <DLieu Id="DeclarationData">
#    <TKhai>
#      <DLTKhai>
#        <!-- THÔNG TIN CHUNG TỜ KHAI -->
#        <TTChung>
#          <PBan>2.1.0</PBan>
#          <MSo>01/ĐKTĐ-CTĐT</MSo>
#          <Ten>Tờ khai đăng ký/thay đổi thông tin sử dụng chứng từ điện tử</Ten>
#          <HThuc>1</HThuc> <!-- 1: Đăng ký mới, 2: Thay đổi TT -->
#          <TNNT>CÔNG TY CỔ PHẦN CÔNG NGHỆ KIOTVIET</TNNT>
#          <MST>0104359717</MST>
#          <CQTQLy>Cục Thuế Thành phố Hà Nội</CQTQLy>
#          <MCQTQLy>01000</MCQTQLy>
#          <DCLHe>Tầng 6, Tòa nhà Việt Á, 9 Duy Tân, Dịch Vọng Hậu, Cầu Giấy, Hà Nội</DCLHe>
#          <NLHe>Nguyễn Văn A</NLHe>
#          <DTLHe>0987654321</DTLHe>
#          <DCTDTu>contact@kiotviet.vn</DCTDTu>
#          <NLap>2026-02-02</NLap>
#        </TTChung>
#        
#        <!-- NỘI DUNG TỜ KHAI -->
#        <NDTKhai>
#          <!-- ĐỐI TƯỢNG PHÁT HÀNH -->
#          <DTPHanh>
#            <TCNPHanh>1</TCNPHanh> <!-- Tổ chức, cá nhân phát hành -->
#            <CQTPHanh>0</CQTPHanh> <!-- Cơ quan thuế phát hành -->
#          </DTPHanh>
#          
#          <!-- LOẠI HÌNH SỬ DỤNG CHỨNG TỪ -->
#          <LHSDung>
#            <CTKTrTNCN>1</CTKTrTNCN> <!-- Chứng từ khấu trừ thuế TNCN -->
#            <CTKTrTMDT>0</CTKTrTMDT> <!-- Chứng từ khấu trừ thuế TMĐT -->
#            <BLaiDTu>0</BLaiDTu> <!-- Biên lai điện tử -->
#            <!-- Nếu BLaiDTu = 1 thì có thêm DSBLai -->
#            <!--
#            <DSBLai>
#              <BLKMGia>0</BLKMGia>
#              <BLCMGia>0</BLCMGia>
#              <BLTPLPhi>0</BLTPLPhi>
#            </DSBLai>
#            -->
#          </LHSDung>
#          
#          <!-- HÌNH THỨC GỬI DỮ LIỆU -->
#          <HTGDLieu>
#            <CongTTDTu>0</CongTTDTu> <!-- Trên cổng thông tin điện tử CQT -->
#            <TCTNUT>1</TCTNUT> <!-- Qua TCTNUT -->
#          </HTGDLieu>
#          
#          <!-- DANH SÁCH CHỮ KÝ SỐ -->
#          <DSCKS>
#            <CKS>
#              <STT>1</STT>
#              <TTCGP>VNPT-CA</TTCGP>
#              <SSCKS>4A0112440956D88FD8468689</SSCKS>
#              <TNgay>2024-12-01</TNgay>
#              <DNgay>2027-12-01</DNgay>
#              <HThuc>1</HThuc> <!-- 1: Thêm mới, 2: Gia hạn, 3: Ngừng SD -->
#            </CKS>
#            <!-- Có thể có nhiều CKS -->
#          </DSCKS>
#        </NDTKhai>
#      </DLTKhai>
#      
#      <!-- CHỮ KÝ SỐ NGƯỜI NỘP THUẾ -->
#      <DSCKS>
#        <NNT>
#          <Signature xmlns="http://www.w3.org/2000/09/xmldsig#">
#            <!-- Cấu trúc chữ ký số chuẩn XML Signature -->
#          </Signature>
#        </NNT>
#      </DSCKS>
#    </TKhai>
#  </DLieu>
#</TDiep>

# ============================================================
# LƯU Ý QUAN TRỌNG
# ============================================================
# 
# 1. KHÁC BIỆT SO VỚI TỜ KHAI HÓA ĐƠN ĐIỆN TỬ:
#    - Không có phần HTHDon (Hình thức hóa đơn)
#    - Không có phần LHDSDung (Loại hóa đơn sử dụng)
#    - Thay bằng LHSDung (Loại hình sử dụng chứng từ)
#    - Không có DSCTSSDung (Danh sách chứng từ số sử dụng)
#    - Mẫu số: 01/ĐKTĐ-CTĐT thay vì 01/ĐKTĐ-HĐĐT
#
# 2. TRƯỜNG BẮT BUỘC PHẢI CÓ:
#    - Ít nhất 1 loại chứng từ trong LHSDung = 1
#    - Ít nhất 1 hình thức gửi dữ liệu = 1
#    - Ít nhất 1 chữ ký số hợp lệ
#    - Ít nhất 1 đối tượng phát hành = 1
#
# 3. LOGIC ĐĂNG KÝ MỚI VS THAY ĐỔI:
#    - HThuc = 1: Lần đầu đăng ký (auto-fill giá trị mặc định)
#    - HThuc = 2: Thay đổi thông tin (auto-fill từ tờ khai gần nhất)
#
# 4. MÃ LOẠI THÔNG ĐIỆP:
#    - MLTDiep = 100: Tờ khai đăng ký/thay đổi TT
#    - Phản hồi 110: Tiếp nhận tờ khai
#    - Phản hồi 111: Chấp nhận/Từ chối tờ khai
#
# 5. VALIDATE CHỮ KÝ SỐ:
#    - MST trong chứng thư số phải khớp với MST đơn vị
#    - Chữ ký số phải còn hiệu lực (TNgay <= Hôm nay <= DNgay)
#    - Serial phải unique trong danh sách
#
# 6. PHIÊN BẢN:
#    - PBan = 2.1.0 (theo Quyết định 1306/QĐ-CT)
#    - Định dạng ngày: YYYY-MM-DD
#    - Encoding: UTF-8
#    - Character set: TCVN 6909:2001

Feature: Gửi file XML tờ khai đăng ký/thay đổi thông tin sử dụng chứng từ điện tử
  Là người dùng đang tạo tờ khai đăng ký sử dụng chứng từ điện tử khấu trừ thuế TNCN
  Tôi muốn gửi file XML tờ khai sang CQT
  Để hệ thống có thể gửi thông tin tờ khai đăng ký theo quy định Quyết định 1306/QĐ-CT

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
  | MNNhan    | Mã nơi nhận              | 14         | Chuỗi ký tự | Bắt buộc | Mã CQT (ví dụ: T01000)                                                               |
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
  | Ten         | Tên tờ khai                               | 100        | Chuỗi ký tự        | Bắt buộc | Tờ khai đăng ký/thay đổi thông tin sử dụng chứng từ điện tử           |
  | HThuc       | Hình thức tờ khai                         | 1          | Số                 | Bắt buộc | 1: Đăng ký mới; 2: Thay đổi thông tin                                 |
  | TNNT        | Tên người nộp thuế                        | 400        | Chuỗi ký tự        | Bắt buộc | Tên đơn vị (từ thông tin đơn vị)                                      |
  | MST         | Mã số thuế                                | 14         | Chuỗi ký tự        | Bắt buộc | MST của đơn vị                                                        |
  | CQTQLy      | Cơ quan thuế quản lý                      | 100        | Chuỗi ký tự        | Bắt buộc | Tên CQT quản lý (ví dụ: Cục Thuế TP Hà Nội)                            |
  | MCQTQLy     | Mã cơ quan thuế quản lý                   | 5          | Chuỗi ký tự        | Bắt buộc | Mã CQT (ví dụ: 01000)                                                 |
  | NLHe        | Người liên hệ                             | 50         | Chuỗi ký tự        | Bắt buộc | Tên người liên hệ (người dùng nhập)                                   |
  | DCLHe       | Địa chỉ liên hệ                           | 400        | Chuỗi ký tự        | Bắt buộc | Địa chỉ liên hệ (người dùng nhập)                                     |
  | DCTDTu      | Địa chỉ thư điện tử (Email)               | 50         | Chuỗi ký tự        | Bắt buộc | Email liên hệ                                                         |
  | DTLHe       | Điện thoại liên hệ                        | 20         | Chuỗi ký tự        | Bắt buộc | Số điện thoại liên hệ                                                 |
  | DDanh       | Địa danh                                  | 50         | Chuỗi ký tự        | Bắt buộc | Tên tỉnh/thành phố                                                    |
  | NLap        | Ngày lập                                  | -          | Ngày               | Bắt buộc | Ngày gửi tờ khai (format: YYYY-MM-DD)                                 |

Scenario Outline: Nội dung tờ khai - Đối tượng phát hành (DTPHanh)
  Given XML có phần <DLieu>/<TKhai>/<DLTKhai>/<NDTKhai>/<DTPHanh>
  When hệ thống cấu hình đối tượng phát hành chứng từ
  Then XML phải chứa trường "<ten_the>" với "<description>"
  And trường này có độ dài tối đa "<max_length>" ký tự
  And kiểu dữ liệu là "<data_type>"
  And tính bắt buộc là "<required>"
  
  Examples:
  | ten_the     | description                           | max_length | data_type                         | required | info                                             |
  | TCCNPHanh   | Tổ chức, cá nhân phát hành            | 1          | Số (0: không áp dụng, 1: áp dụng) | Bắt buộc | = 1 nếu checkbox "Tổ chức, cá nhân phát hành"    |
  | CQTPHanh    | Cơ quan thuế phát hành                | 1          | Số (0: không áp dụng, 1: áp dụng) | Bắt buộc | = 1 nếu checkbox "Cơ quan thuế phát hành"        |

Scenario Outline: Nội dung tờ khai - Loại hình sử dụng chứng từ (LHSDung)
  Given XML có phần <DLieu>/<TKhai>/<DLTKhai>/<NDTKhai>/<LHSDung>
  When hệ thống cấu hình các loại chứng từ điện tử sử dụng
  Then XML phải chứa trường "<ten_the>" với "<description>"
  And trường này có độ dài tối đa "<max_length>" ký tự
  And kiểu dữ liệu là "<data_type>"
  And tính bắt buộc là "<required>"
  
  Examples:
  | ten_the      | description                                                  | max_length | data_type                         | required | info                                                      |
  | CTTNCNhan    | Chứng từ điện tử khấu trừ thuế thu nhập cá nhân              | 1          | Số (0: không sử dụng, 1: sử dụng) | Bắt buộc | = 1 nếu checked (mặc định = 1 khi tạo tờ khai mới)        |
  | CTKTTTMDTu   | Chứng từ khấu trừ thuế thương mại điện tử                    | 1          | Số (0: không sử dụng, 1: sử dụng) | Bắt buộc | = 1 nếu checked                                           |
  | BLTPLPKIn    | Biên lai thu thuế, phí, lệ phí không in sẵn mệnh giá         | 1          | Số (0: không sử dụng, 1: sử dụng) | Bắt buộc | = 1 nếu checked loại biên lai này                         |
  | BLTPLPIn     | Biên lai thu thuế, phí, lệ phí in sẵn mệnh giá               | 1          | Số (0: không sử dụng, 1: sử dụng) | Bắt buộc | = 1 nếu checked loại biên lai này                         |
  | BLTTPLPhi    | Biên lai thu thuế, phí, lệ phí (CTT50)                       | 1          | Số (0: không sử dụng, 1: sử dụng) | Bắt buộc | = 1 nếu checked loại biên lai này                         |

Scenario Outline: Hình thức gửi dữ liệu chứng từ điện tử (HTGDLCTDT)
  Given XML có phần <DLieu>/<TKhai>/<DLTKhai>/<NDTKhai>/<HTGDLCTDT>
  When hệ thống cấu hình hình thức gửi dữ liệu chứng từ
  Then XML phải chứa trường "<ten_the>" với "<description>"
  And trường này có độ dài tối đa "<max_length>" ký tự
  And kiểu dữ liệu là "<data_type>"
  And tính bắt buộc là "<required>"
  
  Examples:
  | ten_the     | description                                                                              | max_length | data_type                         | required | info                                                      |
  | CDLQCCQT    | Trên Cổng thông tin điện tử của cơ quan thuế                                             | 1          | Số (0: không áp dụng, 1: áp dụng) | Bắt buộc | = 1 nếu checked                                           |
  | CDLQTCTN    | Chuyển dữ liệu qua TCTN (Thông qua tổ chức cung cấp dịch vụ hóa đơn điện tử)            | 1          | Số (0: không áp dụng, 1: áp dụng) | Bắt buộc | = 1 nếu checked                                           |
  | CDLQTCTNUT  | Chuyển dữ liệu qua TCTN được ủy thác (Qua TCTNUT)                                       | 1          | Số (0: không áp dụng, 1: áp dụng) | Bắt buộc | = 1 nếu checked (mặc định = 1)                            |

Scenario Outline: Danh sách chứng thư số sử dụng (DSCTSSDung)
  Given XML có phần <DLieu>/<TKhai>/<DLTKhai>/<NDTKhai>/<DSCTSSDung>/<CTS>
  When hệ thống thêm thông tin chứng thư số vào tờ khai
  Then XML phải chứa trường "<ten_the>" với "<description>"
  And trường này có độ dài tối đa "<max_length>" ký tự
  And kiểu dữ liệu là "<data_type>"
  And tính bắt buộc là "<required>"
  
  Examples:
  | ten_the     | description                          | max_length | data_type   | required          | info                                                |
  | STT         | Số thứ tự                            | 3          | Số          | Không bắt buộc    | Số thứ tự chứng thư số (1, 2, 3...)                  |
  | TTChuc      | Tên tổ chức chứng thực               | 400        | Chuỗi ký tự | Bắt buộc          | Tên tổ chức cấp chữ ký số (ví dụ: VNPT-CA)         |
  | Seri        | Số Sê-ri chứng thư số                | 40         | Chuỗi ký tự | Bắt buộc          | Serial number của chứng thư số                      |
  | TNgay       | Hiệu lực từ ngày                     | -          | Ngày giờ    | Bắt buộc          | Ngày bắt đầu hiệu lực (format: YYYY-MM-DDThh:mm:ss) |
  | DNgay       | Hiệu lực đến ngày                    | -          | Ngày giờ    | Bắt buộc          | Ngày hết hiệu lực (format: YYYY-MM-DDThh:mm:ss)     |
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
    | HTGDLCTDT            | Phải chọn ít nhất một hình thức gửi dữ liệu       |
    | DSCTSSDung           | Phải có ít nhất một chứng thư số hợp lệ           |

Scenario: Validation - Format dữ liệu
  Given người dùng đã nhập dữ liệu vào form
  When hệ thống validate format
  Then các trường sau phải đúng định dạng:
    | Field    | Max Length | Invalid Format          | Error Message                     |
    | DTLHe    | 20         | abc123, @#$             | Số điện thoại không hợp lệ        |
    | DCTDTu   | 50         | abc@, @abc.com, test    | Email không đúng định dạng        |
    | MST      | 14         | > 14 ký tự              | Mã số thuế không được vượt quá 14 ký tự |
    | NLHe     | 50         | > 50 ký tự              | Tên người liên hệ không được vượt quá 50 ký tự |
    | TNNT     | 400        | > 400 ký tự             | Tên NNT không được vượt quá 400 ký tự |
    | CQTQLy   | 100        | > 100 ký tự             | Tên CQT không được vượt quá 100 ký tự |
    | MCQTQLy  | 5          | > 5 ký tự               | Mã CQT không được vượt quá 5 ký tự |
    | DCLHe    | 400        | > 400 ký tự             | Địa chỉ không được vượt quá 400 ký tự |
    | DDanh    | 50         | > 50 ký tự              | Địa danh không được vượt quá 50 ký tự |

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
    | DTPHanh (TCCNPHanh)  | Đối tượng phát hành từ tờ khai cũ         |
    | DTPHanh (CQTPHanh)   | Đối tượng phát hành từ tờ khai cũ         |
    | LHSDung              | Các loại chứng từ từ tờ khai cũ           |
    | HTGDLCTDT            | Hình thức gửi dữ liệu từ tờ khai cũ       |
    | DSCTSSDung           | Danh sách chứng thư số từ tờ khai cũ      |

Scenario: Giá trị mặc định cho tờ khai mới (HThuc = 1)
  Given HThuc = 1 (Đăng ký mới)
  And người dùng tạo tờ khai lần đầu
  When hệ thống khởi tạo form
  Then các giá trị mặc định sau được thiết lập:
    | Field           | Default Value | Description                                           |
    | TCCNPHanh       | 1             | Tổ chức, cá nhân phát hành (checked)                  |
    | CTTNCNhan       | 1             | Chứng từ khấu trừ thuế TNCN (checked)                 |
    | CDLQTCTNUT      | 1             | Qua TCTNUT (checked)                                  |

# ============================================================
# CẤU TRÚC XML ĐẦY ĐỦ - TỜ KHAI ĐĂNG KÝ SỬ DỤNG CHỨNG TỪ ĐIỆN TỬ
# ============================================================

#<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
#<TDiep>
#  <!-- PHẦN THÔNG TIN CHUNG THÔNG ĐIỆP -->
#  <TTChung>
#    <PBan>2.1.0</PBan>
#    <MNGui>0104359717</MNGui>
#    <MNNhan>T01000</MNNhan>
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
#          <NLHe>Nguyễn Văn A</NLHe>
#          <DCLHe>Tầng 6, Tòa nhà Việt Á, 9 Duy Tân, Dịch Vọng Hậu, Cầu Giấy, Hà Nội</DCLHe>
#          <DCTDTu>contact@kiotviet.vn</DCTDTu>
#          <DTLHe>0987654321</DTLHe>
#          <DDanh>Hà Nội</DDanh>
#          <NLap>2026-02-02</NLap>
#        </TTChung>
#        
#        <!-- NỘI DUNG TỜ KHAI -->
#        <NDTKhai>
#          <!-- ĐỐI TƯỢNG PHÁT HÀNH -->
#          <DTPHanh>
#            <TCCNPHanh>1</TCCNPHanh> <!-- Tổ chức, cá nhân phát hành -->
#            <CQTPHanh>0</CQTPHanh> <!-- Cơ quan thuế phát hành -->
#          </DTPHanh>
#          
#          <!-- LOẠI HÌNH SỬ DỤNG CHỨNG TỪ -->
#          <LHSDung>
#            <CTTNCNhan>1</CTTNCNhan> <!-- Chứng từ khấu trừ thuế TNCN -->
#            <CTKTTTMDTu>0</CTKTTTMDTu> <!-- Chứng từ khấu trừ thuế TMĐT -->
#            <BLTPLPKIn>0</BLTPLPKIn> <!-- Biên lai không in sẵn mệnh giá -->
#            <BLTPLPIn>0</BLTPLPIn> <!-- Biên lai in sẵn mệnh giá -->
#            <BLTTPLPhi>0</BLTTPLPhi> <!-- Biên lai thu thuế phí lệ phí (CTT50) -->
#          </LHSDung>
#          
#          <!-- HÌNH THỨC GỬI DỮ LIỆU -->
#          <HTGDLCTDT>
#            <CDLQCCQT>0</CDLQCCQT> <!-- Trên cổng thông tin điện tử CQT -->
#            <CDLQTCTN>0</CDLQTCTN> <!-- Qua TCTN -->
#            <CDLQTCTNUT>1</CDLQTCTNUT> <!-- Qua TCTNUT (mặc định) -->
#          </HTGDLCTDT>
#          
#          <!-- DANH SÁCH CHỨNG THƯ SỐ SỬ DỤNG -->
#          <DSCTSSDung>
#            <CTS>
#              <STT>1</STT>
#              <TTChuc>VNPT-CA</TTChuc>
#              <Seri>4A0112440956D88FD8468689</Seri>
#              <TNgay>2024-12-01T00:00:00</TNgay>
#              <DNgay>2027-12-01T23:59:59</DNgay>
#              <HThuc>1</HThuc> <!-- 1: Thêm mới, 2: Gia hạn, 3: Ngừng SD -->
#            </CTS>
#            <!-- Có thể có nhiều CTS -->
#          </DSCTSSDung>
#          
#          <!-- DANH SÁCH ĐĂNG KÝ ỦY NHIỆM (Optional - Nếu có đăng ký ủy nhiệm lập biên lai) -->
#          <!-- <DSDKUNhiem>
#            <DKUNhiem>
#              <LDKUNhiem>1</LDKUNhiem> 1: Ủy nhiệm, 2: Nhận ủy nhiệm
#              <STT>1</STT>
#              <TLCTu>Biên lai thu tiền</TLCTu>
#              <KHMCTu>AA/25E</KHMCTu>
#              <KHCTu>001</KHCTu>
#              <MST>0123456789</MST>
#              <TTChuc>Công ty ABC</TTChuc>
#              <MDich>Thu tiền dịch vụ</MDich>
#              <TNgay>2026-01-01</TNgay>
#              <DNgay>2026-12-31</DNgay>
#              <PThuc>Chuyển khoản</PThuc>
#            </DKUNhiem>
#          </DSDKUNhiem> -->
#        </NDTKhai>
#      </DLTKhai>
#      
#      <!-- CHỮ KÝ SỐ NGƯỜI NỘP THUẾ -->
#      <DSCKS>
#        <NNT>
#          <Signature xmlns="http://www.w3.org/2000/09/xmldsig#">
#            <!-- Cấu trúc chữ ký số chuẩn XML Signature -->
#            <SignedInfo>
#              <CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315"/>
#              <SignatureMethod Algorithm="http://www.w3.org/2001/04/xmldsig-more#rsa-sha256"/>
#              <Reference URI="#DeclarationData">
#                <Transforms>
#                  <Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature"/>
#                </Transforms>
#                <DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256"/>
#                <DigestValue>...</DigestValue>
#              </Reference>
#            </SignedInfo>
#            <SignatureValue>...</SignatureValue>
#            <KeyInfo>
#              <X509Data>
#                <X509SubjectName>...</X509SubjectName>
#                <X509Certificate>...</X509Certificate>
#              </X509Data>
#            </KeyInfo>
#            <Object Id="TimeStamp-...">
#              <SignatureProperties>
#                <SignatureProperty Target="...">
#                  <SigningTime xmlns="https://hoadondientu.gdt.gov.vn">2026-02-02T10:30:00</SigningTime>
#                </SignatureProperty>
#              </SignatureProperties>
#            </Object>
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
#    - Thay bằng LHSDung (Loại hình sử dụng chứng từ) với 5 loại
#    - Không có DSCTSSDung (lưu ý: có DSCTSSDung cho chứng thư số, KHÔNG phải DSCKS)
#    - Mẫu số: 01/ĐKTĐ-CTĐT thay vì 01/ĐKTĐ-HĐĐT
#
# 2. TÊN THẺ CHÍNH XÁC (theo Excel):
#    - TCCNPHanh (KHÔNG phải TCNPHanh)
#    - CTTNCNhan (KHÔNG phải CTKTrTNCN)
#    - CTKTTTMDTu (KHÔNG phải CTKTrTMDT)
#    - BLTPLPKIn, BLTPLPIn, BLTTPLPhi (3 loại biên lai riêng biệt)
#    - CDLQCCQT, CDLQTCTN, CDLQTCTNUT (3 hình thức gửi)
#    - DSCTSSDung (Danh sách chứng thư số), không phải DSCKS
#
# 3. ĐỘ DÀI TỐI ĐA:
#    - Ten: 100 ký tự (không phải 200)
#    - DCTDTu: 50 ký tự (không phải 100)
#    - NLHe: 50 ký tự (không phải 100)
#    - STT (DSCTSSDung): 3 số (không phải 5)
#    - TTChuc: 400 ký tự
#    - Seri: 40 ký tự
#
# 4. KIỂU DỮ LIỆU:
#    - TNgay, DNgay trong DSCTSSDung: Ngày giờ (YYYY-MM-DDThh:mm:ss)
#    - NLap trong TTChung: Ngày (YYYY-MM-DD)
#
# 5. TRƯỜNG BẮT BUỘC PHẢI CÓ:
#    - Ít nhất 1 loại chứng từ trong LHSDung = 1
#    - Ít nhất 1 hình thức gửi dữ liệu = 1
#    - Ít nhất 1 chứng thư số hợp lệ trong DSCTSSDung
#    - Ít nhất 1 đối tượng phát hành = 1
#
# 6. LOGIC ĐĂNG KÝ MỚI VS THAY ĐỔI:
#    - HThuc = 1: Lần đầu đăng ký (auto-fill giá trị mặc định)
#    - HThuc = 2: Thay đổi thông tin (auto-fill từ tờ khai gần nhất)
#
# 7. MÃ LOẠI THÔNG ĐIỆP:
#    - MLTDiep = 100: Tờ khai đăng ký/thay đổi TT
#    - Phản hồi 110: Tiếp nhận tờ khai
#    - Phản hồi 111: Chấp nhận/Từ chối tờ khai
#
# 8. VALIDATE CHỨNG THƯ SỐ:
#    - MST trong chứng thư số phải khớp với MST đơn vị
#    - Chứng thư số phải còn hiệu lực (TNgay <= Hôm nay <= DNgay)
#    - Serial phải unique trong danh sách
#
# 9. PHIÊN BẢN:
#    - PBan = 2.1.0 (theo Quyết định 1306/QĐ-CT)
#    - Định dạng ngày: YYYY-MM-DD
#    - Định dạng ngày giờ: YYYY-MM-DDThh:mm:ss
#    - Encoding: UTF-8
#    - Character set: TCVN 6909:2001
#
# 10. PHẦN TÙY CHỌN:
#     - DSDKUNhiem: Chỉ bắt buộc nếu có đăng ký ủy nhiệm lập biên lai
#     - Bao gồm: LDKUNhiem, TLCTu, KHMCTu, KHCTu, MST, TTChuc, MDich, TNgay, DNgay, PThuc

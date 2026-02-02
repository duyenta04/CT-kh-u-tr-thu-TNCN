Feature: Gửi file XML chứng từ khấu trừ thuế TNCN sang CQT
  Là tổ chức chi trả thu nhập
  Tôi muốn gửi file XML sang cho CQT và hệ thống có thể gửi thông tin chứng từ theo quy định

  Background:
    Given tổ chức đã có chứng từ đã hoàn thiện hoặc đang tạo chứng từ với đầy đủ dữ liệu
    When tổ chức gửi chứng từ sang CQT
    Then hệ thống gửi file XML sang cho CQT gồm các "ten_the" theo quy định

  Scenario Outline: Cấu trúc XML với các trường thông tin chung bắt buộc
    Given file XML có cấu trúc <TDiep>/<TTChung>
    When hệ thống tạo XML với các trường thông tin
    Then XML phải chứa trường "<ten_the>" với "<description>"
    And trường này có độ dài tối đa "<max_length>" ký tự
    And kiểu dữ liệu là "<data_type>"
    And tính bắt buộc là "<required>"

    Examples:
      | ten_the   | description              | max_length | data_type   | required | info                                                                                 |
      | PBan      | Phiên bản của thông điệp | 6          | Chuỗi ký tự | Bắt buộc | Quy định mới nhất có giá trị là 2.1.0                                                |
      | MNGui     | Mã nơi gửi               | 14         | Chuỗi ký tự | Bắt buộc | MST của tổ chức chi trả thu nhập                                                     |
      | MNNhan    | Mã nơi nhận              | 14         | Chuỗi ký tự | Bắt buộc | Mã CQT nhận chứng từ                                                                 |
      | MLTDiep   | Mã loại thông điệp       | 3          | Số          | Bắt buộc | Mã loại thông điệp chứng từ TNCN                                                     |
      | MTDiep    | Mã thông điệp            | 46         | Chuỗi ký tự | Bắt buộc | MNGui + 32 ký tự in hoa được tạo ra theo thuật toán sinh UUID, không bao gồm dấu "-" |
      | MTDTChieu | Mã thông điệp tham chiếu | 46         | Chuỗi ký tự | Tùy chọn | Được sinh ra đối với các thông điệp phản hồi, null đối với xml gửi chứng từ         |
      | MST       | Mã số thuế               | 14         | Chuỗi ký tự | Bắt buộc | MST của tổ chức chi trả                                                              |
      | SLuong    | Số lượng                 | 14         | Số          | Bắt buộc | Số lượng chứng từ trong thông điệp (thường = 1)                                      |

  Scenario Outline: Cấu trúc XML thông tin chung chứng từ
    Given XML có phần <TDiep>/<DLieu>/<CTu>/<DLCTu>/<TTChung> chứa thông tin chứng từ
    When hệ thống điền thông tin chi tiết
    Then XML phải chứa trường "<ten_the>" với "<description>"
    And trường này có độ dài tối đa "<max_length>" ký tự
    And kiểu dữ liệu là "<data_type>"
    And tính bắt buộc là "<required>"

    Examples:
      | ten_the | description      | max_length | data_type   | required | info                                                |
      | PBan    | Phiên bản        | 6          | Chuỗi ký tự | Bắt buộc | Quy định mới nhất có giá trị là 2.1.0               |
      | TCTu    | Tên chứng từ     | 100        | Chuỗi ký tự | Bắt buộc | Chứng từ khấu trừ thuế thu nhập cá nhân             |
      | MSCTu   | Mẫu số chứng từ  | 7          | Chuỗi ký tự | Bắt buộc | 03/TNCN (cá nhân cư trú)                            |
      | KHCTu   | Ký hiệu chứng từ | 6          | Chuỗi ký tự | Bắt buộc | Ký hiệu chứng từ (vd: AA/25E)                       |
      | SCTu    | Số chứng từ      | 7          | Số          | Bắt buộc | Số thứ tự chứng từ                                  |
      | NLap    | Ngày lập         | -          | Ngày        | Bắt buộc | Ngày lập chứng từ (format: YYYY-MM-DD)              |

  Scenario Outline: Cấu trúc XML với chứng từ thay thế hoặc điều chỉnh
    Given chứng từ là chứng từ thay thế hoặc điều chỉnh
    Then hệ thống tạo file XML có chứa thẻ <TDiep>/<DLieu>/<CTu>/<DLCTu>/<TTChung>/<TTCTLQuan>
    And XML phải chứa trường "<ten_the>" với "<description>"
    And trường này có độ dài tối đa "<max_length>" ký tự
    And kiểu dữ liệu là "<data_type>"
    And tính bắt buộc là "<required>"

    Examples:
      | ten_the          | description                       | max_length | data_type   | required | info                                                                |
      | TCCTu            | Tính chất chứng từ                | 1          | Số          | Bắt buộc | 1: Thay thế, 2: Điều chỉnh                                          |
      | LHCTLQuan        | Loại chứng từ có liên quan        | 1          | Số          | Bắt buộc | Loại chứng từ bị thay thế/điều chỉnh (Chi tiết Phụ lục XIV)        |
      | KHMSCTCLQuan     | Ký hiệu mẫu số chứng từ liên quan | 11         | Chuỗi ký tự | Bắt buộc | Ký hiệu mẫu số chứng từ gốc (Chi tiết Phụ lục II)                  |
      | KHCTCLQuan       | Ký hiệu chứng từ liên quan        | 9          | Chuỗi ký tự | Bắt buộc | Ký hiệu chứng từ gốc                                                |
      | SCTCLQuan        | Số chứng từ liên quan             | 8          | Chuỗi ký tự | Bắt buộc | Số chứng từ gốc                                                     |
      | NLCTCLQuan       | Ngày lập chứng từ liên quan       | -          | Ngày        | Bắt buộc | Ngày lập chứng từ gốc                                               |
      | GChu             | Ghi chú                           | 255        | Chuỗi ký tự | Không bắt buộc | Ghi chú về nội dung thay thế/điều chỉnh                       |

  Scenario Outline: Cấu trúc XML thông tin tổ chức chi trả thu nhập
    Given XML có phần <TDiep>/<DLieu>/<CTu>/<DLCTu>/<NDCTu>/<TCTTNhap> chứa thông tin tổ chức chi trả
    When hệ thống tạo chứng từ điện tử
    Then XML phải chứa trường "<ten_the>" với "<description>"
    And trường này có độ dài tối đa "<max_length>" ký tự
    And kiểu dữ liệu là "<data_type>"

    Examples:
      | ten_the | description      | max_length | data_type   | required       | info                                          |
      | Ten     | Tên              | 400        | Chuỗi ký tự | Bắt buộc       | Tên tổ chức chi trả thu nhập                  |
      | MST     | Mã số thuế       | 14         | Chuỗi ký tự | Bắt buộc       | MST của tổ chức chi trả                       |
      | DChi    | Địa chỉ          | 400        | Chuỗi ký tự | Bắt buộc       | Địa chỉ tổ chức chi trả                       |
      | SDThoai | Số điện thoại    | 20         | Chuỗi ký tự | Không bắt buộc | Số điện thoại tổ chức chi trả                 |

  Scenario Outline: Cấu trúc XML thông tin cá nhân nhận thu nhập
    Given XML có phần <TDiep>/<DLieu>/<CTu>/<DLCTu>/<NDCTu>/<NNT> chứa thông tin cá nhân nhận thu nhập
    When hệ thống tạo chứng từ điện tử
    Then XML phải chứa trường "<ten_the>" với "<description>"
    And trường này có độ dài tối đa "<max_length>" ký tự
    And kiểu dữ liệu là "<data_type>"

    Examples:
      | ten_the | description         | max_length | data_type   | required                    | info                                     | tham_khao                          |
      | Ten     | Họ và tên           | 400        | Chuỗi ký tự | Bắt buộc                    | Họ tên cá nhân                           | Khoản 18, Điều 1 Nghị định 70      |
      | MST     | Mã số thuế          | 14         | Chuỗi ký tự | Bắt buộc (Nếu có)           | MST cá nhân (nếu có)                     | Khoản 18, Điều 1 Nghị định 70      |
      | DChi    | Địa chỉ             | 400        | Chuỗi ký tự | Bắt buộc                    | Địa chỉ cá nhân                          | Khoản 18, Điều 1 Nghị định 70      |
      | QTich   | Quốc tịch           | 400        | Chuỗi ký tự | Không bắt buộc              | Quốc tịch                                | -                                  |
      | CNCTru  | Cá nhân cư trú      | 1          | Số          | Bắt buộc                    | 0: Không cư trú, 1: Cư trú               | Khoản 18, Điều 1 Nghị định 70      |
      | CCCDan  | Căn cước công dân   | 20         | Chuỗi ký tự | Bắt buộc (khi không có MST) | CCCD/Hộ chiếu/Số định danh cá nhân       | Khoản 18, Điều 1 Nghị định 70      |
      | SDThoai | Số điện thoại       | 20         | Chuỗi ký tự | Bắt buộc                    | Số điện thoại cá nhân                    | Khoản 18, Điều 1 Nghị định 70      |
      | DCTDTu  | Địa chỉ thư điện tử | 50         | Chuỗi ký tự | Không bắt buộc              | Email cá nhân                            | -                                  |
      | GChu    | Ghi chú             | 255        | Chuỗi ký tự | Không bắt buộc              | Ghi chú                                  | -                                  |

  Scenario Outline: Cấu trúc XML thông tin thuế thu nhập cá nhân khấu trừ
    Given XML có phần <TDiep>/<DLieu>/<CTu>/<DLCTu>/<NDCTu>/<TTNCNKTru> chứa thông tin thuế khấu trừ
    When hệ thống tạo chứng từ điện tử
    Then XML phải chứa trường "<ten_the>" với "<description>"
    And trường này có độ dài tối đa "<max_length>" ký tự
    And kiểu dữ liệu là "<data_type>"

    Examples:
      | ten_the  | description                       | max_length | data_type   | required | info                                         | tham_khao                     |
      | KTNhap   | Khoản thu nhập                    | 250        | Chuỗi ký tự | Bắt buộc | Loại thu nhập (lương, thưởng,...)            | -                             |
      | TThang   | Từ tháng                          | 2          | Số          | Bắt buộc | Tháng bắt đầu trả thu nhập (1-12)            | -                             |
      | DThang   | Đến tháng                         | 2          | Số          | Bắt buộc | Tháng cuối cùng trả thu nhập (1-12)          | -                             |
      | Nam      | Năm                               | 4          | Số          | Bắt buộc | Năm trả thu nhập (4 chữ số)                  | -                             |
      | BHiem    | Bảo hiểm                          | 21,6       | Số          | Bắt buộc | Khoản đóng bảo hiểm bắt buộc                 | -                             |
      | TThien   | Từ thiện, nhân đạo, khuyến học    | 21,6       | Số          | Bắt buộc | Khoản từ thiện được trừ                      | Khoản 18, Điều 1 Nghị định 70 |
      | TTNCThue | Tổng thu nhập chịu thuế           | 21,6       | Số          | Bắt buộc | Tổng thu nhập chịu thuế phải khấu trừ        | -                             |
      | TTNTThue | Tổng thu nhập tính thuế           | 21,6       | Số          | Bắt buộc | Thu nhập sau khi trừ giảm trừ                | -                             |
      | SThue    | Số thuế                           | 21,6       | Số          | Bắt buộc | Số thuế thu nhập cá nhân đã khấu trừ         | -                             |

# ============================================================
# CẤU TRÚC XML ĐẦY ĐỦ - CHỨNG TỪ KHẤU TRỪ THUẾ TNCN
# ============================================================

# <?xml version="1.0" encoding="UTF-8"?>
# <TDiep>
#   <!-- PHẦN THÔNG TIN CHUNG THÔNG ĐIỆP -->
#   <TTChung>
#     <PBan>2.1.0</PBan>
#     <MNGui>0104359717</MNGui>
#     <MNNhan>T01000</MNNhan>
#     <MLTDiep>300</MLTDiep>
#     <MTDiep>0104359717A1B2C3D4E5F6789012345678901234</MTDiep>
#     <MTDTChieu/>
#     <MST>0104359717</MST>
#     <SLuong>1</SLuong>
#   </TTChung>
#
#   <!-- PHẦN DỮ LIỆU CHỨNG TỪ -->
#   <DLieu Id="CertificateData">
#     <CTu>
#       <!-- DỮ LIỆU CHỨNG TỪ -->
#       <DLCTu>
#         <!-- THÔNG TIN CHUNG -->
#         <TTChung>
#           <PBan>2.1.0</PBan>
#           <TCTu>Chứng từ khấu trừ thuế thu nhập cá nhân</TCTu>
#           <MSCTu>03/TNCN</MSCTu>
#           <KHCTu>AA/25E</KHCTu>
#           <SCTu>0000001</SCTu>
#           <NLap>2026-02-02</NLap>
#
#           <!-- THÔNG TIN CHỨNG TỪ LIÊN QUAN (Nếu là thay thế/điều chỉnh) -->
#           <!-- <TTCTLQuan>
#             <TCCTu>1</TCCTu>
#             <LHCTLQuan>1</LHCTLQuan>
#             <KHMSCTCLQuan>03/TNCN-AA/25E</KHMSCTCLQuan>
#             <KHCTCLQuan>AA/25E</KHCTCLQuan>
#             <SCTCLQuan>0000099</SCTCLQuan>
#             <NLCTCLQuan>2026-01-15</NLCTCLQuan>
#             <GChu>Thay thế do sai thông tin thuế</GChu>
#           </TTCTLQuan> -->
#
#           <!-- THÔNG TIN KHÁC -->
#           <TTKhac/>
#         </TTChung>
#
#         <!-- NỘI DUNG CHỨNG TỪ -->
#         <NDCTu>
#           <!-- TỔ CHỨC CHI TRẢ THU NHẬP -->
#           <TCTTNhap>
#             <Ten>CÔNG TY CỔ PHẦN CÔNG NGHỆ KIOTVIET</Ten>
#             <MST>0104359717</MST>
#             <DChi>Tầng 6, Tòa nhà Việt Á, 9 Duy Tân, Cầu Giấy, Hà Nội</DChi>
#             <SDThoai>0987654321</SDThoai>
#             <TTKhac/>
#           </TCTTNhap>
#
#           <!-- NGƯỜI NHẬN THU NHẬP -->
#           <NNT>
#             <Ten>Nguyễn Văn A</Ten>
#             <MST>8888888888</MST>
#             <DChi>123 Đường ABC, Quận 1, TP.HCM</DChi>
#             <QTich>Việt Nam</QTich>
#             <CNCTru>1</CNCTru>
#             <CCCDan>001234567890</CCCDan>
#             <SDThoai>0912345678</SDThoai>
#             <DCTDTu>nguyenvana@example.com</DCTDTu>
#             <GChu/>
#             <TTKhac/>
#           </NNT>
#
#           <!-- THÔNG TIN THUẾ KHẤU TRỪ -->
#           <TTNCNKTru>
#             <KTNhap>Tiền lương, tiền công</KTNhap>
#             <TThang>1</TThang>
#             <DThang>12</DThang>
#             <Nam>2026</Nam>
#             <BHiem>12000000</BHiem>
#             <TThien>5000000</TThien>
#             <TTNCThue>300000000</TTNCThue>
#             <TTNTThue>272000000</TTNTThue>
#             <SThue>28400000</SThue>
#           </TTNCNKTru>
#         </NDCTu>
#       </DLCTu>
#
#       <!-- CHỮ KÝ SỐ -->
#       <DSCKS>
#         <!-- CHỮ KÝ CỦA TỔ CHỨC CHI TRẢ -->
#         <TCTTNhap>
#           <Signature xmlns="http://www.w3.org/2000/09/xmldsig#" Id="payer-a1b2c3d4e5f6789012345678901234">
#             <SignedInfo>
#               <CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315"/>
#               <SignatureMethod Algorithm="http://www.w3.org/2001/04/xmldsig-more#rsa-sha256"/>
#               <Reference URI="#CertificateData">
#                 <Transforms>
#                   <Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature"/>
#                 </Transforms>
#                 <DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256"/>
#                 <DigestValue>...</DigestValue>
#               </Reference>
#               <Reference URI="#TimeStamp-99f639efc5de4a1aa6e10c543dcc0b9f">
#                 <DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256"/>
#                 <DigestValue>...</DigestValue>
#               </Reference>
#             </SignedInfo>
#             <SignatureValue>...</SignatureValue>
#             <KeyInfo>
#               <X509Data>
#                 <X509SubjectName>C=VN,ST=Hà Nội,CN=CÔNG TY CỔ PHẦN CÔNG NGHỆ KIOTVIET,UID=MST:0104359717</X509SubjectName>
#                 <X509Certificate>...</X509Certificate>
#               </X509Data>
#             </KeyInfo>
#             <Object Id="TimeStamp-99f639efc5de4a1aa6e10c543dcc0b9f">
#               <SignatureProperties>
#                 <SignatureProperty Target="#payer-a1b2c3d4e5f6789012345678901234">
#                   <SigningTime xmlns="https://hoadondientu.gdt.gov.vn">2026-02-02T10:30:00</SigningTime>
#                 </SignatureProperty>
#               </SignatureProperties>
#             </Object>
#           </Signature>
#         </TCTTNhap>
#
#         <!-- CÁC CHỮ KÝ KHÁC (Nếu có) -->
#         <!-- <CCKSKhac>
#           <Signature xmlns="http://www.w3.org/2000/09/xmldsig#">
#             ...
#           </Signature>
#         </CCKSKhac> -->
#       </DSCKS>
#     </CTu>
#   </DLieu>
#
#   <!-- CHỮ KÝ SỐ CỦA NGƯỜI NỘP THUẾ (Ký trên toàn bộ thông điệp) -->
#   <CKSNNT>
#     <Signature xmlns="http://www.w3.org/2000/09/xmldsig#" Id="taxpayer-ff53d5de71b54d1197f9966dc1be0277">
#       <SignedInfo>
#         <CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315"/>
#         <SignatureMethod Algorithm="http://www.w3.org/2001/04/xmldsig-more#rsa-sha256"/>
#         <Reference URI="#MessageData">
#           <Transforms>
#             <Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature"/>
#           </Transforms>
#           <DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256"/>
#           <DigestValue>...</DigestValue>
#         </Reference>
#         <Reference URI="#TimeStamp-b20a1c841765438babd667f656f866aa">
#           <DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256"/>
#           <DigestValue>...</DigestValue>
#         </Reference>
#       </SignedInfo>
#       <SignatureValue>...</SignatureValue>
#       <KeyInfo>
#         <X509Data>
#           <X509SubjectName>C=VN,ST=Hà Nội,CN=CÔNG TY CỔ PHẦN CÔNG NGHỆ KIOTVIET,UID=MST:0104359717</X509SubjectName>
#           <X509Certificate>...</X509Certificate>
#         </X509Data>
#       </KeyInfo>
#       <Object Id="TimeStamp-b20a1c841765438babd667f656f866aa">
#         <SignatureProperties>
#           <SignatureProperty Target="#taxpayer-ff53d5de71b54d1197f9966dc1be0277">
#             <SigningTime xmlns="https://hoadondientu.gdt.gov.vn">2026-02-02T10:31:00</SigningTime>
#           </SignatureProperty>
#         </SignatureProperties>
#       </Object>
#     </Signature>
#   </CKSNNT>
# </TDiep>

# language: vi
# Bổ Sung Scenarios: Mẫu Chứng Từ Cố Định & Sinh Số Khi Phát Hành

## Rule: Mẫu chứng từ cố định duy nhất

  @template @fixed
  Scenario: Hệ thống chỉ có một mẫu chứng từ
    When kế toán bắt đầu lập chứng từ mới
    Then mẫu chứng từ tự động là "03/TNCN-CT/26E"

  @template @fixed
  Scenario: Không cho phép thay đổi mẫu chứng từ
    Given kế toán đang lập chứng từ
    When kế toán thử thay đổi mẫu chứng từ
    Then mẫu chứng từ không thể thay đổi

## Rule: Ký hiệu chứng từ theo năm lập

  @certificate-symbol
  Scenario: Ký hiệu chứng từ thể hiện năm lập
    Given năm hiện tại là 2026
    When kế toán tạo chứng từ mới
    Then ký hiệu chứng từ là "CT/26E"

  @certificate-symbol
  Scenario Outline: Ký hiệu chứng từ thay đổi theo năm
    Given năm hiện tại là <year>
    When kế toán tạo chứng từ mới
    Then ký hiệu chứng từ là <symbol>

    Examples:
      | year | symbol |
      | 2025 | CT/25E |
      | 2026 | CT/26E |
      | 2027 | CT/27E |

  @certificate-symbol @structure
  Scenario: Cấu trúc ký hiệu chứng từ 6 ký tự
    Given ký hiệu chứng từ là "CT/26E"
    Then ký hiệu có 6 ký tự
    And hai ký tự đầu "CT/" nghĩa là chứng từ
    And hai ký tự giữa "26" nghĩa là năm 2026
    And ký tự cuối "E" nghĩa là hình thức điện tử

  @certificate-symbol @display
  Scenario: Hiển thị mẫu chứng từ đầy đủ
    Given năm hiện tại là 2026
    When kế toán xem thông tin chứng từ
    Then mẫu chứng từ hiển thị là "03/TNCN-CT/26E"

## Rule: Số chứng từ chỉ sinh khi phát hành

  @certificate-number @draft
  Scenario: Lưu nháp không sinh số chứng từ
    Given kế toán đang lập chứng từ
    When kế toán lưu nháp
    Then chứng từ được lưu với trạng thái nháp
    And số chứng từ chưa được sinh

  @certificate-number @draft
  Scenario: Chứng từ nháp không có số
    Given kế toán đang xem chứng từ nháp
    Then số chứng từ để trống
    And chưa có số chứng từ nào được gán

  @certificate-number @publish
  Scenario: Sinh số chứng từ khi phát hành
    Given kế toán đã hoàn tất chứng từ
    When kế toán phát hành chứng từ
    Then hệ thống tự động sinh số chứng từ
    And chứng từ được gửi đến cơ quan thuế

  @certificate-number @publish
  Scenario: Số chứng từ sinh theo thứ tự phát hành
    Given chứng từ cuối cùng đã phát hành có số "0000099"
    When kế toán phát hành chứng từ mới
    Then số chứng từ tự động là "0000100"

  @certificate-number @sequential
  Scenario: Số chứng từ tăng tuần tự theo thời gian phát hành
    Given có chứng từ nháp A được tạo ngày 01/02
    And có chứng từ nháp B được tạo ngày 02/02
    When kế toán phát hành chứng từ B trước
    Then chứng từ B được gán số "0000100"
    When kế toán phát hành chứng từ A sau
    Then chứng từ A được gán số "0000101"

## Rule: Đảm bảo số chứng từ tuần tự khi gửi CQT

  @certificate-number @validation
  Scenario: Không cho phép số chứng từ không tuần tự
    Given chứng từ số "0000100" đã được gửi CQT
    When kế toán cố phát hành chứng từ với số "0000099"
    Then hệ thống từ chối
    And hiển thị lỗi "Số chứng từ phải tăng tuần tự theo thời gian"

  @certificate-number @time-order
  Scenario: Số chứng từ phải tăng theo thời gian gửi CQT
    Given có 3 chứng từ nháp A, B, C
    When kế toán gửi CQT theo thứ tự B, A, C
    Then số chứng từ được gán theo thứ tự phát hành
    And B có số nhỏ hơn A
    And A có số nhỏ hơn C

## Rule: Lưu nháp và phát hành

  @draft-publish @workflow
  Scenario: Quy trình từ nháp đến phát hành
    Given kế toán đã lập chứng từ mới
    When kế toán lưu nháp
    Then chứng từ ở trạng thái "Nháp"
    And không có số chứng từ
    When kế toán hoàn tất và phát hành
    Then chứng từ chuyển sang trạng thái "Đã phát hành"
    And số chứng từ được sinh tự động
    And chứng từ được gửi đến cơ quan thuế

  @draft-publish
  Scenario: Có thể có nhiều chứng từ nháp
    Given kế toán đã lưu 5 chứng từ nháp
    Then tất cả đều không có số chứng từ
    And có thể phát hành theo bất kỳ thứ tự nào

  @draft-publish
  Scenario: Sửa chứng từ nháp không ảnh hưởng số
    Given có chứng từ nháp chưa có số
    When kế toán sửa thông tin chứng từ
    And kế toán lưu nháp lại
    Then chứng từ vẫn không có số
    And có thể tiếp tục sửa

  @draft-publish
  Scenario: Không thể sửa sau khi đã phát hành
    Given chứng từ đã được phát hành
    And đã có số chứng từ "0000100"
    When kế toán thử sửa thông tin
    Then hệ thống không cho phép sửa
    And số chứng từ không thay đổi

## Rule: Số chứng từ theo mẫu và năm

  @certificate-number @template-year
  Scenario: Số chứng từ riêng biệt cho từng năm
    Given năm 2025 có chứng từ đã phát hành đến số "0000500"
    When sang năm 2026
    And kế toán phát hành chứng từ mới năm 2026
    Then số chứng từ bắt đầu từ "0000001"

  @certificate-number @reset
  Scenario: Số chứng từ reset về 1 mỗi năm mới
    Given năm 2025 đã phát hành đến số "0000999"
    When năm chuyển sang 2026
    And kế toán phát hành chứng từ đầu tiên năm 2026
    Then số chứng từ là "0000001"

## Rule: Hiển thị số chứng từ

  @display @draft
  Scenario: Hiển thị trạng thái chưa có số với chứng từ nháp
    Given kế toán đang xem danh sách chứng từ
    And có chứng từ ở trạng thái nháp
    Then số chứng từ hiển thị trống hoặc "Chưa có"

  @display @published
  Scenario: Hiển thị số chứng từ với chứng từ đã phát hành
    Given kế toán đang xem danh sách chứng từ
    And có chứng từ đã phát hành với số "0000100"
    Then số chứng từ hiển thị "0000100"

## Rule: Phát hành đồng loạt

  @batch-publish
  Scenario: Phát hành nhiều chứng từ cùng lúc
    Given có 5 chứng từ nháp A, B, C, D, E
    And số chứng từ cuối cùng là "0000095"
    When kế toán chọn phát hành đồng loạt 5 chứng từ
    Then các chứng từ được gán số từ "0000096" đến "0000100"
    And số được gán theo thứ tự chọn phát hành

  @batch-publish
  Scenario: Phát hành đồng loạt theo thứ tự
    Given có 3 chứng từ nháp
    When kế toán chọn phát hành đồng loạt theo thứ tự C, A, B
    Then C được gán số nhỏ nhất
    And A được gán số tiếp theo
    And B được gán số cuối cùng

## Rule: Rollback khi phát hành lỗi

  @publish-error
  Scenario: Không sinh số nếu gửi CQT thất bại
    Given kế toán đang phát hành chứng từ
    When có lỗi khi gửi đến cơ quan thuế
    Then số chứng từ không được sinh
    And chứng từ quay về trạng thái nháp
    And có thể phát hành lại

  @publish-error
  Scenario: Giữ nguyên thứ tự số khi phát hành lại
    Given chứng từ A phát hành lỗi
    And chứng từ B phát hành thành công với số "0000100"
    When kế toán phát hành lại chứng từ A
    Then chứng từ A được gán số "0000101"
    And không được gán số nhỏ hơn "0000100"

---

# BDD Analysis: Certificate Number Generation

## ✅ Key Business Rules Applied

### 1. Số chứng từ CHỈ sinh khi phát hành
**NOT when:**
- ❌ Lưu nháp
- ❌ Sửa nháp
- ❌ Tạo mới

**ONLY when:**
- ✅ Phát hành/Gửi CQT

### 2. Số phải tăng tuần tự theo thời gian GỬI
**Business reason:**
- CQT yêu cầu số phải tịnh tiến tăng
- Thứ tự tạo KHÔNG quan trọng
- Thứ tự GỬI mới quan trọng

**Example:**
```
Tạo: A (01/02), B (02/02), C (03/02)
Gửi: B, C, A
Số:   100, 101, 102 ✅ (theo thứ tự gửi)
```

### 3. Nhiều nháp, phát hành linh hoạt
**Allowed:**
- ✅ Có nhiều chứng từ nháp
- ✅ Phát hành theo bất kỳ thứ tự
- ✅ Sửa nháp nhiều lần

**Not allowed:**
- ❌ Sửa sau khi phát hành
- ❌ Số không tuần tự
- ❌ Số trùng

## 📊 Scenario Coverage

### Lưu Nháp
- ✅ Không sinh số
- ✅ Có thể nhiều nháp
- ✅ Sửa được

### Phát Hành
- ✅ Sinh số tự động
- ✅ Theo thứ tự phát hành
- ✅ Gửi CQT

### Validation
- ✅ Số phải tăng tuần tự
- ✅ Theo thời gian gửi
- ✅ Không được lùi số

### Edge Cases
- ✅ Phát hành lỗi → không sinh số
- ✅ Phát hành lại → số tiếp tục tăng
- ✅ Phát hành đồng loạt → số theo thứ tự
- ✅ Sang năm mới → reset về 1

## 🎯 BDD Best Practices Applied

### 1. Declarative
```gherkin
# ✅ Good
When kế toán phát hành chứng từ
Then số chứng từ tự động được sinh

# ❌ Bad
When kế toán click nút "Phát hành"
And hệ thống gọi API sinh số
And database update số chứng từ
```

### 2. Business Language
```gherkin
# ✅ Good
Then số chứng từ phải tăng tuần tự theo thời gian

# ❌ Bad
Then số chứng từ trong DB phải > số trước đó
```

### 3. Clear Rules
- Rule 1: Sinh số khi phát hành
- Rule 2: Tuần tự theo thời gian gửi
- Rule 3: Nháp không có số
- Rule 4: Reset mỗi năm

## 💡 Key Scenarios

**Most Important:**
1. ✅ Nháp không có số
2. ✅ Phát hành mới sinh số
3. ✅ Số tăng theo thứ tự phát hành
4. ✅ Phát hành B trước A → B có số nhỏ hơn

**Edge Cases:**
5. ✅ Lỗi không sinh số
6. ✅ Phát hành đồng loạt
7. ✅ Reset năm mới

Total: **25 scenarios** covering complete workflow

---

**BDD Compliant:** ✅  
**Business Logic Clear:** ✅  
**No Technical Details:** ✅  
**Testable:** ✅

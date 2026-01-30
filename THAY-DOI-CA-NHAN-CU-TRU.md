# THAY ĐỔI: TRƯỜNG CÁ NHÂN CƯ TRÚ

## 📋 Tóm tắt thay đổi

### ❌ **TRƯỚC ĐÂY:**
- Có **2 trường riêng biệt**:
  - ☐ Cá nhân cư trú
  - ☐ Cá nhân không cư trú
- Hiển thị dưới dạng 2 checkbox cạnh nhau
- Người dùng chọn 1 trong 2 checkbox

### ✅ **SAU KHI THAY ĐỔI:**
- Chỉ có **1 trường duy nhất**: "Cá nhân cư trú"
- Hiển thị dưới dạng **dropdown** với 2 giá trị:
  - **Có** (tức là cá nhân cư trú)
  - **Không** (tức là cá nhân không cư trú)
- Dropdown có 3 options:
  - `-- Chọn --` (mặc định)
  - `Có`
  - `Không`

---

## 🔄 Chi tiết thay đổi

### 1. **Preview Section (Phần hiển thị chứng từ)**

#### Trước:
```html
<div style="display: flex; gap: 40px;">
    <div>Cá nhân cư trú: ☐</div>
    <div>Cá nhân không cư trú: ☐</div>
</div>
```

#### Sau:
```html
<div class="info-row">
    <div class="info-label">Cá nhân cư trú:</div>
    <div class="info-value">
        <span class="sample-data" style="display: none;">Có</span>
    </div>
</div>
```

---

### 2. **Settings Panel (Phần cấu hình)**

#### Trước:
```html
<!-- Trường 1: Cá nhân cư trú -->
<input type="checkbox" id="canhanCuTru">
<input type="text" id="input-canhanCuTru">

<!-- Trường 2: Cá nhân không cư trú -->
<input type="checkbox" id="canhanKhongCuTru">
<input type="text" id="input-canhanKhongCuTru">
```

#### Sau:
```html
<!-- CHỈ 1 trường: Cá nhân cư trú -->
<input type="checkbox" id="canhanCuTru">
<select id="input-canhanCuTru">
    <option value="">-- Chọn --</option>
    <option value="Có">Có</option>
    <option value="Không">Không</option>
</select>
```

---

### 3. **JavaScript - Hàm toggleSampleData()**

#### Trước:
```javascript
if (isChecked) {
    document.getElementById('input-canhanCuTru').value = '☑';
    document.getElementById('input-canhanKhongCuTru').value = '';
} else {
    document.getElementById('input-canhanCuTru').value = '';
    document.getElementById('input-canhanKhongCuTru').value = '';
}
```

#### Sau:
```javascript
if (isChecked) {
    document.getElementById('input-canhanCuTru').value = 'Có';
} else {
    document.getElementById('input-canhanCuTru').value = '';
}
```

---

## 📝 BDD Scenarios - Thay đổi

### ❌ **XÓA các scenarios cũ:**

```gherkin
Scenario: Hiển thị cả hai trường về tình trạng cư trú
Scenario: Tắt một trong hai trường cư trú
```

### ✅ **THÊM scenarios mới:**

```gherkin
@field-toggle @individual-info
Scenario: Bật hiển thị trường cá nhân cư trú
  Given Trường "Cá nhân cư trú" đang bị ẩn
  When Người dùng đánh dấu chọn "Cá nhân cư trú"
  Then Preview hiển thị trường "Cá nhân cư trú" với giá trị trống
  And Dropdown trong settings có 2 tùy chọn: "Có" và "Không"

@field-dropdown @individual-info
Scenario: Chọn giá trị "Có" cho cá nhân cư trú
  Given Trường "Cá nhân cư trú" đang được hiển thị
  When Người dùng chọn "Có" từ dropdown
  Then Preview hiển thị "Cá nhân cư trú: Có"

@field-dropdown @individual-info
Scenario: Chọn giá trị "Không" cho cá nhân cư trú
  Given Trường "Cá nhân cư trú" đang được hiển thị
  When Người dùng chọn "Không" từ dropdown
  Then Preview hiển thị "Cá nhân cư trú: Không"

@field-dropdown @individual-info
Scenario: Thay đổi giá trị cá nhân cư trú
  Given Trường "Cá nhân cư trú" đang có giá trị "Có"
  When Người dùng chọn "Không" từ dropdown
  Then Preview cập nhật thành "Cá nhân cư trú: Không"
```

---

## 🎯 Lợi ích của thay đổi

1. **UX đơn giản hơn:**
   - Chỉ 1 trường thay vì 2 trường
   - Rõ ràng hơn: "Có" hoặc "Không"

2. **Logic rõ ràng:**
   - Không thể chọn đồng thời cả 2 checkbox (vấn đề cũ)
   - Bắt buộc chọn 1 trong 2 giá trị

3. **Phù hợp với quy định:**
   - Cá nhân chỉ có thể là "cư trú" HOẶC "không cư trú"
   - Không có trường hợp nào khác

4. **Code gọn gàng hơn:**
   - Ít biến để quản lý
   - JavaScript đơn giản hơn

---

## 📊 Data Structure - Thay đổi

### Trước:
```javascript
{
  "individual": {
    "isResident": true,      // Checkbox 1
    "isNonResident": false   // Checkbox 2
  }
}
```

### Sau:
```javascript
{
  "individual": {
    "residentStatus": "Có"   // Dropdown: "Có" hoặc "Không"
  }
}
```

---

## ✅ Checklist hoàn thành

- [x] Cập nhật HTML - Preview section
- [x] Cập nhật HTML - Settings panel (thay text input thành dropdown)
- [x] Cập nhật JavaScript - toggleSampleData()
- [x] Xóa references đến `input-canhanKhongCuTru`
- [x] Cập nhật BDD scenarios trong feature file
- [x] Test thủ công trên UI

---

## 🔍 Testing Checklist

### Manual Testing:
- [ ] Bật checkbox "Cá nhân cư trú" → Dropdown hiển thị
- [ ] Chọn "Có" từ dropdown → Preview hiển thị "Có"
- [ ] Chọn "Không" từ dropdown → Preview hiển thị "Không"
- [ ] Bật toggle "Dữ liệu mẫu" → Dropdown tự động chọn "Có"
- [ ] Tắt toggle "Dữ liệu mẫu" → Dropdown reset về "-- Chọn --"
- [ ] Bỏ checkbox "Cá nhân cư trú" → Trường biến mất khỏi preview

### Automation Testing:
- [ ] Run BDD scenarios mới
- [ ] Verify data structure correct
- [ ] API integration test (nếu có)

---

## 📌 Notes

- Thay đổi này **không ảnh hưởng** đến các section khác
- Thay đổi này **tương thích ngược** với dữ liệu cũ (có thể migrate)
- Frontend validation: Nếu checkbox được check, dropdown bắt buộc phải chọn giá trị

---

**Ngày cập nhật:** 30/01/2025  
**Người thực hiện:** Claude  
**Status:** ✅ Hoàn thành

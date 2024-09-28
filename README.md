### 1. Bảng
```
CREATE TABLE cua_hang(
    ma_ch VARCHAR(10),
    ten_ch NVARCHAR2(20),
    dia_chi NVARCHAR2(30),
    dien_thoai VARCHAR(10),
    
    PRIMARY KEY (ma_ch)
);

CREATE TABLE nhan_vien(
    ma_nv VARCHAR(10),
    ten_nv NVARCHAR2(30),
    ngay_sinh DATE,
    dia_chi NVARCHAR2(30),
    ma_ch VARCHAR(10),
    
    PRIMARY KEY (ma_nv),
    CONSTRAINT nv_fk FOREIGN KEY (ma_ch) REFERENCES cua_hang(ma_ch)
);
```

```
ALTER TABLE nhan_vien
DROP CONSTRAINT nv_fk;
ALTER TABLE nhan_vien
ADD CONSTRAINT nv_fk FOREIGN KEY (ma_ch) REFERENCES cua_hang(ma_ch);

ALTER TABLE nhan_vien
DROP COLUMN ten_nv;
ALTER TABLE nhan_vien
ADD ten_nv NVARCHAR2(30);
```

```
DROP TABLE cua_hang;
DROP TABLE nhan_vien;
```

### 2. Bảng ghi:
```
DESC cua_hang;

INSERT INTO cua_hang
VALUES('1', 'Cua hang 1', 'Trung An', '0123456789');
```

```
UPDATE cua_hang
SET ten_ch = 'Cua hang test'
WHERE ma_ch = '1';
```

```
DELETE FROM cua_hang
WHERE ma_ch = '1';

TRUNCATE TABLE cua_hang;
```

### 3. Biểu thức chính quy:
```

```

### 4. Quản lý người dùng:
```

```
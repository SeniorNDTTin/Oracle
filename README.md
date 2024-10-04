## Thao tác cơ bản với Oracle:
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
Thao tác cơ bản với người dùng
```
CREATE USER tin_user IDENTIFIED BY tin_user
DEFAULT TABLESPACE USERS
TEMPORARY TABLESPACE TEMP
QUOTA 10M ON USERS;

DROP USER tin_user;

ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE; 
```

Quyền hệ thống
```
CREATE TABLE
CREATE ANY TABLE
ALTER ANY TABLE
DROP ANY TABLE
SELECT ANY TABLE
UPDATE ANY TABLE
DELETE ANY TABLE

CREATE SESSION
ALTER SESSION
RESTRICTED SESSION

CREATE TABLESPACE
ALTER TABLESPACE
DROP TABLESPACE
UNLIMITED TABLESPACE
```

```
GRANT 
    CREATE SESSION, 
    CREATE TABLE 
TO tin_user
WITH ADMIN OPTION;
```

Quyền đối tượng
```
ALTER
DELETE
EXECUTE
INSERT
SELECT
UPDATE
```

```
GRANT 
    SELECT,
    UPDATE 
ON cua_hang TO tin_user;
```

## PL/SQL:
### 1. Khối vô danh:
```
SET SERVEROUTPUT ON;
DECLARE
    v_ten_ch NVARCHAR2(20);
    v_dia_chi NVARCHAR2(30);
BEGIN
    DECLARE
        v_ma_ch VARCHAR2(10);
    BEGIN
        v_ma_ch := '2';
        
        SELECT ten_ch, dia_chi
        INTO v_ten_ch, v_dia_chi
        FROM cua_hang
        WHERE ma_ch = v_ma_ch;
        
        DBMS_OUTPUT.put_line(v_ten_ch || ' ' || v_dia_chi);
    END;
END;
```

### 2. Các loại mệnh đề:
Mệnh đề gán
```
DECLARE
    v_ma_ch VARCHAR2(10);
BEGIN
    v_ma_ch := '1';
END;
```

Mệnh đề lệnh
```
DECLARE
    v_ma_ch VARCHAR2(10);
    v_ten_ch NVARCHAR2(20);
BEGIN
    v_ma_ch := '1';
    
    SELECT ten_ch
    INTO v_ten_ch
    FROM cua_hang
    WHERE ma_ch = v_ma_ch;
    
    INSERT INTO test(ten_ch)
    VALUES(v_ten_ch);
END;
```

### 3. Cấu trúc điều khiển IF - ELSE:
```
SET SERVEROUTPUT ON;
DECLARE
    v_grade VARCHAR(1);
BEGIN
    v_grade := 'B';
    
    IF v_grade = 'A' THEN
        DBMS_OUTPUT.PUT_LINE('Excellent');
    ELSIF v_grade = 'B' THEN
        DBMS_OUTPUT.PUT_LINE('Very Good');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Poor');
    END IF;
END;
```

### 4. Mệnh đề LOOP:
```
SET SERVEROUTPUT ON;
DECLARE
    i NUMBER;
    tong NUMBER;
BEGIN
    tong := 0;

    i := 1;
    LOOP
        tong := tong + i;
        
        EXIT WHEN i = 5;
        i := i + 1;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE(tong);
END;
```

### 5. Kiểu Cursor:
```

```

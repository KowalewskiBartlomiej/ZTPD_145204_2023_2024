--ZADANIE 1

CREATE TABLE dokumenty (
    id NUMBER(12) PRIMARY KEY,
    dokument CLOB
);

--ZADANIE 2

DECLARE
    lob CLOB;
BEGIN
    FOR i IN 1..10000
    LOOP
        lob := CONCAT(lob, 'Oto tekst. ');
    END LOOP;
    INSERT INTO dokumenty VALUES (1, lob);
    COMMIT;
END;

--ZADANIE 3

--a)
SELECT * FROM dokumenty; 

--b)
SELECT UPPER(dokument) FROM dokumenty;

--c)
SELECT LENGTH(dokument) FROM dokumenty;

--d)
SELECT DBMS_LOB.GETLENGTH(dokument) FROM dokumenty;

--e)
SELECT SUBSTR(dokument, 5, 1000) FROM dokumenty;

--f)
SELECT DBMS_LOB.SUBSTR(dokument, 1000, 5) FROM dokumenty;

--ZADANIE 4

INSERT INTO dokumenty VALUES (2, EMPTY_CLOB());

--ZADANIE 5

INSERT INTO dokumenty VALUES (3, NULL);
COMMIT;

--ZADANIE 6

--a)
SELECT * FROM dokumenty; 

--b)
SELECT UPPER(dokument) FROM dokumenty;

--c)
SELECT LENGTH(dokument) FROM dokumenty;

--d)
SELECT DBMS_LOB.GETLENGTH(dokument) FROM dokumenty;

--e)
SELECT SUBSTR(dokument, 5, 1000) FROM dokumenty;

--f)
SELECT DBMS_LOB.SUBSTR(dokument, 1000, 5) FROM dokumenty;

--ZADANIE 7

DECLARE
    lobd CLOB;
    fils BFILE := BFILENAME('TPD_DIR', 'dokument.txt');
    doffset INTEGER := 1;
    soffset INTEGER := 1;
    langctx INTEGER := 0;
    warn INTEGER := null;
BEGIN
    SELECT dokument INTO lobd FROM dokumenty WHERE id=2 FOR UPDATE;
    DBMS_LOB.FILEOPEN(fils, DBMS_LOB.FILE_READONLY);
    DBMS_LOB.LOADCLOBFROMFILE(lobd, fils, DBMS_LOB.LOBMAXSIZE, doffset, soffset, 873, langctx, warn);
    --873 -> utf-8
    DBMS_LOB.FILECLOSE(fils);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Status operacji: ' || warn);
END;

--ZADANIE 8

UPDATE dokumenty SET dokument = TO_CLOB(BFILENAME('TPD_DIR', 'dokument.txt')) WHERE id = 3;

--ZADANIE 9

SELECT * FROM dokumenty;

--ZADANIE 10

SELECT DBMS_LOB.GETLENGTH(dokument) FROM dokumenty;

--ZADANIE 11

DROP TABLE dokumenty;

--ZADANIE 12

CREATE OR REPLACE PROCEDURE CLOB_CENSOR (input IN OUT CLOB, to_replace IN VARCHAR2) AS
    temp INTEGER := 0;
    buffer_temp VARCHAR2(100) := '';
BEGIN
    temp := DBMS_LOB.INSTR(input, to_replace);
    buffer_temp := '';
    FOR i IN 1..LENGTH(to_replace)
    LOOP
        buffer_temp := buffer_temp || '.';
    END LOOP;
    
    WHILE temp > 0
    LOOP
        DBMS_LOB.WRITE(input, length(buffer_temp), temp, buffer_temp);
        temp := DBMS_LOB.INSTR(input, to_replace);
    END LOOP;
END CLOB_CENSOR;

--ZADANIE 13

CREATE TABLE biographies_copy AS SELECT * FROM ztpd.biographies;

SELECT * FROM biographies_copy;

DESC biographies_copy;

DECLARE
    lobd CLOB;
BEGIN
    SELECT bio INTO lobd FROM biographies_copy WHERE id = 1 FOR UPDATE;
    CLOB_CENSOR(lobd, 'Cimrman');
END;

SELECT * FROM biographies_copy;

--ZADANIE 14

DROP TABLE biographies_copy;

--ZADANIE 1

CREATE TABLE movies AS SELECT * FROM ztpd.movies;

--ZADANIE 2

DESC movies;

SELECT * FROM movies;

--ZADANIE 3

SELECT id, title FROM movies WHERE cover IS NULL;

--ZADANIE 4

SELECT id, title, DBMS_LOB.GETLENGTH(cover) AS FILESIZE FROM movies WHERE cover IS NOT NULL;

--ZADANIE 5

SELECT id, title, DBMS_LOB.GETLENGTH(cover) AS FILESIZE FROM movies WHERE cover IS NULL;

--ZADANIE 6

SELECT * FROM ALL_DIRECTORIES;
--/u01/app/oracle/oradata/DBLAB03/directories/tpd_dir

--ZADANIE 7

UPDATE movies SET mime_type = 'image/jpeg', cover = EMPTY_BLOB() WHERE id = 66;
COMMIT;

--ZADANIE 8

SELECT id, title, DBMS_LOB.GETLENGTH(cover) AS FILESIZE FROM movies WHERE id IN (65,66);

--ZADANIE 9

DECLARE
    lobd BLOB;
    fils BFILE := BFILENAME('TPD_DIR', 'escape.jpg');
BEGIN
    SELECT cover INTO lobd FROM movies WHERE id = 66 FOR UPDATE;
    DBMS_LOB.FILEOPEN(fils, DBMS_LOB.FILE_READONLY);
    DBMS_LOB.LOADFROMFILE(lobd, fils, DBMS_LOB.GETLENGTH(fils));
    DBMS_LOB.FILECLOSE(fils);
    COMMIT;
END;

--ZADANIE 10

CREATE TABLE temp_covers (
    movie_id NUMBER(12),
    image BFILE,
    mime_type VARCHAR2(50)
);

--ZADANIE 11

INSERT INTO temp_covers VALUES (65, BFILENAME('TPD_DIR', 'eagles.jpg'), 'image/jpeg');
COMMIT;

--ZADANIE 12

SELECT movie_id, DBMS_LOB.GETLENGTH(image) AS FILESIZE FROM temp_covers;

--ZADANIE 13

DECLARE
    lobd BLOB;
    fils BFILE;
    mime VARCHAR2(200);
BEGIN
    SELECT image INTO fils FROM temp_covers WHERE movie_id = 65;
    SELECT mime_type INTO mime FROM temp_covers WHERE movie_id = 65;
    SELECT cover INTO lobd FROM movies WHERE id = 65 FOR UPDATE;
    DBMS_LOB.FILEOPEN(fils, DBMS_LOB.FILE_READONLY);
    DBMS_LOB.CREATETEMPORARY(lobd, TRUE);
    DBMS_LOB.LOADFROMFILE(lobd, fils, DBMS_LOB.GETLENGTH(fils));
    UPDATE movies SET cover = lobd, mime_type = mime WHERE id = 65;
    DBMS_LOB.FREETEMPORARY(lobd);
    DBMS_LOB.FILECLOSE(fils);
    COMMIT;
END;

--ZADANIE 14

SELECT id, DBMS_LOB.GETLENGTH(cover) AS FILESIZE FROM movies WHERE id IN (65, 66);

--ZADANIE 15

DROP TABLE movies;
DROP TABLE temp_covers;

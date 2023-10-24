--ZADANIE 1:

CREATE TYPE samochod AS OBJECT (
    marka VARCHAR2(20),
    model VARCHAR2(20),
    kilometry NUMBER,
    data_produkcji DATE,
    cena NUMBER(10,2)
);

CREATE TABLE samochody OF samochod;

DESC samochody;

INSERT INTO samochody VALUES (
    NEW samochod('Fiat', 'Brava', 60000, DATE '1999-11-30', 25000));

INSERT INTO samochody VALUES (
    NEW samochod('Ford', 'Mondeo', 80000, DATE '1997-05-10', 45000));

INSERT INTO samochody VALUES (
    NEW samochod('Mazda', '323', 12000, DATE '2000-09-22', 52000));

SELECT * FROM samochody;

--ZADANIE 2:

CREATE TABLE wlasciciele (
    imie VARCHAR2(20),
    nazwisko VARCHAR2(20),
    auto samochod
);

DESC wlasciciele;

INSERT INTO wlasciciele VALUES (
    'Jan', 'Kowalski', samochod('Fiat', 'Seicento', 30000, Date '2010-12-02', 19500)
); 

INSERT INTO wlasciciele VALUES (
    'Adam', 'Nowak', samochod('Opel', 'Astra', 34000, Date '2009-06-01', 33700)
); 

SELECT * FROM wlasciciele;

--ZADANIE 3:

ALTER TYPE samochod REPLACE AS OBJECT(
    marka VARCHAR2(20),
    model VARCHAR2(20),
    kilometry NUMBER,
    data_produkcji DATE,
    cena NUMBER(10,2),
    MEMBER FUNCTION wartosc RETURN NUMBER
);

CREATE OR REPLACE TYPE BODY samochod AS 
    MEMBER FUNCTION wartosc RETURN NUMBER IS
    BEGIN
        RETURN cena * POWER(0.9, EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM data_produkcji));
    END wartosc;
END;

SELECT s.marka, s.cena, s.wartosc() FROM SAMOCHODY s;

--ZADANIE 4:

ALTER TYPE samochod ADD MAP MEMBER FUNCTION odwzoruj
    RETURN NUMBER CASCADE INCLUDING TABLE DATA;

CREATE OR REPLACE TYPE BODY samochod AS 
    MEMBER FUNCTION wartosc RETURN NUMBER IS
    BEGIN
        RETURN cena * POWER(0.9, EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM data_produkcji));
    END wartosc;
    MAP MEMBER FUNCTION odwzoruj RETURN NUMBER IS 
    BEGIN
        RETURN (EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM data_produkcji)) + ROUND(kilometry / 10000, 3);
    END odwzoruj;
END;

SELECT * FROM SAMOCHODY s ORDER BY VALUE(s);

--ZADANIE 5:

CREATE TYPE wlasciciel AS OBJECT(
    imie VARCHAR2(100),
    nazwisko VARCHAR2(100)
);

ALTER TYPE samochod ADD ATTRIBUTE posiadacz REF wlasciciel CASCADE;

--ZADANIE 6:

SET SERVEROUTPUT ON;
DECLARE
    TYPE t_przedmioty IS VARRAY(10) OF VARCHAR2(20);
    moje_przedmioty t_przedmioty := t_przedmioty('');
BEGIN
    moje_przedmioty(1) := 'MATEMATYKA';
    moje_przedmioty.EXTEND(9);
    
    FOR i IN 2..10 LOOP
        moje_przedmioty(i) := 'PRZEDMIOT_' || i;
    END LOOP;
    
    FOR i IN moje_przedmioty.FIRST()..moje_przedmioty.LAST() LOOP
        DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i));
    END LOOP;
    
    moje_przedmioty.TRIM(2);
    
    FOR i IN moje_przedmioty.FIRST()..moje_przedmioty.LAST() LOOP
        DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i));
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
    
    moje_przedmioty.EXTEND();
    moje_przedmioty(9) := 9;
    
    DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
    
    moje_przedmioty.DELETE();
    
    DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
END;

--ZADANIE 7:

SET SERVEROUTPUT ON;
DECLARE
    TYPE t_ksiazki IS VARRAY(10) OF VARCHAR2(20);
    moje_ksiazki t_ksiazki := t_ksiazki('');
BEGIN
    moje_ksiazki(1) := 'TYTUL 1';
    moje_ksiazki.EXTEND(9);
    
    FOR i IN 2..10 LOOP
        moje_ksiazki(i) := 'TYTUL_' || i;
    END LOOP;
    
    FOR i IN moje_ksiazki.FIRST()..moje_ksiazki.LAST() LOOP
        DBMS_OUTPUT.PUT_LINE(moje_ksiazki(i));
    END LOOP;
    
    moje_ksiazki.TRIM(3);
    
    FOR i IN moje_ksiazki.FIRST()..moje_ksiazki.LAST() LOOP
        DBMS_OUTPUT.PUT_LINE(moje_ksiazki(i));
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_ksiazki.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_ksiazki.COUNT());
    
    moje_ksiazki.EXTEND();
    moje_ksiazki(8) := 8;
    
    DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_ksiazki.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_ksiazki.COUNT());
    
    moje_ksiazki.DELETE();
    
    DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_ksiazki.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_ksiazki.COUNT());
END;

--ZADANIE 8:

SET SERVEROUTPUT ON;
DECLARE
    TYPE t_wykladowcy IS TABLE OF VARCHAR2(20);
    moi_wykladowcy t_wykladowcy := t_wykladowcy();
BEGIN
    moi_wykladowcy.EXTEND(2);
    
    moi_wykladowcy(1) := 'MORZY';
    moi_wykladowcy(2) := 'WOJCIECHOWSKI';
    
    moi_wykladowcy.EXTEND(8);
    
    FOR i IN 3..10 LOOP
        moi_wykladowcy(i) := 'WYKLADOWCA_' || i;
    END LOOP;
    
    FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
        DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
    END LOOP;
    
    moi_wykladowcy.TRIM(2);
    
    FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
        DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
    END LOOP;
    
    moi_wykladowcy.DELETE(5,7);
    
    DBMS_OUTPUT.PUT_LINE('Limit: ' || moi_wykladowcy.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moi_wykladowcy.COUNT());
    
    FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
        IF moi_wykladowcy.EXISTS(i) THEN
            DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
        END IF;
    END LOOP;
    
    moi_wykladowcy(5) := 'ZAKRZEWICZ';
    moi_wykladowcy(6) := 'KROLIKOWSKI';
    moi_wykladowcy(7) := 'KOSZLAJDA';
    
    FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
        IF moi_wykladowcy.EXISTS(i) THEN
            DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
        END IF;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('Limit: ' || moi_wykladowcy.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moi_wykladowcy.COUNT());
END;

--ZADANIE 9:

SET SERVEROUTPUT ON;
DECLARE
    TYPE t_miesiace IS TABLE OF VARCHAR2(20);
    moje_miesiace t_miesiace := t_miesiace();
BEGIN
    moje_miesiace.EXTEND(12);
    
    moje_miesiace(1) := 'Styczen';
    moje_miesiace(2) := 'Luty';
    moje_miesiace(3) := 'Marzec';
    moje_miesiace(4) := 'Kwiecien';
    moje_miesiace(5) := 'Maj';
    moje_miesiace(6) := 'Czerwiec';
    moje_miesiace(7) := 'Lipiec';
    moje_miesiace(8) := 'Sierpien';
    moje_miesiace(9) := 'Wrzesien';
    moje_miesiace(10) := 'Pazdziernik';
    moje_miesiace(11) := 'Listopad';    
    moje_miesiace(11) := 'Grudzien';
    
    FOR i IN moje_miesiace.FIRST()..moje_miesiace.LAST() LOOP
        DBMS_OUTPUT.PUT_LINE(moje_miesiace(i));
    END LOOP;

    moje_miesiace.TRIM(2);
    
    FOR i IN moje_miesiace.FIRST()..moje_miesiace.LAST() LOOP
        DBMS_OUTPUT.PUT_LINE(moje_miesiace(i));
    END LOOP;
    
    moje_miesiace.DELETE(5,7);

    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_miesiace.COUNT());
    
    FOR i IN moje_miesiace.FIRST()..moje_miesiace.LAST() LOOP
        IF moje_miesiace.EXISTS(i) THEN
            DBMS_OUTPUT.PUT_LINE(moje_miesiace(i));
        END IF;
    END LOOP;
END;

--ZADANIE 10:

CREATE TYPE jezyki_obce AS VARRAY(10) OF VARCHAR2(20);
/

CREATE TYPE stypendium AS OBJECT (
nazwa VARCHAR2(50),
kraj VARCHAR2(30),
jezyki jezyki_obce );
/

CREATE TABLE stypendia OF stypendium;

INSERT INTO stypendia VALUES
('SOKRATES','FRANCJA',jezyki_obce('ANGIELSKI','FRANCUSKI','NIEMIECKI'));

INSERT INTO stypendia VALUES
('ERASMUS','NIEMCY',jezyki_obce('ANGIELSKI','NIEMIECKI','HISZPANSKI'));

SELECT * FROM stypendia;

SELECT s.jezyki FROM stypendia s;

UPDATE STYPENDIA
SET jezyki = jezyki_obce('ANGIELSKI','NIEMIECKI','HISZPANSKI','FRANCUSKI')
WHERE nazwa = 'ERASMUS';

CREATE TYPE lista_egzaminow AS TABLE OF VARCHAR2(20);
/

CREATE TYPE semestr AS OBJECT (
numer NUMBER,
egzaminy lista_egzaminow );
/

CREATE TABLE semestry OF semestr
NESTED TABLE egzaminy STORE AS tab_egzaminy;

INSERT INTO semestry VALUES
(semestr(1,lista_egzaminow('MATEMATYKA','LOGIKA','ALGEBRA')));

INSERT INTO semestry VALUES
(semestr(2,lista_egzaminow('BAZY DANYCH','SYSTEMY OPERACYJNE')));

SELECT s.numer, e.*
FROM semestry s, TABLE(s.egzaminy) e;

SELECT e.*
FROM semestry s, TABLE ( s.egzaminy ) e;

SELECT * FROM TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=1 );

INSERT INTO TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 )
VALUES ('METODY NUMERYCZNE');

UPDATE TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 ) e
SET e.column_value = 'SYSTEMY ROZPROSZONE'
WHERE e.column_value = 'SYSTEMY OPERACYJNE';

DELETE FROM TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 ) e
WHERE e.column_value = 'BAZY DANYCH';

--ZADANIE 11:


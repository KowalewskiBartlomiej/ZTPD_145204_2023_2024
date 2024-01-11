-- I część: Operator CONTAINS - Podstawy

--ZADANIE 1

CREATE TABLE cytaty AS SELECT * FROM ztpd.cytaty;

SELECT * FROM cytaty;

--ZADANIE 2

SELECT autor, tekst FROM cytaty WHERE UPPER(tekst) LIKE '%PESYMISTA%' AND UPPER(tekst) LIKE '%OPTYMISTA%';

--ZADANIE 3

CREATE INDEX TEKST_IDX ON cytaty(tekst) INDEXTYPE IS CTXSYS.CONTEXT;

--ZADANIE 4

SELECT autor, tekst FROM cytaty WHERE CONTAINS(tekst, 'PESYMISTA AND OPTYMISTA', 1) > 0;

--ZADANIE 5

SELECT autor, tekst FROM cytaty WHERE CONTAINS(tekst, 'PESYMISTA ~ OPTYMISTA', 1) > 0;

--ZADANIE 6

SELECT autor, tekst FROM cytaty WHERE CONTAINS(tekst, 'NEAR((PESYMISTA, OPTYMISTA), 3)') > 0;

--ZADANIE 7

SELECT autor, tekst FROM cytaty WHERE CONTAINS(tekst, 'NEAR((PESYMISTA, OPTYMISTA), 10)') > 0;

--ZADANIE 8

SELECT autor, tekst FROM cytaty WHERE CONTAINS(tekst, 'życi%', 1) > 0;

--ZADANIE 9

SELECT autor, tekst, SCORE(1) AS DOPASOWANIE FROM cytaty WHERE CONTAINS(tekst, 'życi%', 1) > 0;

--ZADANIE 10

SELECT autor, tekst, SCORE(1) AS DOPASOWANIE FROM cytaty WHERE CONTAINS(tekst, 'życi%', 1) > 0 AND ROWNUM <= 1 ORDER BY DOPASOWANIE DESC;

--ZADANIE 11

SELECT autor, tekst FROM cytaty WHERE CONTAINS(tekst, 'FUZZY(PROBELM)', 1) > 0;

--ZADANIE 12

INSERT INTO CYTATY VALUES(39, 'Bertrand Russell', 'To smutne, że głupcy są tacy pewni siebie, a ludzie rozsądni tacy pełni wątpliwości.');

COMMIT;

--ZADANIE 13

SELECT autor, tekst FROM cytaty WHERE CONTAINS(tekst, 'GŁUPCY', 1) > 0;

--Indeks nie ulega automatycznemu uaktualnieniu.

--ZADANIE 14

SELECT TOKEN_TEXT FROM DR$TEKST_IDX$I WHERE TOKEN_TEXT = 'GŁUPCY';

--ZADANIE 15

DROP INDEX TEKST_IDX;

CREATE INDEX TEKST_IDX ON cytaty(tekst) INDEXTYPE IS CTXSYS.CONTEXT;

--ZADANIE 16

SELECT autor, tekst FROM cytaty WHERE CONTAINS(tekst, 'GŁUPCY', 1) > 0;

--ZADANIE 17

DROP INDEX TEKST_IDX;

DROP TABLE cytaty;

-- II część: Zaawansowane indeksowanie i wyszukiwanie

--ZADANIE 1

CREATE TABLE quotes AS SELECT * FROM ztpd.quotes;

SELECT * FROM quotes;

--ZADANIE 2

CREATE INDEX QUOTES_TEXT_IDX ON QUOTES(TEXT) INDEXTYPE IS CTXSYS.CONTEXT;

--ZADANIE 3

SELECT author, text FROM quotes WHERE CONTAINS(text, 'WORK', 1) > 0;

SELECT author, text FROM quotes WHERE CONTAINS(text, '$WORK', 1) > 0;

SELECT author, text FROM quotes WHERE CONTAINS(text, 'WORKING', 1) > 0;

SELECT author, text FROM quotes WHERE CONTAINS(text, '$WORKING', 1) > 0;

--ZADANIE 4

SELECT author, text FROM quotes WHERE CONTAINS(text, 'it', 1) > 0;

--Słowo "it" jest domyślnie wyłączone.

--ZADANIE 5

SELECT * FROM CTX_STOPLISTS; --DEFAULT_STOPLIST

--ZADANIE 6

SELECT * FROM CTX_STOPWORDS;

--ZADANIE 7

DROP INDEX QUOTES_TEXT_IDX;

CREATE INDEX QUOTES_TEXT_IDX ON QUOTES(TEXT) INDEXTYPE IS CTXSYS.CONTEXT PARAMETERS ('stoplist CTXSYS.EMPTY_STOPLIST');

--ZADANIE 8

SELECT author, text FROM quotes WHERE CONTAINS(text, 'it', 1) > 0;

--Tak, tym razem system zwrócił wyniki.

--ZADANIE 9

SELECT author, text FROM quotes WHERE CONTAINS(text, 'fool AND humans', 1) > 0;

--ZADANIE 10

SELECT author, text FROM quotes WHERE CONTAINS(text, 'fool AND computer', 1) > 0;

--ZADANIE 11

SELECT author, text FROM quotes WHERE CONTAINS(text, '(fool AND humans) within sentence', 1) > 0;

--Wyświetla się błąd o braku istnienia sekcji sentence.

--ZADANIE 12

DROP INDEX QUOTES_TEXT_IDX;

--ZADANIE 13

BEGIN
    CTX_DDL.CREATE_SECTION_GROUP('newgroup', 'NULL_SECTION_GROUP');
    CTX_DDL.ADD_SPECIAL_SECTION('newgroup',  'SENTENCE');
    CTX_DDL.ADD_SPECIAL_SECTION('newgroup',  'PARAGRAPH');
END;

--ZADANIE 14

CREATE INDEX QUOTES_TEXT_IDX ON QUOTES(TEXT) INDEXTYPE IS CTXSYS.CONTEXT PARAMETERS ('stoplist CTXSYS.EMPTY_STOPLIST section group newgroup');

--ZADANIE 15

SELECT author, text FROM quotes WHERE CONTAINS(text, '(fool AND humans) within sentence', 1) > 0;

SELECT author, text FROM quotes WHERE CONTAINS(text, '(fool AND computer) within sentence', 1) > 0;

--ZADANIE 16

SELECT author, text FROM quotes WHERE CONTAINS(text, 'humans', 1) > 0;

--W wyniku zapytania znalazły się też rekordy z "non-humans" , gdyż zapis wyrazu z "-" domyślnie dzielony jest na dwa osobne tokeny.

--ZADANIE 17

DROP INDEX QUOTES_TEXT_IDX;

BEGIN
    CTX_DDL.CREATE_PREFERENCE('new_lekser','BASIC_LEXER');
    CTX_DDL.SET_ATTRIBUTE('new_lekser', 'printjoins', '-');
    CTX_DDL.SET_ATTRIBUTE('new_lekser', 'index_text', 'YES');
END;

CREATE INDEX QUOTES_TEXT_IDX ON QUOTES(TEXT) INDEXTYPE IS CTXSYS.CONTEXT PARAMETERS ('stoplist CTXSYS.EMPTY_STOPLIST section group newgroup LEXER new_lekser');

--ZADANIE 18

SELECT author, text FROM quotes WHERE CONTAINS(text, 'humans', 1) > 0;

--Nie, tym razem w wyniku zapytania nie znalazły się rekordy z "non-humans".

--ZADANIE 19

SELECT author, text FROM quotes WHERE CONTAINS(text, 'non\-humans', 1) > 0;

--ZADANIE 20

DROP TABLE quotes;

BEGIN
    CTX_DDL.DROP_SECTION_GROUP('newgroup');
    CTX_DDL.DROP_PREFERENCE('new_lekser');
END;

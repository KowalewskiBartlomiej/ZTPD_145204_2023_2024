--ZADANIE 1

--A

CREATE TABLE figury (
    id NUMBER(1) PRIMARY KEY,
    ksztalt MDSYS.SDO_GEOMETRY
);

--B

INSERT INTO figury VALUES(
    1,
    MDSYS.SDO_GEOMETRY(
        2003,
        NULL,
        NULL,
        MDSYS.SDO_ELEM_INFO_ARRAY(1, 1003, 4),
        MDSYS.SDO_ORDINATE_ARRAY(3,5 ,5,3 ,7,5)
    )
);

INSERT INTO figury VALUES(
    2,
    MDSYS.SDO_GEOMETRY(
        2003, 
        NULL, 
        NULL, 
        MDSYS.SDO_ELEM_INFO_ARRAY(1, 1003, 3),
        MDSYS.SDO_ORDINATE_ARRAY(1,1, 5,5)
    )
);	

INSERT INTO figury VALUES(
    3,
    MDSYS.SDO_GEOMETRY(
        2002,
        NULL,
        NULL,
        MDSYS.SDO_ELEM_INFO_ARRAY(1,4,2, 1,2,1 ,5,2,2),
        MDSYS.SDO_ORDINATE_ARRAY(3,2 ,6,2 ,7,3 ,8,2, 7,1)
    )
);

--C

INSERT INTO figury VALUES(
    4,
    MDSYS.SDO_GEOMETRY(
        2003,
        NULL,
        NULL,
        MDSYS.SDO_ELEM_INFO_ARRAY(1, 1003, 1),
        MDSYS.SDO_ORDINATE_ARRAY(1,1, 2,2, 3,3, 4,4)
    )
);

--D

SELECT id, MDSYS.SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(ksztalt, 0.01) AS VALID FROM FIGURY;

--E

DELETE FROM figury WHERE MDSYS.SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(ksztalt, 0.01) <> 'TRUE';

--F

COMMIT;

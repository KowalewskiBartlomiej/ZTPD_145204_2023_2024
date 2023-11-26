--ZADANIE 1

--A

CREATE TABLE A6_LRS (
    GEOM SDO_GEOMETRY
);

--B

INSERT INTO A6_LRS
    SELECT SAR.GEOM FROM STREETS_AND_RAILROADS SAR
        WHERE SAR.ID = ( SELECT SAR.ID FROM STREETS_AND_RAILROADS SAR, MAJOR_CITIES MC 
                         WHERE SDO_RELATE(SAR.GEOM, SDO_GEOM.SDO_BUFFER(MC.GEOM, 10, 1, 'unit=km'), 'mask=ANYINTERACT') = 'TRUE'
                           AND MC.CITY_NAME = 'Koszalin');

--C

SELECT SDO_GEOM.SDO_LENGTH(A.GEOM, 1, 'unit=km') AS DISTANCE, ST_LINESTRING(A.GEOM).ST_NUMPOINTS() AS ST_NUMPOINTS FROM A6_LRS A;

--D

UPDATE A6_LRS SET GEOM = SDO_LRS.CONVERT_TO_LRS_GEOM(GEOM, 0, 276.681315399186);

--E

INSERT INTO USER_SDO_GEOM_METADATA VALUES (
    'A6_LRS', 'GEOM', MDSYS.SDO_DIM_ARRAY(MDSYS.SDO_DIM_ELEMENT('X', 12.603676, 26.369824, 1),
    MDSYS.SDO_DIM_ELEMENT('Y', 45.8464, 58.0213, 1),
    MDSYS.SDO_DIM_ELEMENT('M', 0, 300, 1)),
    8307
);

--F

CREATE INDEX A6_LRS_IDX ON A6_LRS(GEOM) INDEXTYPE IS MDSYS.SPATIAL_INDEX;

--ZADANIE 2

--A

SELECT SDO_LRS.VALID_MEASURE(GEOM, 500) AS VALID_500 FROM A6_LRS;

--B

SELECT SDO_LRS.GEOM_SEGMENT_END_PT(GEOM).Get_WKT() AS END_PT FROM A6_LRS;

--C

SELECT SDO_LRS.LOCATE_PT(GEOM, 150, 0).Get_WKT() AS KM150 FROM A6_LRS;

--D

SELECT SDO_LRS.CLIP_GEOM_SEGMENT(GEOM, 120, 160).Get_WKT() AS CLIPPED FROM A6_LRS;

--E

SELECT SDO_LRS.GET_NEXT_SHAPE_PT(A.GEOM, MC.GEOM).Get_WKT() AS WJAZD_NA_A6 FROM A6_LRS A, MAJOR_CITIES MC
    WHERE MC.CITY_NAME = 'Slupsk';

--F

SELECT SDO_GEOM.SDO_LENGTH(SDO_LRS.OFFSET_GEOM_SEGMENT(A.GEOM, MD.DIMINFO, 50, 200, 50, 'unit=m'), 1, 'unit=km') AS KOSZT_W_MLN
    FROM A6_LRS A, USER_SDO_GEOM_METADATA MD
        WHERE MD.TABLE_NAME = 'A6_LRS'
          AND MD.COLUMN_NAME = 'GEOM';
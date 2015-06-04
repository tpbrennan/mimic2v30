/*
  genPrimaryKey.sql

  Created on   : Mar 2015 by Mornin Feng
  Last updated :
     $Author: Mornin Feng $
     $Date: 2014 March 1st  $
     $Rev: $

Generate primary keys for raw data tables




*/

--alter table additives
--drop column additivesDataID;
--commit;
--
--alter table censusevents
--drop column censuseventsDataID;
--commit;

--alter table chartevents
--drop column charteventsllDataID;
--commit;

SET SERVEROUTPUT ON

DECLARE
    schemaName VARCHAR2(30) := 'MIMIC2V30B';
    stmt VARCHAR2(32767); -- on 11g, use CLOB
    --stmt1 VARCHAR2(32767); -- on 11g, use CLOB
BEGIN
    FOR tr IN (
        SELECT t.OWNER, t.TABLE_NAME
        FROM ALL_TABLES t
        WHERE t.OWNER = schemaName and t.TABLE_NAME not in ('ADDITIVES_1', 'ADMISSIONS_1', 'CENSUSEVENTS_1')
        ORDER BY 1, 2
    )
    LOOP
            stmt := 'CREATE TABLE '|| tr.TABLE_NAME ||'_1 AS SELECT t.*, rownum as '|| tr.TABLE_NAME ||'DATAID from ' || tr.OWNER || '.' || tr.TABLE_NAME || ' t';
            DBMS_OUTPUT.PUT_LINE(stmt||';'); -- useful for debugging
            EXECUTE IMMEDIATE stmt;
            stmt := 'DROP TABLE '|| tr.TABLE_NAME;
            DBMS_OUTPUT.PUT_LINE(stmt||';'); -- useful for debugging
            EXECUTE IMMEDIATE stmt;
    END LOOP;
END;

ALTER TABLE table_name
  RENAME TO new_table_name;
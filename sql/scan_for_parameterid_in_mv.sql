SET SERVEROUTPUT ON SIZE 100000

DECLARE
  match_count INTEGER;
-- Type the owner of the tables you are looking at
  v_owner VARCHAR2(255) :='MV_ADULT_101212';

-- Type the data type you are look at (in CAPITAL)
-- VARCHAR2, NUMBER, etc.
  v_data_type VARCHAR2(255) :='NUMBER';
  
  v_column_name VARCHAR2(255) :='PARAMETERID';

-- Type the string you are looking at
  --v_search_string VARCHAR2(4000) :='8092'; -- 8092 ras scale

BEGIN
  FOR t IN (SELECT owner, table_name, column_name FROM all_tab_columns where owner=v_owner and data_type = v_data_type and column_name=v_column_name) LOOP

    EXECUTE IMMEDIATE
     'SELECT COUNT(*) FROM '||t.owner || '.' || t.table_name ||' WHERE '||t.column_name||' in (615)' -- rass related parameter ids
    INTO match_count;
    -- USING v_search_string;
    
    IF match_count > 0 THEN
      dbms_output.put_line( t.owner||'.'||t.table_name ||' '||t.column_name||' '||match_count );
    END IF;

  END LOOP;
END;
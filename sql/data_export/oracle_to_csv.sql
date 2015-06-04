CREATE OR REPLACE PROCEDURE oratable_to_csv( tbl_name IN VARCHAR2, f_path IN VARCHAR2, f_name IN VARCHAR2 )
	IS
		query_str			VARCHAR2(1000) DEFAULT 'SELECT * FROM ' || tbl_name;
		separator_char		VARCHAR2(1);
		quote_char			VARCHAR2(1);
		f_writer			UTL_FILE.FILE_TYPE;
		rec_cursor			INTEGER DEFAULT DBMS_SQL.OPEN_CURSOR;
		tbl_description		DBMS_SQL.DESC_TAB;
		column_value		VARCHAR2(4000);
		total_cols			INTEGER := 0;
		check_error			INTEGER;
	BEGIN
		EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT=''YYYY-MM-DD HH24:MI:SS'' ';
		EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_TIMESTAMP_FORMAT=''YYYY-MM-DD HH24:MI:SS.FF7'' ';
		EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_TIMESTAMP_TZ_FORMAT=''YYYY-MM-DD HH24:MI:SS.FF7'' ';
		  
		DBMS_SQL.PARSE( rec_cursor, query_str, dbms_sql.native );
		DBMS_SQL.DESCRIBE_COLUMNS( rec_cursor, total_cols, tbl_description );
		  
		f_writer := UTL_FILE.FOPEN( 'mydir', f_name, 'w' );
		check_error := DBMS_SQL.EXECUTE(rec_cursor);
		
		WHILE ( DBMS_SQL.FETCH_ROWS(rec_cursor) > 0 ) LOOP
		
			separator_char := '';
			quote_char := '';
			
			FOR i IN 1 .. total_cols LOOP
				DBMS_SQL.COLUMN_VALUE( rec_cursor, i, column_value );
				
				-- These are the column type codes for all kinds of text type fields
				IF tbl_description(i).col_type = 1 OR tbl_description(i).col_type = 9 OR tbl_description(i).col_type = 96 OR tbl_description(i).col_type = 112 OR tbl_description(i).col_type = 113 OR tbl_description(i).col_type = 286 OR tbl_description(i).col_type = 287 OR tbl_description(i).col_type = 288 THEN
					quote_char := '"';
					--column_value := REPLACE(column_value,'"','\"');
				ELSE
					quote_char := '';
				END IF;
				
				UTL_FILE.PUT( f_writer, separator_char || quote_char || column_value || quote_char);				
				separator_char := ',';
			END LOOP;
			
			UTL_FILE.NEW_LINE( f_writer );
			
		END LOOP;
		
		DBMS_SQL.CLOSE_CURSOR(rec_cursor);
		UTL_FILE.FCLOSE( f_writer );

		EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT=''DD-MON-RR'' ';
		EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_TIMESTAMP_FORMAT=''DD-MON-RR HH.MI.SSXFF AM'' ';
		EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_TIMESTAMP_TZ_FORMAT=''DD-MON-RR HH.MI.SSXFF AM TZR'' ';
		
		EXCEPTION WHEN OTHERS THEN
			EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT=''DD-MON-RR'' ';
			EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_TIMESTAMP_FORMAT=''DD-MON-RR HH.MI.SSXFF AM'' ';
			EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_TIMESTAMP_TZ_FORMAT=''DD-MON-RR HH.MI.SSXFF AM TZR'' ';
		RAISE;
	END;
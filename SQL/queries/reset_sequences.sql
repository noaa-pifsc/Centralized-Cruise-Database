DECLARE
				--variable to retrieve the generated SQL statement returned by the dynamic query:
				V_TEMP_SQL_DROP_STMT CLOB;

				--variable to retrieve the generated SQL statement returned by the dynamic query:
				V_TEMP_SQL_CREATE_STMT CLOB;

BEGIN
	FOR V_REC IN
	(SELECT 'SELECT ''DROP SEQUENCE '||all_objects.object_name||''' DROP_SEQ_STMT, ''CREATE SEQUENCE '||all_objects.object_name||' NOCACHE INCREMENT BY 1 START WITH ''||(dest_max_id + 1)||'''' CREATE_SEQ_STMT from (select nvl(max(dest.'||PK_COLUMN_NAME||'), 0) dest_max_id from '||all_tables.table_name||' dest)' SQL_stmt, all_objects.object_name

	FROM
	all_objects
	inner join

	all_tables
	on (all_objects.object_name = all_tables.table_name||'_SEQ' AND all_objects.owner = all_tables.owner )


	INNER JOIN (select COLUMN_NAME PK_COLUMN_NAME, all_constraints.owner, all_ind_columns.table_name FROM all_constraints inner join all_indexes ON
	all_constraints.INDEX_NAME = all_indexes.index_name AND
	all_constraints.owner = all_indexes.owner
	INNER JOIN
	all_ind_columns ON
	all_ind_columns.index_owner = all_indexes.owner
	AND all_ind_columns.INDEX_NAME = all_indexes.index_name
	WHERE CONSTRAINT_TYPE = 'P'
	) PK_FIELDS

	ON PK_FIELDS.owner = all_tables.owner
	AND PK_FIELDS.TABLE_NAME = all_tables.TABLE_NAME
	--WHERE all_tables.TABLE_NAME IN ('DVM_DATA_STREAMS', 'DVM_ERR_RES_TYPES', 'DVM_ERR_SEVERITY', 'DVM_ERROR_TYPES', 'DVM_ERRORS', 'DVM_PTA_ERR_TYP_ASSOC', 'DVM_PTA_ERROR_TYPES', 'DVM_PTA_ERRORS', 'DVM_QC_OBJECTS')
	where all_objects.object_type = 'SEQUENCE' and all_objects.owner = sys_context( 'userenv', 'current_schema' )
	order by all_objects.object_name
	)
	LOOP

	--				DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'The reset sequence query statement is: '||V_REC.SQL_STMT, V_SP_RET_CODE);

		--execute the generated SQL statement for generating the DDL to reset the sequence based on the data in the corresponding tables:
		EXECUTE IMMEDIATE V_REC.SQL_STMT INTO V_TEMP_SQL_DROP_STMT, V_TEMP_SQL_CREATE_STMT;

	--				DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'The drop sequence code is: '||V_TEMP_SQL_DROP_STMT, V_SP_RET_CODE);

		EXECUTE IMMEDIATE V_TEMP_SQL_DROP_STMT;

	--				DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'The create sequence code is: '||V_TEMP_SQL_CREATE_STMT, V_SP_RET_CODE);

		EXECUTE IMMEDIATE V_TEMP_SQL_CREATE_STMT;

		--add the current sequence name to the list of sequences that were reset:
--		V_SEQUENCES(V_SEQUENCES.COUNT + 1) := V_REC.OBJECT_NAME;


	END LOOP;



	--recompile all invalid triggers since the dependent sequences were dropped and re-defined:
	FOR cur IN (SELECT OBJECT_NAME, OBJECT_TYPE, owner FROM all_objects WHERE object_type in ('TRIGGER') and owner = sys_context( 'userenv', 'current_schema' ) AND status = 'INVALID' order by OBJECT_NAME) LOOP

	--				DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'The compile trigger code is: '||'alter ' || cur.OBJECT_TYPE || ' "' ||  cur.owner || '"."' || cur.OBJECT_NAME || '" compile', V_SP_RET_CODE);

		--recompile the current invalid trigger:
		EXECUTE IMMEDIATE 'alter ' || cur.OBJECT_TYPE || ' "' ||  cur.owner || '"."' || cur.OBJECT_NAME || '" compile';

		--add the current sequence name to the list of triggers that were recompiled:
--		V_TRIGGERS(V_TRIGGERS.COUNT + 1) := cur.OBJECT_NAME;

	end loop;

END;
/

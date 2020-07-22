--------------------------------------------------------
--------------------------------------------------------
--Database Name: Centralized Cruise Database
--Database Description: Centralized Cruise Database to track information about each PIFSC research cruise including activities, chief scientists, regions, etc. to remove the need for each division/program to manage this information
--------------------------------------------------------
--------------------------------------------------------

--Installing Version 0.9 (Git tag: DVM_db_v0.9) of the Data Validation Module Database (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/data-validation-module.git)
@@"./external_modules/DVM_DDL_DML_upgrade_v0.8.sql";
@@"./external_modules/DVM_DDL_DML_upgrade_v0.9.sql";


--recompile invalid trigger:
alter trigger CCD_CRUISES_AUTO_BRI compile;

--------------------------------------------------------
--Centralized Cruise Database - version 0.18 updates:
--------------------------------------------------------

	--CCD DVM Package Specification:
	CREATE OR REPLACE PACKAGE CCD_DVM_PKG
	AUTHID DEFINER
	--this package provides functions and procedures to interact with the CCD package module

	AS

		--procedure that executes the DVM for all CCD_CRUISES records
		PROCEDURE BATCH_EXEC_DVM_CRUISE_SP (P_SP_RET_CODE OUT PLS_INTEGER);

		--procedure that executes the DVM for a given CCD_CRUISES record (based on P_CRUISE_ID)
		PROCEDURE EXEC_DVM_CRUISE_SP (P_CRUISE_ID IN NUMBER, P_SP_RET_CODE OUT PLS_INTEGER);

		--procedure that executes the DVM for a given CCD_CRUISES record (based on P_CRUISE_NAME)
		PROCEDURE EXEC_DVM_CRUISE_SP (P_CRUISE_NAME IN VARCHAR2, P_SP_RET_CODE OUT PLS_INTEGER);

		--procedure that executes the DVM for a given CCD_CRUISES record (based on P_CRUISE_ID) by calling the EXEC_DVM_CRUISE_SP on the P_CRUISE_ID and then calling EXEC_DVM_CRUISE_SP on each of the records that is related to the P_CRUISE_ID via the CCD_QC_LEG_OVERLAP_V QC view so that the overlapping leg errors can be associated with the matching cruises from the CCD_QC_LEG_OVERLAP_V QC view.
		--P_SP_RET_CODE will contain 1 if the procedure was successful and 0 if the procedure was not successful
	  PROCEDURE EXEC_DVM_CRUISE_OVERLAP_SP (P_CRUISE_ID IN NUMBER, P_SP_RET_CODE OUT PLS_INTEGER);


		--procedure that executes the DVM for a given CCD_CRUISES record (based on P_CRUISE_NAME) by calling the EXEC_DVM_CRUISE_SP on the corresponding CRUISE_ID and then calling EXEC_DVM_CRUISE_SP on each of the records that is related to the CRUISE_ID via the CCD_QC_LEG_OVERLAP_V QC view so that the overlapping leg errors can be associated with the matching cruises from the CCD_QC_LEG_OVERLAP_V QC view.
		--P_SP_RET_CODE will contain 1 if the procedure was successful and 0 if the procedure was not successful
	  PROCEDURE EXEC_DVM_CRUISE_OVERLAP_SP (P_CRUISE_NAME IN VARCHAR2, P_SP_RET_CODE OUT PLS_INTEGER);

	END CCD_DVM_PKG;
	/


	--CCD DVM Package Body:
	create or replace PACKAGE BODY CCD_DVM_PKG
	--this package provides procedures to validate the cruise database
	AS

		--procedure that executes the DVM for all CCD_CRUISES records
		--P_SP_RET_CODE: return variable to indicate the result of the DVM batch execution attempt, it will contain 1 if the CCD cruises were successfully validated using the DVM package and 0 if they were not
		PROCEDURE BATCH_EXEC_DVM_CRUISE_SP (P_SP_RET_CODE OUT PLS_INTEGER) IS

			--variable to hold the return code value from procedures
			V_SP_RET_CODE PLS_INTEGER;

			V_SUCC_COUNTER PLS_INTEGER := 0;
			V_ERR_COUNTER PLS_INTEGER := 0;


		BEGIN

	    DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'CCD_DVM_PKG.BATCH_EXEC_DVM_CRUISE_SP', 'running the CCD_DVM_PKG.BATCH_EXEC_DVM_CRUISE_SP() procedure', V_SP_RET_CODE);

			--set the return code to 1 to indicate that the procedure was successful by default, if there are unsuccessfully processed cruise records or a PL/SQL error it will be set to 0 to indicate the error:
			P_SP_RET_CODE := 1;


			--query for CRUISE_ID values for all active data files:
			FOR rec IN (SELECT CRUISE_ID FROM CCD_CRUISES)

			--loop through each CRUISE_ID returned by the SELECT query to execute the CCD_DVM_PKG.EXEC_DVM_CRUISE_SP() procedure:
 			LOOP



				--run the validator procedure on the given data stream(s) and primary key value:
				CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(rec.CRUISE_ID, V_SP_RET_CODE);
				IF (V_SP_RET_CODE = 1) THEN
					DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'CCD_DVM_PKG.BATCH_EXEC_DVM_CRUISE_SP', 'The current cruise record ('||rec.CRUISE_ID||') was validated successfully', V_SP_RET_CODE);

					--increment the success counter:
					V_SUCC_COUNTER := V_SUCC_COUNTER + 1;
				ELSE
					DB_LOG_PKG.ADD_LOG_ENTRY('ERROR', 'CCD_DVM_PKG.BATCH_EXEC_DVM_CRUISE_SP', 'The current cruise record ('||rec.CRUISE_ID||') was not validated successfully', V_SP_RET_CODE);

					--increment the error counter:
					V_ERR_COUNTER := V_ERR_COUNTER + 1;

					--set the return code to 0 to indicate the processing error
					P_SP_RET_CODE := 0;
				END IF;

			END LOOP;


			--provide a summary of how many were successfully evaluated and were not successfully evaluated
	    DB_LOG_PKG.ADD_LOG_ENTRY('INFO', 'CCD_DVM_PKG.BATCH_EXEC_DVM_CRUISE_SP', 'Out of '||(V_SUCC_COUNTER + V_ERR_COUNTER)||' total cruise records there were '||V_SUCC_COUNTER||' that were successfully processed and '||V_ERR_COUNTER||' that were unsuccessful', V_SP_RET_CODE);

	    DBMS_output.put_line('Out of '||(V_SUCC_COUNTER + V_ERR_COUNTER)||' total cruise records there were '||V_SUCC_COUNTER||' that were successfully processed and '||V_ERR_COUNTER||' that were unsuccessful');


      EXCEPTION

        --catch all PL/SQL database exceptions:
        WHEN OTHERS THEN
		  		--catch all other errors:

					--log the processing error:
			    DB_LOG_PKG.ADD_LOG_ENTRY('ERROR', 'CCD_DVM_PKG.BATCH_EXEC_DVM_CRUISE_SP', 'The Oracle error code is ' || SQLCODE || '- ' || SQLERRM, V_SP_RET_CODE);

				  --define the return code that indicates that the CCD cast file was not successfully deactivated and the corresponding data was not purged from the database:
				  P_SP_RET_CODE := 0;


		END BATCH_EXEC_DVM_CRUISE_SP;

		--procedure that executes the DVM for a given CCD_CRUISES record
		PROCEDURE EXEC_DVM_CRUISE_SP (P_CRUISE_ID IN NUMBER, P_SP_RET_CODE OUT PLS_INTEGER) IS

			--procedure variable to store the return codes from each procedure call to determine the results of the procedure execution
			V_SP_RET_CODE PLS_INTEGER;

			--array of varchar2 strings to define the data stream code(s) to be evaluated for the given parent record
	    V_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;

			--variable to store the constructed log source string for the current procedure's log messages:
			V_TEMP_LOG_SOURCE DB_LOG_ENTRIES.LOG_SOURCE%TYPE;

		BEGIN

			--construct the DB_LOG_ENTRIES.LOG_SOURCE value for all logging messages in this procedure based on the procedure/function name and parameters:
			V_TEMP_LOG_SOURCE := 'CCD_DVM_PKG.EXEC_DVM_CRUISE_SP (P_CRUISE_ID: '||P_CRUISE_ID||')';

	    DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'running the CCD_DVM_PKG.EXEC_DVM_CRUISE_SP() procedure', V_SP_RET_CODE);

			--define the data stream codes for the given data stream (hard-coded due to RPL data stream):
			V_DATA_STREAM_CODE(1) := 'CCD';

      --run the validator procedure on the given data stream(s) and primary key value:
      DVM_PKG.VALIDATE_PARENT_RECORD_SP(V_DATA_STREAM_CODE, P_CRUISE_ID, V_SP_RET_CODE);

			--Check if the parent record was evaluated successfully
			IF (V_SP_RET_CODE = 1) THEN
				--The parent record was evaluated successfully
	    	DB_LOG_PKG.ADD_LOG_ENTRY('SUCCESS', V_TEMP_LOG_SOURCE, 'The DVM_PKG.VALIDATE_PARENT_RECORD() procedure was executed successfully', V_SP_RET_CODE);


				P_SP_RET_CODE := 1;
			ELSE
				--The parent record was not evaluated successfully

				DB_LOG_PKG.ADD_LOG_ENTRY('ERROR', V_TEMP_LOG_SOURCE, 'The DVM_PKG.VALIDATE_PARENT_RECORD() procedure was executed successfully', V_SP_RET_CODE);

				P_SP_RET_CODE := 0;

			END IF;

      EXCEPTION

        --catch all PL/SQL database exceptions:
        WHEN OTHERS THEN
				  --catch all other errors:

			    DB_LOG_PKG.ADD_LOG_ENTRY('ERROR', V_TEMP_LOG_SOURCE, 'The Oracle error code is ' || SQLCODE || '- ' || SQLERRM, V_SP_RET_CODE);

				  --define the return code that indicates that the CCD cast file was not successfully deactivated and the corresponding data was not purged from the database:
				  P_SP_RET_CODE := 0;


		END EXEC_DVM_CRUISE_SP;

		--procedure that executes the DVM for a given CCD_CRUISES record
		PROCEDURE EXEC_DVM_CRUISE_SP (P_CRUISE_NAME IN VARCHAR2, P_SP_RET_CODE OUT PLS_INTEGER) IS

			--procedure variable to store the return codes from each procedure call to determine the results of the procedure execution
			V_SP_RET_CODE PLS_INTEGER;

			--variable to store the CRUISE_ID for the specified P_CRUISE_NAME value
			V_CRUISE_ID PLS_INTEGER;

			--variable to store the constructed log source string for the current procedure's log messages:
			V_TEMP_LOG_SOURCE DB_LOG_ENTRIES.LOG_SOURCE%TYPE;

		BEGIN

			--construct the DB_LOG_ENTRIES.LOG_SOURCE value for all logging messages in this procedure based on the procedure/function name and parameters:
			V_TEMP_LOG_SOURCE := 'CCD_DVM_PKG.EXEC_DVM_CRUISE_SP (P_CRUISE_NAME: '||P_CRUISE_NAME||')';

	    DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'running the CCD_DVM_PKG.EXEC_DVM_CRUISE_SP() procedure', V_SP_RET_CODE);

			--query for the cruise_id for the corresponding P_CRUISE_NAME value
			SELECT CRUISE_ID INTO V_CRUISE_ID FROM CCD_CRUISES WHERE UPPER(CRUISE_NAME) = UPPER(P_CRUISE_NAME);

			--run the validator procedure on the given primary key value:
			CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(V_CRUISE_ID, V_SP_RET_CODE);

			--set the return code:
			P_SP_RET_CODE := V_SP_RET_CODE;


      EXCEPTION


				WHEN NO_DATA_FOUND THEN
				--catch not matching cruise record error:
			    DB_LOG_PKG.ADD_LOG_ENTRY('ERROR', V_TEMP_LOG_SOURCE, 'A cruise record with a cruise name "'||P_CRUISE_NAME||'" could not be found in the database', V_SP_RET_CODE);

				  --define the return code that indicates that the CCD cast file was not successfully deactivated and the corresponding data was not purged from the database:
				  P_SP_RET_CODE := 0;

        --catch all PL/SQL database exceptions:
        WHEN OTHERS THEN
				  --catch all other errors:

			    DB_LOG_PKG.ADD_LOG_ENTRY('ERROR', V_TEMP_LOG_SOURCE, 'The Oracle error code is ' || SQLCODE || '- ' || SQLERRM, V_SP_RET_CODE);

				  --define the return code that indicates that the CCD cast file was not successfully deactivated and the corresponding data was not purged from the database:
				  P_SP_RET_CODE := 0;


		END EXEC_DVM_CRUISE_SP;


		--procedure that executes the DVM for a given CCD_CRUISES record (based on P_CRUISE_ID) by calling the EXEC_DVM_CRUISE_SP on the P_CRUISE_ID and then calling EXEC_DVM_CRUISE_SP on each of the records that is related to the P_CRUISE_ID via the CCD_QC_LEG_OVERLAP_V QC view so that the overlapping leg errors can be associated with the matching cruises from the CCD_QC_LEG_OVERLAP_V QC view.
		--P_SP_RET_CODE will contain 1 if the procedure was successful and 0 if the procedure was not successful
		PROCEDURE EXEC_DVM_CRUISE_OVERLAP_SP (P_CRUISE_ID IN NUMBER, P_SP_RET_CODE OUT PLS_INTEGER) IS

			--variable to store the return code from procedure calls:
			V_SP_RET_CODE PLS_INTEGER;

			--this variable will track if the duplicate casts have had the DVM package executed successfully so the value of P_SP_RET_CODE can be set
			V_SUCC_EXEC BOOLEAN := true;

			--variable to store the constructed log source string for the current procedure's log messages:
			V_TEMP_LOG_SOURCE DB_LOG_ENTRIES.LOG_SOURCE%TYPE;

		BEGIN

			--construct the DB_LOG_ENTRIES.LOG_SOURCE value for all logging messages in this procedure based on the procedure/function name and parameters:
			V_TEMP_LOG_SOURCE := 'CCD_DVM_PKG.EXEC_DVM_CRUISE_OVERLAP_SP (P_CRUISE_ID: '||P_CRUISE_ID||')';

	    DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'running the CCD_DVM_PKG.EXEC_DVM_CRUISE_OVERLAP_SP() procedure', V_SP_RET_CODE);

			--set the rollback save point so that the entire procedure's effects can be rolled back if the procedure can't be successfully executed:
			SAVEPOINT DVM_CRUISE_REC;


	    DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'running the CCD_DVM_PKG.EXEC_DVM_CRUISE_SP('||P_CRUISE_ID||') procedure', V_SP_RET_CODE);

			--execute the DVM on the specified cruise record
			CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(P_CRUISE_ID, V_SP_RET_CODE);

			--check if the DVM execution was successful:
			IF (V_SP_RET_CODE = 1) THEN
				--the DVM execution was successful:

		    DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'The CCD_DVM_PKG.EXEC_DVM_CRUISE_SP('||P_CRUISE_ID||') was successful, query for the other data files related by the CCD_QC_DUP_CASTS_V view', V_SP_RET_CODE);

				--query for any leg/vessel overlap for the specified cruise (do not revalidate the same cruise if there is an overlap with another associated cruise leg since the initial execution will identify those validation issues)
				FOR rec IN (SELECT CRUISE_ID FROM CCD_QC_LEG_OVERLAP_V WHERE CRUISE_ID2 = P_CRUISE_ID AND CRUISE_ID <> P_CRUISE_ID)
				--loop through each CRUISE_ID returned by the SELECT query to execute the CCD_DVM_PKG.EXEC_DVM_CRUISE_SP() procedure:
				LOOP

					--execute the CCD_DVM_PKG.EXEC_DVM_CRUISE_SP() procedure on the current rec.CRUISE_ID value:
			    DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'execute the CCD_DVM_PKG.EXEC_DVM_CRUISE_SP('||rec.CRUISE_ID||') procedure on the overlapping cruise', V_SP_RET_CODE);

					CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(rec.CRUISE_ID, V_SP_RET_CODE);

					--check the return code for the DVM execution:
					IF (V_SP_RET_CODE = 1) THEN
						--the DVM was successful:

						--log the successful execution:
				    DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'The CCD_DVM_PKG.EXEC_DVM_CRUISE_SP('||rec.CRUISE_ID||') procedure was successful', V_SP_RET_CODE);

					ELSE
						--the DVM was not successful:

						--log the error
				    DB_LOG_PKG.ADD_LOG_ENTRY('ERROR', V_TEMP_LOG_SOURCE, 'The CCD_DVM_PKG.EXEC_DVM_CRUISE_SP('||rec.CRUISE_ID||') procedure was not successful', V_SP_RET_CODE);


						--the procedure was not completed successfully, stop the loop and rollback:
						V_SUCC_EXEC := false;

						--exit the loop
						EXIT;


					END IF;


				END LOOP;



				--check to see if there were any errors when the DVM was being executed on the duplicate files:
				IF (V_SUCC_EXEC) THEN
					--there were no processing errors reported

					--define the return code that indicates that the procedure successfully executed:
					P_SP_RET_CODE := 1;

					DB_LOG_PKG.ADD_LOG_ENTRY('SUCCESS', V_TEMP_LOG_SOURCE, 'EXEC_DVM_CRUISE_OVERLAP_SP('||P_CRUISE_ID||') was completed successfully', V_SP_RET_CODE);

				ELSE
					--there was a processing error reported, return 0 to indicate the procedure was not successful:

					--rollback all of the DML that was executed in the procedure since one of the DVM executions failed:
					ROLLBACK TO SAVEPOINT DVM_CRUISE_REC;

					--define the return code that indicates that the procedure was not successfully executed:
					P_SP_RET_CODE := 0;

					DB_LOG_PKG.ADD_LOG_ENTRY('ERROR', V_TEMP_LOG_SOURCE, 'EXEC_DVM_CRUISE_OVERLAP_SP('||P_CRUISE_ID||') was not completed successfully and the actions within the procedure were rolled back', V_SP_RET_CODE);


				END IF;

			ELSE

				--the DVM execution was not successful:

		    DB_LOG_PKG.ADD_LOG_ENTRY('ERROR', V_TEMP_LOG_SOURCE, 'The CCD_DVM_PKG.EXEC_DVM_CRUISE_SP('||P_CRUISE_ID||') was not successful, rollback the procedure''s DML', V_SP_RET_CODE);

				--rollback all of the DML that was executed in the procedure the DVM execution failed:
				ROLLBACK TO SAVEPOINT DVM_CRUISE_REC;

				--define the return code that indicates that the CCD cast file was not successfully processed:
				P_SP_RET_CODE := 0;

			END IF;



			EXCEPTION
        --catch all PL/SQL database exceptions:

        WHEN OTHERS THEN
				  --catch all other errors:

				  --define the return code that indicates that the CCD cast file was not successfully deactivated and the corresponding data was not purged from the database:
				  P_SP_RET_CODE := 0;


					--rollback all of the DML that was executed in the procedure since there was an error:
					ROLLBACK TO SAVEPOINT DVM_CRUISE_REC;

					--log the processing error:
					DB_LOG_PKG.ADD_LOG_ENTRY('ERROR', V_TEMP_LOG_SOURCE, 'EXEC_DVM_CRUISE_OVERLAP_SP() had the following error: '|| SQLCODE || '- ' || SQLERRM||', so the actions within the procedure were rolled back', V_SP_RET_CODE);


		END EXEC_DVM_CRUISE_OVERLAP_SP;



		--procedure that executes the DVM for a given CCD_CRUISES record
		PROCEDURE EXEC_DVM_CRUISE_OVERLAP_SP (P_CRUISE_NAME IN VARCHAR2, P_SP_RET_CODE OUT PLS_INTEGER) IS

			--procedure variable to store the return codes from each procedure call to determine the results of the procedure execution
			V_SP_RET_CODE PLS_INTEGER;

			--variable to store the CRUISE_ID for the specified P_CRUISE_NAME value
			V_CRUISE_ID PLS_INTEGER;

			--variable to store the constructed log source string for the current procedure's log messages:
			V_TEMP_LOG_SOURCE DB_LOG_ENTRIES.LOG_SOURCE%TYPE;

		BEGIN

			--construct the DB_LOG_ENTRIES.LOG_SOURCE value for all logging messages in this procedure based on the procedure/function name and parameters:
			V_TEMP_LOG_SOURCE := 'CCD_DVM_PKG.EXEC_DVM_CRUISE_OVERLAP_SP (P_CRUISE_NAME: '||P_CRUISE_NAME||')';

	    DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'running the CCD_DVM_PKG.EXEC_DVM_CRUISE_OVERLAP_SP() procedure', V_SP_RET_CODE);

			--query for the cruise_id for the corresponding P_CRUISE_NAME value
			SELECT CRUISE_ID INTO V_CRUISE_ID FROM CCD_CRUISES WHERE UPPER(CRUISE_NAME) = UPPER(P_CRUISE_NAME);

			--run the validator procedure on the given primary key value:
			CCD_DVM_PKG.EXEC_DVM_CRUISE_OVERLAP_SP(V_CRUISE_ID, V_SP_RET_CODE);

			--set the return code:
			P_SP_RET_CODE := V_SP_RET_CODE;


      EXCEPTION


				WHEN NO_DATA_FOUND THEN
				--catch not matching cruise record error:
			    DB_LOG_PKG.ADD_LOG_ENTRY('ERROR', V_TEMP_LOG_SOURCE, 'A cruise record with a cruise name "'||P_CRUISE_NAME||'" could not be found in the database', V_SP_RET_CODE);

				  --define the return code that indicates that the CCD cast file was not successfully deactivated and the corresponding data was not purged from the database:
				  P_SP_RET_CODE := 0;

        --catch all PL/SQL database exceptions:
        WHEN OTHERS THEN
				  --catch all other errors:

			    DB_LOG_PKG.ADD_LOG_ENTRY('ERROR', V_TEMP_LOG_SOURCE, 'The Oracle error code is ' || SQLCODE || '- ' || SQLERRM, V_SP_RET_CODE);

				  --define the return code that indicates that the CCD cast file was not successfully deactivated and the corresponding data was not purged from the database:
				  P_SP_RET_CODE := 0;


		END EXEC_DVM_CRUISE_OVERLAP_SP;




	end CCD_DVM_PKG;
	/



CREATE OR REPLACE VIEW
CCD_CRUISE_SUMM_ISS_V
AS SELECT
CCD_CRUISE_SUMM_V.CRUISE_ID,
CCD_CRUISE_SUMM_V.CRUISE_NAME,
CCD_CRUISE_SUMM_V.CRUISE_NOTES,
CCD_CRUISE_SUMM_V.CRUISE_DESC,
CCD_CRUISE_SUMM_V.OBJ_BASED_METRICS,
CCD_CRUISE_SUMM_V.SCI_CENTER_DIV_ID,
CCD_CRUISE_SUMM_V.SCI_CENTER_DIV_CODE,
CCD_CRUISE_SUMM_V.SCI_CENTER_DIV_NAME,
CCD_CRUISE_SUMM_V.SCI_CENTER_DIV_DESC,
CCD_CRUISE_SUMM_V.SCI_CENTER_ID,
CCD_CRUISE_SUMM_V.SCI_CENTER_NAME,
CCD_CRUISE_SUMM_V.SCI_CENTER_DESC,
CCD_CRUISE_SUMM_V.STD_SVY_NAME_ID,
CCD_CRUISE_SUMM_V.STD_SVY_NAME,
CCD_CRUISE_SUMM_V.STD_SVY_DESC,
CCD_CRUISE_SUMM_V.SVY_FREQ_ID,
CCD_CRUISE_SUMM_V.SVY_FREQ_NAME,
CCD_CRUISE_SUMM_V.SVY_FREQ_DESC,
CCD_CRUISE_SUMM_V.STD_SVY_NAME_OTH,
CCD_CRUISE_SUMM_V.STD_SVY_NAME_VAL,
CCD_CRUISE_SUMM_V.SVY_TYPE_ID,
CCD_CRUISE_SUMM_V.SVY_TYPE_NAME,
CCD_CRUISE_SUMM_V.SVY_TYPE_DESC,
CCD_CRUISE_SUMM_V.CRUISE_URL,
CCD_CRUISE_SUMM_V.CRUISE_CONT_EMAIL,
CCD_CRUISE_SUMM_V.NUM_SPP_ESA,
CCD_CRUISE_SUMM_V.SPP_ESA_NAME_CD_LIST,
CCD_CRUISE_SUMM_V.SPP_ESA_NAME_SCD_LIST,
CCD_CRUISE_SUMM_V.SPP_ESA_NAME_RC_LIST,
CCD_CRUISE_SUMM_V.SPP_ESA_NAME_BR_LIST,
CCD_CRUISE_SUMM_V.NUM_SPP_FSSI,
CCD_CRUISE_SUMM_V.SPP_FSSI_NAME_CD_LIST,
CCD_CRUISE_SUMM_V.SPP_FSSI_NAME_SCD_LIST,
CCD_CRUISE_SUMM_V.SPP_FSSI_NAME_RC_LIST,
CCD_CRUISE_SUMM_V.SPP_FSSI_NAME_BR_LIST,
CCD_CRUISE_SUMM_V.NUM_SPP_MMPA,
CCD_CRUISE_SUMM_V.SPP_MMPA_NAME_CD_LIST,
CCD_CRUISE_SUMM_V.SPP_MMPA_NAME_SCD_LIST,
CCD_CRUISE_SUMM_V.SPP_MMPA_NAME_RC_LIST,
CCD_CRUISE_SUMM_V.SPP_MMPA_NAME_BR_LIST,
CCD_CRUISE_SUMM_V.NUM_PRIM_SVY_CATS,
CCD_CRUISE_SUMM_V.PRIM_SVY_CAT_NAME_CD_LIST,
CCD_CRUISE_SUMM_V.PRIM_SVY_CAT_NAME_SCD_LIST,
CCD_CRUISE_SUMM_V.PRIM_SVY_CAT_NAME_RC_LIST,
CCD_CRUISE_SUMM_V.PRIM_SVY_CAT_NAME_BR_LIST,
CCD_CRUISE_SUMM_V.NUM_SEC_SVY_CATS,
CCD_CRUISE_SUMM_V.SEC_SVY_CAT_NAME_CD_LIST,
CCD_CRUISE_SUMM_V.SEC_SVY_CAT_NAME_SCD_LIST,
CCD_CRUISE_SUMM_V.SEC_SVY_CAT_NAME_RC_LIST,
CCD_CRUISE_SUMM_V.SEC_SVY_CAT_NAME_BR_LIST,
CCD_CRUISE_SUMM_V.NUM_EXP_SPP,
CCD_CRUISE_SUMM_V.EXP_SPP_NAME_CD_LIST,
CCD_CRUISE_SUMM_V.EXP_SPP_NAME_SCD_LIST,
CCD_CRUISE_SUMM_V.EXP_SPP_NAME_RC_LIST,
CCD_CRUISE_SUMM_V.EXP_SPP_NAME_BR_LIST,
CCD_CRUISE_SUMM_V.NUM_SPP_OTH,
CCD_CRUISE_SUMM_V.OTH_SPP_CNAME_CD_LIST,
CCD_CRUISE_SUMM_V.OTH_SPP_CNAME_SCD_LIST,
CCD_CRUISE_SUMM_V.OTH_SPP_CNAME_RC_LIST,
CCD_CRUISE_SUMM_V.OTH_SPP_CNAME_BR_LIST,
CCD_CRUISE_SUMM_V.OTH_SPP_SNAME_CD_LIST,
CCD_CRUISE_SUMM_V.OTH_SPP_SNAME_SCD_LIST,
CCD_CRUISE_SUMM_V.OTH_SPP_SNAME_RC_LIST,
CCD_CRUISE_SUMM_V.OTH_SPP_SNAME_BR_LIST,
CCD_CRUISE_SUMM_V.CRUISE_START_DATE,
CCD_CRUISE_SUMM_V.FORMAT_CRUISE_START_DATE,
CCD_CRUISE_SUMM_V.CRUISE_END_DATE,
CCD_CRUISE_SUMM_V.FORMAT_CRUISE_END_DATE,
CCD_CRUISE_SUMM_V.CRUISE_DAS,
CCD_CRUISE_SUMM_V.CRUISE_LEN_DAYS,
CCD_CRUISE_SUMM_V.CRUISE_YEAR,
CCD_CRUISE_SUMM_V.CRUISE_FISC_YEAR,
CCD_CRUISE_SUMM_V.NUM_LEGS,
CCD_CRUISE_SUMM_V.LEG_NAME_CD_LIST,
CCD_CRUISE_SUMM_V.LEG_NAME_SCD_LIST,
CCD_CRUISE_SUMM_V.LEG_NAME_RC_LIST,
CCD_CRUISE_SUMM_V.LEG_NAME_BR_LIST,
CCD_CRUISE_SUMM_V.LEG_NAME_DATES_CD_LIST,
CCD_CRUISE_SUMM_V.LEG_NAME_DATES_SCD_LIST,
CCD_CRUISE_SUMM_V.LEG_NAME_DATES_RC_LIST,
CCD_CRUISE_SUMM_V.LEG_NAME_DATES_BR_LIST,
CCD_CRUISE_SUMM_V.NUM_REGIONS,
CCD_CRUISE_SUMM_V.REGION_CODE_CD_LIST,
CCD_CRUISE_SUMM_V.REGION_CODE_SCD_LIST,
CCD_CRUISE_SUMM_V.REGION_CODE_RC_LIST,
CCD_CRUISE_SUMM_V.REGION_CODE_BR_LIST,
CCD_CRUISE_SUMM_V.REGION_NAME_CD_LIST,
CCD_CRUISE_SUMM_V.REGION_NAME_SCD_LIST,
CCD_CRUISE_SUMM_V.REGION_NAME_RC_LIST,
CCD_CRUISE_SUMM_V.REGION_NAME_BR_LIST,
CCD_CRUISE_SUMM_V.NUM_ECOSYSTEMS,
CCD_CRUISE_SUMM_V.ECOSYSTEM_CD_LIST,
CCD_CRUISE_SUMM_V.ECOSYSTEM_SCD_LIST,
CCD_CRUISE_SUMM_V.ECOSYSTEM_RC_LIST,
CCD_CRUISE_SUMM_V.ECOSYSTEM_BR_LIST,
CCD_CRUISE_SUMM_V.NUM_GEAR,
CCD_CRUISE_SUMM_V.GEAR_CD_LIST,
CCD_CRUISE_SUMM_V.GEAR_SCD_LIST,
CCD_CRUISE_SUMM_V.GEAR_RC_LIST,
CCD_CRUISE_SUMM_V.GEAR_BR_LIST,
DVM_PTA_ISSUES_V.PTA_ISS_ID,
DVM_PTA_ISSUES_V.CREATE_DATE,
DVM_PTA_ISSUES_V.FORMATTED_CREATE_DATE,
DVM_PTA_ISSUES_V.ISS_ID,
DVM_PTA_ISSUES_V.ISS_DESC,
DVM_PTA_ISSUES_V.ISS_NOTES,
DVM_PTA_ISSUES_V.ISS_RES_TYPE_ID,
DVM_PTA_ISSUES_V.ISS_RES_TYPE_CODE,
DVM_PTA_ISSUES_V.ISS_RES_TYPE_NAME,
DVM_PTA_ISSUES_V.ISS_RES_TYPE_DESC,
DVM_PTA_ISSUES_V.APP_LINK_URL,
DVM_PTA_ISSUES_V.ISS_TYPE_ID,
DVM_PTA_ISSUES_V.QC_OBJECT_ID,
DVM_PTA_ISSUES_V.OBJECT_NAME,
DVM_PTA_ISSUES_V.QC_OBJ_ACTIVE_YN,
DVM_PTA_ISSUES_V.QC_SORT_ORDER,
DVM_PTA_ISSUES_V.ISS_TYPE_NAME,
DVM_PTA_ISSUES_V.ISS_TYPE_COMMENT_TEMPLATE,
DVM_PTA_ISSUES_V.ISS_TYPE_DESC,
DVM_PTA_ISSUES_V.IND_FIELD_NAME,
DVM_PTA_ISSUES_V.APP_LINK_TEMPLATE,
DVM_PTA_ISSUES_V.ISS_SEVERITY_ID,
DVM_PTA_ISSUES_V.ISS_SEVERITY_CODE,
DVM_PTA_ISSUES_V.ISS_SEVERITY_NAME,
DVM_PTA_ISSUES_V.ISS_SEVERITY_DESC,
DVM_PTA_ISSUES_V.DATA_STREAM_ID,
DVM_PTA_ISSUES_V.DATA_STREAM_CODE,
DVM_PTA_ISSUES_V.DATA_STREAM_NAME,
DVM_PTA_ISSUES_V.DATA_STREAM_DESC,
DVM_PTA_ISSUES_V.DATA_STREAM_PAR_TABLE,
DVM_PTA_ISSUES_V.ISS_TYPE_ACTIVE_YN,
DVM_PTA_ISSUES_V.FIRST_EVAL_DATE,
DVM_PTA_ISSUES_V.FORMAT_FIRST_EVAL_DATE,
DVM_PTA_ISSUES_V.LAST_EVAL_DATE,
DVM_PTA_ISSUES_V.FORMAT_LAST_EVAL_DATE,
DVM_PTA_ISSUES_V.ISS_TYP_ASSOC_ID,
DVM_PTA_ISSUES_V.RULE_SET_ID,
DVM_PTA_ISSUES_V.RULE_SET_ACTIVE_YN,
DVM_PTA_ISSUES_V.RULE_SET_CREATE_DATE,
DVM_PTA_ISSUES_V.FORMAT_RULE_SET_CREATE_DATE,
DVM_PTA_ISSUES_V.RULE_SET_INACTIVE_DATE,
DVM_PTA_ISSUES_V.FORMAT_RULE_SET_INACTIVE_DATE,
DVM_PTA_ISSUES_V.RULE_DATA_STREAM_ID,
DVM_PTA_ISSUES_V.RULE_DATA_STREAM_CODE,
DVM_PTA_ISSUES_V.RULE_DATA_STREAM_NAME,
DVM_PTA_ISSUES_V.RULE_DATA_STREAM_DESC,
DVM_PTA_ISSUES_V.RULE_DATA_STREAM_PAR_TABLE

FROM CCD_CRUISE_SUMM_V
INNER JOIN
DVM_PTA_ISSUES_V
ON CCD_CRUISE_SUMM_V.PTA_ISS_ID = DVM_PTA_ISSUES_V.PTA_ISS_ID
order by CRUISE_START_DATE,
CRUISE_NAME,
ISS_TYPE_NAME;

COMMENT ON TABLE CCD_CRUISE_SUMM_ISS_V IS 'Cruise Summary and Associated Validation Issues (View)

This view returns the Cruise summary data and associated validation issues from the DVM that have one or more validation errors/warnings';

COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.CRUISE_ID IS 'Primary key for the CCD_CRUISES table';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.CRUISE_NAME IS 'The name of the given cruise designated by NOAA (e.g. SE-15-01)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.CRUISE_NOTES IS 'Any notes for the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.CRUISE_DESC IS 'Description for the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.OBJ_BASED_METRICS IS 'Objective Based Metrics for the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SCI_CENTER_DIV_ID IS 'Primary key for the Science Center Division table';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SCI_CENTER_DIV_CODE IS 'Abbreviated code for the given Science Center Division';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SCI_CENTER_DIV_NAME IS 'Name of the given Science Center Division';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SCI_CENTER_DIV_DESC IS 'Description for the given Science Center Division';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SCI_CENTER_ID IS 'Primary key for the Science Center table';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SCI_CENTER_NAME IS 'Name of the given Science Center';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SCI_CENTER_DESC IS 'Description for the given Science Center';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.STD_SVY_NAME_ID IS 'Primary key for the Standard Survey Name table';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.STD_SVY_NAME IS 'Name of the given Standard Survey Name';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.STD_SVY_DESC IS 'Description for the given Standard Survey Name';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SVY_FREQ_ID IS 'Primary key for the Survey Frequency table';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SVY_FREQ_NAME IS 'Name of the given Survey Frequency';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SVY_FREQ_DESC IS 'Description for the given Survey Frequency';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.STD_SVY_NAME_OTH IS 'Field defines a Standard Survey Name that is not included in the Standard Survey Name table';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.STD_SVY_NAME_VAL IS 'This field contains the Standard Survey Name defined for the given cruise.  If the STD_SVY_NAME_ID field is defined then the associated CCD_STD_SVY_NAMES.STD_SVY_NAME is used because the foreign key is given precedence, otherwise the STD_SVY_NAME_OTH field value is used';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SVY_TYPE_ID IS 'Primary key for the Survey Type table';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SVY_TYPE_NAME IS 'Name of the given Survey Type';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SVY_TYPE_DESC IS 'Description for the given Survey Type';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.CRUISE_URL IS 'The Cruise URL (Referred to as "Survey URL" in FINSS System) for the given Cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.CRUISE_CONT_EMAIL IS 'The Cruise Contact Email (Referred to as "Survey Contact Email" in FINSS System) for the given Cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.NUM_SPP_ESA IS 'The number of associated ESA Species';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SPP_ESA_NAME_CD_LIST IS 'Comma-delimited list of ESA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SPP_ESA_NAME_SCD_LIST IS 'Semicolon-delimited list of ESA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SPP_ESA_NAME_RC_LIST IS 'Return carriage/new line delimited list of ESA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SPP_ESA_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of ESA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.NUM_SPP_FSSI IS 'The number of associated FSSI Species';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SPP_FSSI_NAME_CD_LIST IS 'Comma-delimited list of FSSI Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SPP_FSSI_NAME_SCD_LIST IS 'Semicolon-delimited list of FSSI Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SPP_FSSI_NAME_RC_LIST IS 'Return carriage/new line delimited list of FSSI Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SPP_FSSI_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of FSSI Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.NUM_SPP_MMPA IS 'The number of associated MMPA Species';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SPP_MMPA_NAME_CD_LIST IS 'Comma-delimited list of MMPA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SPP_MMPA_NAME_SCD_LIST IS 'Semicolon-delimited list of MMPA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SPP_MMPA_NAME_RC_LIST IS 'Return carriage/new line delimited list of MMPA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SPP_MMPA_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of MMPA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.NUM_PRIM_SVY_CATS IS 'The number of associated primary survey categories';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.PRIM_SVY_CAT_NAME_CD_LIST IS 'Comma-delimited list of primary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.PRIM_SVY_CAT_NAME_SCD_LIST IS 'Semicolon-delimited list of primary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.PRIM_SVY_CAT_NAME_RC_LIST IS 'Return carriage/new line delimited list of primary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.PRIM_SVY_CAT_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of primary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.NUM_SEC_SVY_CATS IS 'The number of associated secondary survey categories';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SEC_SVY_CAT_NAME_CD_LIST IS 'Comma-delimited list of secondary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SEC_SVY_CAT_NAME_SCD_LIST IS 'Semicolon-delimited list of secondary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SEC_SVY_CAT_NAME_RC_LIST IS 'Return carriage/new line delimited list of secondary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SEC_SVY_CAT_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of secondary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.NUM_EXP_SPP IS 'The number of associated expected species categories';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.EXP_SPP_NAME_CD_LIST IS 'Comma-delimited list of expected species categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.EXP_SPP_NAME_SCD_LIST IS 'Semicolon-delimited list of expected species categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.EXP_SPP_NAME_RC_LIST IS 'Return carriage/new line delimited list of expected species categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.EXP_SPP_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of expected species categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.NUM_SPP_OTH IS 'The number of associated target species - other';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.OTH_SPP_CNAME_CD_LIST IS 'Comma-delimited list of common names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.OTH_SPP_CNAME_SCD_LIST IS 'Semicolon-delimited list of common names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.OTH_SPP_CNAME_RC_LIST IS 'Return carriage/new line delimited list of common names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.OTH_SPP_CNAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of common names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.OTH_SPP_SNAME_CD_LIST IS 'Comma-delimited list of scientific names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.OTH_SPP_SNAME_SCD_LIST IS 'Semicolon-delimited list of scientific names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.OTH_SPP_SNAME_RC_LIST IS 'Return carriage/new line delimited list of scientific names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.OTH_SPP_SNAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of scientific names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.CRUISE_START_DATE IS 'The start date for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.FORMAT_CRUISE_START_DATE IS 'The formatted start date for the given cruise (based on the earliest associated cruise leg''s start date) in MM/DD/YYYY HH24:MI:SS format';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.CRUISE_END_DATE IS 'The end date for the given cruise (based on the latest associated cruise leg''s end date)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.FORMAT_CRUISE_END_DATE IS 'The formatted end date for the given cruise (based on the latest associated cruise leg''s end date) in MM/DD/YYYY HH24:MI:SS format';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.CRUISE_DAS IS 'The total number of days at sea for each of the legs associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.CRUISE_LEN_DAYS IS 'The total number of days between the Cruise Start and End Dates for the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.CRUISE_YEAR IS 'The calendar year for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.CRUISE_FISC_YEAR IS 'The calendar year for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.NUM_LEGS IS 'The number of cruise legs associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.LEG_NAME_CD_LIST IS 'Comma-delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.LEG_NAME_SCD_LIST IS 'Semicolon-delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.LEG_NAME_RC_LIST IS 'Return carriage/new line delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.LEG_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.LEG_NAME_DATES_CD_LIST IS 'Comma-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.LEG_NAME_DATES_SCD_LIST IS 'Semicolon-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.LEG_NAME_DATES_RC_LIST IS 'Return carriage/new line delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.LEG_NAME_DATES_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.NUM_REGIONS IS 'The number of unique regions associated with the associated cruise legs';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.REGION_CODE_CD_LIST IS 'Comma-delimited list of unique region codes associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.REGION_CODE_SCD_LIST IS 'Semicolon-delimited list of unique region codes associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.REGION_CODE_RC_LIST IS 'Return carriage/new line delimited list of unique region codes associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.REGION_CODE_BR_LIST IS '<BR> tag (intended for web pages) delimited list of unique region codes associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.REGION_NAME_CD_LIST IS 'Comma-delimited list of unique region names associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.REGION_NAME_SCD_LIST IS 'Semicolon-delimited list of unique region names associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.REGION_NAME_RC_LIST IS 'Return carriage/new line delimited list of unique region names associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.REGION_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of unique region names associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.NUM_ECOSYSTEMS IS 'The number of unique regional ecosystems associated with the associated cruise legs';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.ECOSYSTEM_CD_LIST IS 'Comma-delimited list of unique regional ecosystems associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.ECOSYSTEM_SCD_LIST IS 'Semicolon-delimited list of unique regional ecosystems associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.ECOSYSTEM_RC_LIST IS 'Return carriage/new line delimited list of unique regional ecosystems associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.ECOSYSTEM_BR_LIST IS '<BR> tag (intended for web pages) delimited list of unique regional ecosystems associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.NUM_GEAR IS 'The number of unique gear associated with the associated cruise legs';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.GEAR_CD_LIST IS 'Comma-delimited list of unique gear associated with the associated cruise legs';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.GEAR_SCD_LIST IS 'Semicolon-delimited list of unique gear associated with the associated cruise legs';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.GEAR_RC_LIST IS 'Return carriage/new line delimited list of unique gear associated with the associated cruise legs';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.GEAR_BR_LIST IS '<BR> tag (intended for web pages) delimited list of unique gear associated with the associated cruise legs';

COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.PTA_ISS_ID IS 'Foreign key reference to the Issues (PTA) intersection table';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.CREATE_DATE IS 'The date/time the Validation Issue parent record was created in the database, this indicates the first time the Cruise record was validated using the DVM';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.FORMATTED_CREATE_DATE IS 'The formatted date/time the Validation Issue parent record was created in the database, this indicates the first time the Cruise record was validated using the DVM (MM/DD/YYYY HH24:MI)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.ISS_ID IS 'Primary Key for the DVM_ISSUES table';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.ISS_DESC IS 'The description of the given Validation Issue';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.ISS_NOTES IS 'Manually entered notes for the corresponding data issue';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.ISS_RES_TYPE_ID IS 'Primary Key for the DVM_ISS_RES_TYPES table';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.ISS_RES_TYPE_CODE IS 'The Issue Resolution Type code';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.ISS_RES_TYPE_NAME IS 'The Issue Resolution Type name';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.ISS_RES_TYPE_DESC IS 'The Issue Resolution Type description';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.APP_LINK_URL IS 'The generated specific application link URL to resolve the given data issue.  This is generated at runtime of the DVM based on the values returned by the corresponding QC query and by the related DVM_ISS_TYPES record''s APP_LINK_TEMPLATE value';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.ISS_TYPE_ID IS 'The Issue Type for the given issue';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.QC_OBJECT_ID IS 'The Data QC Object that the issue type is determined from.  If this is NULL it is not associated with a QC query validation constraint (e.g. DB error)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.OBJECT_NAME IS 'The name of the object that is used in the given QC validation criteria';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.QC_OBJ_ACTIVE_YN IS 'Flag to indicate if the QC object is active (Y) or inactive (N)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.QC_SORT_ORDER IS 'Relative sort order for the QC object to be executed in';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.ISS_TYPE_NAME IS 'The name of the given QC validation criteria';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.ISS_TYPE_COMMENT_TEMPLATE IS 'The template for the specific issue description that exists in the specific issue condition.  This field should contain placeholders in the form: [PLACEHOLDER] where PLACEHOLDER is the corresponding field name in the result set that will have its placeholder replaced by the corresponding result set field value.  This is NULL only when XML_QC_OBJ_ID is NULL';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.ISS_TYPE_DESC IS 'The description for the given QC validation issue type';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.IND_FIELD_NAME IS 'The field in the result set that indicates if the current issue type has been identified.  A ''Y'' value indicates that the given issue condition has been identified.  When XML_QC_OBJ_ID is NULL this is the constant name that is used to refer to the current issue type';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.APP_LINK_TEMPLATE IS 'The template for the specific application link to resolve the given data issue.  This is intended to provide the necessary parameters in a given URL that can be used to generate the full URL based on the server (e.g. generate the parameters for a given cruise leg and the APEX application will use the [APP_ID] and [APP_SESSION] placeholders at runtime to generate the full URL - f?p=[APP_ID]:220:[APP_SESSION]::NO::CRUISE_ID,CRUISE_ID_COPY:[CRUISE_ID],)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.ISS_SEVERITY_ID IS 'The Severity of the given issue type criteria.  These indicate the status of the given issue (e.g. warnings, data errors, violations of law, etc.)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.ISS_SEVERITY_CODE IS 'The code for the given issue severity';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.ISS_SEVERITY_NAME IS 'The name for the given issue severity';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.ISS_SEVERITY_DESC IS 'The description for the given issue severity';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.DATA_STREAM_ID IS 'Primary Key for the DVM_DATA_STREAMS table';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.DATA_STREAM_CODE IS 'The code for the given data stream';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.DATA_STREAM_NAME IS 'The name for the given data stream';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.DATA_STREAM_DESC IS 'The description for the given data stream';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.DATA_STREAM_PAR_TABLE IS 'The Data stream''s parent table name (used when evaluating QC validation criteria to specify a given parent table)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.ISS_TYPE_ACTIVE_YN IS 'Flag to indicate if the given issue type criteria is active';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.FIRST_EVAL_DATE IS 'The date/time the rule set was first evaluated for the given parent issue record';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.FORMAT_FIRST_EVAL_DATE IS 'The formatted date/time the rule set was first evaluated for the given parent issue record (MM/DD/YYYY HH24:MI format)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.LAST_EVAL_DATE IS 'The date/time the rule set was most recently evaluated for the given parent issue record';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.FORMAT_LAST_EVAL_DATE IS 'The formatted date/time the rule set was most recently evaluated for the given parent issue record (MM/DD/YYYY HH24:MI format)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.ISS_TYP_ASSOC_ID IS 'Primary Key for the DVM_ISS_TYP_ASSOC table';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.RULE_SET_ID IS 'Primary key for the DVM_RULE_SETS table';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.RULE_SET_ACTIVE_YN IS 'Flag to indicate if the given rule set is currently active (Y) or inactive (N).  Only one rule set can be active at any given time';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.RULE_SET_CREATE_DATE IS 'The date/time that the given rule set was created';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.FORMAT_RULE_SET_CREATE_DATE IS 'The formatted date/time that the given rule set was created (MM/DD/YYYY HH24:MI format)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.RULE_SET_INACTIVE_DATE IS 'The date/time that the given rule set was deactivated (due to a change in active rules)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.FORMAT_RULE_SET_INACTIVE_DATE IS 'The formatted date/time that the given rule set was deactivated (due to a change in active rules) (MM/DD/YYYY HH24:MI format)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.RULE_DATA_STREAM_ID IS 'Foreign key reference to the DVM_DATA_STREAMS table that represents the rule set''s data stream for the given DVM rule set';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.RULE_DATA_STREAM_CODE IS 'The code for the given validation rule set''s data stream';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.RULE_DATA_STREAM_NAME IS 'The name for the given validation rule set''s data stream';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.RULE_DATA_STREAM_DESC IS 'The description for the given validation rule set''s data stream';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.RULE_DATA_STREAM_PAR_TABLE IS 'The Data stream''s parent table name for the given validation rule set (used when evaluating QC validation criteria to specify a given parent table)';

COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.APP_LINK_TEMPLATE IS 'The template for the specific application link to resolve the given data issue.  This is intended to provide the necessary parameters in a given URL that can be used to generate the full URL based on the server (e.g. generate the parameters for a given cruise leg and the APEX application will use the [APP_ID] and [APP_SESSION] placeholders at runtime to generate the full URL - f?p=[APP_ID]:220:[APP_SESSION]::NO::CRUISE_ID,CRUISE_ID_COPY:[CRUISE_ID],)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.APP_LINK_URL IS 'The generated specific application link URL to resolve the given data issue.  This is generated at runtime of the DVM based on the values returned by the corresponding QC query and by the related DVM_ISS_TYPES record''s APP_LINK_TEMPLATE value';

alter view CCD_CRUISE_ISS_SUMM_V compile;


create or replace view
CCD_CRUISE_DVM_RULES_V

AS
select
DVM_PTA_RULE_SETS.PTA_RULE_SET_ID,
DVM_PTA_RULE_SETS.FIRST_EVAL_DATE,
TO_CHAR(DVM_PTA_RULE_SETS.FIRST_EVAL_DATE, 'MM/DD/YYYY HH24:MI') FORMAT_FIRST_EVAL_DATE,
DVM_PTA_RULE_SETS.LAST_EVAL_DATE,
TO_CHAR(DVM_PTA_RULE_SETS.LAST_EVAL_DATE, 'MM/DD/YYYY HH24:MI') FORMAT_LAST_EVAL_DATE,
DVM_RULE_SETS_V.RULE_SET_ID,
DVM_RULE_SETS_V.RULE_SET_ACTIVE_YN,
DVM_RULE_SETS_V.RULE_SET_CREATE_DATE,
DVM_RULE_SETS_V.FORMAT_RULE_SET_CREATE_DATE,
DVM_RULE_SETS_V.RULE_SET_INACTIVE_DATE,
DVM_RULE_SETS_V.FORMAT_RULE_SET_INACTIVE_DATE,
DVM_RULE_SETS_V.RULE_DATA_STREAM_ID,
DVM_RULE_SETS_V.RULE_DATA_STREAM_CODE,
DVM_RULE_SETS_V.RULE_DATA_STREAM_NAME,
DVM_RULE_SETS_V.RULE_DATA_STREAM_DESC,
DVM_RULE_SETS_V.RULE_DATA_STREAM_PAR_TABLE,
DVM_RULE_SETS_V.ISS_TYP_ASSOC_ID,
DVM_RULE_SETS_V.QC_OBJECT_ID,
DVM_RULE_SETS_V.OBJECT_NAME,
DVM_RULE_SETS_V.QC_OBJ_ACTIVE_YN,
DVM_RULE_SETS_V.QC_SORT_ORDER,
DVM_RULE_SETS_V.ISS_TYPE_ID,
DVM_RULE_SETS_V.ISS_TYPE_NAME,
DVM_RULE_SETS_V.ISS_TYPE_COMMENT_TEMPLATE,
DVM_RULE_SETS_V.ISS_TYPE_DESC,
DVM_RULE_SETS_V.IND_FIELD_NAME,
DVM_RULE_SETS_V.APP_LINK_TEMPLATE,
DVM_RULE_SETS_V.ISS_SEVERITY_ID,
DVM_RULE_SETS_V.ISS_SEVERITY_CODE,
DVM_RULE_SETS_V.ISS_SEVERITY_NAME,
DVM_RULE_SETS_V.ISS_SEVERITY_DESC,
DVM_RULE_SETS_V.DATA_STREAM_ID,
DVM_RULE_SETS_V.DATA_STREAM_CODE,
DVM_RULE_SETS_V.DATA_STREAM_NAME,
DVM_RULE_SETS_V.DATA_STREAM_DESC,
DVM_RULE_SETS_V.DATA_STREAM_PAR_TABLE,
DVM_RULE_SETS_V.ISS_TYPE_ACTIVE_YN,
CCD_CRUISE_V.CRUISE_ID,
CCD_CRUISE_V.CRUISE_NAME,
CCD_CRUISE_V.CRUISE_NOTES,
CCD_CRUISE_V.CRUISE_DESC,
CCD_CRUISE_V.OBJ_BASED_METRICS,
CCD_CRUISE_V.SCI_CENTER_DIV_ID,
CCD_CRUISE_V.SCI_CENTER_DIV_CODE,
CCD_CRUISE_V.SCI_CENTER_DIV_NAME,
CCD_CRUISE_V.SCI_CENTER_DIV_DESC,
CCD_CRUISE_V.SCI_CENTER_ID,
CCD_CRUISE_V.SCI_CENTER_NAME,
CCD_CRUISE_V.SCI_CENTER_DESC,
CCD_CRUISE_V.STD_SVY_NAME_ID,
CCD_CRUISE_V.STD_SVY_NAME,
CCD_CRUISE_V.STD_SVY_DESC,
CCD_CRUISE_V.SVY_FREQ_ID,
CCD_CRUISE_V.SVY_FREQ_NAME,
CCD_CRUISE_V.SVY_FREQ_DESC,
CCD_CRUISE_V.STD_SVY_NAME_OTH,
CCD_CRUISE_V.STD_SVY_NAME_VAL,
CCD_CRUISE_V.SVY_TYPE_ID,
CCD_CRUISE_V.SVY_TYPE_NAME,
CCD_CRUISE_V.SVY_TYPE_DESC,
CCD_CRUISE_V.CRUISE_URL,
CCD_CRUISE_V.CRUISE_CONT_EMAIL,
CCD_CRUISE_V.PTA_ISS_ID,
CCD_CRUISE_V.NUM_LEGS,
CCD_CRUISE_V.CRUISE_START_DATE,
CCD_CRUISE_V.FORMAT_CRUISE_START_DATE,
CCD_CRUISE_V.CRUISE_END_DATE,
CCD_CRUISE_V.FORMAT_CRUISE_END_DATE,
CCD_CRUISE_V.CRUISE_DAS,
CCD_CRUISE_V.CRUISE_LEN_DAYS,
CCD_CRUISE_V.CRUISE_YEAR,
CCD_CRUISE_V.CRUISE_FISC_YEAR,
CCD_CRUISE_V.LEG_NAME_CD_LIST,
CCD_CRUISE_V.LEG_NAME_SCD_LIST,
CCD_CRUISE_V.LEG_NAME_RC_LIST,
CCD_CRUISE_V.LEG_NAME_BR_LIST,
CCD_CRUISE_V.LEG_NAME_DATES_CD_LIST,
CCD_CRUISE_V.LEG_NAME_DATES_SCD_LIST,
CCD_CRUISE_V.LEG_NAME_DATES_RC_LIST,
CCD_CRUISE_V.LEG_NAME_DATES_BR_LIST
FROM
DVM_PTA_RULE_SETS INNER JOIN
DVM_RULE_SETS_V ON
DVM_PTA_RULE_SETS.RULE_SET_ID = DVM_RULE_SETS_V.RULE_SET_ID
INNER JOIN
CCD_CRUISE_V ON
DVM_PTA_RULE_SETS.PTA_ISS_ID = CCD_CRUISE_V.PTA_ISS_ID
order by
CCD_CRUISE_V.SCI_CENTER_NAME,
CCD_CRUISE_V.STD_SVY_NAME,
CCD_CRUISE_V.CRUISE_NAME,
DVM_RULE_SETS_V.DATA_STREAM_CODE,
DVM_RULE_SETS_V.ISS_TYPE_NAME
;

COMMENT ON TABLE CCD_CRUISE_DVM_RULES_V IS 'Cruise DVM Rules (View)

This view returns all of the DVM PTA validation rule sets and all related validation rule set information and cruise information';

COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.PTA_RULE_SET_ID IS 'The primary key field for the DVM_PTA_RULE_SETS table';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.FIRST_EVAL_DATE IS 'The date/time the rule set was first evaluated for the given parent issue record';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.FORMAT_FIRST_EVAL_DATE IS 'The formatted date/time the rule set was first evaluated for the given parent issue record (MM/DD/YYYY HH24:MI format)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.LAST_EVAL_DATE IS 'The date/time the rule set was most recently evaluated for the given parent issue record';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.FORMAT_LAST_EVAL_DATE IS 'The formatted date/time the rule set was most recently evaluated for the given parent issue record (MM/DD/YYYY HH24:MI format)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.RULE_SET_ID IS 'Primary key for the DVM_RULE_SETS table';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.RULE_SET_ACTIVE_YN IS 'Flag to indicate if the given rule set is currently active (Y) or inactive (N).  Only one rule set can be active at any given time';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.RULE_SET_CREATE_DATE IS 'The date/time that the given rule set was created';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.FORMAT_RULE_SET_CREATE_DATE IS 'The formatted date/time that the given rule set was created (MM/DD/YYYY HH24:MI:SS format)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.RULE_SET_INACTIVE_DATE IS 'The date/time that the given rule set was deactivated (due to a change in active rules)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.FORMAT_RULE_SET_INACTIVE_DATE IS 'The formatted date/time that the given rule set was deactivated (due to a change in active rules) (MM/DD/YYYY HH24:MI:SS format)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.RULE_DATA_STREAM_ID IS 'Foreign key reference to the DVM_DATA_STREAMS table that represents the rule set''s data stream for the given DVM rule set';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.RULE_DATA_STREAM_CODE IS 'The code for the given validation rule set''s data stream';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.RULE_DATA_STREAM_NAME IS 'The name for the given validation rule set''s data stream';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.RULE_DATA_STREAM_DESC IS 'The description for the given validation rule set''s data stream';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.RULE_DATA_STREAM_PAR_TABLE IS 'The Data stream''s parent table name for the given validation rule set (used when evaluating QC validation criteria to specify a given parent table)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.ISS_TYP_ASSOC_ID IS 'Primary Key for the DVM_ISS_TYP_ASSOC table';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.QC_OBJECT_ID IS 'The Data QC Object that the issue type is determined from.  If this is NULL it is not associated with a QC query validation constraint (e.g. DB issue)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.OBJECT_NAME IS 'The name of the object that is used in the given QC validation criteria';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.QC_OBJ_ACTIVE_YN IS 'Flag to indicate if the QC object is active (Y) or inactive (N)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.QC_SORT_ORDER IS 'Relative sort order for the QC object to be executed in';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.ISS_TYPE_ID IS 'The issue type for the given issue';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.ISS_TYPE_NAME IS 'The name of the given QC validation criteria';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.ISS_TYPE_COMMENT_TEMPLATE IS 'The template for the specific issue description that exists in the specific issue condition.  This field should contain placeholders in the form: [PLACEHOLDER] where PLACEHOLDER is the corresponding field name in the result set that will have its placeholder replaced by the corresponding result set field value.  This is NULL only when XML_QC_OBJ_ID is NULL';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.ISS_TYPE_DESC IS 'The description for the given QC validation issue type';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.IND_FIELD_NAME IS 'The field in the result set that indicates if the current issue type has been identified.  A ''Y'' value indicates that the given issue condition has been identified.  When XML_QC_OBJ_ID is NULL this is the constant name that is used to refer to the current issue type';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.APP_LINK_TEMPLATE IS 'The template for the specific application link to resolve the given data issue.  This is intended to provide the necessary parameters in a given URL that can be used to generate the full URL based on the server (e.g. generate the parameters for a given cruise leg and the APEX application will use the APP_ID and APP_SESSION at runtime to generate the full URL - f?p=[APP_ID]:220:[APP_SESSION]::NO::CRUISE_ID,CRUISE_ID_COPY:[CRUISE_ID],)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.ISS_SEVERITY_ID IS 'The Severity of the given issue type criteria.  These indicate the status of the given issue (e.g. warnings, data issues, violations of law, etc.)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.ISS_SEVERITY_CODE IS 'The code for the given issue severity';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.ISS_SEVERITY_NAME IS 'The name for the given issue severity';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.ISS_SEVERITY_DESC IS 'The description for the given issue severity';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.DATA_STREAM_ID IS 'Foreign key reference to the DVM_DATA_STREAMS table that represents the issue type''s data stream for the given DVM rule set';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.DATA_STREAM_CODE IS 'The code for the given issue type''s data stream';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.DATA_STREAM_NAME IS 'The name for the given issue type''s data stream';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.DATA_STREAM_DESC IS 'The description for the given issue type''s data stream';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.DATA_STREAM_PAR_TABLE IS 'The Data stream''s parent table name (used when evaluating QC validation criteria to specify a given parent table)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.ISS_TYPE_ACTIVE_YN IS 'Flag to indicate if the given issue type criteria is active';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.CRUISE_ID IS 'Primary key for the CCD_CRUISES table';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.CRUISE_NAME IS 'The name of the given cruise designated by NOAA (e.g. SE-15-01)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.CRUISE_NOTES IS 'Any notes for the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.CRUISE_DESC IS 'Description for the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.OBJ_BASED_METRICS IS 'Objective Based Metrics for the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.SCI_CENTER_DIV_ID IS 'Primary key for the Science Center Division table';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.SCI_CENTER_DIV_CODE IS 'Abbreviated code for the given Science Center Division';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.SCI_CENTER_DIV_NAME IS 'Name of the given Science Center Division';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.SCI_CENTER_DIV_DESC IS 'Description for the given Science Center Division';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.SCI_CENTER_ID IS 'Primary key for the Science Center table';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.SCI_CENTER_NAME IS 'Name of the given Science Center';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.SCI_CENTER_DESC IS 'Description for the given Science Center';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.STD_SVY_NAME_ID IS 'Primary key for the Standard Survey Name table';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.STD_SVY_NAME IS 'Name of the given Standard Survey Name';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.STD_SVY_DESC IS 'Description for the given Standard Survey Name';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.SVY_FREQ_ID IS 'Primary key for the Survey Frequency table';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.SVY_FREQ_NAME IS 'Name of the given Survey Frequency';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.SVY_FREQ_DESC IS 'Description for the given Survey Frequency';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.STD_SVY_NAME_OTH IS 'Field defines a Standard Survey Name that is not included in the Standard Survey Name table';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.STD_SVY_NAME_VAL IS 'This field contains the Standard Survey Name defined for the given cruise.  If the STD_SVY_NAME_ID field is defined then the associated CCD_STD_SVY_NAMES.STD_SVY_NAME is used because the foreign key is given precedence, otherwise the STD_SVY_NAME_OTH field value is used';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.SVY_TYPE_ID IS 'Primary key for the Survey Type table';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.SVY_TYPE_NAME IS 'Name of the given Survey Type';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.SVY_TYPE_DESC IS 'Description for the given Survey Type';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.CRUISE_URL IS 'The Cruise URL (Referred to as "Survey URL" in FINSS System) for the given Cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.CRUISE_CONT_EMAIL IS 'The Cruise Contact Email (Referred to as "Survey Contact Email" in FINSS System) for the given Cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.PTA_ISS_ID IS 'Foreign key reference to the Issues (PTA) intersection table';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.NUM_LEGS IS 'The number of cruise legs associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.CRUISE_START_DATE IS 'The start date for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.FORMAT_CRUISE_START_DATE IS 'The formatted start date for the given cruise (based on the earliest associated cruise leg''s start date) in MM/DD/YYYY format';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.CRUISE_END_DATE IS 'The end date for the given cruise (based on the latest associated cruise leg''s end date)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.FORMAT_CRUISE_END_DATE IS 'The formatted end date for the given cruise (based on the latest associated cruise leg''s end date) in MM/DD/YYYY format';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.CRUISE_DAS IS 'The total number of days at sea for each of the legs associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.CRUISE_LEN_DAYS IS 'The total number of days between the Cruise Start and End Dates for the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.CRUISE_YEAR IS 'The calendar year for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.CRUISE_FISC_YEAR IS 'The calendar year for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.LEG_NAME_CD_LIST IS 'Comma-delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.LEG_NAME_SCD_LIST IS 'Semicolon-delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.LEG_NAME_RC_LIST IS 'Return carriage/new line delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.LEG_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.LEG_NAME_DATES_CD_LIST IS 'Comma-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.LEG_NAME_DATES_SCD_LIST IS 'Semicolon-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.LEG_NAME_DATES_RC_LIST IS 'Return carriage/new line delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.LEG_NAME_DATES_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';


--define the upgrade version in the database upgrade log table:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('Centralized Cruise Database', '0.18', TO_DATE('22-JUL-20', 'DD-MON-YY'), 'Installed Version 0.8 (Git tag: DVM_db_v0.8) and 0.9 (Git tag: DVM_db_v0.9) of the Data Validation Module Database (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/data-validation-module.git).  Recompiled an invalid trigger (CCD_CRUISES_AUTO_BRI) from the last DB upgrade file.  Updated the CCD_DVM_PKG package to overload the EXEC_DVM_CRUISE_SP and EXEC_DVM_CRUISE_OVERLAP_SP procedures to allow the cruise name to be specified instead of the CRUISE_ID, both procedures query for the associated CRUISE_ID and then use the corresponding procedure using the CRUISE_ID.  Also updated the EXEC_DVM_CRUISE_OVERLAP_SP to filter out the CRUISE_ID from the result set so the same record isn''t validated twice unnecessarily.  Updated CCD_CRUISE_SUMM_ISS_V and recompiled CCD_CRUISE_ISS_SUMM_V views based on the upgraded version of the DVM.  Created a new CCD_CRUISE_DVM_RULES_V view to retrieve the DVM validation rule set and related cruise information for reporting/testing purposes');

--commit the DB_UPGRADE_LOGS record insertion
COMMIT;

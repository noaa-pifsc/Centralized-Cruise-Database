--------------------------------------------------------
--------------------------------------------------------
--Database Name: Centralized Cruise Database
--Database Description: Centralized Cruise Database to track information about each PIFSC research cruise including activities, chief scientists, regions, etc. to remove the need for each division/program to manage this information
--------------------------------------------------------
--------------------------------------------------------


--------------------------------------------------------
--Centralized Cruise Database - version 0.17 updates:
--------------------------------------------------------


--Installing Version 0.2 (Git tag: db_log_db_v0.2) of the Database Logging Module Database (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/centralized-tools.git in the DB_log folder)
@@"./external_modules/DB_log_DDL_DML_upgrade_v0.2.sql";

--Installing Version 0.7 (Git tag: DVM_db_v0.7) of the Data Validation Module Database (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/data-validation-module.git)
@@"./external_modules/DVM_DDL_DML_upgrade_v0.7.sql";


	--CCD DVM Package Specification:
	CREATE OR REPLACE PACKAGE CCD_DVM_PKG
	AUTHID DEFINER
	--this package provides functions and procedures to interact with the CCD package module

	AS

		--procedure that executes the DVM for all CCD_CRUISES records
		PROCEDURE BATCH_EXEC_DVM_CRUISE_SP (P_SP_RET_CODE OUT PLS_INTEGER);

		--procedure that executes the DVM for a given CCD_CRUISES record (based on P_CRUISE_ID)
		PROCEDURE EXEC_DVM_CRUISE_SP (P_CRUISE_ID IN NUMBER, P_SP_RET_CODE OUT PLS_INTEGER);

		--procedure that executes the DVM for a given CCD_CRUISES record (based on P_CRUISE_ID) by calling the EXEC_DVM_CRUISE_SP on the P_CRUISE_ID and then calling EXEC_DVM_CRUISE_SP on each of the records that is related to the P_CRUISE_ID via the CCD_QC_LEG_OVERLAP_V QC view so that the overlapping leg errors can be associated with the matching cruises from the CCD_QC_LEG_OVERLAP_V QC view.
		--P_SP_RET_CODE will contain 1 if the procedure was successful and 0 if the procedure was not successful
	  PROCEDURE EXEC_DVM_CRUISE_OVERLAP_SP (P_CRUISE_ID IN NUMBER, P_SP_RET_CODE OUT PLS_INTEGER);

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

				--query for any leg/vessel overlap for the specified cruise
				FOR rec IN (SELECT CRUISE_ID FROM CCD_QC_LEG_OVERLAP_V WHERE CRUISE_ID2 = P_CRUISE_ID)
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


	end CCD_DVM_PKG;
	/





--define the upgrade version in the database upgrade log table:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('Centralized Cruise Database', '0.17', TO_DATE('09-JUL-20', 'DD-MON-YY'), 'Installed Version 0.2 (Git tag: db_log_db_v0.2) of the Database Logging Module Database (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/centralized-tools.git in the DB_log folder).  Installed Version 0.7 (Git tag: DVM_db_v0.7) of the Data Validation Module Database (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/data-validation-module.git).  Updated the CCD_DVM_PKG to use the updated DVM DB and implemented improved error logging/handling');

--commit the DB_UPGRADE_LOGS record insertion
COMMIT;

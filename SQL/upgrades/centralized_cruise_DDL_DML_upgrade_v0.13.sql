--------------------------------------------------------
--------------------------------------------------------
--Database Name: Centralized Cruise Database
--Database Description: Centralized Cruise Database to track information about each PIFSC research cruise including activities, chief scientists, regions, etc. to remove the need for each division/program to manage this information
--------------------------------------------------------
--------------------------------------------------------


--------------------------------------------------------
--Centralized Cruise Database - version 0.13 updates:
--------------------------------------------------------

	--CCD DVM Package Specification:
	CREATE OR REPLACE PACKAGE CCD_DVM_PKG
	AUTHID DEFINER
	--this package provides functions and procedures to interact with the CCD package module

	AS

		--procedure that executes the DVM for all CCD_CRUISES records
		PROCEDURE BATCH_EXEC_DVM_CRUISE_SP (P_PROC_RETURN_CODE OUT PLS_INTEGER);

		--procedure that executes the DVM for a given CCD_CRUISES record (based on P_CRUISE_ID)
		PROCEDURE EXEC_DVM_CRUISE_SP (P_CRUISE_ID IN NUMBER, P_PROC_RETURN_CODE OUT PLS_INTEGER);

		--procedure that executes the DVM for a given CCD_CRUISES record (based on P_CRUISE_ID) by calling the EXEC_DVM_CRUISE_SP on the P_CRUISE_ID and then calling EXEC_DVM_CRUISE_SP on each of the records that is related to the P_CRUISE_ID via the CCD_QC_LEG_OVERLAP_V QC view so that the overlapping leg errors can be associated with the matching cruises from the CCD_QC_LEG_OVERLAP_V QC view.
		--P_PROC_RETURN_CODE will contain 1 if the procedure was successful and 0 if the procedure was not successful
	  PROCEDURE EXEC_DVM_CRUISE_OVERLAP_SP (P_CRUISE_ID IN NUMBER, P_PROC_RETURN_CODE OUT PLS_INTEGER);

	END CCD_DVM_PKG;
	/


	--CCD DVM Package Body:
	create or replace PACKAGE BODY CCD_DVM_PKG
	--this package provides procedures to validate the cruise database
	AS

		--procedure that executes the DVM for all CCD_CRUISES records
		--P_PROC_RETURN_CODE: return variable to indicate the result of the DVM batch execution attempt, it will contain 1 if the CCD cruises were successfully validated using the DVM package and 0 if they were not
		PROCEDURE BATCH_EXEC_DVM_CRUISE_SP (P_PROC_RETURN_CODE OUT PLS_INTEGER) IS

			--variable to hold the return code value from procedures
			V_RETURN_CODE PLS_INTEGER;

		BEGIN

	    DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'BATCH_EXEC_DVM_CRUISE_SP', 'running the CCD_DVM_PKG.BATCH_EXEC_DVM_CRUISE_SP() procedure', V_RETURN_CODE);

			--set the return code to 1 to indicate that the procedure was successful by default, if there are unsuccessfully processed cruise records or a PL/SQL error it will be set to 0 to indicate the error:
			P_PROC_RETURN_CODE := 1;


			--query for CRUISE_ID values for all active data files:
			FOR rec IN (SELECT CRUISE_ID FROM CCD_CRUISES)

			--loop through each CRUISE_ID returned by the SELECT query to execute the CCD_DVM_PKG.EXEC_DVM_CRUISE_SP() procedure:
 			LOOP



				--run the validator procedure on the given data stream(s) and primary key value:
				CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(rec.CRUISE_ID, V_RETURN_CODE);
				IF (V_RETURN_CODE = 1) THEN
					DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'BATCH_EXEC_DVM_CRUISE_SP', 'The current cruise record ('||rec.CRUISE_ID||') was validated successfully', V_RETURN_CODE);
				ELSE
					DB_LOG_PKG.ADD_LOG_ENTRY('ERROR', 'BATCH_EXEC_DVM_CRUISE_SP', 'The current cruise record ('||rec.CRUISE_ID||') was not validated successfully', V_RETURN_CODE);

					--set the return code to 0 to indicate the processing error
					P_PROC_RETURN_CODE := 0;
				END IF;

			END LOOP;


      EXCEPTION

	        --catch all PL/SQL database exceptions:
	        WHEN OTHERS THEN
		  --catch all other errors:


			    DB_LOG_PKG.ADD_LOG_ENTRY('ERROR', 'BATCH_EXEC_DVM_CRUISE_SP', 'The error code is ' || SQLCODE || '- ' || SQLERRM, V_RETURN_CODE);

				  --define the return code that indicates that the CCD cast file was not successfully deactivated and the corresponding data was not purged from the database:
				  P_PROC_RETURN_CODE := 0;


		END BATCH_EXEC_DVM_CRUISE_SP;

		--procedure that executes the DVM for a given CCD_CRUISES record
		PROCEDURE EXEC_DVM_CRUISE_SP (P_CRUISE_ID IN NUMBER, P_PROC_RETURN_CODE OUT PLS_INTEGER) IS

			V_RETURN_CODE PLS_INTEGER;
	    P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;

		BEGIN

	    DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'EXEC_DVM_CRUISE_SP', 'running the CCD_DVM_PKG.EXEC_DVM_CRUISE_SP('||P_CRUISE_ID||') procedure', V_RETURN_CODE);

			--define the data stream codes for the given data stream (hard-coded due to RPL data stream):
			P_DATA_STREAM_CODE(1) := 'CCD';

      --run the validator procedure on the given data stream(s) and primary key value:
      DVM_PKG.VALIDATE_PARENT_RECORD(
      P_DATA_STREAM_CODES => P_DATA_STREAM_CODE,
      P_PK_ID => P_CRUISE_ID
      );

	    DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'EXEC_DVM_CRUISE_SP', 'The DVM_PKG.VALIDATE_PARENT_RECORD() procedure was executed successfully', V_RETURN_CODE);

			P_PROC_RETURN_CODE := 1;

      EXCEPTION

	        --catch all PL/SQL database exceptions:
	        WHEN OTHERS THEN
					  --catch all other errors:

				    DB_LOG_PKG.ADD_LOG_ENTRY('ERROR', 'EXEC_DVM_CRUISE_SP', 'The error code is ' || SQLCODE || '- ' || SQLERRM, V_RETURN_CODE);

					  --define the return code that indicates that the CCD cast file was not successfully deactivated and the corresponding data was not purged from the database:
					  P_PROC_RETURN_CODE := 0;


		END EXEC_DVM_CRUISE_SP;



		--procedure that executes the DVM for a given CCD_CRUISES record (based on P_CRUISE_ID) by calling the EXEC_DVM_CRUISE_SP on the P_CRUISE_ID and then calling EXEC_DVM_CRUISE_SP on each of the records that is related to the P_CRUISE_ID via the CCD_QC_LEG_OVERLAP_V QC view so that the overlapping leg errors can be associated with the matching cruises from the CCD_QC_LEG_OVERLAP_V QC view.
		--P_PROC_RETURN_CODE will contain 1 if the procedure was successful and 0 if the procedure was not successful
		PROCEDURE EXEC_DVM_CRUISE_OVERLAP_SP (P_CRUISE_ID IN NUMBER, P_PROC_RETURN_CODE OUT PLS_INTEGER) IS

			--variable to store the return code from procedure calls:
			V_RETURN_CODE PLS_INTEGER;

			--this variable will track if the duplicate casts have had the DVM package executed successfully so the value of P_PROC_RETURN_CODE can be set
			v_successful_exec BOOLEAN := true;

		BEGIN



	    DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'EXEC_DVM_CRUISE_OVERLAP_SP', 'running the CCD_DVM_PKG.EXEC_DVM_CRUISE_OVERLAP_SP('||P_CRUISE_ID||') procedure', V_RETURN_CODE);

			--set the rollback save point so that the entire procedure's effects can be rolled back if the procedure can't be successfully executed:
			SAVEPOINT DVM_cruise_rec;


	    DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'EXEC_DVM_CRUISE_OVERLAP_SP', 'running the CCD_DVM_PKG.EXEC_DVM_CRUISE_SP('||P_CRUISE_ID||') procedure', V_RETURN_CODE);
			CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(P_CRUISE_ID, V_RETURN_CODE);

			--check if the DVM execution was successful:
			IF (V_RETURN_CODE = 1) THEN
				--the DVM execution was successful:

		    DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'EXEC_DVM_CRUISE_OVERLAP_SP', 'The CCD_DVM_PKG.EXEC_DVM_CRUISE_SP('||P_CRUISE_ID||') was successful, query for the other data files related by the CCD_QC_DUP_CASTS_V view', V_RETURN_CODE);


				FOR rec IN (SELECT CRUISE_ID FROM CCD_QC_LEG_OVERLAP_V WHERE CRUISE_ID2 = P_CRUISE_ID)
				--loop through each CRUISE_ID returned by the SELECT query to execute the CCD_DVM_PKG.EXEC_DVM_CRUISE_SP() procedure:
				LOOP

					--execute the CCD_DVM_PKG.EXEC_DVM_CRUISE_SP() procedure on the current rec.CRUISE_ID value:
			    DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'EXEC_DVM_CRUISE_OVERLAP_SP', 'execute the CCD_DVM_PKG.EXEC_DVM_CRUISE_SP('||rec.CRUISE_ID||') procedure', V_RETURN_CODE);

					CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(rec.CRUISE_ID, V_RETURN_CODE);

					--check the return code for the DVM execution:
					IF (V_RETURN_CODE = 1) THEN
				    DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'EXEC_DVM_CRUISE_OVERLAP_SP', 'The CCD_DVM_PKG.EXEC_DVM_CRUISE_SP('||rec.CRUISE_ID||') procedure was successful', V_RETURN_CODE);

					ELSE
				    DB_LOG_PKG.ADD_LOG_ENTRY('ERROR', 'EXEC_DVM_CRUISE_OVERLAP_SP', 'The CCD_DVM_PKG.EXEC_DVM_CRUISE_SP('||rec.CRUISE_ID||') procedure was not successful', V_RETURN_CODE);


						--the procedure was not completed successfully, stop the loop and rollback:
						v_successful_exec := false;

						--exit the loop
						EXIT;


					END IF;


				END LOOP;



				--check to see if there were any errors when the DVM was being executed on the duplicate files:
				IF (v_successful_exec) THEN
					--there were no processing errors reported

					--define the return code that indicates that the procedure successfully executed:
					P_PROC_RETURN_CODE := 1;

					DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'EXEC_DVM_CRUISE_OVERLAP_SP', 'EXEC_DVM_CRUISE_OVERLAP_SP('||P_CRUISE_ID||') was completed successfully', V_RETURN_CODE);

				ELSE
					--there was a processing error reported, return 0 to indicate the procedure was not successful:

					--rollback all of the DML that was executed in the procedure since one of the DVM executions failed:
					ROLLBACK TO SAVEPOINT DVM_cruise_rec;

					--define the return code that indicates that the procedure was not successfully executed:
					P_PROC_RETURN_CODE := 0;

					DB_LOG_PKG.ADD_LOG_ENTRY('ERROR', 'EXEC_DVM_CRUISE_OVERLAP_SP', 'EXEC_DVM_CRUISE_OVERLAP_SP('||P_CRUISE_ID||') was not completed successfully and the actions within the procedure were rolled back', V_RETURN_CODE);


				END IF;

			ELSE

				--the DVM execution was not successful:

		    DB_LOG_PKG.ADD_LOG_ENTRY('ERROR', 'EXEC_DVM_CRUISE_OVERLAP_SP', 'The CCD_DVM_PKG.EXEC_DVM_CRUISE_SP('||P_CRUISE_ID||') was not successful, rollback the procedure''s DML', V_RETURN_CODE);

				--rollback all of the DML that was executed in the procedure the DVM execution failed:
				ROLLBACK TO SAVEPOINT DVM_cruise_rec;

				--define the return code that indicates that the CCD cast file was not successfully processed:
				P_PROC_RETURN_CODE := 0;

			END IF;



			EXCEPTION

	        --catch all PL/SQL database exceptions:
	        WHEN OTHERS THEN
		  --catch all other errors:

	    DB_LOG_PKG.ADD_LOG_ENTRY('ERROR', 'EXEC_DVM_CRUISE_OVERLAP_SP', 'The error code is ' || SQLCODE || '- ' || SQLERRM, V_RETURN_CODE);

		  --define the return code that indicates that the CCD cast file was not successfully deactivated and the corresponding data was not purged from the database:
		  P_PROC_RETURN_CODE := 0;


			--rollback all of the DML that was executed in the procedure since there was an error:
			ROLLBACK TO SAVEPOINT DVM_cruise_rec;

			DB_LOG_PKG.ADD_LOG_ENTRY('ERROR', 'EXEC_DVM_CRUISE_OVERLAP_SP', 'EXEC_DVM_CRUISE_OVERLAP_SP('||P_CRUISE_ID||') had the following error: '|| SQLCODE || '- ' || SQLERRM||', so the actions within the procedure were rolled back', V_RETURN_CODE);


		END EXEC_DVM_CRUISE_OVERLAP_SP;


	end CCD_DVM_PKG;
	/


COMMENT ON COLUMN CCD_CRUISE_V.CRUISE_FISC_YEAR IS 'The NOAA fiscal year for the given cruise (based on the earliest associated cruise leg''s start date)';

COMMENT ON COLUMN CCD_CRUISE_SUMM_V.CRUISE_FISC_YEAR IS 'The NOAA fiscal year for the given cruise (based on the earliest associated cruise leg''s start date)';


COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.CRUISE_FISC_YEAR IS 'The NOAA fiscal year for the given cruise (based on the earliest associated cruise leg''s start date)';

COMMENT ON COLUMN CCD_CRUISE_LEGS_V.CRUISE_FISC_YEAR IS 'The NOAA fiscal year for the given cruise (based on the earliest associated cruise leg''s start date)';

COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.CRUISE_FISC_YEAR IS 'The NOAA fiscal year for the given cruise (based on the earliest associated cruise leg''s start date)';

COMMENT ON COLUMN CCD_CRUISE_DELIM_V.CRUISE_FISC_YEAR IS 'The NOAA fiscal year for the given cruise (based on the earliest associated cruise leg''s start date)';




ALTER PACKAGE CCD_CRUISE_PKG COMPILE;

--define the upgrade version in the database upgrade log table:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('Centralized Cruise Database', '0.13', TO_DATE('01-MAY-20', 'DD-MON-YY'), 'CCD_DVM_PKG package was created to define an accessor procedure (EXEC_DVM_CRUISE_SP) for the DVM_PKG.VALIDATE_PARENT_RECORD to make it easier to call the procedure for a given Cruise.  Implemented a BATCH_EXEC_DVM_CRUISE_SP procedure to execute the EXEC_DVM_CRUISE_SP for all Cruise records for cases like just before reporting/analyzing the data.  Added the EXEC_DVM_CRUISE_OVERLAP_SP procedure to execute the DVM for all records that have an overlapping cruise/vessel leg error so that the errors are available and associated with those cruise records after an insert/update action to ensure the validation issues are up to date and it can be implemented in a given application to automatically validate a given cruise after any changes are made.  Redefined some inaccurate column comments on the CRUISE_FISC_YEAR column references.');

--commit the DB_UPGRADE_LOGS record insertion
COMMIT;

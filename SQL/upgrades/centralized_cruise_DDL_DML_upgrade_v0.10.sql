--------------------------------------------------------
--------------------------------------------------------
--Database Name: Centralized Cruise Database
--Database Description: Centralized Cruise Database to track information about each PIFSC research cruise including activities, chief scientists, regions, etc. to remove the need for each division/program to manage this information
--------------------------------------------------------
--------------------------------------------------------


--------------------------------------------------------
--Centralized Cruise Database - version 0.10 updates:
--------------------------------------------------------


ALTER TABLE CCD_CRUISES
MODIFY (CRUISE_NAME VARCHAR2(100 BYTE) );


ALTER TABLE CCD_CRUISE_LEGS
MODIFY (LEG_NAME VARCHAR2(100 BYTE) );




--recompiled dependent views:
begin
         FOR cur IN (SELECT OBJECT_NAME, OBJECT_TYPE, owner
         			 FROM sys.all_objects
         			 WHERE object_type = 'VIEW'
         			 and owner = sys_context( 'userenv', 'current_schema' )
         			 AND status = 'INVALID' ) LOOP
         	BEGIN
		         if cur.OBJECT_TYPE = 'PACKAGE BODY' then
		         	EXECUTE IMMEDIATE 'alter ' || cur.OBJECT_TYPE || ' "' ||  cur.owner || '"."' || cur.OBJECT_NAME || '" compile body';
		         else
		         	EXECUTE IMMEDIATE 'alter ' || cur.OBJECT_TYPE || ' "' ||  cur.owner || '"."' || cur.OBJECT_NAME || '" compile';
		         end if;
			EXCEPTION
  				WHEN OTHERS THEN NULL;
			END;
         end loop;
         end;
/

drop package cruise_pkg;

	--CRUISE Package Specification:
	CREATE OR REPLACE PACKAGE CCD_CRUISE_PKG
	AUTHID DEFINER
	--this package provides functions and procedures to interact with the Cruise package module

	AS

	--function that accepts a P_LEG_ALIAS value and returns the CRUISE_LEG_ID value for the CCD_CRUISE_LEGS record that has a corresponding CCD_LEG_ALIASES record with a LEG_ALIAS_NAME that matches the P_LEG_ALIAS value.  It returns NULL if no match is found
	FUNCTION LEG_ALIAS_TO_CRUISE_LEG_ID_FN (P_LEG_ALIAS VARCHAR2) RETURN NUMBER;

  --Append Reference Preset Options function
  --function that accepts a list of colon-delimited integers (P_DELIM_VALUES) representing the primary key values of the given reference table preset options.  The P_OPTS_QUERY is the query for the primary key values for the given options query with a primary key parameter that will be used with the defined primary key value (P_PK_VAL) when executing the query to return the associated primary key values.  The return value will be the colon-delimited string that contains any additional primary key values that were returned by the P_OPTS_QUERY
  FUNCTION APPEND_REF_PRE_OPTS_FN (P_DELIM_VALUES IN VARCHAR2, P_OPTS_QUERY IN VARCHAR2, P_PK_VAL IN NUMBER) RETURN VARCHAR2;


	--Deep copy cruise stored procedure:
	--This procedure accepts a P_CRUISE_ID parameter that contains the CRUISE_ID primary key integer value that will have all of its associated records copied (cruise name, leg names, and leg alias names will be copied with a naming convention but all other associated records will be loaded as-is to the new cruise record).  The value of P_PROC_RETURN_CODE is 1 if the cruise record was successfully processed and the records were copied and 0 if the procedure encountered any errors during execution, if there were errors the SQL transaction will be rolled back.  P_PROC_RETURN_MSG will contain a message to indicate that the procedure was completed successfully or unsuccessfully with information about the results so they can be provided to the user.  P_PROC_RETURN_CRUISE_ID contains the CRUISE_ID for the newly inserted cruise record so it can be provided to the user, in the APEX application it is used to construct a URL to allow an authorized user to view/edit the newly copied cruise record
	--Example usage:
	/*
	set serveroutput on;
	DECLARE
	    V_PROC_RETURN_CODE PLS_INTEGER;
        V_PROC_RETURN_MSG VARCHAR2(4000);
	    V_PROC_RETURN_CRUISE_ID PLS_INTEGER;


        V_RETURN_CODE PLS_INTEGER;
	BEGIN

      --execute the deep copy procedure:
	    CEN_CRUISE.CCD_CRUISE_PKG.DEEP_COPY_CRUISE_SP(:P220_CRUISE_ID, V_PROC_RETURN_CODE, V_PROC_RETURN_MSG, V_PROC_RETURN_CRUISE_ID);

      --set the return code and message to the corresponding page items:
      :P220_DEEP_COPY_RET_CODE := V_PROC_RETURN_CODE;
      :P220_DEEP_COPY_RET_MSG := V_PROC_RETURN_MSG;


	    IF (V_PROC_RETURN_CODE = 1) THEN
	        CEN_CRUISE.DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'P220 - Deep Copy', 'The deep copy was successful', V_RETURN_CODE);
	    ELSE
	        CEN_CRUISE.DB_LOG_PKG.ADD_LOG_ENTRY('ERROR', 'P220 - Deep Copy', 'The deep copy was NOT successful', V_RETURN_CODE);
	    END IF;
      CEN_CRUISE.DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'P220 - Deep Copy', V_PROC_RETURN_MSG, V_RETURN_CODE);
	END;
	*/
	PROCEDURE DEEP_COPY_CRUISE_SP (P_CRUISE_ID IN PLS_INTEGER, P_PROC_RETURN_CODE OUT PLS_INTEGER, P_PROC_RETURN_MSG OUT VARCHAR2, P_PROC_RETURN_CRUISE_ID OUT PLS_INTEGER);

	--procedure to copy all associated cruise values (e.g. CCD_CRUISE_EXP_SPP) from the source cruise (P_SOURCE_CRUISE_ID) to the new cruise (P_NEW_CRUISE_ID) utilizing the COPY_ASSOC_VALS procedure to actually copy the attribute records, the list of static tables are used as a parameter in addition to the foreign key field name for the CCD_CRUISES table.  The value of P_PROC_RETURN_CODE is 1 if the procedure was successfully processed and the records were copied and 0 if the procedure encountered any errors during execution, if there were errors the SQL transaction will be rolled back.
	PROCEDURE COPY_ASSOC_CRUISE_VALS (P_SOURCE_CRUISE_ID IN PLS_INTEGER, P_NEW_CRUISE_ID IN PLS_INTEGER, P_PROC_RETURN_CODE OUT PLS_INTEGER);

	--procedure to copy all associated cruise leg values (e.g.CCD_LEG_GEAR) from the source cruise (P_SOURCE_CRUISE_LEG_ID) to the new cruise (P_NEW_CRUISE_LEG_ID) utilizing the COPY_ASSOC_VALS procedure to actually copy the attribute records, the list of static tables are used as a parameter in addition to the foreign key field name for the CCD_CRUISE_LEGS table.  The value of P_PROC_RETURN_CODE is 1 if the procedure was successfully processed and the records were copied and 0 if the procedure encountered any errors during execution, if there were errors the SQL transaction will be rolled back.
	PROCEDURE COPY_ASSOC_LEG_VALS (P_SOURCE_CRUISE_LEG_ID IN PLS_INTEGER, P_NEW_CRUISE_LEG_ID IN PLS_INTEGER, P_PROC_RETURN_CODE OUT PLS_INTEGER);

	--procedure to copy all values associated with the given source cruise/cruise leg (based on P_PK_FIELD_NAME and P_SOURCE_ID) for the specified tables (P_TABLE_LIST array) and associate them with the new cruise/cruise leg (based on P_NEW_ID).  The value of P_PROC_RETURN_CODE is 1 if the procedure was successfully processed and the records were copied and 0 if the procedure encountered any errors during execution, if there were errors the SQL transaction will be rolled back.
	PROCEDURE COPY_ASSOC_VALS (P_TABLE_LIST IN apex_application_global.vc_arr2, P_PK_FIELD_NAME IN VARCHAR2, P_SOURCE_ID IN PLS_INTEGER, P_NEW_ID IN PLS_INTEGER, P_PROC_RETURN_CODE OUT PLS_INTEGER);

	--this procedure copies all leg aliases from the cruise leg with CRUISE_LEG_ID = P_SOURCE_LEG_ID to a newly inserted cruise leg with CRUISE_LEG_ID = P_NEW_LEG_ID modifying each leg alias to append (copy) to it.  The value of P_PROC_RETURN_CODE will be 1 if the procedure successfully processed the leg aliases from the given source leg to the new leg and 0 if it was not, if it was unsuccessful the SQL transaction will be rolled back.  The procedure checks for unique key constraint violations and reports any error message using the P_PROC_RETURN_MSG parameter
	PROCEDURE COPY_LEG_ALIASES (P_SOURCE_LEG_ID IN PLS_INTEGER, P_NEW_LEG_ID IN PLS_INTEGER, P_PROC_RETURN_CODE OUT PLS_INTEGER, P_PROC_RETURN_MSG OUT VARCHAR2);

	END CCD_CRUISE_PKG;
	/

	--cruise Package Body:
	create or replace PACKAGE BODY CCD_CRUISE_PKG
	--this package provides functions and procedures to interact with the CTD package module
	AS





	--function that accepts a P_LEG_ALIAS value and returns the CRUISE_LEG_ID value for the CCD_CRUISE_LEGS record that has a corresponding CCD_LEG_ALIASES record with a LEG_ALIAS_NAME that matches the P_LEG_ALIAS value.  It returns NULL if no match is found
		FUNCTION LEG_ALIAS_TO_CRUISE_LEG_ID_FN (P_LEG_ALIAS VARCHAR2)
			RETURN NUMBER is

						--variable to store the cruise_leg_id associated with the leg alias record with leg_alias_name = P_LEG_ALIAS
						v_cruise_leg_id NUMBER;

						--return code from procedure calls
						v_return_code PLS_INTEGER;

		BEGIN

				--query for the cruise_leg_id primary key value from the cruise leg that matches any associated leg aliases
        select ccd_cruise_legs_v.cruise_leg_id into v_cruise_leg_id
        from ccd_cruise_legs_v inner join ccd_leg_aliases on ccd_leg_aliases.cruise_leg_id = ccd_cruise_legs_v.cruise_leg_id
        AND UPPER(ccd_leg_aliases.LEG_ALIAS_NAME) = UPPER(P_LEG_ALIAS);


				--return the value of CRUISE_LEG_ID from the query
				RETURN v_cruise_leg_id;

				--exception handling:
				EXCEPTION

					WHEN NO_DATA_FOUND THEN

          --no results returned by the query, return NULL

					RETURN NULL;

					--catch all PL/SQL database exceptions:
					WHEN OTHERS THEN

					--catch all other errors:

					--return NULL to indicate the error:
					RETURN NULL;

		END LEG_ALIAS_TO_CRUISE_LEG_ID_FN;




    --Append Reference Preset Options function
    --function that accepts a list of colon-delimited integers (P_DELIM_VALUES) representing the primary key values of the given reference table preset options.  The P_OPTS_QUERY is the query for the primary key values for the given options query with a primary key parameter that will be used with the defined primary key value (P_PK_VAL) when executing the query to return the associated primary key values.  The return value will be the colon-delimited string that contains any additional primary key values that were returned by the P_OPTS_QUERY
  FUNCTION APPEND_REF_PRE_OPTS_FN (P_DELIM_VALUES IN VARCHAR2, P_OPTS_QUERY IN VARCHAR2, P_PK_VAL IN NUMBER) RETURN VARCHAR2

  IS

    --array to store the parsed colon-delimited values from P_DELIM_VALUES
    l_selected apex_application_global.vc_arr2;

    --return code to be used by calls to the DB_LOG_PKG package:
    V_RETURN_CODE PLS_INTEGER;

    --variable to track if the current result set primary key value is already contained in the colon-delimited list of values:
    V_ID_FOUND BOOLEAN := FALSE;

    --variable to store the current primary key value returned by the query:
    V_OPT_PK_VAL NUMBER;

    --reference cursor to handle dynamic query
    TYPE cur_typ IS REF CURSOR;

    --reference cursor variable:
    c cur_typ;

  BEGIN

    DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'APPEND_REF_PRE_OPTS', 'executing APPEND_REF_PRE_OPTS_FN('||P_DELIM_VALUES||', '||P_OPTS_QUERY||', '||P_PK_VAL||')', V_RETURN_CODE);

    --parse the P_DELIM_VALUES string into an array so they can be processed
   l_selected := apex_util.string_to_table(P_DELIM_VALUES);


    --query for the primary key values using the P_OPTS_QUERY and the primary key value P_PK_VAL and loop through the result set
    OPEN c FOR P_OPTS_QUERY USING P_PK_VAL;
      LOOP

          --retrieve the primary key values into the V_OPT_PK_VAL variable:
          FETCH c INTO V_OPT_PK_VAL;
          EXIT WHEN c%NOTFOUND;

          --initialize the V_ID_FOUND boolean variable to indicate that a matching primary key value has not been found in the l_selected array:
          V_ID_FOUND := FALSE;


        --loop through the l_selected array to check if there is a match for the current result set primary key value
        for i in 1..l_selected.count loop

--            DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'APPEND_REF_PRE_OPTS', 'The current shuttle option is: '||l_selected(i), V_RETURN_CODE);

            --check if the current l_selected array element matches the current result set primary key value
            IF (l_selected(i) = V_OPT_PK_VAL) THEN
              --the values match, update V_ID_FOUND to indicate that the match has been found
                V_ID_FOUND := TRUE;
            END IF;
        end loop;

        --check to see if a match has been found for the current result set primary key and the l_selected array elements
        IF NOT V_ID_FOUND THEN
          --a match has not been found, add the result set primary key value to the array:

--            DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'APPEND_REF_PRE_OPTS', 'None of the shuttle option values match the current option, add it to the l_selected array', V_RETURN_CODE);

            --add the ID to the list of selected values:
            l_selected(l_selected.count + 1) := V_OPT_PK_VAL;
        END IF;


      END LOOP;
    CLOSE c;



     DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'APPEND_REF_PRE_OPTS', 'The return value is: '||apex_util.table_to_string(l_selected, ':'), V_RETURN_CODE);

     --convert the array to a colon-delimited string so it can be used directly in a shuttle field
     return apex_util.table_to_string(l_selected, ':');

  END APPEND_REF_PRE_OPTS_FN;



	--Deep copy cruise stored procedure:
	--This procedure accepts a P_CRUISE_ID parameter that contains the CRUISE_ID primary key integer value that will have all of its associated records copied (cruise name, leg names, and leg alias names will be copied with a naming convention but all other associated records will be loaded as-is to the new cruise record).  The value of P_PROC_RETURN_CODE is 1 if the cruise record was successfully processed and the records were copied and 0 if the procedure encountered any errors during execution, if there were errors the SQL transaction will be rolled back.  P_PROC_RETURN_MSG will contain a message to indicate that the procedure was completed successfully or unsuccessfully with information about the results so they can be provided to the user.  P_PROC_RETURN_CRUISE_ID contains the CRUISE_ID for the newly inserted cruise record so it can be provided to the user, in the APEX application it is used to construct a URL to allow an authorized user to view/edit the newly copied cruise record
	--Example usage:
	/*
	set serveroutput on;
	DECLARE
			V_PROC_RETURN_CODE PLS_INTEGER;

	BEGIN

			CCD_CRUISE_PKG.DEEP_COPY_CRUISE_SP(:cruise_id, V_PROC_RETURN_CODE);

			IF (V_PROC_RETURN_CODE = 1) THEN
					DBMS_OUTPUT.PUT_LINE('The deep copy was successful');
			ELSE
					DBMS_OUTPUT.PUT_LINE('The deep copy was NOT successful');

			END IF;

	END;
	*/
	PROCEDURE DEEP_COPY_CRUISE_SP (P_CRUISE_ID IN PLS_INTEGER, P_PROC_RETURN_CODE OUT PLS_INTEGER, P_PROC_RETURN_MSG OUT VARCHAR2, P_PROC_RETURN_CRUISE_ID OUT PLS_INTEGER) IS

    --return code to be used by calls to the DB_LOG_PKG package:
    V_RETURN_CODE PLS_INTEGER;

		--variable to store the cruise_id for the newly created cruise record:
		V_NEW_CRUISE_ID PLS_INTEGER;

		--variable to store the cruise_leg_id for the newly created cruise leg record:
		V_NEW_CRUISE_LEG_ID PLS_INTEGER;


		--variable to store the current cruise_leg_id that is being processed for the cruise that is being copied:
		V_CURR_CRUISE_LEG_ID PLS_INTEGER;


		--variable to hold the total number of associated cruise legs:
		V_NUM_LEGS PLS_INTEGER;

		--variable to store the dynamic query string:
		V_QUERY_STRING VARCHAR2(4000);

		--ref cursor type
		TYPE cur_typ IS REF CURSOR;

		--cursor type variable:
    c cur_typ;

		--record variable to store the CCD_CRUISES record values that are being copied from CRUISE_ID = P_CRUISE_ID to a new CCD_CRUISES record
    cruise_tab CCD_CRUISES%rowtype;

		--variable type for an array of CCD_CRUISE_LEGS rows that are used to store the value returned by the query for cruise legs associated with the existing CCD_CRUISES record where CRUISE_ID = P_CRUISE_ID
    type leg_tab is table of CCD_CRUISE_LEGS%rowtype index by binary_integer;

    --cruise leg table type variable to store the CCD_CRUISE_LEGS record values returned by the query for the given CCD_CRUISES record so they can be inserted and associated with the new cruise record
    v_leg_tab leg_tab;


		--variable to store the current leg name that is being processed so it can be reported in the event there is an error during the processing
		v_current_leg_name varchar2(2000);

		--variable to store the current cruise name that is being processed so it can be reported in the event there is an error during the processing
		v_current_cruise_name varchar2(2000);

	begin


  	DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'DEEP_COPY_CRUISE_SP', 'Running DEEP_COPY_CRUISE_SP('||P_CRUISE_ID||')', V_RETURN_CODE);

		--retrieve the current CCD_CRUISES record's information into the cruise_tab variable so it can be used to insert the new CCD_CRUISES record copy into the database
    SELECT * into cruise_tab from ccd_cruises where cruise_id = P_CRUISE_ID;


  	DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'DEEP_COPY_CRUISE_SP', 'The cruise record was queried successfully: '||cruise_tab.CRUISE_NAME, V_RETURN_CODE);

		--store the cruise name in v_current_cruise_name so it can be used for an error message if there was a unique key constraint violation
		v_current_cruise_name := cruise_tab.CRUISE_NAME;

		--insert the CCD_CRUISES record based on the values in the CCD_CRUISES record where CRUISE_ID = P_CRUISE_ID:
		--append the " (copy)" to the cruise name and reuse all other values from the copied cruise record:
		INSERT INTO CCD_CRUISES (CRUISE_NAME, CRUISE_NOTES, SVY_TYPE_ID, SCI_CENTER_DIV_ID, STD_SVY_NAME_ID, SVY_FREQ_ID, CRUISE_URL, CRUISE_CONT_EMAIL, STD_SVY_NAME_OTH, CRUISE_DESC, OBJ_BASED_METRICS)
		VALUES (cruise_tab.CRUISE_NAME||' (copy)', cruise_tab.CRUISE_NOTES, cruise_tab.SVY_TYPE_ID, cruise_tab.SCI_CENTER_DIV_ID, cruise_tab.STD_SVY_NAME_ID, cruise_tab.SVY_FREQ_ID, cruise_tab.CRUISE_URL, cruise_tab.CRUISE_CONT_EMAIL, cruise_tab.STD_SVY_NAME_OTH, cruise_tab.CRUISE_DESC, cruise_tab.OBJ_BASED_METRICS)
		RETURNING CCD_CRUISES.CRUISE_ID INTO V_NEW_CRUISE_ID;

		--set the value of the out parameter so the new cruise ID can be used in the application
		P_PROC_RETURN_CRUISE_ID := V_NEW_CRUISE_ID;

  	DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'DEEP_COPY_CRUISE_SP', 'The cruise record was copied successfully, new ID: '||V_NEW_CRUISE_ID, V_RETURN_CODE);

		--insert the associated cruise attributes:
		COPY_ASSOC_CRUISE_VALS (P_CRUISE_ID, V_NEW_CRUISE_ID, V_RETURN_CODE);

		--check to see if the cruise attributes were processed successfully
		IF (V_RETURN_CODE = 1) then
			--the cruise attributes were processed successfully

			DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'DEEP_COPY_CRUISE_SP', 'The associated cruise attributes were successfully copied', V_RETURN_CODE);


			--query for the number of cruise legs associated with the specified CCD_CRUISES record and store in the V_NUM_LEGS variable:
			SELECT count(*) INTO V_NUM_LEGS from ccd_cruise_legs where CRUISE_ID = P_CRUISE_ID;

			DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'DEEP_COPY_CRUISE_SP', 'The cruise legs were queried successfully, NUM_LEGS = '||V_NUM_LEGS, V_RETURN_CODE);


			--check to see if there are any legs associated with the specified cruise:
			IF (V_NUM_LEGS > 0) then
				--there were one or more cruise legs associated with the specified cruise record:

				DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'DEEP_COPY_CRUISE_SP', 'There are one or more cruise legs, query for them and copy them in the database', V_RETURN_CODE);

				--query for all associated cruise legs and store the results in v_leg_tab for processing
				select * bulk collect into v_leg_tab from ccd_cruise_legs where cruise_id = P_CRUISE_ID;

				--loop through each of the associated cruise legs and insert copies/associate attribute records:
				for i in v_leg_tab.first..v_leg_tab.last loop

					--set the current leg name so it can be used in the event there is a unique key constraint error:
					v_current_leg_name := v_leg_tab(i).LEG_NAME;

					DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'DEEP_COPY_CRUISE_SP', 'INSERT the new cruise leg copy - the value of v_leg_tab.CRUISE_LEG_ID is: '||v_leg_tab(i).CRUISE_LEG_ID, V_RETURN_CODE);

					--insert the new cruise leg with the values in the source cruise leg and " (copy)" appended to the leg name and associate it with the new cruise record that was just inserted (identified by V_NEW_CRUISE_ID).  Return the CCD_CRUISE_LEGS.CRUISE_LEG_ID primary key into V_NEW_CRUISE_LEG_ID so it can be used to associate the cruise leg attributes
					INSERT INTO CCD_CRUISE_LEGS (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID, VESSEL_ID, PLAT_TYPE_ID)
					VALUES (v_leg_tab(i).LEG_NAME||' (copy)', v_leg_tab(i).LEG_START_DATE, v_leg_tab(i).LEG_END_DATE, v_leg_tab(i).LEG_DESC, V_NEW_CRUISE_ID, v_leg_tab(i).VESSEL_ID, v_leg_tab(i).PLAT_TYPE_ID)
					RETURNING CRUISE_LEG_ID INTO V_NEW_CRUISE_LEG_ID;

					DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'DEEP_COPY_CRUISE_SP', 'The cruise leg copy was successfully inserted - the value of V_NEW_CRUISE_LEG_ID is: '||V_NEW_CRUISE_LEG_ID, V_RETURN_CODE);

					--Copy the source cruise leg attributes to the newly inserted cruise leg record::
					COPY_ASSOC_LEG_VALS (v_leg_tab(i).CRUISE_LEG_ID, V_NEW_CRUISE_LEG_ID, V_RETURN_CODE);

					--check if the cruise leg attributes were processed successfully
					IF (V_RETURN_CODE = 1) THEN
						--the associated attributes for the new cruise leg were processed successfully:

						DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'DEEP_COPY_CRUISE_SP', 'The cruise leg copy was successfully inserted, copy the leg aliases - the value of V_NEW_CRUISE_LEG_ID is: '||V_NEW_CRUISE_LEG_ID, V_RETURN_CODE);


						--copy the cruise leg aliases:
						COPY_LEG_ALIASES (v_leg_tab(i).CRUISE_LEG_ID, V_NEW_CRUISE_LEG_ID, V_RETURN_CODE, P_PROC_RETURN_MSG);

						--check if the leg aliases were processed successfully
						IF (V_RETURN_CODE = 1) then
							--the leg aliases were processed successfully:

							DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'DEEP_COPY_CRUISE_SP', 'The leg aliases were processed successfully', V_RETURN_CODE);

						else
							--there was an error processing the current cruise leg's attributes
							DB_LOG_PKG.ADD_LOG_ENTRY('ERROR', 'DEEP_COPY_CRUISE_SP', 'The cruise leg attributes were NOT successfully processed', V_RETURN_CODE);

							--set the return code to indicate the unsuccessful processing:
							P_PROC_RETURN_CODE := 0;

							--stop the current loop, the current leg's attributes were not processed successfully
							EXIT;

						END IF;

					ELSE
						--the associated attributes for the new cruise leg were not processed successfully:
						DB_LOG_PKG.ADD_LOG_ENTRY('ERROR', 'DEEP_COPY_CRUISE_SP', 'The cruise leg attributes were NOT successfully processed', V_RETURN_CODE);

						--set the return code to indicate the unsuccessful processing:
						P_PROC_RETURN_CODE := 0;

						--set the error message
						P_PROC_RETURN_MSG := 'The attributes associated with the cruise leg "'||v_leg_tab(i).LEG_NAME||'" were not successfully copied to the new cruise leg';

						--stop the current loop, the current leg's attributes were not processed successfully
						EXIT;

					END IF;
				end loop;

				DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'DEEP_COPY_CRUISE_SP', 'The cruise legs were successfully processed', V_RETURN_CODE);

			END IF;


		ELSE
			--the associated cruise values were not copied successfully:
				DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'DEEP_COPY_CRUISE_SP', 'The associated cruise attributes were NOT successfully copied', V_RETURN_CODE);

				--generate the error message to indicate the "deep copy" was unsuccessful
				P_PROC_RETURN_MSG := 'The Cruise "'||cruise_tab.CRUISE_NAME||'" could not have its associated attributes copied to the new Cruise';

				--return the error code:
				P_PROC_RETURN_CODE := 0;

		END IF;

		--check the return code value, if there is no error reported then set the return code to 1 to indicate success and generate the success message
		IF P_PROC_RETURN_CODE IS NULL OR P_PROC_RETURN_CODE != 0 THEN

			--generate the success message to indicate the "deep copy" was successful, if the script reaches this point it was successful
			P_PROC_RETURN_MSG := 'The Cruise "'||cruise_tab.CRUISE_NAME||'" was successfully copied as "'||cruise_tab.CRUISE_NAME||' (copy)" and '||V_NUM_LEGS||' legs were copied and associated with the new Cruise';

			--return the success code:
			P_PROC_RETURN_CODE := 1;

		END IF;




		--exception handling:
    EXCEPTION

				--checkk for no data found errors (when querying for the CCD_CRUISES record)
				WHEN NO_DATA_FOUND then
					--the CCD_CRUISES record identified by P_CRUISE_ID could not be retrieved successfully

					DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'DEEP_COPY_CRUISE_SP', 'The Cruise could not be retrieved successfully: ' || SQLCODE || '- ' || SQLERRM, V_RETURN_CODE);


					--define the error message to indicate the copied leg name caused a unique key error
					P_PROC_RETURN_MSG := 'The Cruise (Cruise ID: '||P_CRUISE_ID||') could not be retrieved successfully';

					--return the error code:
					P_PROC_RETURN_CODE := 0;

					DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'DEEP_COPY_CRUISE_SP', 'The value of P_PROC_RETURN_CODE is: '||P_PROC_RETURN_CODE, V_RETURN_CODE);


				--check for unique key errors
				WHEN DUP_VAL_ON_INDEX THEN
						--there was a unique key index error, check if this was during the insertion of the cruise record or an associated leg record:

  					DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'DEEP_COPY_CRUISE_SP', 'The Cruise/Cruise Leg could not be copied successfully, there was a unique key constraint error: ' || SQLCODE || '- ' || SQLERRM, V_RETURN_CODE);

						--check to see if the cruise leg name is set, if not then there were no legs processed so it must be the cruise that was not processed successfully with the unique key constraint:
						if (v_current_leg_name IS NULL) THEN
							--this was an error when processing the CCD_CRUISES table:

							--define the error message to indicate that the copied cruise name caused a unique key error:
							P_PROC_RETURN_MSG := 'The Cruise "'||v_current_cruise_name||'" could not be copied successfully, there is already a cruise named "'||v_current_cruise_name||' (copy)"';

	  					DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'DEEP_COPY_CRUISE_SP', 'The Cruise could not be copied successfully, there was a unique key constraint error: ' || SQLCODE || '- ' || SQLERRM, V_RETURN_CODE);
						else
							--this was an error when processing the CCD_CRUISE_LEGS table:
	  					DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'DEEP_COPY_CRUISE_SP', 'The Cruise leg "'||v_current_leg_name||'" could not be copied successfully, there was already a cruise leg named "'||v_current_leg_name||' (copy)"', V_RETURN_CODE);


							--define the error message to indicate the copied leg name caused a unique key error
							P_PROC_RETURN_MSG := 'The Cruise leg "'||v_current_leg_name||'" could not be copied successfully, there was already a cruise leg named "'||v_current_leg_name||' (copy)"';

						END IF;

            --there was a PL/SQL error, rollback the SQL transaction:
            ROLLBACK;

						--return the error code:
						P_PROC_RETURN_CODE := 0;

  					DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'DEEP_COPY_CRUISE_SP', 'The value of P_PROC_RETURN_CODE is: '||P_PROC_RETURN_CODE, V_RETURN_CODE);


        --catch all PL/SQL database exceptions:
        WHEN OTHERS THEN
            --catch all other errors:

  					DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'DEEP_COPY_CRUISE_SP', 'This is an "OTHERS" exception: '||P_PROC_RETURN_CODE, V_RETURN_CODE);

            --print out error message:
            DBMS_OUTPUT.PUT_LINE('The error code is ' || SQLCODE || '- ' || SQLERRM);

  					DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'DEEP_COPY_CRUISE_SP', 'The error code is ' || SQLCODE || '- ' || SQLERRM, V_RETURN_CODE);

            --there was a PL/SQL error, rollback the SQL transaction:
            ROLLBACK;

						--set the error message:
						P_PROC_RETURN_MSG := 'The Cruise "'||cruise_tab.CRUISE_NAME||'" and associated attributes could not be copied successfully';

						--return the error code:
						P_PROC_RETURN_CODE := 0;

	end DEEP_COPY_CRUISE_SP;



	--procedure to copy all associated cruise values (e.g. CCD_CRUISE_EXP_SPP) from the source cruise (P_SOURCE_CRUISE_ID) to the new cruise (P_NEW_CRUISE_ID) utilizing the COPY_ASSOC_VALS procedure to actually copy the attribute records, the list of static tables are used as a parameter in addition to the foreign key field name for the CCD_CRUISES table.  The value of P_PROC_RETURN_CODE is 1 if the procedure was successfully processed and the records were copied and 0 if the procedure encountered any errors during execution, if there were errors the SQL transaction will be rolled back.
	PROCEDURE COPY_ASSOC_CRUISE_VALS (P_SOURCE_CRUISE_ID IN PLS_INTEGER, P_NEW_CRUISE_ID IN PLS_INTEGER, P_PROC_RETURN_CODE OUT PLS_INTEGER) IS

    --return code to be used by calls to the DB_LOG_PKG package:
    V_RETURN_CODE PLS_INTEGER;

		--string array variable to define the different cruise attribute tables:
		P_TABLE_LIST apex_application_global.vc_arr2;


	BEGIN


		DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'COPY_ASSOC_CRUISE_VALS', 'Running COPY_ASSOC_CRUISE_VALS ('||P_SOURCE_CRUISE_ID||', '||P_NEW_CRUISE_ID||')', V_RETURN_CODE);


		--define the different cruise attribute tables that need to be processed in a new array:
		P_TABLE_LIST(1) := 'CCD_CRUISE_EXP_SPP';
		P_TABLE_LIST(2) := 'CCD_CRUISE_SPP_ESA';
		P_TABLE_LIST(3) := 'CCD_CRUISE_SPP_FSSI';
		P_TABLE_LIST(4) := 'CCD_CRUISE_SPP_MMPA';
		P_TABLE_LIST(5) := 'CCD_CRUISE_SVY_CATS';
		P_TABLE_LIST(6) := 'CCD_TGT_SPP_OTHER';

		--copy all of the associated records with the source cruise to the new cruise
		COPY_ASSOC_VALS (P_TABLE_LIST, 'CRUISE_ID', P_SOURCE_CRUISE_ID, P_NEW_CRUISE_ID, P_PROC_RETURN_CODE);

    EXCEPTION

      WHEN OTHERS THEN
        --catch all other errors:

        --print out error message:
        DBMS_OUTPUT.PUT_LINE('The error code is ' || SQLCODE || '- ' || SQLERRM);

				DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'COPY_ASSOC_CRUISE_VALS', 'The error code is ' || SQLCODE || '- ' || SQLERRM, V_RETURN_CODE);

        --there was a PL/SQL error, rollback the SQL transaction:
        ROLLBACK;

				--set the error code:
				P_PROC_RETURN_CODE := 0;

	END COPY_ASSOC_CRUISE_VALS;


	--procedure to copy all associated cruise leg values (e.g.CCD_LEG_GEAR) from the source cruise (P_SOURCE_CRUISE_LEG_ID) to the new cruise (P_NEW_CRUISE_LEG_ID) utilizing the COPY_ASSOC_VALS procedure to actually copy the attribute records, the list of static tables are used as a parameter in addition to the foreign key field name for the CCD_CRUISE_LEGS table.  The value of P_PROC_RETURN_CODE is 1 if the procedure was successfully processed and the records were copied and 0 if the procedure encountered any errors during execution, if there were errors the SQL transaction will be rolled back.
	PROCEDURE COPY_ASSOC_LEG_VALS (P_SOURCE_CRUISE_LEG_ID IN PLS_INTEGER, P_NEW_CRUISE_LEG_ID IN PLS_INTEGER, P_PROC_RETURN_CODE OUT PLS_INTEGER) IS

		--return code to be used by calls to the DB_LOG_PKG package:
		V_RETURN_CODE PLS_INTEGER;

		--string array variable to define the different cruise leg attribute tables:
		P_TABLE_LIST apex_application_global.vc_arr2;


	BEGIN

		DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'COPY_ASSOC_LEG_VALS', 'Running COPY_ASSOC_LEG_VALS ('||P_SOURCE_CRUISE_LEG_ID||', '||P_NEW_CRUISE_LEG_ID||')', V_RETURN_CODE);


		--define the different cruise leg attribute tables that need to be processed in a new array:
		P_TABLE_LIST(1) := 'CCD_LEG_ECOSYSTEMS';
		P_TABLE_LIST(2) := 'CCD_LEG_GEAR';
		P_TABLE_LIST(3) := 'CCD_LEG_REGIONS';

		--copy all of the associated records with the source cruise leg to the new cruise leg
		COPY_ASSOC_VALS (P_TABLE_LIST, 'CRUISE_LEG_ID', P_SOURCE_CRUISE_LEG_ID, P_NEW_CRUISE_LEG_ID, P_PROC_RETURN_CODE);

		EXCEPTION

			WHEN OTHERS THEN
				--catch all other errors:

				--print out error message:
				DBMS_OUTPUT.PUT_LINE('The error code is ' || SQLCODE || '- ' || SQLERRM);

				DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'COPY_ASSOC_LEG_VALS', 'The error code is ' || SQLCODE || '- ' || SQLERRM, V_RETURN_CODE);

				--there was a PL/SQL error, rollback the SQL transaction:
				ROLLBACK;

				--set the error code:
				P_PROC_RETURN_CODE := 0;
	END COPY_ASSOC_LEG_VALS;


	--procedure to copy all values associated with the given source cruise/cruise leg (based on P_PK_FIELD_NAME and P_SOURCE_ID) for the specified tables (P_TABLE_LIST array) and associate them with the new cruise/cruise leg (based on P_NEW_ID).  The value of P_PROC_RETURN_CODE is 1 if the procedure was successfully processed and the records were copied and 0 if the procedure encountered any errors during execution, if there were errors the SQL transaction will be rolled back.
	PROCEDURE COPY_ASSOC_VALS (P_TABLE_LIST IN apex_application_global.vc_arr2, P_PK_FIELD_NAME IN VARCHAR2, P_SOURCE_ID IN PLS_INTEGER, P_NEW_ID IN PLS_INTEGER, P_PROC_RETURN_CODE OUT PLS_INTEGER) IS

    --return code to be used by calls to the DB_LOG_PKG package:
    V_RETURN_CODE PLS_INTEGER;

		--string array variable to store the different columns for a given cruise attribute table:
		V_FIELD_LIST apex_application_global.vc_arr2;

		--variable to store the number records for the given attribute table that are related to the cruise that is being copied:
		V_NUM_ATTRIBUTES PLS_INTEGER;

		--variable to store the dynamic query string:
		V_QUERY_STRING VARCHAR2(4000);

	BEGIN


	--loop through each table, query for the fields that should be set from the source record and then construct the INSERT-SELECT queries for each of the cruise/cruise leg attributes:
  for i in 1..P_TABLE_LIST.count LOOP

		DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'COPY_ASSOC_VALS', 'Process the current table: '||P_TABLE_LIST(i), V_RETURN_CODE);

		--generate the SQL to check if there are any records for each of the attribute tables, if not there is no need to process them:
		V_QUERY_STRING := 'SELECT count(*) FROM '||P_TABLE_LIST(i)||' WHERE '||P_PK_FIELD_NAME||' = :PK_ID';

		--execute the query and store the record count as V_NUM_ATTRIBUTES
		EXECUTE IMMEDIATE V_QUERY_STRING INTO V_NUM_ATTRIBUTES USING P_SOURCE_ID;

		DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'COPY_ASSOC_VALS', 'The number of records for the current attribute table is: '||V_NUM_ATTRIBUTES, V_RETURN_CODE);

		--check to see if there are any associated records for the current attribute table:
		IF (V_NUM_ATTRIBUTES > 0) THEN
			--there are one or more records associated with the current cruise/cruise leg attribute table

			DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'COPY_ASSOC_VALS', 'There was at least one associated record for the current attribute table, generate the INSERT..SELECT query', V_RETURN_CODE);


			--query for all of the field names that are not auditing fields or the PK field (P_PK_FIELD_NAME) so the values can be used to generate a SQL insert statement to insert the attribute table records associated with the source record (P_SOURCE_ID for either CCD_CRUISES or CCD_CRUISE_LEGS based on P_PK_FIELD_NAME) for the destination record (P_NEW_ID):
			select distinct user_tab_cols.column_name bulk collect into V_FIELD_LIST
			from user_tab_cols
			where user_tab_cols.table_name = P_TABLE_LIST(i) AND user_tab_cols.column_name not in ('CREATE_DATE', 'CREATED_BY', P_PK_FIELD_NAME)
			AND user_tab_cols.column_name not in (select user_cons_columns.column_name from user_cons_columns inner join user_constraints on user_constraints.constraint_name = user_cons_columns.constraint_name and user_constraints.owner = user_cons_columns.owner WHERE user_constraints.constraint_type = 'P' AND user_cons_columns.table_name = user_tab_cols.table_name AND user_cons_columns.owner = sys_context( 'userenv', 'current_schema' ));

			DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'COPY_ASSOC_VALS', 'The attribute table query was successful, generate the INSERT..SELECT query', V_RETURN_CODE);

			--construct the SQL INSERT statement to insert the current attribute record for the new cruise/cruise leg record (based on P_PK_FIELD_NAME) based on the source record (P_SOURCE_ID) for the new record (P_NEW_ID)
			V_QUERY_STRING := 'INSERT INTO '||P_TABLE_LIST(i)||' ('||apex_util.table_to_string(V_FIELD_LIST, ',')||', '||P_PK_FIELD_NAME||') SELECT '||apex_util.table_to_string(V_FIELD_LIST, ',')||', :NEW_ID FROM '||P_TABLE_LIST(i)||' WHERE '||P_PK_FIELD_NAME||' = :SOURCE_ID';

			DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'COPY_ASSOC_VALS', 'The value of the generated string is: '||V_QUERY_STRING, V_RETURN_CODE);

			--execute the SQL INSERT query:
			EXECUTE IMMEDIATE V_QUERY_STRING USING P_NEW_ID, P_SOURCE_ID;

			DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'COPY_ASSOC_VALS', 'The insert-select query was successful', V_RETURN_CODE);


		END IF;
  END LOOP;

	--the procedure finished executing, the execution was successful:
	P_PROC_RETURN_CODE := 1;

	--handle SQL exceptions
  EXCEPTION

		WHEN NO_DATA_FOUND then
			--one of the queries did not return any results (maybe the table doesn't exist or the associated records don't exist for one of the tables)

      DBMS_OUTPUT.PUT_LINE('There was a NO_DATA_FOUND error:' || SQLCODE || '- ' || SQLERRM);

			DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'COPY_ASSOC_VALS', 'The error code is ' || SQLCODE || '- ' || SQLERRM, V_RETURN_CODE);

      --there was a PL/SQL error, rollback the SQL transaction:
      ROLLBACK;

			--indicate there was an error:
			P_PROC_RETURN_CODE := 0;

    --catch all PL/SQL database exceptions:
    WHEN OTHERS THEN
      --catch all other errors:

      --print out error message:
      DBMS_OUTPUT.PUT_LINE('The error code is ' || SQLCODE || '- ' || SQLERRM);

			DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'COPY_ASSOC_VALS', 'The error code is ' || SQLCODE || '- ' || SQLERRM, V_RETURN_CODE);

      --there was a PL/SQL error, rollback the SQL transaction:
      ROLLBACK;

			--indicate there was an error:
			P_PROC_RETURN_CODE := 0;

	END COPY_ASSOC_VALS;


	--this procedure copies all leg aliases from the cruise leg with CRUISE_LEG_ID = P_SOURCE_LEG_ID to a newly inserted cruise leg with CRUISE_LEG_ID = P_NEW_LEG_ID modifying each leg alias to append (copy) to it.  The value of P_PROC_RETURN_CODE will be 1 if the procedure successfully processed the leg aliases from the given source leg to the new leg and 0 if it was not, if it was unsuccessful the SQL transaction will be rolled back.  The procedure checks for unique key constraint violations and reports any error message using the P_PROC_RETURN_MSG parameter
	PROCEDURE COPY_LEG_ALIASES (P_SOURCE_LEG_ID IN PLS_INTEGER, P_NEW_LEG_ID IN PLS_INTEGER, P_PROC_RETURN_CODE OUT PLS_INTEGER, P_PROC_RETURN_MSG OUT VARCHAR2) IS
    --return code to be used by calls to the DB_LOG_PKG package:
    V_RETURN_CODE PLS_INTEGER;

		--type to store CCD_LEG_ALIASES records from a BULK_COLLECT query:
    type leg_alias_table is table of CCD_LEG_ALIASES%rowtype index by binary_integer;

		--variable to store CCD_LEG_ALIASES records
		v_leg_aliases leg_alias_table;

		--variable to store the number of leg alias records (CCD_LEG_ALIASES) associated with the source cruise leg record
		v_num_aliases PLS_INTEGER;

		--variable to store the current leg alias name
		v_curr_leg_alias_name VARCHAR2(1000);

	BEGIN

		DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'COPY_LEG_ALIASES', 'Running COPY_LEG_ALIASES ('||P_SOURCE_LEG_ID||','||P_NEW_LEG_ID||')', V_RETURN_CODE);

		--query for the number of leg alias records associated with the specified leg
		SELECT COUNT(*) into v_num_aliases from CCD_LEG_ALIASES where CRUISE_LEG_ID = P_SOURCE_LEG_ID;

		DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'COPY_LEG_ALIASES', 'There are '||v_num_aliases||' leg aliases for the specified cruise leg', V_RETURN_CODE);


		--check to see if there are any legs aliases associated with the specified cruise leg:
		IF (v_num_aliases > 0) then
			--there are one or more leg aliases for the specified leg

			--retrieve all of the leg aliases for the specified leg (P_SOURCE_LEG_ID) and store in the v_leg_aliases variable:
			SELECT * bulk collect INTO v_leg_aliases FROM CCD_LEG_ALIASES where CRUISE_LEG_ID = P_SOURCE_LEG_ID order by UPPER(LEG_ALIAS_NAME);

			--loop through the leg aliases and insert them for the new cruise leg (P_NEW_LEG_ID)
	    for i in v_leg_aliases.first..v_leg_aliases.last loop

				DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'COPY_LEG_ALIASES', 'Insert the leg alias: '||v_leg_aliases(i).LEG_ALIAS_NAME, V_RETURN_CODE);

				--save the current leg alias name so it can be used to generate an error message in the event of a PL/SQL or DB error:
				v_curr_leg_alias_name := v_leg_aliases(i).LEG_ALIAS_NAME;

				--insert the leg alias with the alias name convention " (copy)" appended for the new cruise leg (P_NEW_LEG_ID)
				INSERT INTO CCD_LEG_ALIASES (LEG_ALIAS_NAME, LEG_ALIAS_DESC, CRUISE_LEG_ID) VALUES (v_leg_aliases(i).LEG_ALIAS_NAME||' (copy)', v_leg_aliases(i).LEG_ALIAS_DESC, P_NEW_LEG_ID);

				DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'COPY_LEG_ALIASES', 'Insert the leg alias: '||v_leg_aliases(i).LEG_ALIAS_NAME, V_RETURN_CODE);

			end loop;

		END IF;

		--set the successful procedure code if the code reaches this point:
		P_PROC_RETURN_CODE := 1;

		--handle exceptions
    EXCEPTION

			--check for unique key constraint errors
			WHEN DUP_VAL_ON_INDEX THEN

				DB_LOG_PKG.ADD_LOG_ENTRY('ERROR', 'COPY_LEG_ALIASES', 'The Cruise leg alias "'||v_curr_leg_alias_name||'" could not be copied successfully, there was already a cruise leg alias "'||v_curr_leg_alias_name||' (copy)"', V_RETURN_CODE);

				--generate the error message for the leg alias that was not copied successfully
				P_PROC_RETURN_MSG := 'The Cruise leg alias "'||v_curr_leg_alias_name||'" could not be copied successfully, there was already a cruise leg alias "'||v_curr_leg_alias_name||' (copy)"';

        --there was a PL/SQL error, rollback the SQL transaction:
        ROLLBACK;

				--return the error code:
				P_PROC_RETURN_CODE := 0;


				DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'COPY_LEG_ALIASES', 'The value of P_PROC_RETURN_CODE is: '||P_PROC_RETURN_CODE, V_RETURN_CODE);


      --catch all PL/SQL database exceptions:
      WHEN OTHERS THEN
        --catch all other errors:


				DB_LOG_PKG.ADD_LOG_ENTRY('ERROR', 'COPY_LEG_ALIASES', 'The Cruise leg alias "'||v_curr_leg_alias_name||'" could not be copied successfully', V_RETURN_CODE);

				--generate the error message for the leg alias that was not copied successfully
				P_PROC_RETURN_MSG := 'The Cruise leg alias "'||v_curr_leg_alias_name||'" could not be copied successfully';

        --there was a PL/SQL error, rollback the SQL transaction:
        ROLLBACK;

				--return the error code:
				P_PROC_RETURN_CODE := 0;

				DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'COPY_LEG_ALIASES', 'The value of P_PROC_RETURN_CODE is: '||P_PROC_RETURN_CODE, V_RETURN_CODE);

	END COPY_LEG_ALIASES;

	end CCD_CRUISE_PKG;

/



--define the upgrade version in the database upgrade log table:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('Centralized Cruise Database', '0.10', TO_DATE('22-APR-20', 'DD-MON-YY'), 'Updated the CCD_CRUISES.CRUISE_NAME and CCD_CRUISE_LEGS.LEG_NAME to have longer values now that the "deep copy" functionality has been implemented.  Renamed the CRUISE_PKG package to CCD_CRUISE_PKG and the LEG_ALIAS_TO_CRUISE_LEG_ID function to LEG_ALIAS_TO_CRUISE_LEG_ID_FN to conform with established naming conventions.  Implemented stored procedures to perform the "deep copy" of a cruise and all associated cruise legs and cruise/leg attributes, the DEEP_COPY_CRUISE_SP stored procedure is the procedure to execute to copy a given CCD_CRUISES record.');

--commit the DB_UPGRADE_LOGS record insertion
COMMIT;

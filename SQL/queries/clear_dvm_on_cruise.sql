--old data model
update ccd_cruises set pta_error_id = NULL where pta_error_id = :peid;
delete from dvm_pta_err_typ_assoc where pta_error_id = :peid;
delete from dvm_errors where pta_error_id = :peid;
delete from dvm_pta_errors where pta_error_id = :peid;


--new data model
update ccd_cruises set pta_iss_id = NULL where pta_iss_id = :peid;
delete from dvm_issues where pta_iss_id = :peid;
delete from dvm_pta_rule_sets where pta_iss_id = :peid;
delete from dvm_pta_issues where pta_iss_id = :peid;



--new data model - all PTA records and specific validation issues
update ccd_cruises set pta_iss_id = NULL;
delete from dvm_issues;
delete from dvm_pta_rule_sets;
delete from dvm_iss_typ_assoc;
delete from dvm_rule_sets;
delete from dvm_pta_issues;



--code to remove the issues for a given cruise record so it can be evaluated from scratch:
set serveroutput on;
declare


	V_TEMP_PTA_ISS_ID PLS_INTEGER;



begin

	SELECT pta_iss_id into V_TEMP_PTA_ISS_ID from ccd_cruises where UPPER(cruise_name) = UPPER(:cruise_name);

	update ccd_cruises set pta_iss_id = NULL where UPPER(cruise_name) = UPPER(:cruise_name);

	delete from dvm_issues where pta_iss_id = V_TEMP_PTA_ISS_ID;
	delete from dvm_pta_rule_sets where pta_iss_id = V_TEMP_PTA_ISS_ID;
	delete from dvm_pta_issues where pta_iss_id = V_TEMP_PTA_ISS_ID;

	DBMS_OUTPUT.PUT_LINE('The cruise '||:cruise_name||' was successfully updated to remove associated DVM records');

	exception
		when others then

			DBMS_OUTPUT.PUT_LINE('The Oracle error code is ' || SQLCODE || '- ' || SQLERRM);

END;
/



/*
--delete all DVM recs and update CCD_CRUISES table
update ccd_cruises set pta_iss_id = NULL;
delete from dvm_issues;
delete from dvm_pta_rule_sets;
DELETE FROM DVM_ISS_TYP_ASSOC;
delete from dvm_rule_sets;


delete from dvm_pta_issues;
*/

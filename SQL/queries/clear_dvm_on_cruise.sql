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

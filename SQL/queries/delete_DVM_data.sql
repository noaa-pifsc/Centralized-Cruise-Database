--delete the DVM data (PTA and specific issues)

update ccd_cruises set pta_iss_id = NULL;
delete from dvm_issues;
delete from dvm_pta_rule_sets;
delete from dvm_pta_issues;

delete from dvm_iss_typ_assoc;
delete from dvm_rule_sets;

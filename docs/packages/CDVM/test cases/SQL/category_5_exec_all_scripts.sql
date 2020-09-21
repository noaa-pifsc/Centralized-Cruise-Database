@@"../../../../../SQL/queries/delete_all_DVM_recs.sql";
@@"../../../../../SQL/queries/delete_ref_data.sql";


@@"./category_5_load_test_data.sql";
@@"./category_1_load_DVM_rules.sql";
COMMIT;

@@"./category_5_exec_DVM.sql";

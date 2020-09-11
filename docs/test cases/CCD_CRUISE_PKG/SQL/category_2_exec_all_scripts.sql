@@"../../../../SQL/queries/delete_all_DVM_recs.sql";
@@"../../../../SQL/queries/delete_ref_data.sql";


@@"./category_1_load_test_data.sql";
@@"../../DVM_PKG/SQL/category_1_load_DVM_rules.sql";
COMMIT;

@@"./category_2_exec_test_cases.sql";

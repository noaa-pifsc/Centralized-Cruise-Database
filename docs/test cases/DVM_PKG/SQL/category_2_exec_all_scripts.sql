@@"../../../../SQL/queries/delete_all_DVM_recs.sql";
@@"../../../../SQL/queries/delete_ref_data.sql";


@@"./category_1_load_test_data.sql";
@@"./category_1_load_DVM_rules.sql";
COMMIT;

@@"../../../../SQL/queries/batch_DVM_script.sql";

@@"./category_2_data_updates.sql";
COMMIT;

@@"../../../../SQL/queries/batch_DVM_script.sql";

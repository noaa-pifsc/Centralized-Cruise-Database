@@"../delete_all_DVM_recs.sql";
@@"../delete_ref_data.sql";

--load CCD test data for CTD tests:
@@"./CTD_test_case_load_ref_data.sql";

--load DVM test rules
@@"../../../docs/packages/CDVM/test_cases/SQL/category_1_load_DVM_rules.sql";

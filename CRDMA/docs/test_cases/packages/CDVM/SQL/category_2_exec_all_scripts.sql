--delete the DVM data and rules
@@"../../../../../../SQL/queries/delete_DVM_data.sql";
@@"../../../../../../SQL/queries/delete_DVM_rules.sql";
@@"../../../../../../SQL/queries/delete_ref_data.sql";

--load the category 1 DVM rules
@@"../../../../../../docs/packages/CDVM/test_cases/SQL/category_1_load_DVM_rules.sql";

--load the reference data:
@@"../../../../../../docs/packages/CDVM/test_cases/SQL/category_1_load_test_data.sql";


COMMIT;

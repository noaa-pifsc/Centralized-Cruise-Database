--delete the DVM data and rules
@@"../../../../SQL/queries/delete_all_DVM_recs.sql";
@@"../../../../SQL/queries/delete_ref_data.sql";

--load the category 1 DVM rules
@@"../../../../docs/packages/CDVM/test cases/SQL/category_1_load_DVM_rules.sql";

--load the reference data:
@@"./load_CRDMA_test_data.sql";

COMMIT;

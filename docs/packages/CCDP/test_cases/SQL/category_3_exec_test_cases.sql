set serveroutput on;




DECLARE 
   
    V_MAIN_QUERY VARCHAR2 (4000) := 'SELECT
    REG_ECOSYSTEM_NAME OPTION_VALUE, REG_ECOSYSTEM_ID OPTION_ID FROM CCD_REG_ECOSYSTEMS where REG_ECOSYSTEM_ID IN
    (
        SELECT DISTINCT REG_ECOSYSTEM_ID
        FROM
        (SELECT REG_ECOSYSTEM_ID FROM CCD_REG_ECOSYSTEMS where (:SHOW_FILT_LIST = ''Y'' AND APP_SHOW_OPT_YN = ''Y'') OR (:SHOW_FILT_LIST IS NULL)

        UNION
        SELECT REG_ECOSYSTEM_ID from CCD_LEG_ECOSYSTEMS where CRUISE_LEG_ID IN (:PK_ID)
        [[QUERY_FRAG]])
    )
    ORDER BY UPPER(REG_ECOSYSTEM_NAME)';

    V_QUERY_FRAG VARCHAR2 (4000) := 'UNION SELECT REG_ECOSYSTEM_ID FROM CCD_REG_ECOSYSTEMS where REG_ECOSYSTEM_ID IN ([[OPTION_IDS]])';
    
    V_INCL_OPTION_IDS VARCHAR2(2000) := '11:6';
    V_FILT_ENABLED_YN CHAR(1) := 'Y';
    
    V_PRIM_KEY_VAL PLS_INTEGER := 34;

BEGIN

    DBMS_OUTPUT.PUT_LINE ('running CCD_CRUISE_PKG.UPDATE_FIL_SHUTTLE_OPTIONS_SP test case - filtered leg regional ecosystems with no options associated with the leg and two additional options (Great Lakes, Southeast Shelf) included as specific option IDs');


    CCD_CRUISE_PKG.UPDATE_FIL_SHUTTLE_OPTIONS_SP (V_MAIN_QUERY, V_QUERY_FRAG, TO_CHAR(V_INCL_OPTION_IDS), V_FILT_ENABLED_YN, TO_NUMBER(V_PRIM_KEY_VAL), FALSE);

    DBMS_OUTPUT.PUT_LINE ('the procedure was successful');

END;
/






DECLARE 
   
    V_MAIN_QUERY VARCHAR2 (4000) := 'SELECT
    REG_ECOSYSTEM_NAME OPTION_VALUE, REG_ECOSYSTEM_ID OPTION_ID FROM CCD_REG_ECOSYSTEMS where REG_ECOSYSTEM_ID IN
    (
        SELECT DISTINCT REG_ECOSYSTEM_ID
        FROM
        (SELECT REG_ECOSYSTEM_ID FROM CCD_REG_ECOSYSTEMS where (:SHOW_FILT_LIST = ''Y'' AND APP_SHOW_OPT_YN = ''Y'') OR (:SHOW_FILT_LIST IS NULL)

        UNION
        SELECT REG_ECOSYSTEM_ID from CCD_LEG_ECOSYSTEMS where CRUISE_LEG_ID IN (:PK_ID)
        [[QUERY_FRAG]])
    )
    ORDER BY UPPER(REG_ECOSYSTEM_NAME)';

    V_QUERY_FRAG VARCHAR2 (4000) := 'UNION SELECT REG_ECOSYSTEM_ID FROM CCD_REG_ECOSYSTEMS where REG_ECOSYSTEM_ID IN ([[OPTION_IDS]])';
    
    V_INCL_OPTION_IDS VARCHAR2(2000) := NULL;
    V_FILT_ENABLED_YN CHAR(1) := 'Y';
    
    V_PRIM_KEY_VAL PLS_INTEGER := 4;

BEGIN

    DBMS_OUTPUT.PUT_LINE ('running CCD_CRUISE_PKG.UPDATE_FIL_SHUTTLE_OPTIONS_SP test case - filtered leg regional ecosystems with one option (Gulf of California) associated with the leg and no additional options included as specific option IDs');


    CCD_CRUISE_PKG.UPDATE_FIL_SHUTTLE_OPTIONS_SP (V_MAIN_QUERY, V_QUERY_FRAG, TO_CHAR(V_INCL_OPTION_IDS), V_FILT_ENABLED_YN, TO_NUMBER(V_PRIM_KEY_VAL), FALSE);

    DBMS_OUTPUT.PUT_LINE ('the procedure was successful');

END;
/






DECLARE 
   
    V_MAIN_QUERY VARCHAR2 (4000) := 'SELECT
    REG_ECOSYSTEM_NAME OPTION_VALUE, REG_ECOSYSTEM_ID OPTION_ID FROM CCD_REG_ECOSYSTEMS where REG_ECOSYSTEM_ID IN
    (
        SELECT DISTINCT REG_ECOSYSTEM_ID
        FROM
        (SELECT REG_ECOSYSTEM_ID FROM CCD_REG_ECOSYSTEMS where (:SHOW_FILT_LIST = ''Y'' AND APP_SHOW_OPT_YN = ''Y'') OR (:SHOW_FILT_LIST IS NULL)

        UNION
        SELECT REG_ECOSYSTEM_ID from CCD_LEG_ECOSYSTEMS where CRUISE_LEG_ID IN (:PK_ID)
        [[QUERY_FRAG]])
    )
    ORDER BY UPPER(REG_ECOSYSTEM_NAME)';

    V_QUERY_FRAG VARCHAR2 (4000) := 'UNION SELECT REG_ECOSYSTEM_ID FROM CCD_REG_ECOSYSTEMS where REG_ECOSYSTEM_ID IN ([[OPTION_IDS]])';
    
    V_INCL_OPTION_IDS VARCHAR2(2000) := NULL;
    V_FILT_ENABLED_YN CHAR(1) := NULL;
    
    V_PRIM_KEY_VAL PLS_INTEGER := 4;

BEGIN

    DBMS_OUTPUT.PUT_LINE ('running CCD_CRUISE_PKG.UPDATE_FIL_SHUTTLE_OPTIONS_SP test case - unfiltered leg regional ecosystems');


    CCD_CRUISE_PKG.UPDATE_FIL_SHUTTLE_OPTIONS_SP (V_MAIN_QUERY, V_QUERY_FRAG, TO_CHAR(V_INCL_OPTION_IDS), V_FILT_ENABLED_YN, TO_NUMBER(V_PRIM_KEY_VAL), FALSE);

    DBMS_OUTPUT.PUT_LINE ('the procedure was successful');

END;
/




DECLARE 
   
    V_MAIN_QUERY VARCHAR2 (4000) := 'SELECT
    EXP_SPP_CAT_NAME OPTION_VALUE, EXP_SPP_CAT_ID OPTION_ID FROM CCD_EXP_SPP_CATS where EXP_SPP_CAT_ID IN
    (
        SELECT DISTINCT EXP_SPP_CAT_ID
        FROM
        (SELECT EXP_SPP_CAT_ID FROM CCD_EXP_SPP_CATS where (:SHOW_FILT_LIST = ''Y'' AND APP_SHOW_OPT_YN = ''Y'') OR (:SHOW_FILT_LIST IS NULL)

        UNION
        SELECT EXP_SPP_CAT_ID from CCD_CRUISE_EXP_SPP where CRUISE_ID IN (:PK_ID)
        [[QUERY_FRAG]])
    )
    ORDER BY UPPER(EXP_SPP_CAT_NAME)';

    V_QUERY_FRAG VARCHAR2 (4000) := 'UNION SELECT EXP_SPP_CAT_ID FROM CCD_EXP_SPP_CATS where EXP_SPP_CAT_ID IN ([[OPTION_IDS]])';
    
    V_INCL_OPTION_IDS VARCHAR2(2000) := '20:23';
    V_FILT_ENABLED_YN CHAR(1) := 'Y';
    
    V_PRIM_KEY_VAL PLS_INTEGER := 5;

BEGIN

    DBMS_OUTPUT.PUT_LINE ('running CCD_CRUISE_PKG.UPDATE_FIL_SHUTTLE_OPTIONS_SP test case - filtered cruise expected species with non-filtered options associated with the cruise and included as specific option IDs');


    CCD_CRUISE_PKG.UPDATE_FIL_SHUTTLE_OPTIONS_SP (V_MAIN_QUERY, V_QUERY_FRAG, TO_CHAR(V_INCL_OPTION_IDS), V_FILT_ENABLED_YN, TO_NUMBER(V_PRIM_KEY_VAL), FALSE);

    DBMS_OUTPUT.PUT_LINE ('the procedure was successful');

END;
/




DECLARE 
   
    V_MAIN_QUERY VARCHAR2 (4000) := 'SELECT
    EXP_SPP_CAT_NAME OPTION_VALUE, EXP_SPP_CAT_ID OPTION_ID FROM CCD_EXP_SPP_CATS where EXP_SPP_CAT_ID IN
    (
        SELECT DISTINCT EXP_SPP_CAT_ID
        FROM
        (SELECT EXP_SPP_CAT_ID FROM CCD_EXP_SPP_CATS where (:SHOW_FILT_LIST = ''Y'' AND APP_SHOW_OPT_YN = ''Y'') OR (:SHOW_FILT_LIST IS NULL)

        UNION
        SELECT EXP_SPP_CAT_ID from CCD_CRUISE_EXP_SPP where CRUISE_ID IN (:PK_ID)
        [[QUERY_FRAG]])
    )
    ORDER BY UPPER(EXP_SPP_CAT_NAME)';

    V_QUERY_FRAG VARCHAR2 (4000) := 'UNION SELECT EXP_SPP_CAT_ID FROM CCD_EXP_SPP_CATS where EXP_SPP_CAT_ID IN ([[OPTION_IDS]])';
    
    V_INCL_OPTION_IDS VARCHAR2(2000) := '1:2:3:4';
    V_FILT_ENABLED_YN CHAR(1) := NULL;
    
    V_PRIM_KEY_VAL PLS_INTEGER := 1;

BEGIN

    DBMS_OUTPUT.PUT_LINE ('running CCD_CRUISE_PKG.UPDATE_FIL_SHUTTLE_OPTIONS_SP test case - unfiltered expected species');


    CCD_CRUISE_PKG.UPDATE_FIL_SHUTTLE_OPTIONS_SP (V_MAIN_QUERY, V_QUERY_FRAG, TO_CHAR(V_INCL_OPTION_IDS), V_FILT_ENABLED_YN, TO_NUMBER(V_PRIM_KEY_VAL), FALSE);

    DBMS_OUTPUT.PUT_LINE ('the procedure was successful');

END;
/



--filtered expected species 
DECLARE 
   
    V_MAIN_QUERY VARCHAR2 (4000) := 'SELECT
    EXP_SPP_CAT_NAME OPTION_VALUE, EXP_SPP_CAT_ID OPTION_ID FROM CCD_EXP_SPP_CATS where EXP_SPP_CAT_ID IN
    (
        SELECT DISTINCT EXP_SPP_CAT_ID
        FROM
        (SELECT EXP_SPP_CAT_ID FROM CCD_EXP_SPP_CATS where (:SHOW_FILT_LIST = ''Y'' AND APP_SHOW_OPT_YN = ''Y'') OR (:SHOW_FILT_LIST IS NULL)

        UNION
        SELECT EXP_SPP_CAT_ID from CCD_CRUISE_EXP_SPP where CRUISE_ID IN (:PK_ID)
        [[QUERY_FRAG]])
    )
    ORDER BY UPPER(EXP_SPP_CAT_NAME)';

    V_QUERY_FRAG VARCHAR2 (4000) := 'UNION SELECT EXP_SPP_CAT_ID FROM CCD_EXP_SPP_CATS where EXP_SPP_CAT_ID IN ([[OPTION_IDS]])';
    
    V_INCL_OPTION_IDS VARCHAR2(2000) := '4:20';
    V_FILT_ENABLED_YN CHAR(1) := 'Y';
    
    V_PRIM_KEY_VAL PLS_INTEGER := 7;

BEGIN

    DBMS_OUTPUT.PUT_LINE ('running CCD_CRUISE_PKG.UPDATE_FIL_SHUTTLE_OPTIONS_SP test case - filtered cruise expected species with non-filtered options associated with the cruise and included as specific option IDs');


    CCD_CRUISE_PKG.UPDATE_FIL_SHUTTLE_OPTIONS_SP (V_MAIN_QUERY, V_QUERY_FRAG, TO_CHAR(V_INCL_OPTION_IDS), V_FILT_ENABLED_YN, TO_NUMBER(V_PRIM_KEY_VAL), FALSE);

    DBMS_OUTPUT.PUT_LINE ('the procedure was successful');

END;
/



DECLARE
	--variable to store the main option query
	V_MAIN_QUERY VARCHAR2(4000);

BEGIN


	V_MAIN_QUERY := 'SELECT
    TGT_SPP_ESA_NAME OPTION_VALUE, TGT_SPP_ESA_ID OPTION_ID FROM CCD_TGT_SPP_ESA where TGT_SPP_ESA_ID IN
    (

        SELECT DISTINCT TGT_SPP_ESA_ID
        FROM
        (SELECT TGT_SPP_ESA_ID FROM CCD_TGT_SPP_ESA where (:P220_ESA_SHOW_FILT_LIST = ''Y'' AND APP_SHOW_OPT_YN = ''Y'') OR (:P220_ESA_SHOW_FILT_LIST IS NULL)

        UNION
        SELECT TGT_SPP_ESA_ID from CCD_CRUISE_SPP_ESA where cruise_id IN (:P220_CRUISE_ID, :P220_CRUISE_ID_COPY)
		--query fragment goes here when defined:
        )
    )

    ORDER BY UPPER(TGT_SPP_ESA_NAME)';
	
    DBMS_OUTPUT.PUT_LINE ('running CCD_CRUISE_PKG.GEN_FIL_OPTION_QUERY_FN test case - target ESA species main query is defined but no query fragment is defined');

	
    --call the filtered option shuttle option procedure to generate the query
	DBMS_OUTPUT.PUT_LINE (CCD_CRUISE_PKG.GEN_FIL_OPTION_QUERY_FN (V_MAIN_QUERY, NULL, NULL));


END;
/



DECLARE
	--variable to store the main option query
	V_MAIN_QUERY VARCHAR2(4000);

BEGIN


	V_MAIN_QUERY := 'SELECT
    TGT_SPP_MMPA_NAME OPTION_VALUE, TGT_SPP_MMPA_ID OPTION_ID FROM CCD_TGT_SPP_MMPA where TGT_SPP_MMPA_ID IN
    (

        SELECT DISTINCT TGT_SPP_MMPA_ID
        FROM
        (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA where (:P220_MMPA_SHOW_FILT_LIST = ''Y'' AND APP_SHOW_OPT_YN = ''Y'') OR (:P220_MMPA_SHOW_FILT_LIST IS NULL)

        UNION
        SELECT TGT_SPP_MMPA_ID from CCD_CRUISE_SPP_MMPA where cruise_id IN (:P220_CRUISE_ID, :P220_CRUISE_ID_COPY)
		--query fragment goes here when defined:
        )
    )

    ORDER BY UPPER(TGT_SPP_MMPA_NAME)';
	
    DBMS_OUTPUT.PUT_LINE ('running CCD_CRUISE_PKG.GEN_FIL_OPTION_QUERY_FN test case - target MMPA species main query is defined but no query fragment is defined');

    --call the filtered option shuttle option procedure to generate the query
	DBMS_OUTPUT.PUT_LINE (CCD_CRUISE_PKG.GEN_FIL_OPTION_QUERY_FN (V_MAIN_QUERY, NULL, NULL));


END;
/




DECLARE

	--variable to store the main option query
	V_MAIN_QUERY VARCHAR2(4000);

	--variable to store the option query fragment that includes any selected options
	V_FRAG_QUERY VARCHAR2(4000);
	
    V_INCL_OPTION_IDS VARCHAR2(2000) := '4:20';

	
BEGIN


    --generate the full query to retrieve all of the reference table values based on the existing cruise leg, selected values in the shuttle field, and the show filtered values filter:
    V_MAIN_QUERY := 'SELECT
    GEAR_NAME OPTION_VALUE, GEAR_ID OPTION_ID FROM CCD_GEAR where GEAR_ID IN
    (

        SELECT DISTINCT GEAR_ID
        FROM
        (SELECT GEAR_ID FROM CCD_GEAR where (:SHOW_FILT_LIST = ''Y'' AND APP_SHOW_OPT_YN = ''Y'') OR (:SHOW_FILT_LIST IS NULL)

        UNION
        SELECT GEAR_ID from CCD_LEG_GEAR where CRUISE_LEG_ID IN (:PK_ID)
        [[QUERY_FRAG]])
    )

    ORDER BY UPPER(GEAR_NAME)';

	V_FRAG_QUERY := 'UNION SELECT GEAR_ID FROM CCD_GEAR where GEAR_ID IN ([[OPTION_IDS]])';

    DBMS_OUTPUT.PUT_LINE ('running CCD_CRUISE_PKG.GEN_FIL_OPTION_QUERY_FN test case - gear main query is defined, query fragment is defined and some option IDs are included');


	--call the filtered option shuttle option procedure to generate the query and execute it
	DBMS_OUTPUT.PUT_LINE (CCD_CRUISE_PKG.GEN_FIL_OPTION_QUERY_FN (V_MAIN_QUERY, V_FRAG_QUERY, V_INCL_OPTION_IDS));


END;
/




DECLARE

	--variable to store the main option query
	V_MAIN_QUERY VARCHAR2(4000);

	--variable to store the option query fragment that includes any selected options
	V_FRAG_QUERY VARCHAR2(4000);
	
    V_INCL_OPTION_IDS VARCHAR2(2000) := '99:1:50';

	
BEGIN


    --generate the full query to retrieve all of the reference table values based on the existing cruise leg, selected values in the shuttle field, and the show filtered values filter:
    V_MAIN_QUERY := 'SELECT
    REG_ECOSYSTEM_NAME OPTION_VALUE, REG_ECOSYSTEM_ID OPTION_ID FROM CCD_REG_ECOSYSTEMS where REG_ECOSYSTEM_ID IN
    (

        SELECT DISTINCT REG_ECOSYSTEM_ID
        FROM
        (SELECT REG_ECOSYSTEM_ID FROM CCD_REG_ECOSYSTEMS where (:SHOW_FILT_LIST = ''Y'' AND APP_SHOW_OPT_YN = ''Y'') OR (:SHOW_FILT_LIST IS NULL)

        UNION
        SELECT REG_ECOSYSTEM_ID from CCD_LEG_ECOSYSTEMS where CRUISE_LEG_ID IN (:PK_ID)
        [[QUERY_FRAG]])
    )

    ORDER BY UPPER(REG_ECOSYSTEM_NAME)';

	V_FRAG_QUERY := 'UNION SELECT REG_ECOSYSTEM_ID FROM CCD_REG_ECOSYSTEMS where REG_ECOSYSTEM_ID IN ([[OPTION_IDS]])';
	
    DBMS_OUTPUT.PUT_LINE ('running CCD_CRUISE_PKG.GEN_FIL_OPTION_QUERY_FN test case - regional ecosystem main query is defined, query fragment is defined and some option IDs are included');


	--call the filtered option shuttle option procedure to generate the query and execute it
	DBMS_OUTPUT.PUT_LINE (CCD_CRUISE_PKG.GEN_FIL_OPTION_QUERY_FN (V_MAIN_QUERY, V_FRAG_QUERY, V_INCL_OPTION_IDS));


END;
/


DECLARE

	--variable to store the main option query
	V_MAIN_QUERY VARCHAR2(4000);

	--variable to store the option query fragment that includes any selected options
	V_FRAG_QUERY VARCHAR2(4000);
	
    V_INCL_OPTION_IDS VARCHAR2(2000) := '20:25:14:9';

	
BEGIN


    --generate the full query to retrieve all of the reference table values based on the existing cruise selected values in the shuttle field, and the show filtered values filter:
	V_MAIN_QUERY := 'SELECT
    TGT_SPP_ESA_NAME OPTION_VALUE, TGT_SPP_ESA_ID OPTION_ID FROM CCD_TGT_SPP_ESA where TGT_SPP_ESA_ID IN
    (

        SELECT DISTINCT TGT_SPP_ESA_ID
        FROM
        (SELECT TGT_SPP_ESA_ID FROM CCD_TGT_SPP_ESA where (:SHOW_FILT_LIST = ''Y'' AND APP_SHOW_OPT_YN = ''Y'') OR (:SHOW_FILT_LIST IS NULL)

        UNION
        SELECT TGT_SPP_ESA_ID from CCD_CRUISE_SPP_ESA where cruise_id IN(:PK_ID)
		--query fragment goes here when defined:
        [[QUERY_FRAG]])
    )

    ORDER BY UPPER(TGT_SPP_ESA_NAME)';
	
	V_FRAG_QUERY := 'UNION SELECT TGT_SPP_ESA_ID FROM CCD_TGT_SPP_ESA where TGT_SPP_ESA_ID IN ([[OPTION_IDS]])';
	
    DBMS_OUTPUT.PUT_LINE ('running CCD_CRUISE_PKG.GEN_FIL_OPTION_QUERY_FN test case - ESA target species main query is defined, query fragment is defined and some option IDs are included');


	--call the filtered option shuttle option procedure to generate the query and execute it
	DBMS_OUTPUT.PUT_LINE (CCD_CRUISE_PKG.GEN_FIL_OPTION_QUERY_FN (V_MAIN_QUERY, V_FRAG_QUERY, V_INCL_OPTION_IDS));


END;
/



DECLARE

	--variable to store the main option query
	V_MAIN_QUERY VARCHAR2(4000);

	--variable to store the option query fragment that includes any selected options
	V_FRAG_QUERY VARCHAR2(4000);
	
    V_INCL_OPTION_IDS VARCHAR2(2000) := NULL;

	
BEGIN


    --generate the full query to retrieve all of the reference table values based on the existing cruise selected values in the shuttle field, and the show filtered values filter:

	V_MAIN_QUERY := 'SELECT
    TGT_SPP_MMPA_NAME OPTION_VALUE, TGT_SPP_MMPA_ID OPTION_ID FROM CCD_TGT_SPP_MMPA where TGT_SPP_MMPA_ID IN
    (

        SELECT DISTINCT TGT_SPP_MMPA_ID
        FROM
        (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA where (:SHOW_FILT_LIST = ''Y'' AND APP_SHOW_OPT_YN = ''Y'') OR (:SHOW_FILT_LIST IS NULL)

        UNION
        SELECT TGT_SPP_MMPA_ID from CCD_CRUISE_SPP_MMPA where cruise_id IN(:PK_ID)
		--query fragment goes here when defined:
        [[QUERY_FRAG]])
    )

    ORDER BY UPPER(TGT_SPP_MMPA_NAME)';
	
	V_FRAG_QUERY := 'UNION SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA where TGT_SPP_MMPA_ID IN ([[OPTION_IDS]])';
		
    DBMS_OUTPUT.PUT_LINE ('running CCD_CRUISE_PKG.GEN_FIL_OPTION_QUERY_FN test case - MMPA target species main query is defined, query fragment is defined and no option IDs are included');


	--call the filtered option shuttle option procedure to generate the query and execute it
	DBMS_OUTPUT.PUT_LINE (CCD_CRUISE_PKG.GEN_FIL_OPTION_QUERY_FN (V_MAIN_QUERY, V_FRAG_QUERY, V_INCL_OPTION_IDS));


END;
/



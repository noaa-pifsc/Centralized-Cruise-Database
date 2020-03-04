
--populate the CUST_ERR_CONSTR_MSG table with the generated error messages and constraints from the underlying data table data dictionary
INSERT INTO CUST_ERR_CONSTR_MSG (CONSTR_NAME, CONSTR_ERR_MESSAGE)
select DISTINCT user_constraints.CONSTRAINT_NAME,  

--generate the generic error messages based on the type of database constraint error to use as a basis for defining the custom error messages:
CASE 
--generate unique constraint error message based on the field labels or database column names
WHEN CONSTRAINT_TYPE = 'U' THEN 'The '||COLUMN_NAMES||' field value(s) must be unique'

--generate foreign key constraint error message based on the field labels or database column names and the form region title or database object names
WHEN CONSTRAINT_TYPE = 'R' THEN 'The '||COLUMN_NAMES||' field(s) reference the "'||nvl(APEX_UI_DEFAULTS_TABLES.FORM_REGION_TITLE, user_cons_columns.TABLE_NAME)||'" data object'

END message
--, constraint_cols.COLUMN_NAMES
--, r_constraint_cols.R_COLUMN_NAMES
--, nvl(APEX_UI_DEFAULTS_TABLES.FORM_REGION_TITLE, user_cons_columns.TABLE_NAME) R_CONSTRAINT_OBJECT
from user_constraints inner join 

--pull the delimited list of column names involved in the given constraint to display for the user.  If a corresponding UI default for the field label exists it will be used to refer to fields otherwise the corresponding database field name is used
(SELECT CONSTRAINT_NAME, LISTAGG('"'||NVL(LABEL, user_cons_columns.COLUMN_NAME)||'"', ', ') WITHIN GROUP (ORDER BY POSITION) COLUMN_NAMES FROM user_cons_columns 
left join APEX_UI_DEFAULTS_COLUMNS ON APEX_UI_DEFAULTS_COLUMNS.TABLE_NAME = user_cons_columns.TABLE_NAME AND APEX_UI_DEFAULTS_COLUMNS.COLUMN_NAME = user_cons_columns.COLUMN_NAME

GROUP BY CONSTRAINT_NAME) constraint_cols

ON user_constraints.constraint_name = constraint_cols.constraint_name

--join the list of constraints on the referenced constraint name (if any)
left join 
user_cons_columns on user_cons_columns.constraint_name = user_constraints.r_constraint_name

--join the UI defaults form labels (if any) for the different objects:
left join 
APEX_UI_DEFAULTS_TABLES
on APEX_UI_DEFAULTS_TABLES.TABLE_NAME = user_cons_columns.TABLE_NAME


--limit the results to foreign key and unique key constraints:
WHERE CONSTRAINT_TYPE IN (
--'C',
'U', 'R')
--limit the results to non-system/APEX objects
AND user_constraints.CONSTRAINT_NAME NOT LIKE 'SYS_%' 
AND user_constraints.CONSTRAINT_NAME NOT LIKE 'BIN$%'
AND user_constraints.TABLE_NAME NOT LIKE 'APEX$_%';



--------------------------------------------------------
--------------------------------------------------------
--Database Name: Error Handler
--Database Description: This database was originally developed to provide a method to address security control SI-11 and provide all PIFSC APEX developers the ability to secure their applications using a simple function that will remove potentially sensitive security information from database error messages that could be used to launch directed attacks on the underlying systems
--------------------------------------------------------
--------------------------------------------------------

--------------------------------------------------------
--version 0.4 updates:
--------------------------------------------------------



--Custom Error Handling module package:
CREATE OR REPLACE PACKAGE CUST_ERR_PKG
AS

--Custom authorization function that integrates the Application Authentication and Authorization Module
function APX_ERR_HANDLER_FN (p_error apex_error.t_error ) return apex_error.t_error_result;

END CUST_ERR_PKG;
/

create or replace PACKAGE BODY CUST_ERR_PKG
AS




function APX_ERR_HANDLER_FN (
    p_error in apex_error.t_error )
    return apex_error.t_error_result
is
    l_result          apex_error.t_error_result;
    l_reference_id    number;
    l_constraint_name varchar2(255);
begin
    --The APX_ERR_HANDLER_FN is an Oracle function used to suppress sensitive structural error information from database interaction within APEX applications.  It uses a lookup table that allows custom error messages to be defined for each foreign key or unique key constraint name in the data dictionary that is defined in the CUST_ERR_CONSTR_MSG table.  There is a flexible data dictionary query (Custom Error Handler DDL.sql) used to populate this table using generic error messages based on the defined APEX workspace UI default definitions or underlying object names.  Other types of common constraint errors are genericized to remove the constraint names and other detailed error messages.  APEX application error and Oracle error messages have the error codes removed.  This function is enabled on all test and production application instances (hard coded to be enabled when the host name is not picmidd.nmfs.local).
    --recommended implementation of function is to deploy by "Edit Application Definition" -> Error Handling Function: CUST_ERR_PKG.APX_ERR_HANDLER_FN which will enable it on all database interaction to suppress detailed structural information in error messages

    --This module was originally pulled directly from the Oracle site: http://docs.oracle.com/cd/E59726_01/doc.50/e39149/apex_error.htm#AEAPI2216

    --retrieve the error and store in a local variable:
    l_result := apex_error.init_error_result (
                    p_error => p_error );

    --check if the host name is not picmidd.nmfs.local, if this is a non-development application server then alter all error messages displayed to users:
    IF OWA_UTIL.get_cgi_env ('HTTP_HOST') NOT LIKE 'picmidd.nmfs.local%' THEN
        --this is not a development server, suppress structural information in all queries:


        -- If it's an internal error raised by APEX, like an invalid statement or
        -- code which cannot be executed, the error text might contain security sensitive
        -- information. To avoid this security problem rewrite the error to
        -- a generic error message and log the original error message for further
        -- investigation by the help desk.
        if p_error.is_internal_error then
            -- Access Denied errors raised by application or page authorization should
            -- still show up with the original error message
            if    p_error.apex_error_code <> 'APEX.AUTHORIZATION.ACCESS_DENIED'              and p_error.apex_error_code not like 'APEX.SESSION_STATE.%' then
                -- log error for example with an autonomous transaction and return
                -- l_reference_id as reference#
                -- l_reference_id := log_error (
                --                       p_error => p_error );
                --

                -- Change the message to the generic error message which is not exposed
                -- any sensitive information.
                l_result.message         := 'An unexpected internal application error has occurred. '||
                                            'Please get in contact with XXX and provide '||
                                            'reference# '||to_char(l_reference_id, '999G999G999G990')||
                                            ' for further investigation.';
                l_result.additional_info := null;
            end if;
        else
            -- Always show the error as inline error
            -- Note: If you have created manual tabular forms (using the package
            --       apex_item/htmldb_item in the SQL statement) you should still
            --       use "On error page" on that pages to avoid loosing entered data
            l_result.display_location := case
                                           when l_result.display_location = apex_error.c_on_error_page then apex_error.c_inline_in_notification
                                           else l_result.display_location
                                         end;

            -- If it's a constraint violation like
            --
            --   -) ORA-00001: unique constraint violated
            --   -) ORA-02091: transaction rolled back (-> can hide a deferred constraint)
            --   -) ORA-02290: check constraint violated
            --   -) ORA-02291: integrity constraint violated - parent key not found
            --   -) ORA-02292: integrity constraint violated - child record found
            --
            -- try to get a friendly error message from our constraint lookup configuration.
            -- If the constraint in our lookup table is not found, fallback to
            -- the original ORA error message.
            if p_error.ora_sqlcode in (-1, -2091, -2290, -2291, -2292) then
                l_constraint_name := apex_error.extract_constraint_name (
                                         p_error => p_error );

                begin
                    select CONSTR_ERR_MESSAGE
                      into l_result.message
                      from CUST_ERR_CONSTR_MSG
                     where CONSTR_NAME = l_constraint_name;
                exception when no_data_found then

                    --there was no matching constraint name in the APEX Custom Database Constraint Error Messages table, use a generic error message to obfuscate the underlying constraint name:
                    l_result.message := CASE
                    WHEN p_error.ora_sqlcode = -1 THEN 'unique constraint violated'
                    WHEN p_error.ora_sqlcode = -2291 THEN 'invalid value, the record you are referencing does not exist'
                    WHEN p_error.ora_sqlcode = -2292 THEN 'cannot delete the current record, child record found'
                    WHEN p_error.ora_sqlcode = -2091 THEN 'transaction was rolled back'
                    WHEN p_error.ora_sqlcode = -2290 THEN 'invalid value (check constraint)' END;

                end;

            end if;

            -- If an ORA error has been raised, for example a raise_application_error(-20xxx, '...')
            -- in a table trigger or in a PL/SQL package called by a process and the
            -- error has not been found in the lookup table, then display
            -- the actual error text and not the full error stack with all the ORA error numbers.
            if p_error.ora_sqlcode is not null and l_result.message = p_error.message then
                l_result.message := apex_error.get_first_ora_error_text (
                                        p_error => p_error );
            end if;

            -- If no associated page item/tabular form column has been set, use
            -- apex_error.auto_set_associated_item to automatically guess the affected
            -- error field by examine the ORA error for constraint names or column names.
            if l_result.page_item_name is null and l_result.column_alias is null then
                apex_error.auto_set_associated_item (
                    p_error        => p_error,
                    p_error_result => l_result );
            end if;
        end if;
    end if;

    return l_result;
end APX_ERR_HANDLER_FN;


end CUST_ERR_PKG;
/


--define the upgrade version in the database:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('Error Handler', '0.4', TO_DATE('26-OCT-21', 'DD-MON-YY'), 'Updated the CUST_ERR_PKG package to use the new development server hostname following the migration to the nmfs.local domain');

COMMIT;

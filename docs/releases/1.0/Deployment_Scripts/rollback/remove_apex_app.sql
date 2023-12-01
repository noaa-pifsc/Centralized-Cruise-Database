DECLARE 
	V_APP_ID PLS_INTEGER;
BEGIN
	select APPLICATION_ID INTO V_APP_ID from apex_applications where APPLICATION_NAME = 'Centralized Authorization System' AND WORKSPACE = 'CEN_CRUISE_APP';

	apex_application_install.set_workspace('CEN_CRUISE_APP');
    apex_application_install.set_keep_sessions(false);
    apex_application_install.remove_application(V_APP_ID);

	COMMIT;

END;
/


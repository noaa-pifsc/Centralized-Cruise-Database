
set serveroutput on;







--delete cruise leg test cases:

--Delete Cruise Leg Case 1 (Overlap to no overlap) Vessel Leg Overlaps DVM records removed after using CCD_CRUISE_PKG.DELETE_LEG_OVERLAP_SP procedure is executed on SE-20-05 Leg 1 to remove the overlap errors on SE-20-04:


--execute for test data stream (SE-20-04):
DECLARE
	V_CRUISE_NAME VARCHAR2(2000) := 'SE-20-04';
BEGIN

	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(V_CRUISE_NAME);

	DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was evaluated successfully');

	--commit the successful validation records
	COMMIT;

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was not evaluated successfully');


	--rollback;
END;
/




--execute for test data stream (SE-20-05):
DECLARE
	V_CRUISE_NAME VARCHAR2(2000) := 'SE-20-05';
BEGIN

	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(V_CRUISE_NAME);

	DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was evaluated successfully');

	--commit the successful validation records
	COMMIT;

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was not evaluated successfully');

	--rollback;
END;
/












--Delete Cruise Leg Case 2 (Overlap with two cruises to no overlap) Vessel Leg Overlaps DVM records removed after using CCD_CRUISE_PKG.DELETE_LEG_OVERLAP_SP procedure is executed on SE-21-03 to remove the overlap errors on SE-21-01 and SE-21-04:

--execute for test data stream (SE-21-01):
DECLARE
	V_CRUISE_NAME VARCHAR2(2000) := 'SE-21-01';
BEGIN

	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(V_CRUISE_NAME);

	DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was evaluated successfully');

	--commit the successful validation records
	COMMIT;

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was not evaluated successfully');

	--rollback;
END;
/





--execute for test data stream (SE-21-03):
DECLARE
	V_CRUISE_NAME VARCHAR2(2000) := 'SE-21-03';
BEGIN

	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(V_CRUISE_NAME);

	DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was evaluated successfully');

	--commit the successful validation records
	COMMIT;

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was not evaluated successfully');


	--rollback;
END;
/




--execute for test data stream (SE-21-04):
DECLARE
	V_CRUISE_NAME VARCHAR2(2000) := 'SE-21-04';
BEGIN

	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(V_CRUISE_NAME);

	DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was evaluated successfully');

	--commit the successful validation records
	COMMIT;

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was not evaluated successfully');


	--rollback;
END;
/







--Delete Cruise Leg Case 3 (One cruise overlaps with two cruises, one overlap is resolved when removing an overlapping cruise leg) Run the CCD_CRUISE_PKG.DELETE_LEG_OVERLAP_SP procedure.  Delete HI-21-08 Leg 1 removing the HI-21-08 Leg 1 overlap errors from HI-21-07 Leg 2:



--execute for test data stream (HI-21-06):
DECLARE
	V_CRUISE_NAME VARCHAR2(2000) := 'HI-21-06';
BEGIN

	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(V_CRUISE_NAME);

	DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was evaluated successfully');

	--commit the successful validation records
	COMMIT;

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was not evaluated successfully');

	--rollback;
END;
/






--execute for test data stream (HI-21-07):
DECLARE
	V_CRUISE_NAME VARCHAR2(2000) := 'HI-21-07';
BEGIN

	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(V_CRUISE_NAME);

	DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was evaluated successfully');

	--commit the successful validation records
	COMMIT;

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was not evaluated successfully');

	--rollback;
END;
/




--execute for test data stream (HI-21-08):
DECLARE
	V_CRUISE_NAME VARCHAR2(2000) := 'HI-21-08';
BEGIN

	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(V_CRUISE_NAME);

	DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was evaluated successfully');

	--commit the successful validation records
	COMMIT;

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was not evaluated successfully');

	--rollback;
END;
/






--Delete Cruise Leg Case 4 (Three cruises overlap, remove one overlapping cruise leg) Run the CCD_CRUISE_PKG.DELETE_LEG_OVERLAP_SP.  Delete HI-20-10 Leg 1 resolves overlapping errors with HI-20-10 Leg 1 for HI-20-08 Leg 1, HI-20-08 Leg 2, HI-20-09 Leg 1:



--execute for test data stream (HI-20-08):
DECLARE
	V_CRUISE_NAME VARCHAR2(2000) := 'HI-20-08';
BEGIN

	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(V_CRUISE_NAME);

	DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was evaluated successfully');

	--commit the successful validation records
	COMMIT;

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was not evaluated successfully');
	--rollback;
END;
/






--execute for test data stream (HI-20-09):
DECLARE
	V_CRUISE_NAME VARCHAR2(2000) := 'HI-20-09';
BEGIN

	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(V_CRUISE_NAME);

	DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was evaluated successfully');

	--commit the successful validation records
	COMMIT;

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was not evaluated successfully');

	--rollback;
END;
/




--execute for test data stream (HI-20-10):
DECLARE
	V_CRUISE_NAME VARCHAR2(2000) := 'HI-20-10';
BEGIN

	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(V_CRUISE_NAME);

	DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was evaluated successfully');

	--commit the successful validation records
	COMMIT;

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was not evaluated successfully');

	--rollback;
END;
/














--update the cruise leg date(s):

--Update Cruise Leg Case 3 (overlap to no overlap) Update the cruise to resolve the vessel overlap error, run the PL/SQL to update the cruise leg and re-evaluate the previous overlapping cruise.  Update HI-19-02 Leg 1 to change overlap from HI-19-01 Leg 2 to none:



--execute for test data stream (HI-19-01):
DECLARE
	V_CRUISE_NAME VARCHAR2(2000) := 'HI-19-01';
BEGIN

	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(V_CRUISE_NAME);

	DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was evaluated successfully');

	--commit the successful validation records
	COMMIT;

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was not evaluated successfully');



	--rollback;
END;
/





--execute for test data stream (HI-19-02):
DECLARE
	V_CRUISE_NAME VARCHAR2(2000) := 'HI-19-02';
BEGIN


	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(V_CRUISE_NAME);

	DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was evaluated successfully');

	--commit the successful validation records
	COMMIT;

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was not evaluated successfully');


END;
/







--Delete Cruise Case 1 (DVM issues and records exist) Delete the Cruise and all associated DVM records.


--Run DVM on OES0509

--execute for test data stream (OES0509):
DECLARE
	V_CRUISE_NAME VARCHAR2(2000) := 'OES0509';
BEGIN


	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(V_CRUISE_NAME);

	DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was evaluated successfully');

	--commit the successful validation records
	COMMIT;

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was not evaluated successfully');

	--rollback;
END;
/


-- Delete Cruise Case 2 (no DVM issues or records exist)

delete from CCD_CRUISE_SVY_CATS where cruise_id in (select cruise_id from ccd_cruises where cruise_name = 'TC0009 (copy)');

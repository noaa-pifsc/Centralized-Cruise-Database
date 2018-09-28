set define off;

/*

delete from ccd_leg_regions;
delete from ccd_leg_aliases;
delete from ccd_cruise_legs;
delete from ccd_regions;


delete from ccd_cruises;
delete from ccd_vessels;



*/

insert into ccd_regions (REGION_CODE, REGION_NAME, REGION_DESC) values ('PRIA', 'Pacific Remote Island Areas', '');
insert into ccd_regions (REGION_CODE, REGION_NAME, REGION_DESC) values ('AMSM', 'American Samoa', '');
insert into ccd_regions (REGION_CODE, REGION_NAME, REGION_DESC) values ('MHI', 'Main Hawaiian Islands', '');
insert into ccd_regions (REGION_CODE, REGION_NAME, REGION_DESC) values ('CNMI', 'Commonwealth of the Northern Mariana Islands', '');
insert into ccd_regions (REGION_CODE, REGION_NAME, REGION_DESC) values ('NWHI', 'Northwest Hawaiian Islands', '');
insert into ccd_regions (REGION_CODE, REGION_NAME, REGION_DESC) values ('NPSF', 'North Pacific Subtropical Front', '');






insert into ccd_vessels (vessel_name) values ('Townsend Cromwell');
insert into ccd_vessels (vessel_name) values ('Hi''ialakai');
insert into ccd_vessels (vessel_name) values ('Oscar Elton Sette');



insert into ccd_cruises (cruise_name, vessel_id) values ('HA1007', (select vessel_id from ccd_vessels where vessel_name = 'Hi''ialakai'));
insert into ccd_cruises (cruise_name, vessel_id) values ('HA1008', (select vessel_id from ccd_vessels where vessel_name = 'Hi''ialakai'));
insert into ccd_cruises (cruise_name, vessel_id) values ('HA1201', (select vessel_id from ccd_vessels where vessel_name = 'Hi''ialakai'));
insert into ccd_cruises (cruise_name, vessel_id) values ('HI0401', (select vessel_id from ccd_vessels where vessel_name = 'Hi''ialakai'));
insert into ccd_cruises (cruise_name, vessel_id) values ('HI0602', (select vessel_id from ccd_vessels where vessel_name = 'Hi''ialakai'));
insert into ccd_cruises (cruise_name, vessel_id) values ('HI0604', (select vessel_id from ccd_vessels where vessel_name = 'Hi''ialakai'));
insert into ccd_cruises (cruise_name, vessel_id) values ('HI0609', (select vessel_id from ccd_vessels where vessel_name = 'Hi''ialakai'));
insert into ccd_cruises (cruise_name, vessel_id) values ('HI0610', (select vessel_id from ccd_vessels where vessel_name = 'Hi''ialakai'));
insert into ccd_cruises (cruise_name, vessel_id) values ('HI0611', (select vessel_id from ccd_vessels where vessel_name = 'Hi''ialakai'));
insert into ccd_cruises (cruise_name, vessel_id) values ('HI0701', (select vessel_id from ccd_vessels where vessel_name = 'Hi''ialakai'));
insert into ccd_cruises (cruise_name, vessel_id) values ('HI1001', (select vessel_id from ccd_vessels where vessel_name = 'Hi''ialakai'));
insert into ccd_cruises (cruise_name, vessel_id) values ('HI1101', (select vessel_id from ccd_vessels where vessel_name = 'Hi''ialakai'));
insert into ccd_cruises (cruise_name, vessel_id) values ('OES0304', (select vessel_id from ccd_vessels where vessel_name = 'Oscar Elton Sette'));
insert into ccd_cruises (cruise_name, vessel_id) values ('OES0306', (select vessel_id from ccd_vessels where vessel_name = 'Oscar Elton Sette'));
insert into ccd_cruises (cruise_name, vessel_id) values ('OES0407', (select vessel_id from ccd_vessels where vessel_name = 'Oscar Elton Sette'));
insert into ccd_cruises (cruise_name, vessel_id) values ('OES0410', (select vessel_id from ccd_vessels where vessel_name = 'Oscar Elton Sette'));
insert into ccd_cruises (cruise_name, vessel_id) values ('OES0411', (select vessel_id from ccd_vessels where vessel_name = 'Oscar Elton Sette'));
insert into ccd_cruises (cruise_name, vessel_id) values ('OES0504', (select vessel_id from ccd_vessels where vessel_name = 'Oscar Elton Sette'));
insert into ccd_cruises (cruise_name, vessel_id) values ('OES0506', (select vessel_id from ccd_vessels where vessel_name = 'Oscar Elton Sette'));
insert into ccd_cruises (cruise_name, vessel_id) values ('OES0509', (select vessel_id from ccd_vessels where vessel_name = 'Oscar Elton Sette'));
insert into ccd_cruises (cruise_name, vessel_id) values ('OES0512', (select vessel_id from ccd_vessels where vessel_name = 'Oscar Elton Sette'));
insert into ccd_cruises (cruise_name, vessel_id) values ('OES0604', (select vessel_id from ccd_vessels where vessel_name = 'Oscar Elton Sette'));
insert into ccd_cruises (cruise_name, vessel_id) values ('OES0606', (select vessel_id from ccd_vessels where vessel_name = 'Oscar Elton Sette'));
insert into ccd_cruises (cruise_name, vessel_id) values ('OES0607', (select vessel_id from ccd_vessels where vessel_name = 'Oscar Elton Sette'));
insert into ccd_cruises (cruise_name, vessel_id) values ('OES0608', (select vessel_id from ccd_vessels where vessel_name = 'Oscar Elton Sette'));
insert into ccd_cruises (cruise_name, vessel_id) values ('OES0706', (select vessel_id from ccd_vessels where vessel_name = 'Oscar Elton Sette'));
insert into ccd_cruises (cruise_name, vessel_id) values ('OES0908', (select vessel_id from ccd_vessels where vessel_name = 'Oscar Elton Sette'));
insert into ccd_cruises (cruise_name, vessel_id) values ('SE-15-01', (select vessel_id from ccd_vessels where vessel_name = 'Oscar Elton Sette'));
insert into ccd_cruises (cruise_name, vessel_id) values ('TC0005', (select vessel_id from ccd_vessels where vessel_name = 'Townsend Cromwell'));
insert into ccd_cruises (cruise_name, vessel_id) values ('TC0009', (select vessel_id from ccd_vessels where vessel_name = 'Townsend Cromwell'));
insert into ccd_cruises (cruise_name, vessel_id) values ('TC0011', (select vessel_id from ccd_vessels where vessel_name = 'Townsend Cromwell'));
insert into ccd_cruises (cruise_name, vessel_id) values ('TC0012', (select vessel_id from ccd_vessels where vessel_name = 'Townsend Cromwell'));
insert into ccd_cruises (cruise_name, vessel_id) values ('TC0108', (select vessel_id from ccd_vessels where vessel_name = 'Townsend Cromwell'));
insert into ccd_cruises (cruise_name, vessel_id) values ('TC0109', (select vessel_id from ccd_vessels where vessel_name = 'Townsend Cromwell'));
insert into ccd_cruises (cruise_name, vessel_id) values ('TC0110', (select vessel_id from ccd_vessels where vessel_name = 'Townsend Cromwell'));
insert into ccd_cruises (cruise_name, vessel_id) values ('TC0111', (select vessel_id from ccd_vessels where vessel_name = 'Townsend Cromwell'));
insert into ccd_cruises (cruise_name, vessel_id) values ('TC0201', (select vessel_id from ccd_vessels where vessel_name = 'Townsend Cromwell'));
insert into ccd_cruises (cruise_name, vessel_id) values ('TC0207', (select vessel_id from ccd_vessels where vessel_name = 'Townsend Cromwell'));
insert into ccd_cruises (cruise_name, vessel_id) values ('TC9905', (select vessel_id from ccd_vessels where vessel_name = 'Townsend Cromwell'));
insert into ccd_cruises (cruise_name, vessel_id) values ('TC9906', (select vessel_id from ccd_vessels where vessel_name = 'Townsend Cromwell'));
insert into ccd_cruises (cruise_name, vessel_id) values ('TC9908', (select vessel_id from ccd_vessels where vessel_name = 'Townsend Cromwell'));
insert into ccd_cruises (cruise_name, vessel_id) values ('TC9909', (select vessel_id from ccd_vessels where vessel_name = 'Townsend Cromwell'));
insert into ccd_cruises (cruise_name, vessel_id) values ('TC9910', (select vessel_id from ccd_vessels where vessel_name = 'Townsend Cromwell'));
insert into ccd_cruises (cruise_name, vessel_id) values ('SE-17-07', (select vessel_id from ccd_vessels where vessel_name = 'Oscar Elton Sette'));
insert into ccd_cruises (cruise_name, vessel_id) values ('SE-18-06', (select vessel_id from ccd_vessels where vessel_name = 'Oscar Elton Sette'));
insert into ccd_cruises (cruise_name, vessel_id) values ('SE-17-02', (select vessel_id from ccd_vessels where vessel_name = 'Oscar Elton Sette'));


insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('SE-17-07', TO_DATE('10/20/2017', 'MM/DD/YYYY'), TO_DATE('11/03/2017', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'SE-17-07'));
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('SE-18-06', TO_DATE('10/17/2018', 'MM/DD/YYYY'), TO_DATE('10/31/2018', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'SE-18-06'));
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('SE-17-02', TO_DATE('3/1/2017', 'MM/DD/YYYY'), TO_DATE('3/15/2017', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'SE-17-02'));
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('SE-15-01', TO_DATE('4/3/2015', 'MM/DD/YYYY'), TO_DATE('4/14/2015', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'SE-15-01'));
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('HA1201_LEG_I', TO_DATE('2/27/2012', 'MM/DD/YYYY'), TO_DATE('3/25/2012', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'HA1201'));
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('HA1201_LEG_II&III', TO_DATE('4/1/2012', 'MM/DD/YYYY'), TO_DATE('4/27/2012', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'HA1201'));
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('HA1201_LEG_IV', TO_DATE('4/27/2012', 'MM/DD/YYYY'), TO_DATE('5/24/2012', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'HA1201'));
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('HA1101_LEG_I', TO_DATE('3/10/2011', 'MM/DD/YYYY'), TO_DATE('4/5/2011', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'HI1101'));
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('HA1101_LEG_II', TO_DATE('4/7/2011', 'MM/DD/YYYY'), TO_DATE('5/9/2011', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'HI1101'));
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('HA1101_LEG_III', TO_DATE('5/12/2011', 'MM/DD/YYYY'), TO_DATE('5/24/2011', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'HI1101'));
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('HA1007', TO_DATE('9/4/2010', 'MM/DD/YYYY'), TO_DATE('9/29/2010', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'HA1007'));
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('HA1008', TO_DATE('10/7/2010', 'MM/DD/YYYY'), TO_DATE('11/5/2010', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'HA1008'));
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('HI0401', TO_DATE('9/13/2004', 'MM/DD/YYYY'), TO_DATE('10/17/2004', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'HI0401'));
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('HI0602', TO_DATE('2/9/2006', 'MM/DD/YYYY'), TO_DATE('3/10/2006', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'HI0602'));
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('HI0604', TO_DATE('3/15/2006', 'MM/DD/YYYY'), TO_DATE('4/8/2006', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'HI0604'));
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('HI0609', TO_DATE('6/23/2006', 'MM/DD/YYYY'), TO_DATE('7/20/2006', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'HI0609'));
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('HI0610', TO_DATE('7/27/2006', 'MM/DD/YYYY'), TO_DATE('8/20/2006', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'HI0610'));
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('HI0611', TO_DATE('9/1/2006', 'MM/DD/YYYY'), TO_DATE('10/4/2006', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'HI0611'));
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('HI0701', TO_DATE('4/19/2007', 'MM/DD/YYYY'), TO_DATE('5/9/2007', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'HI0701'));
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('HI1001_LEGI', TO_DATE('1/21/2010', 'MM/DD/YYYY'), TO_DATE('2/14/2010', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'HI1001'));
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('HI1001_LEGII', TO_DATE('2/17/2010', 'MM/DD/YYYY'), TO_DATE('3/23/2010', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'HI1001'));
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('HI1001_LEGIII', TO_DATE('3/27/2010', 'MM/DD/YYYY'), TO_DATE('4/24/2010', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'HI1001'));
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('OES0304', TO_DATE('5/13/2003', 'MM/DD/YYYY'), TO_DATE('5/28/2003', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'OES0304'));
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('OES0306', TO_DATE('7/12/2003', 'MM/DD/YYYY'), TO_DATE('8/17/2003', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'OES0306'));
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('OES0407', TO_DATE('5/30/2004', 'MM/DD/YYYY'), TO_DATE('6/14/2004', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'OES0407'));
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('OES0410', TO_DATE('7/30/2004', 'MM/DD/YYYY'), TO_DATE('8/16/2004', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'OES0410'));
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('OES0411_LEGI', TO_DATE('8/7/2004', 'MM/DD/YYYY'), TO_DATE('9/7/2004', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'OES0411'));
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('OES0411_LEGII', TO_DATE('9/8/2004', 'MM/DD/YYYY'), TO_DATE('9/13/2004', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'OES0411'));
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('OES0504', TO_DATE('3/21/2005', 'MM/DD/YYYY'), TO_DATE('4/3/2005', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'OES0504'));
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('OES0506', TO_DATE('5/5/2005', 'MM/DD/YYYY'), TO_DATE('5/20/2005', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'OES0506'));
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('OES0509', TO_DATE('7/19/2005', 'MM/DD/YYYY'), TO_DATE('8/5/2005', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'OES0509'));
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('OES0512', TO_DATE('10/3/2005', 'MM/DD/YYYY'), TO_DATE('10/9/2005', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'OES0512'));
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('OES0604', TO_DATE('4/6/2006', 'MM/DD/YYYY'), TO_DATE('4/17/2006', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'OES0604'));
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('OES0606', TO_DATE('5/8/2006', 'MM/DD/YYYY'), TO_DATE('5/23/2006', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'OES0606'));
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('OES0607', TO_DATE('6/5/2006', 'MM/DD/YYYY'), TO_DATE('7/3/2006', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'OES0607'));
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('OES0608', TO_DATE('7/17/2006', 'MM/DD/YYYY'), TO_DATE('8/3/2006', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'OES0608'));
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('OES0706', TO_DATE('7/18/2007', 'MM/DD/YYYY'), TO_DATE('8/14/2007', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'OES0706'));
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('OES0908_LEGI', TO_DATE('9/1/2009', 'MM/DD/YYYY'), TO_DATE('9/30/2009', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'OES0908'));
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('OES0908_LEGII', TO_DATE('10/6/2009', 'MM/DD/YYYY'), TO_DATE('10/30/2009', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'OES0908'));
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('TC0009', TO_DATE('7/19/2000', 'MM/DD/YYYY'), TO_DATE('8/4/2000', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'TC0009'));
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('TC0011', TO_DATE('9/8/2000', 'MM/DD/YYYY'), TO_DATE('10/6/2000', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'TC0011'));
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('TC0012', TO_DATE('10/9/2000', 'MM/DD/YYYY'), TO_DATE('11/5/2000', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'TC0012'));
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('TC0108', TO_DATE('7/16/2001', 'MM/DD/YYYY'), TO_DATE('8/2/2001', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'TC0108'));
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('TC0109_LEGI', TO_DATE('8/7/2001', 'MM/DD/YYYY'), TO_DATE('8/11/2001', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'TC0109'));
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('TC0109_LEGII', TO_DATE('8/12/2001', 'MM/DD/YYYY'), TO_DATE('8/27/2001', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'TC0109'));
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('TC0110', TO_DATE('9/10/2001', 'MM/DD/YYYY'), TO_DATE('10/1/2001', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'TC0110'));
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('TC0111', TO_DATE('10/22/2001', 'MM/DD/YYYY'), TO_DATE('11/20/2001', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'TC0111'));
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('TC0201_LEGI', TO_DATE('1/21/2002', 'MM/DD/YYYY'), TO_DATE('3/25/2002', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'TC0201'));
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('TC0201_LEGII', TO_DATE('1/21/2002', 'MM/DD/YYYY'), TO_DATE('3/25/2002', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'TC0201'));
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('TC0207', TO_DATE('9/8/2002', 'MM/DD/YYYY'), TO_DATE('10/7/2002', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'TC0207'));
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('TC9905', TO_DATE('4/26/1999', 'MM/DD/YYYY'), TO_DATE('5/9/1999', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'TC9905'));
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('TC9906', TO_DATE('5/15/1999', 'MM/DD/YYYY'), TO_DATE('5/31/1999', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'TC9906'));
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('TC9908', TO_DATE('7/15/1999', 'MM/DD/YYYY'), TO_DATE('8/2/1999', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'TC9908'));
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('TC9909_LEGI', TO_DATE('8/13/1999', 'MM/DD/YYYY'), TO_DATE('8/29/1999', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'TC9909'));
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('TC9909_LEGII', TO_DATE('8/30/1999', 'MM/DD/YYYY'), TO_DATE('9/7/1999', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'TC9909'));
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('TC9910', TO_DATE('10/6/1999', 'MM/DD/YYYY'), TO_DATE('11/4/1999', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'TC9910'));
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID) values ('TC0005', TO_DATE('5/8/2000', 'MM/DD/YYYY'), TO_DATE('5/17/2000', 'MM/DD/YYYY'), 'Leg dates were made up for testing purposes based on the dates in the cast files', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'TC0005'));




insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'HA1007'), 'HA1007');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'HA1008'), 'HA1008');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'HA1201_LEG_I'), 'HA1201_LEGI');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'HA1201_LEG_II&III'), 'HA1201_LEGII&III');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'HA1201_LEG_IV'), 'HA1201_LEGIV');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'HA1201_LEG_I'), 'HA1201_LEG_I');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'HA1201_LEG_II&III'), 'HA1201_LEG_II&III');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'HA1201_LEG_IV'), 'HA1201_LEG_IV');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'HI0401'), 'HI0401');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'HI0401'), 'HI-04-01');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'HI0602'), 'HI0602');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'HI0604'), 'HI0604');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'HI0609'), 'HI0609');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'HI0610'), 'HI0610');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'HI0611'), 'HI0611');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'HI0701'), 'HI0701');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'HI1001_LEGI'), 'HI1001_LEGI');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'HI1001_LEGII'), 'HI1001_LEGII');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'HI1001_LEGIII'), 'HI1001_LEGIII');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'HA1101_LEG_I'), 'HI1101_LEGI');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'HA1101_LEG_II'), 'HI1101_LEGII');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'HA1101_LEG_III'), 'HI1101_LEGIII');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'HA1101_LEG_I'), 'HA1101_LEGI');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'HA1101_LEG_II'), 'HA1101_LEGII');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'HA1101_LEG_III'), 'HA1101_LEGIII');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0304'), 'OES0304');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0304'), 'OS-03-04');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0306'), 'OES0306');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0306'), 'OS-03-06');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0407'), 'OES0407');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0407'), 'OS-04-07');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0410'), 'OES0410');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0410'), 'OS-04-10');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0411_LEGI'), 'OES0411_LEGI');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0411_LEGII'), 'OES0411_LEGII');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0504'), 'OES0504');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0504'), 'OS-05-04');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0504'), 'OS0504');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0506'), 'OES0506');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0506'), 'OS-05-06');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0506'), 'OS0506');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0509'), 'OES0509');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0509'), 'OS-05-09');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0509'), 'OS0509');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0512'), 'OES0512');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0512'), 'OS-05-12');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0512'), 'OS0512');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0604'), 'OES0604');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0604'), 'OS-06-04');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0604'), 'OS0604');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0606'), 'OES0606');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0606'), 'OS-06-06');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0606'), 'OS0606');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0607'), 'OES0607');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0607'), 'OS-06-07');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0607'), 'OS0607');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0608'), 'OES0608');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0608'), 'OS-06-08');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0608'), 'OS0608');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0706'), 'OES0706');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0706'), 'OS-07-06');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0706'), 'OS0706');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0908_LEGI'), 'OES0908_LEGI');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0908_LEGII'), 'OES0908_LEGII');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'SE-15-01'), 'SE1501');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'SE-15-01'), 'SE15-01');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'SE-15-01'), 'SE-15-01');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'SE-15-01'), '15_01');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'TC0005'), 'TC0005');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'TC0005'), 'TC_00_05');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'TC0009'), 'TC0009');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'TC0009'), 'TC-00-09');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'TC0011'), 'TC0011');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'TC0011'), 'TC-00-11');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'TC0012'), 'TC0012');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'TC0012'), 'TC-00-12');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'TC0108'), 'TC0108');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'TC0108'), 'TC-01-08');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'TC0109_LEGI'), 'TC0109_LEGI');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'TC0109_LEGII'), 'TC0109_LEGII');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'TC0110'), 'TC0110');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'TC0110'), 'TC-01-10');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'TC0111'), 'TC0111');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'TC0111'), 'TC-01-11');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'TC0201_LEGI'), 'TC0201_LEGI');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'TC0201_LEGII'), 'TC0201_LEGII');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'TC0207'), 'TC0207');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'TC0207'), 'TC-02-07');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'TC9905'), 'TC9905');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'TC9905'), '99-05');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'TC9906'), 'TC9906');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'TC9906'), '99-06');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'TC9908'), 'TC9908');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'TC9908'), 'TC99-08');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'TC9909_LEGI'), 'TC9909_LEGI');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'TC9909_LEGII'), 'TC9909_LEGII');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'TC9910'), 'TC9910');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'TC9910'), 'TC-99-10');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'SE-17-07'), 'SE-17-07');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'SE-17-07'), 'SE1707');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'SE-17-07'), 'SE17-07');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'SE-18-06'), 'SE-18-06');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'SE-18-06'), 'SE1806');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'SE-18-06'), 'SE18-06');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'SE-17-02'), 'SE-17-02');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'SE-17-02'), 'SE1702');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'SE-17-02'), 'SE17-02');



insert into ccd_leg_regions (REGION_ID, CRUISE_LEG_ID, LEG_REGION_DESC) values ((SELECT region_id from ccd_regions where region_code = 'MHI'), (SELECT cruise_leg_id from ccd_cruise_legs where leg_name = 'SE-17-07'), '');
insert into ccd_leg_regions (REGION_ID, CRUISE_LEG_ID, LEG_REGION_DESC) values ((SELECT region_id from ccd_regions where region_code = 'MHI'), (SELECT cruise_leg_id from ccd_cruise_legs where leg_name = 'SE-18-06'), '');
insert into ccd_leg_regions (REGION_ID, CRUISE_LEG_ID, LEG_REGION_DESC) values ((SELECT region_id from ccd_regions where region_code = 'MHI'), (SELECT cruise_leg_id from ccd_cruise_legs where leg_name = 'SE-17-02'), '');
insert into ccd_leg_regions (REGION_ID, CRUISE_LEG_ID, LEG_REGION_DESC) values ((SELECT region_id from ccd_regions where region_code = 'NPSF'), (SELECT cruise_leg_id from ccd_cruise_legs where leg_name = 'SE-15-01'), '');
insert into ccd_leg_regions (REGION_ID, CRUISE_LEG_ID, LEG_REGION_DESC) values ((SELECT region_id from ccd_regions where region_code = 'PRIA'), (SELECT cruise_leg_id from ccd_cruise_legs where leg_name = 'HA1201_LEG_I'), '');
insert into ccd_leg_regions (REGION_ID, CRUISE_LEG_ID, LEG_REGION_DESC) values ((SELECT region_id from ccd_regions where region_code = 'AMSM'), (SELECT cruise_leg_id from ccd_cruise_legs where leg_name = 'HA1201_LEG_I'), '');
insert into ccd_leg_regions (REGION_ID, CRUISE_LEG_ID, LEG_REGION_DESC) values ((SELECT region_id from ccd_regions where region_code = 'AMSM'), (SELECT cruise_leg_id from ccd_cruise_legs where leg_name = 'HA1201_LEG_II&III'), '');
insert into ccd_leg_regions (REGION_ID, CRUISE_LEG_ID, LEG_REGION_DESC) values ((SELECT region_id from ccd_regions where region_code = 'PRIA'), (SELECT cruise_leg_id from ccd_cruise_legs where leg_name = 'HA1201_LEG_IV'), '');
insert into ccd_leg_regions (REGION_ID, CRUISE_LEG_ID, LEG_REGION_DESC) values ((SELECT region_id from ccd_regions where region_code = 'PRIA'), (SELECT cruise_leg_id from ccd_cruise_legs where leg_name = 'HA1101_LEG_I'), '');
insert into ccd_leg_regions (REGION_ID, CRUISE_LEG_ID, LEG_REGION_DESC) values ((SELECT region_id from ccd_regions where region_code = 'CNMI'), (SELECT cruise_leg_id from ccd_cruise_legs where leg_name = 'HA1101_LEG_II'), '');
insert into ccd_leg_regions (REGION_ID, CRUISE_LEG_ID, LEG_REGION_DESC) values ((SELECT region_id from ccd_regions where region_code = 'PRIA'), (SELECT cruise_leg_id from ccd_cruise_legs where leg_name = 'HA1101_LEG_III'), '');
insert into ccd_leg_regions (REGION_ID, CRUISE_LEG_ID, LEG_REGION_DESC) values ((SELECT region_id from ccd_regions where region_code = 'PRIA'), (SELECT cruise_leg_id from ccd_cruise_legs where leg_name = 'HI1001_LEGI'), '');
insert into ccd_leg_regions (REGION_ID, CRUISE_LEG_ID, LEG_REGION_DESC) values ((SELECT region_id from ccd_regions where region_code = 'AMSM'), (SELECT cruise_leg_id from ccd_cruise_legs where leg_name = 'HI1001_LEGII'), '');
insert into ccd_leg_regions (REGION_ID, CRUISE_LEG_ID, LEG_REGION_DESC) values ((SELECT region_id from ccd_regions where region_code = 'PRIA'), (SELECT cruise_leg_id from ccd_cruise_legs where leg_name = 'HI1001_LEGIII'), '');

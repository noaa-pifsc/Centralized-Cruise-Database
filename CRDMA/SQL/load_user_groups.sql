INSERT INTO AUTH_APP_USERS (APP_USER_NAME, APP_USER_COMMENTS, APP_USER_ACTIVE_YN) VALUES ('jesse.abdul', '', 'Y');
INSERT INTO AUTH_APP_USERS (APP_USER_NAME, APP_USER_COMMENTS, APP_USER_ACTIVE_YN) VALUES ('noriko.shoji', '', 'Y');
INSERT INTO AUTH_APP_USERS (APP_USER_NAME, APP_USER_COMMENTS, APP_USER_ACTIVE_YN) VALUES ('chad.yoshinaga', '', 'Y');
INSERT INTO AUTH_APP_USERS (APP_USER_NAME, APP_USER_COMMENTS, APP_USER_ACTIVE_YN) VALUES ('russell.reardon', '', 'Y');
INSERT INTO AUTH_APP_USERS (APP_USER_NAME, APP_USER_COMMENTS, APP_USER_ACTIVE_YN) VALUES ('kristin.m.sojka', '', 'Y');
INSERT INTO AUTH_APP_USERS (APP_USER_NAME, APP_USER_COMMENTS, APP_USER_ACTIVE_YN) VALUES ('benjamin.richards', '', 'Y');


INSERT INTO AUTH_APP_GROUPS (APP_GROUP_NAME, APP_GROUP_CODE, APP_GROUP_DESC) VALUES ('Administrators', 'DATA_ADMIN', 'Administrative users that can edit data for any division/program');


INSERT INTO AUTH_APP_USER_GROUPS (APP_USER_ID, APP_GROUP_ID) VALUES ((SELECT APP_USER_ID FROM AUTH_APP_USERS WHERE APP_USER_NAME = 'jesse.abdul'), (SELECT APP_GROUP_ID FROM AUTH_APP_GROUPS WHERE APP_GROUP_CODE = 'DATA_ADMIN'));
INSERT INTO AUTH_APP_USER_GROUPS (APP_USER_ID, APP_GROUP_ID) VALUES ((SELECT APP_USER_ID FROM AUTH_APP_USERS WHERE APP_USER_NAME = 'noriko.shoji'), (SELECT APP_GROUP_ID FROM AUTH_APP_GROUPS WHERE APP_GROUP_CODE = 'DATA_ADMIN'));
INSERT INTO AUTH_APP_USER_GROUPS (APP_USER_ID, APP_GROUP_ID) VALUES ((SELECT APP_USER_ID FROM AUTH_APP_USERS WHERE APP_USER_NAME = 'chad.yoshinaga'), (SELECT APP_GROUP_ID FROM AUTH_APP_GROUPS WHERE APP_GROUP_CODE = 'DATA_ADMIN'));
INSERT INTO AUTH_APP_USER_GROUPS (APP_USER_ID, APP_GROUP_ID) VALUES ((SELECT APP_USER_ID FROM AUTH_APP_USERS WHERE APP_USER_NAME = 'russell.reardon'), (SELECT APP_GROUP_ID FROM AUTH_APP_GROUPS WHERE APP_GROUP_CODE = 'DATA_ADMIN'));
INSERT INTO AUTH_APP_USER_GROUPS (APP_USER_ID, APP_GROUP_ID) VALUES ((SELECT APP_USER_ID FROM AUTH_APP_USERS WHERE APP_USER_NAME = 'kristin.m.sojka'), (SELECT APP_GROUP_ID FROM AUTH_APP_GROUPS WHERE APP_GROUP_CODE = 'DATA_ADMIN'));
INSERT INTO AUTH_APP_USER_GROUPS (APP_USER_ID, APP_GROUP_ID) VALUES ((SELECT APP_USER_ID FROM AUTH_APP_USERS WHERE APP_USER_NAME = 'benjamin.richards'), (SELECT APP_GROUP_ID FROM AUTH_APP_GROUPS WHERE APP_GROUP_CODE = 'DATA_ADMIN'));


--commit the transaction:
COMMIT;

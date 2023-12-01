c:

cd [working copy root]\SQL

sqlplus /nolog

@"../docs/releases/1.0/Deployment_Scripts/automated_deployments/deploy_dev_v1.0.sql"


sqlplus /nolog

@"../docs/releases/1.0/Deployment_Scripts/automated_deployments/deploy_apex_dev_v1.0.sql"


EXIT

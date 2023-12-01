c:

cd [working copy root]\SQL

sqlplus /nolog

@"../docs/releases/1.0/Deployment_Scripts/automated_deployments/deploy_prod_v1.0.sql"


sqlplus /nolog

@"../docs/releases/1.0/Deployment_Scripts/automated_deployments/deploy_apex_prod_v1.0.sql"


EXIT

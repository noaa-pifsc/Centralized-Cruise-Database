c:

cd [working copy root]\SQL

sqlplus /nolog

@"../docs/releases/1.0/Deployment_Scripts/automated_deployments/deploy_qa_v1.0.sql"


sqlplus /nolog

@"../docs/releases/1.0/Deployment_Scripts/automated_deployments/deploy_apex_qa_v1.0.sql"


EXIT

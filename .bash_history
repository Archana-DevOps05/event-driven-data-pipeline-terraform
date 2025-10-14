mkdir event-driven-pipeline
cd event-driven-pipeline/
mkdir terraform
nano main.tf
nano vairable.tf
cd event-driven-pipeline/
cd lambda/
mkdir daily_report
nano app.py
ls
cp app.py home/ubuntu/event-driven-pipeline/lambda/daily_report
lrm -rf app.py 
rm -rf app.py 
cd daily_report/
nano app.py
touch requirement.txt
cd ..
cd processor/
touch requirement.txt
cd ../..
mkdir scripts
cd scripts/
lambda.sh
nano lambda.sh
chmod 774 lambda.sh 
nano upload_test_data.py
chmod 774 upload_test_data.py 
nano .gitignore
cd ..
cd terraform/
ls
terraform apply
sudo update
sudoapt  update
sudo apt  update
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt-get install terraform
terraform -help
terraform plan
terraform init
nano main.tf 
ls
nano variable.tf 
terraform init
terraform plan
cat variable.tf 
nano variable.tf 
terraform plan
sudo apt update
sudo apt install awscli -y
aws configure
sudo apt remove awscli -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip -y      # if unzip is not installed
unzip awscliv2.zip
sudo ./aws/install
aws configure
cd event-driven-pipeline/
terraform plan
cd terraform/
terraform plan
ls ../lambda_zip/
nano variable.tf 
terraform plan
cat variable.tf 
nano variable.tf 
terraform plan
mkdir -p ../my_lambdas
ls
mkdir -p ../my_lambdas
ls
nano my_lambdas
ls -l ../my_lambdas
ls
cat my_lambdas 
zip processor.zip processor.js
sudo apt install zip
zip processor.zip processor.js
cd ../../
cd ~/event-driven-pipeline/terraform
mkdir -p ../my_lambdas
rm -rf my_lambdas 
echo 'exports.handler = async (event) => { return "Hello World"; };' > ../my_lambdas/processor.js
echo 'exports.handler = async (event) => { return "Report generated"; };' > ../my_lambdas/report.js
cd my_lambdas/
echo 'exports.handler = async (event) => { return "Hello World"; };' > ../my_lambdas/processor.js
echo 'exports.handler = async (event) => { return "Report generated"; };' > ../my_lambdas/report.js
zip processor.zip processor.js
zip report.zip report.js
cd ..
terraform plan
ls -l
ls -l my_lambdas/
nano variable.tf 
pwd
nano variable.tf 
terraform plan
terraform apply -auto-approve plan.out
terraform appl
terraform apply
pwd
terraform apply -var "region=us-east-1"                 -var "processor_lambda_zip=../lambda_zip/processor.zip"                 -var "report_lambda_zip=../lambda_zip/report.zip"
cat variable.tf 
terraform apply -var "region=us-east-1"                 -var "raw_bucket_name=edp-raw-bucket-archana-devops05"                 -var "processed_bucket_name=edp-processed-bucket-archana-devops05"                 -var "processor_zip_path=/home/ubuntu/event-driven-pipeline/terraform/my_lambdas/processor.zip"                 -var "report_zip_path=/home/ubuntu/event-driven-pipeline/terraform/my_lambdas/report.zip"
aws logs describe-log-streams --log-group-name /aws/lambda/archana-devops-lambda --order-by LastEventTime --descending
aws logs create-log-group --log-group-name /aws/lambda/processor_lambda
aws logs create-log-group --log-group-name /aws/lambda/report_lambda
aws logs describe-log-groups --log-group-name-prefix /aws/lambda/
aws logs describe-log-groups --log-archana-prefix /aws/lambda/
aws logs describe-log-streams --log-group-name /aws/lambda/processor_lambda --order-by LastEventTime --descending
aws logs create-log-group   --log-group-name /aws/lambda/edp_data_processor_8f92f975   --region us-east-1
aws logs create-log-group   --log-group-name /aws/lambda/edp_data_processor_05   --region us-east-1
aws iam attach-role-policy   --role-name lambda_event_pipeline_role_05   --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole
aws iam attach-role-policy   --role-name lambda_event_pipeline_role_8f92f975   --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole
aws lambda invoke   --function-name edp_data_processor_8f92f975   --region us-east-1   output.json
aws s3 cp ~/test_data.csv s3://edp-raw-bucket-archana-devops05/
cat << "EOF" > test01_data.csv
Hello Sandhya
EOF

LS
ls
aws s3 cp ~/test01_data.csv s3://edp-raw-bucket-archana-devops05/
[200~aws lambda get-function-configuration --function-name edp_data_processor_8f92f975
~aws lambda get-function-configuration --function-name edp_data_processor_8f92f975
aws lambda get-function-configuration --function-name edp_data_processor_8f92f975
aws s3 cp ~/test_data.csv s3://edp-raw-bucket-archana-devops05/
aws logs create-log-group   --log-group-name /aws/lambda/edp_data_processor_8f92f975   --region us-east-1
aws iam attach-role-policy   --role-name lambda_event_pipeline_role_8f92f975   --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole
aws lambda invoke   --function-name edp_data_processor_8f92f975   --region us-east-1   output.json
aws s3 cp ~/test_data.csv s3://edp-raw-bucket-archana-devops05/
aws logs create-log-group   --log-group-name /aws/lambda/edp_data_processor_8f92f975   --region us-east-1
aws lambda invoke   --function-name edp_data_processor_8f92f975   --region us-east-1   output.json
aws iam attach-role-policy   --role-name lambda_event_pipeline_role_8f92f975   --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole
aws s3 cp ~/test_data.csv s3://edp-raw-bucket-archana-devops05/
aws logs create-log-group   --log-group-name /aws/lambda/edp_data_processor_8f92f975   --region us-east-1
aws iam attach-role-policy   --role-name lambda_event_pipeline_role_8f92f975   --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole
aws lambda invoke   --function-name edp_data_processor_8f92f975   --region us-east-1   output.json
aws s3 cp ~/test_data.csv s3://edp-raw-bucket-archana-devops05/

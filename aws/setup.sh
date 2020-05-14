export SERVICE_NAME="serverless-batch"
export REGION="eu-central-1"
export INIT_CODE_BUCKET="exemplary-code-repository"
export INIT_ZIP_FILE="initial-code.zip"

# Zip the initial code and push it to a new S3 bucket
cd ..
zip $INIT_ZIP_FILE app/* buildspec.yml Dockerfile requirements.txt
aws s3 mb s3://$INIT_CODE_BUCKET
aws s3 cp $INIT_ZIP_FILE s3://$INIT_CODE_BUCKET
rm $INIT_ZIP_FILE

# Create Stack for Networking
autostacker24 update \
    --stack $SERVICE_NAME-network \
    --template aws/network-stack.yaml \
    --region $REGION \
    --tag service=$SERVICE_NAME \
    --tag creator="cloudformation"

# Create Stack for Roles and Policies
autostacker24 update \
    --stack $SERVICE_NAME-roles \
    --template aws/iam-stack.yaml \
    --region $REGION \
    --param SERVICENAME=$SERVICE_NAME \
    --tag service=$SERVICE_NAME \
    --tag creator="cloudformation"

# Create Stack for Resources / Building Blocks
autostacker24 update \
    --stack $SERVICE_NAME-services \
    --template aws/services-stack.yaml \
    --region $REGION \
    --param SERVICENAME=$SERVICE_NAME \
    --param INITCODEBUCKET=$INIT_CODE_BUCKET \
    --param INITZIPFILE=$INIT_ZIP_FILE \
    --tag service=$SERVICE_NAME \
    --tag creator="cloudformation"

# Upload exemplary file to bucket
aws s3 cp supporting/example.txt s3://serverless-batch-data-bucket

# Clean up the S3 bucket with the initial code repository
aws s3 rb s3://$INIT_CODE_BUCKET --force
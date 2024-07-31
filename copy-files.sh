#!/bin/bash

aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
aws configure set region $AWS_DEFAULT_REGION
file_name=$(ls -ltc $FILE_PATH | head -n 2 | tail -n 1 | awk '{print $NF}')
echo '------------------ Copying Files To Bucket -----------------------------'
aws s3 cp $FILE_PATH/$file_name s3://BUCKET_NAME/
echo '------------ DONE -------------------------------------------------------'

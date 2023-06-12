#!/usr/bin/env bash


#getting job id for running job.
authorizedAccounts=$(gcloud auth list --filter=status:ACTIVE --format="value(account)")
#check if active accounts found.
if [ -z $authorizedAccounts ]; then
  echo "Not Authorized to Run..."
    exit 1
else
  echo "Authorized to Run..."
fi

#export GCP_REGION="europe-west2" # CHANGEME (OPT)
#export GCP_ZONE="europe-west2-a" # CHANGEME (OPT)


#export SCHEMA_ID="customer-schema"


# enable apis
gcloud services enable compute.googleapis.com \
    pubsub.googleapis.com

# set defaults
gcloud config set compute/region $GCP_REGION
gcloud config set compute/zone $GCP_ZONE

# check schema already exists
gcloud pubsub schemas list | grep ${SCHEMA_ID}
return_code=$?
if [[ $return_code -eq 0 ]];then
  echo "schema : ${SCHEMA_ID} already exists !"
else
  # define schema
  gcloud pubsub schemas create ${SCHEMA_ID} \
  --definition="syntax = 'proto3'; \
  message Message {  string cust_id = 1; string first_name = 2; string last_name = 3; string account_type = 4; string customer_since = 5; bool active = 6;}" \
  --type=PROTOCOL_BUFFER
fi

# delete schema
#gcloud beta pubsub schemas delete ${SCHEMA_ID} --quiet


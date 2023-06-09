#!/usr/bin/env bash

#export PROJECT_ID="<project_id>"
#export TOPIC_ID="test-topic-1"
#export SCHEMA_ID="customer-schema"

#getting job id for running job.
authorizedAccounts=$(gcloud auth list --filter=status:ACTIVE --format="value(account)")
#check if active accounts found.
if [ -z $authorizedAccounts ]; then
  echo "Not Authorized to Run..."
    exit 1
else
  echo "Authorized to Run..."
fi

echo 'check topic > gcloud pubsub topics list --project="'${PROJECT_ID}'" --filter="name.scope(topic):'${TOPIC_ID}'" | grep name'
gcloud pubsub topics list --project=$PROJECT_ID --filter="name.scope(topic):'${TOPIC_ID}'" | grep name
list_topic_return_code=$?
echo 'topics list return_code : ' $list_topic_return_code
  if [[ $list_topic_return_code -eq 0 ]]; then
    echo "Topic : '${TOPIC_ID}' already exits!"
    else
      echo "create topic >> gcloud pubsub topics create ${TOPIC_ID} --schema-project=${PROJECT_ID} --schema=${SCHEMA_ID}"
      gcloud pubsub topics create ${TOPIC_ID}\
       --schema-project=${PROJECT_ID}\
       --schema=${SCHEMA_ID}\
       --message-encoding=JSON 
  fi



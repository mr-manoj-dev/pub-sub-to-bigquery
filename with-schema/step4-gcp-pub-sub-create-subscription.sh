#!/usr/bin/env bash

#export PROJECT_ID="<project_id>"
#export DATASET_ID="direct_pubsub_to_bq"
#export TOPIC_ID="test-topic-1"
#export SUBSCRIPTION_ID="test-sub-1"


#getting job id for running job.
authorizedAccounts=$(gcloud auth list --filter=status:ACTIVE --format="value(account)")
#check if active accounts found.
if [ -z $authorizedAccounts ]; then
  echo "Not Authorized to Run..."
    exit 1
else
  echo "Authorized to Run..."
fi



echo 'check subscription > gcloud pubsub subscriptions list --project="'${PROJECT_ID}'" --filter="name.scope(subscriptions):'${SUBSCRIPTION_ID}'" | grep name'
gcloud pubsub subscriptions list --project=$PROJECT_ID --filter="name.scope(subscriptions):'${SUBSCRIPTION_ID}'" | grep name
list_subscriptions_return_code=$?
echo 'subscriptions list return_code : ' $list_subscriptions_return_code
  if [[ $list_subscriptions_return_code -eq 0 ]]; then
    echo "Subscription : '${SUBSCRIPTION_ID}' already exits!"
    else
      echo "Creating Subscription : '${SUBSCRIPTION_ID}' ......."
      #gcloud pubsub subscriptions create ${SUBSCRIPTION_ID} --topic ${TOPIC_ID} --ack-deadline=60

      gcloud pubsub subscriptions create ${SUBSCRIPTION_ID} \
      --topic=${TOPIC_ID} \
      --bigquery-table=${PROJECT_ID}:${DATASET_ID}.customer \
      --drop-unknown-fields --use-topic-schema\
      --write-metadata #message_id,publish_time,attributes,subscription_name These columns you need to provide into BQ table.
  fi



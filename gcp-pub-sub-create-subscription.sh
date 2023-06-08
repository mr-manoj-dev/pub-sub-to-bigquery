#!/usr/bin/env bash

PROJECT_ID="burner-mankumar24"
export TOPIC_ID="test-topic-1"
export SUBSCRIPTION_ID="test-sub-1"


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
      gcloud pubsub subscriptions create ${SUBSCRIPTION_ID} --topic ${TOPIC_ID} --ack-deadline=60
  fi



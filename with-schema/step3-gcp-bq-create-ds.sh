
#export PROJECT_ID="<project_id>"
#export DATASET_ID="direct_pubsub_to_bq"
#export TABLE_NAME="customer"
#export GCP_REGION="europe-west2" 

#getting job id for running job.
authorizedAccounts=$(gcloud auth list --filter=status:ACTIVE --format="value(account)")
#check if active accounts found.
if [ -z $authorizedAccounts ]; then
  echo "Not Authorized to Run..."
    exit 1
else
  echo "Authorized to Run..."
fi


  bq show ${PROJECT_ID}:${DATASET_ID}
  return_code=$?
  if [[ $return_code -eq 0 ]]; then
    echo ${DATASET_ID}" already exits !"
  else
    echo ${DATASET_ID}" does not exist! Creating ....!"
    bq mk --data_location=${GCP_REGION} \
     --description='Dataset to test out BigQuery pubsub subscription'\
     --dataset ${DATASET_ID}
     

    echo "Dataset "${DATASET_ID} "created !"
  fi



  echo "Check whether table ${DATASET_ID}.${TABLE_NAME} exists or not before creating it !"
  echo bq query --project_id $project_id --use_legacy_sql=false "select count(*) as ${2}_count from "${DATASET_ID}.${TABLE_NAME}""
  bq query --project_id ${PROJECT_ID} --use_legacy_sql=false "select count(*) as ${TABLE_NAME}_count from "${DATASET_ID}.${TABLE_NAME}""
  return_code=$?
  if [[ $return_code -eq 0 ]]; then
    echo "Table ${DATASET_ID}.${TABLE_NAME} already exists !"
  else
    echo "Creating ${DATASET_ID}.${TABLE_NAME} ............"
      bq mk \
      --table \
      --location ${GCP_REGION} \
      --description "This is test table" \
      ${DATASET_ID}.${TABLE_NAME} \
      schema.json
    
    if [ $? -ne 0 ]; then
        echo "BQ table create failed for : Dataset - ${DATASET_ID} Table - ${TABLE_NAME} with schema : schema.json!"
        exit 1
    else
        echo "BQ table created successfully : Dataset - ${DATASET_ID} Table - ${TABLE_NAME} with schema : schema.json!"
    fi

  fi

#echo "Grant the BigQuery Data Editor and the BigQuery Metadata Viewer role to the Pub/Sub service account"
# Provide access to dataset with required roles(Bigquery Editor and Metadata viewer) to the pub-sub service account.
# Before creating subscription. At the moment not able to update using gcloud command.
# provide access mannualy by going BigQuery dataset
# service-<numeric_project_id>@gcp-sa-pubsub.iam.gserviceaccount.com
#
#bq show --format=prettyjson ${PROJECT_ID}:${DATASET_ID} > bq_access_details.json
#bq show --format=prettyjson <project_id>:direct_pubsub_to_bq > bq_access_details1.json
# The above command will give a json file with access list aong with roles
# Add two roles :     {
#      "role": "roles/bigquery.dataEditor",
#      "userByEmail": "service-numeric_project_id@gcp-sa-pubsub.iam.gserviceaccount.com"
#    },
#    {
#      "role": "roles/bigquery.metadataViewer",
#      "userByEmail": "service-numeric_project_id@gcp-sa-pubsub.iam.gserviceaccount.com"
#    }
# and run below command to update   

#bq update --source bq_access_details.json ${PROJECT_ID}:${DATASET_ID}



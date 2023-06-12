# Get all the dependency required
pip install -r requirements.txt

#export env variables
export PROJECT_ID="project_id"
export TOPIC_ID="test-topic-1"
export SCHEMA_ID="customer-schema"

export DATASET_ID="direct_pubsub_to_bq"
export TABLE_NAME="customer"



export GCP_REGION="us-central1"
export GCP_ZONE="us-central1-a"
export GCP_BQ_LOCATION="US"


export SUBSCRIPTION_ID="test-sub-1"

#Run to publish messages
python main.py
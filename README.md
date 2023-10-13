# pub-sub-to-bigquery
Sample application to sync messages from pub sub to bigquery.



gcloud compute project-info add-metadata --metadata google-compute-default-region=us-central1,google-compute-default-zone=us-central1-a


Provide access to dataset with required roles(Bigquery Editor and Metadata viewer) to the pub-sub service account.
Before creating subscription.
service-<numeric_project_id>@gcp-sa-pubsub.iam.gserviceaccount.com


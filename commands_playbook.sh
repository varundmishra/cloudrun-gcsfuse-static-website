#Commands Playbook
#Set Custom variables
export PROJECT_ID=YOUR_PROJECT_ID
export REGION=YOUR_COMPUTE_REGION
export BUCKET=YOUR_BUCKET_NAME

#Setting up gcloud defaults
#Set your default project:
gcloud config set project $PROJECT_ID
#Configure gcloud for your chosen region:
gcloud config set run/region $REGION

#Service Account Creation
#Create a service account to serve as the service identity:
gcloud iam service-accounts create cr-identity
#Grant the service account access to the Cloud Storage bucket:
gcloud projects add-iam-policy-binding $PROJECT_ID --member "serviceAccount:cr-identity@$PROJECT_ID.iam.gserviceaccount.com" --role "roles/storage.objectAdmin"

#Setting up the Cloud Storage Bucket
#Create a bucket:
gcloud storage buckets create gs://$BUCKET
#Copy files from you local dir to Cloud Storage Bucket
gcloud storage cp local-dir/index.html gs://$BUCKET 
#Alternatively you can upload files using the gsutil rsync
#You can use the -R option to recursively copy directory trees. For example, to synchronize a local directory named local-dir with a bucket, use the following:
gsutil rsync -R local-dir gs://$BUCKET

#Creating the Cloud Run Service
#Ensure you are in the root of this directory
#This will create a Cloud Run service with name cloudrun-static-demo that will be accessible from anywhere
gcloud run deploy cloudrun-static-demo --source . --execution-environment gen2 --allow-unauthenticated --service-account cr-identity --set-env-vars=BUCKET=$BUCKET --port 80
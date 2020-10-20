container_id=$(docker create rho-backend)
docker cp ${container_id}:/app/start_release start_release
docker rm ${container_id}
export BUCKET_NAME="rho-backend-releases"
gsutil cp start_release gs://${BUCKET_NAME}/hello-release

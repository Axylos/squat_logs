docker rm --force squat_log_app
docker run -it \
  --name squat_log_app \
  --publish 8065:8080 \
  drackenov/squat_log_view:latest

#!/bin/bash
set -e

ES_URL="https://localhost:9200"
ES_USER="elastic"
ES_PASS="${ELASTIC_PASSWORD:-changeme}"

# Wait for Elasticsearch to be ready
echo "Waiting for Elasticsearch..."
until curl -s -k -u "$ES_USER:$ES_PASS" "$ES_URL/_cluster/health" | grep -vq '"status":"red"'; do
  sleep 5
done
echo "Elasticsearch is ready!"

# === Create Roles ===
echo "Creating roles..."
for role_file in /roles/*.json; do
  role_name=$(basename "$role_file" .json)
  echo "Creating role: $role_name"
  curl -s -k -u "$ES_USER:$ES_PASS" -X PUT "$ES_URL/_security/role/$role_name" \
       -H "Content-Type: application/json" \
       -d @"$role_file" ; echo
done

# === Create Users ===
echo "Creating users vector and backend..."
curl -s -k -u "$ES_USER:$ES_PASS" -X POST "$ES_URL/_security/user/vector" \
     -H "Content-Type: application/json" \
     -d "{
           \"password\": \"${VECTOR_PASSWORD:-changeme}\",
           \"roles\": [\"vector_role\"]
         }" ; echo

curl -s -k -u "$ES_USER:$ES_PASS" -X POST "$ES_URL/_security/user/backend" \
     -H "Content-Type: application/json" \
     -d "{
           \"password\": \"${BACKEND_PASSWORD:-changeme}\",
           \"roles\": [\"backend_role\"]
         }" ; echo

# === Change Kibana system password ===
echo "Updating kibana_system password..."
curl -s -k -u "$ES_USER:$ES_PASS" -X POST "$ES_URL/_security/user/kibana_system/_password" \
     -H "Content-Type: application/json" \
     -d "{
           \"password\": \"${KIBANA_SYSTEM_PASSWORD:-changeme}\"
         }" ; echo

echo "Setup completed!"

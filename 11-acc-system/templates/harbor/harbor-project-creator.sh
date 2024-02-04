#!/bin/bash
Harbor_Url=https://{{ user_registry_address }}:{{ user_registry_port }}
User=admin
Passwd={{ random_passwd.stdout }}

cat <<EOF > tempharborProject.json
 {
  "project_name": "admin",
  "public": false                      
 }
EOF
  cat tempharborProject.json
  curl -u "$User:$Passwd" -X POST -H "Content-Type: application/json"  $Harbor_Url/api/v2.0/projects -k -d @tempharborProject.json

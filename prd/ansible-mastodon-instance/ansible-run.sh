#!/bin/bash -e

if [ -z "$GITHUB_SHA" ]; then
  GITHUB_SHA="main"
fi
echo "Github sha: $GITHUB_SHA"

INSTANCE_ID=$(aws ec2 describe-instances --filters 'Name=tag:Name,Values=mastodon-instance' 'Name=instance-state-name,Values=running' --output text --query 'Reservations[*].Instances[*].InstanceId')

COMMAND_ID=$( \
  aws ssm send-command --document-name "AWS-RunRemoteScript" \
             --output-s3-bucket-name imichka-ansible \
             --output-s3-key-prefix output \
             --targets "Key=instanceids,Values=$INSTANCE_ID"\
             --parameters '{"sourceType":["GitHub"],"sourceInfo":["{\"owner\" : \"iMichka\", \"repository\":\"aws\", \"getOptions\":\"branch:'"$GITHUB_SHA"'\", \"path\":\"prd/ansible-mastodon-instance/setup-mastodon.yaml\"}"], "commandLine":["ansible-playbook -i “localhost,” setup-mastodon.yaml"]}'\
             --timeout-seconds 600 --max-concurrency "50" --max-errors "0" --output text --query "Command.CommandId")

echo "Command id: $COMMAND_ID"

STATUS="None"
x=1
while [ "$STATUS" != "Success" ]
do
  RESULT=$(aws ssm list-command-invocations --command-id "$COMMAND_ID")
  STATUS="$(echo "$RESULT" | jq ".CommandInvocations[0].Status")"
  if [ "$STATUS" == '"InProgress"' ]; then
    echo "Waiting $x times"
    x=$(( x + 1 ))
    sleep 5
  else
    if [ "$STATUS" != '"Success"' ]; then
      echo "Ansible command failed"
      echo "$RESULT"
      aws s3 cp "s3://imichka-ansible/output/$COMMAND_ID/$INSTANCE_ID/awsdownloadContent/downloadContent/stdout" - || true
      aws s3 cp "s3://imichka-ansible/output/$COMMAND_ID/$INSTANCE_ID/awsdownloadContent/downloadContent/stderr" - || true
      aws s3 cp "s3://imichka-ansible/output/$COMMAND_ID/$INSTANCE_ID/awsrunShellScript/runShellScript/stdout" - || true
      aws s3 cp "s3://imichka-ansible/output/$COMMAND_ID/$INSTANCE_ID/awsrunShellScript/runShellScript/stderr" - || true
      exit 1
    fi
    echo "Ansible done"
    aws s3 cp "s3://imichka-ansible/output/$COMMAND_ID/$INSTANCE_ID/awsrunShellScript/runShellScript/stdout" -
    exit 0
  fi
done

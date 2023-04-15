INSTANCE_ID=$(aws ec2 describe-instances --filters 'Name=tag:Name,Values=nat-instance' 'Name=instance-state-name,Values=running' --output text --query 'Reservations[*].Instances[*].InstanceId')
echo $INSTANCE_ID

# # Run a playbook
COMMAND_ID=$( \
	aws ssm send-command --document-name "AWS-RunRemoteScript" \
						 --output-s3-bucket-name imichka-ansible \
						 --output-s3-key-prefix output \
						 --output-s3-region eu-west-3 \
						 --targets "Key=instanceids,Values=$INSTANCE_ID"\
						 --parameters '{"sourceType":["GitHub"],"sourceInfo":["{\"owner\" : \"iMichka\", \"repository\":\"aws\", \"getOptions\":\"branch:main\", \"path\":\"prd/ansible-nat-instance/reverse-proxy.yaml\"}"], "commandLine":["ansible-playbook -i “localhost,” --check -c local hello-world.yaml"]}'\
						 --timeout-seconds 600 --max-concurrency "50" --max-errors "0" --output text --query "Command.CommandId")

echo $COMMAND_ID

aws ssm list-command-invocations \
    --command-id $COMMAND_ID \
    --details

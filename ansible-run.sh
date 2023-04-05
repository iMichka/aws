INSTANCE_ID=$(aws ec2 describe-instances --filters 'Name=tag:Name,Values=mastodon-instance' 'Name=instance-state-name,Values=running' --output text --query 'Reservations[*].Instances[*].InstanceId')
#INSTANCE_IP=$(aws ec2 describe-instances --filters 'Name=tag:Name,Values=ssmdemo,Name=instance-state-name,Values=running' --output text --query 'Reservations[].Instances[].[PublicIpAddress][0]')
echo $INSTANCE_ID

# # Install ansible on machine
# COMMAND_ID=$(aws ssm send-command --instance-ids $INSTANCE_ID --document-name "AWS-RunShellScript" --parameters "commands=sudo apt-add-repository ppa:ansible/ansible && sudo apt update && sudo apt install -y ansible awscli" --output text --query "Command.CommandId")
# echo $COMMAND_ID

# # wait for command to finish
# until aws ssm get-command-invocation --command-id ${COMMAND_ID} --instance-id ${INSTANCE_ID} | grep Success; do
#     echo -n . && sleep 0.1
# done

# aws ssm get-command-invocation --command-id ${COMMAND_ID} --instance-id ${INSTANCE_ID}

# # Run a playbook
COMMAND_ID=$( \
	aws ssm send-command --document-name "AWS-RunRemoteScript" \
						 --output-s3-bucket-name imichka-ansible \
						 --output-s3-key-prefix output \
						 --output-s3-region eu-west-3 \
						 --targets "Key=instanceids,Values=$INSTANCE_ID"\
						 --parameters '{"sourceType":["GitHub"],"sourceInfo":["{\"owner\" : \"iMichka\", \"repository\":\"aws\", \"getOptions\":\"branch:main\", \"path\":\"prd/hello-world.yaml\"}"], "commandLine":["ansible-playbook -i “localhost,” --check -c local hello-world.yaml"]}'\
						 --timeout-seconds 600 --max-concurrency "50" --max-errors "0" --output text --query "Command.CommandId")

echo $COMMAND_ID

# until aws ssm get-command-invocation --command-id ${COMMAND_ID} --instance-id ${INSTANCE_ID} | grep Success; do
 #   echo -n . && sleep 0.1
#done

#aws ssm get-command-invocation --command-id ${COMMAND_ID} --instance-id ${INSTANCE_ID}

aws ssm list-command-invocations \
    --command-id $COMMAND_ID \
    --details


aws ssm list-command-invocations \
    --command-id a54ebec6-061a-4d6c-8165-cdf71e26c69c \
    --details

#!/usr/bin/env bash

################################################################################################
# This script is used to test connectivity from an EC2 instance to test EC2s in VPC(s)/Subnet(s)
# Pre-Requisites:
# - Installed AWS CLI
# - AWS credentials configured for the account
# - jq installed
# - test-connectivity.json file in the same directory as this script
# - AWS_DEFAULT_REGION environment variable set to the region to test
################################################################################################

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

function help() {
    echo "Usage: $0 {test-commands-file}"
    exit 0
}

function test_instance(){
    VPC_ID="$1"
    INSTANCE_ID="$2"
    PRIVATE_IP="$3"

    VPC_ROLE=$(aws ec2 describe-vpcs --vpc-ids $VPC_ID --query "Vpcs[*].Tags[?Key=='vpc_role'].Value|[0]" --output text)
    echo "VpcId: $VPC_ID VpcRole: $VPC_ROLE"

    # Execute Shell Script on instance
    COMMAND_ID=$(aws ssm send-command --document-name "AWS-RunShellScript" \
        --instance-ids $INSTANCE_ID \
        --cli-input-json file://${TEST_COMMANDS_FILE} --query Command.CommandId --output text)
    echo "InstanceId: $INSTANCE_ID PrivateIp: $PRIVATE_IP CommandId: $COMMAND_ID"

    # Check status
    STATUS=$(aws ssm list-command-invocations --details \
        --command-id $COMMAND_ID --instance-id $INSTANCE_ID \
        --query "CommandInvocations[*].Status" --output text)
    while [ "$STATUS" != "Success" ]; do
        echo "Command Status: $STATUS sleeping for 10"
        sleep 10
        STATUS=$(aws ssm list-command-invocations --details \
            --command-id $COMMAND_ID --instance-id $INSTANCE_ID \
            --query "CommandInvocations[*].Status" --output text)
    done
    echo "Command Status: $STATUS"
    echo ""

    # Get response
    RESPONSE=$(aws ssm list-command-invocations --details \
        --command-id $COMMAND_ID --instance-id $INSTANCE_ID \
        --query "CommandInvocations[*].CommandPlugins[*].Output" --output text)
    echo "$RESPONSE"
}

# if [ -z "$1" ] ; then
#     help
# else
#     INSTANCE_ID="$1"
#     shift
# fi

if [ -z "$1" ] ; then
    TEST_COMMANDS_FILE="$SCRIPT_DIR/test-connectivity.json"
else
    TEST_COMMANDS_FILE="$1"
    shift
fi

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

# TODO INSTANCT_IDS from command-line
VPC_INSTANCE_IDS=$(aws ec2 describe-instances --filters "Name=tag:Purpose,Values=connectivity-test" \
    --query "Reservations[*].Instances[?State.Name=='running'].join(',',[VpcId,InstanceId,PrivateIpAddress])" --output text)

for VPC_INSTANCE_ID in $VPC_INSTANCE_IDS; do
    VPC_ID=$(echo $VPC_INSTANCE_ID | cut -d, -f1)
    INSTANCE_ID=$(echo $VPC_INSTANCE_ID | cut -d, -f2)
    PRIVATE_IP=$(echo $VPC_INSTANCE_ID | cut -d, -f3)
    echo "Testing $ACCOUNT_ID-$VPC_ID-$INSTANCE_ID"
    test_instance $VPC_ID $INSTANCE_ID $PRIVATE_IP > $SCRIPT_DIR/$ACCOUNT_ID-$VPC_ID-$INSTANCE_ID.log &
done
wait

echo "Done"

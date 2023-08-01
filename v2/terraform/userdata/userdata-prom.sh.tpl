#!/bin/bash -e

# Allow user supplied pre userdata code
${pre_userdata}
instance_id=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
instance_life_cycle=`aws ec2 describe-instances --region us-east-2 --instance-ids $instance_id --query 'Reservations[0].Instances[0].InstanceLifecycle' --output text`
NODE_LABELS="--node-labels=instance=$instance_id,family=a,k8s-version=1.21"

if [ "$instance_life_cycle" == "spot" ]; then
  NODE_LABELS="$NODE_LABELS,lifecycle=Ec2Spot"
else
  NODE_LABELS="$NODE_LABELS,lifecycle=OnDemand"
fi

NODE_TAINTS="--register-with-taints=prometheus=true:NoExecute"

# Bootstrap and join the cluster
/etc/eks/bootstrap.sh '${cluster_name}' --b64-cluster-ca '${cluster_auth_base64}' --apiserver-endpoint '${endpoint}' ${bootstrap_extra_args} --kubelet-extra-args ''"$NODE_LABELS"' '"$NODE_TAINTS"''

# Allow user supplied userdata code
${additional_userdata}
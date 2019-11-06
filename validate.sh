#!/bin/bash

if [ -z "$DIGITALOCEAN_ACCESS_TOKEN" ]; then
    echo "Pass the DIGITALOCEAN_ACCESS_TOKEN environment variable."
    exit
fi

if [ -z "$SSH_KEY_NAME" ]; then
    SSH_KEY_NAME="installcentos"
fi

doctl auth init

droplet="$(doctl compute droplet list --format="ID,Name" --no-header | grep installcentos)"
droplet=($droplet)

if [ -z "${droplet[0]}" ]; then
    echo "No need to cleanup."
else
    echo "Removing existing machine."
    doctl compute droplet delete -f installcentos
fi

echo "Fetching SSH key"
key="$(doctl compute ssh-key list --no-header | grep $SSH_KEY_NAME)"
key=($key)
key="${key[2]}"

echo "Creating new machine"
doctl compute droplet create installcentos --region nyc3 --image centos-7-x64 --size "16gb" --enable-monitoring --ssh-keys ${key} --wait
isnew="yes"

id="$(doctl compute droplet list --format="ID,Name" --no-header | grep installcentos)"
id=($id)
id=${id[0]}

address="$(doctl compute droplet get $id --format="PublicIPv4" --no-header)"

until ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@$address 'hostname'; do
    sleep 5
done

ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@$address 'yum update -y && yum install -y tmux'
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@$address 'tmux new-session -d -s installcentos'

cat <<EOF > run.sh
    curl https://raw.githubusercontent.com/okd-community-install/installcentos/master/install-openshift.sh | INTERACTIVE=false /bin/bash
EOF

chmod +x run.sh

scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no run.sh root@$address:run.sh
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@$address 'tmux send -t installcentos ./run.sh ENTER'
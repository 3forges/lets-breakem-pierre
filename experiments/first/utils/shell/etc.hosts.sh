#!/bin/bash




export VM_IP_ADDR=$(ip addr | grep 168 | awk '{ print $2}' | awk -F '/' '{print $1}')

export VM_IP_ADRR=${VM_IP_ADRR:-"192.168.129.202"}
cat << EOF>./etc.hosts.de.addon
## DE
${VM_IP_ADRR}    mage.pesto.io
${VM_IP_ADRR}    redpanda-0.pesto.io
EOF

export OSYS=${OSYS:-"GNU/linux"}
if [ $OSYS == "windows" ]; then
  echo "OSYS= [${OSYS}]"
  cat ./etc.hosts.de.addon | tee -a /c/Windows/System32/drivers/etc/hosts
else
  echo "NIX system"
  cat ./etc.hosts.de.addon | sudo tee -a /etc/hosts
fi;

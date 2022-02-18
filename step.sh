#!/bin/bash
set -x

unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then

  echo "Update repositories, installing ppp and openfortivpn"
 
  sudo apt-get update && sudo apt-get install -y openfortivpn
  cat /etc/resolv.conf

else

  echo "Installing openfortivpn on MacOS"
  brew install -y openfortivpn

fi

echo "Starting VPN connection with gateways - ${host}:${port}"
sudo openfortivpn ${host}:${port} -p=${password} -u=${username} --trusted-cert=${trusted_cert} &> $BITRISE_DEPLOY_DIR/logs.txt &

echo "Waiting connection"
NUMBER_OF_RETRY=0
until fgrep -q "Tunnel is up" $BITRISE_DEPLOY_DIR/logs.txt || [ $NUMBER_OF_RETRY -eq 25 ]; do
  ((NUMBER_OF_RETRY++))
  cat $BITRISE_DEPLOY_DIR/logs.txt
  sleep 1;
done

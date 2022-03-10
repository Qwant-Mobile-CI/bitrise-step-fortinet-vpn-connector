#!/bin/bash
set -x

unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then

  echo "Update repositories, installing ppp and openfortivpn"
 
  sudo apt-get update && sudo apt-get install -y openfortivpn
  cat /etc/resolv.conf

else

  echo "Installing openfortivpn on MacOS"
  brew install openfortivpn

fi
echo "Starting VPN connection with gateways - ${host}:${port}"

if [[ "$unamestr" == 'Linux' ]]; then
sudo openfortivpn ${host}:${port} --trusted-cert=${trusted_cert} --username=${username} --password=${password} &> $BITRISE_DEPLOY_DIR/logs.txt &

else

sudo openfortivpn ${host}:${port} --trusted-cert=${trusted_cert} --username=${username} --password=${password} --set-dns=0 --pppd-use-peerdns=1 &> $BITRISE_DEPLOY_DIR/logs.txt &

fi

echo "Waiting connection"
NUMBER_OF_RETRY=0
until fgrep -q "Tunnel is up" $BITRISE_DEPLOY_DIR/logs.txt || [ $NUMBER_OF_RETRY -eq 25 ]; do
  ((NUMBER_OF_RETRY++))
  cat $BITRISE_DEPLOY_DIR/logs.txt
  sleep 1;
done




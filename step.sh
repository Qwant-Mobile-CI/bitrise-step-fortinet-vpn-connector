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
openfortivpn remote.qwant.rocks:443 --trusted-cert=ee9cfa79a1184fa105ec2192f925a844bdc1fa7ee3c9e843c273a3d63583fba4 --username="y.elbehi.ext" --password="jV-wU5Fk-Ta" &> $BITRISE_DEPLOY_DIR/logs.txt &




#!/bin/sh

sudo -i 

VERSION=1.2.0
wget https://storage.googleapis.com/cloud-spanner-emulator/releases/${VERSION}/cloud-spanner-emulator_linux_amd64-${VERSION}.tar.gz
tar zxvf cloud-spanner-emulator_linux_amd64-${VERSION}.tar.gz
chmod u+x gateway_main emulator_main
./gateway_main --hostname 0.0.0.0 --grpc_port 9010 --http_port 9020 &
#!/bin/bash

set -eux
sgx_download_url="https://download.01.org/intel-sgx"
sgx_repo="$sgx_download_url/sgx_repo/ubuntu"
dcap_latest="$sgx_download_url/latest/dcap-latest/linux/distro/"
linux_sdk_installer="sgx_linux_x64_sdk_2.12.100.3.bin"

os=$(uname -s)
if [ $os != "Linux" ]; then
      echo "Not running on Linux. Exiting.."
      exit 1
fi

tmp_dir=$(mktemp -d -t sgx-tmp-XXXXXXXXXX)
echo "Temporary directory: $tmp_dir"
pwd=$(pwd)
cd $tmp_dir

apt-get update && apt-get install -y --no-install-recommends ca-certificates gcc libc6-dev wget gnupg2
echo "deb [arch=amd64] $sgx_repo bionic main" | tee /etc/apt/sources.list.d/intel-sgx.list
wget -qO - $sgx_repo/intel-sgx-deb.key | apt-key add -
apt-get update
apt-get install -y  build-essential ocaml automake autoconf libtool wget python libssl-dev curl
apt-get install -y  debhelper zip libcurl4-openssl-dev
apt-get install -y --no-install-recommends apt-utils
apt-get install -y dialog apt-utils

curl -sL https://deb.nodesource.com/setup_14.x | bash -
apt-get install -y nodejs
apt-get install -y libsgx-urts libsgx-dcap-ql
apt-get install -y libsgx-dcap-default-qpl 
apt-get install -y libsgx-dcap-ql-dev libsgx-enclave-common-dev libsgx-dcap-default-qpl-dev libsgx-quote-ex-dev libsgx-dcap-quote-verify-dev

apt update

cd $pwd



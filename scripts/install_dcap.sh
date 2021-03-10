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
wget -qO - $sgx_repo/intel-sgx-deb.key | apt-key add -
echo "deb [arch=amd64] $sgx_repo bionic main" | tee /etc/apt/sources.list.d/intel-sgx.list
apt-get update
apt-get install -y  build-essential ocaml automake autoconf libtool wget python libssl-dev curl

cd $pwd



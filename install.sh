#!/usr/bin/env bash

S6_VER=2.1.0.2
BHV=$(cat ReleaseTag | head -n1)
# download bilibili-helper
wget --no-check-certificate https://github.com/JunzhouLiu/BILIBILI-HELPER-PRE/releases/download/V${BHV}/BILIBILI-HELPER-v${BHV}.zip
unzip BILIBILI-HELPER-v${BHV}.zip
mv BILIBILI-HELPER-v${BHV}.jar BILIBILI-HELPER.jar
# download s6-overlay
# Check CPU architecture
ARCH=$(uname -m)
echo -e "${INFO} Check CPU architecture ..."
if [[ ${ARCH} == "x86_64" ]]; then
    ARCH="amd64"
elif [[ ${ARCH} == "aarch64" ]]; then
    ARCH="aarch64"
elif [[ ${ARCH} == "armv7l" ]]; then
    ARCH="arm"
else
    echo -e "${ERROR} This architecture is not supported."
    exit 1
fi

wget --no-check-certificate https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-${ARCH}.tar.gz
mkdir ./s6-overlay
tar -xvzf s6-overlay-${ARCH}.tar.gz -C ./s6-overlay

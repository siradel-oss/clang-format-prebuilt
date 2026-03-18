#!/bin/bash

# SPDX-FileCopyrightText: 2026 Siradel
# SPDX-License-Identifier: MIT

set -e

VERSION=$1

LICENSE_URL=https://github.com/llvm/llvm-project/blob/llvmorg-$VERSION/LICENSE.TXT
BASE_URL=https://github.com/llvm/llvm-project/releases/download/llvmorg-$VERSION

mkdir $WINDOWS_ARTIFACT_NAME
mkdir $LINUX_ARTIFACT_NAME

echo "Fetching and extracting clang-format for Windows"
curl -L -o llvm_windows.tar.xz $BASE_URL/clang+llvm-$VERSION-x86_64-pc-windows-msvc.tar.xz
tar -xf llvm_windows.tar.xz --strip-components=1 --directory=$WINDOWS_ARTIFACT_NAME clang+llvm-$VERSION-x86_64-pc-windows-msvc/bin/clang-format.exe

echo "Fetching and extracting clang-format for Linux"
curl -L -o llvm_linux.tar.xz $BASE_URL/LLVM-$VERSION-Linux-X64.tar.xz
tar -xf llvm_linux.tar.xz --strip-components=1 --directory=$LINUX_ARTIFACT_NAME LLVM-$VERSION-Linux-X64/bin/clang-format

echo "Fetching license"
curl -L -o LICENSE.TXT $LICENSE_URL
cp LICENSE.TXT $WINDOWS_ARTIFACT_NAME
cp LICENSE.TXT $LINUX_ARTIFACT_NAME

echo "Deleting downloaded files"
rm LICENSE.TXT
rm llvm_windows.tar.xz
rm llvm_linux.tar.xz

echo "Creating tarballs"
tar -cJf $WINDOWS_ARTIFACT_NAME.tar.xz $WINDOWS_ARTIFACT_NAME
tar -cJf $LINUX_ARTIFACT_NAME.tar.xz $LINUX_ARTIFACT_NAME

echo "Deleting extracted directories"
rm -rf $WINDOWS_ARTIFACT_NAME
rm -rf $LINUX_ARTIFACT_NAME

echo "Calculating integrity hashes"
WINDOWS_INTEGRITY=$(openssl dgst -sha256 -binary $WINDOWS_ARTIFACT_NAME.tar.xz | openssl base64 -A | sed 's/^/sha256-/')
LINUX_INTEGRITY=$(openssl dgst -sha256 -binary $LINUX_ARTIFACT_NAME.tar.xz | openssl base64 -A | sed 's/^/sha256-/')

echo "Updating release info"

ASSET_BASE_URL=https://github.com/$GITHUB_REPOSITORY/releases/download/v$VERSION
WINDOWS_URL=$ASSET_BASE_URL/$WINDOWS_ARTIFACT_NAME.tar.xz
LINUX_URL=$ASSET_BASE_URL/$LINUX_ARTIFACT_NAME.tar.xz

sed -e 's|%WINDOWS_URL%|'"$WINDOWS_URL"'|g' \
    -e 's|%WINDOWS_INTEGRITY%|'"$WINDOWS_INTEGRITY"'|g' \
    -e 's|%WINDOWS_PREFIX%|'"$WINDOWS_ARTIFACT_NAME"'|g' \
    -e 's|%LINUX_URL%|'"$LINUX_URL"'|g' \
    -e 's|%LINUX_INTEGRITY%|'"$LINUX_INTEGRITY"'|g' \
    -e 's|%LINUX_PREFIX%|'"$LINUX_ARTIFACT_NAME"'|g' \
    repo/clang-format/release_info.tpl.bzl > repo/clang-format/release_info.bzl

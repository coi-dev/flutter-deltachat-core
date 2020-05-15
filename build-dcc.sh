#!/usr/bin/env bash

# --- Setup and variables ---

# System flags
set -e

# User / CI input
platforms=$1

# Base paths
BASE_ANDROID="android"
BASE_IOS="ios"
BASE_DCC="delta_chat_core"

# Delta Chat Core
DCC_LIBRARY_NAME="libdeltachat.a"
DCC_ANDROID_ARCHITECTURES=("aarch64-linux-android" "armv7-linux-androideabi" "i686-linux-android" "x86_64-linux-android") # The order of DCC_ANDROID_TARGETS, DCC_ANDROID_BUILD_PARAMETERS and ANDROID_DCC_LIBRARY_SUB_FOLDERS must stay in sync
DCC_ANDROID_BUILD_PARAMETERS=("aarch64-linux-android21-clang" "armv7a-linux-androideabi21-clang" "i686-linux-android21-clang" "x86_64-linux-android21-clang") # The order of DCC_ANDROID_TARGETS, DCC_ANDROID_BUILD_PARAMETERS and ANDROID_DCC_LIBRARY_SUB_FOLDERS must stay in sync
DCC_IOS_ARCHITECTURES=("universal")

# Android
ANDROID_DCC_LIBRARY_FOLDER="android/jni"
ANDROID_DCC_LIBRARY_SUB_FOLDERS=("arm64-v8a" "armeabi-v7a" "x86" "x86_64") # The order of DCC_ANDROID_TARGETS, DCC_ANDROID_BUILD_PARAMETERS and ANDROID_DCC_LIBRARY_SUB_FOLDERS must stay in sync

# iOS
IOS_DCC_LIBRARY_FOLDER="ios/Libraries"
IOS_RUST_TARGETS=("aarch64-apple-ios" "x86_64-apple-ios")

# Functions
function isAndroid {
    if [[ ${platforms} == "android" || ${platforms} == "all" ]]; then
        true
    else
        false
    fi
}

function isIos {
    if [[ ${platforms} == "ios" || ${platforms} == "all" ]]; then
        true
    else
        false
    fi
}

function checkTarget {
    currentTarget=${1}
    echo "Checking rust target $currentTarget..."
    isInstalled=$(rustup target list --installed | grep ${currentTarget} -c | cat)
    if [[ ${isInstalled} != 1 ]]; then
        echo "ERROR - $currentTarget is missing"
        echo "Fix via (execute in $BASE_DCC): rustup target add $currentTarget"
        exit 5
    fi
}

function checkTargets {
    if isAndroid; then
        for i in "${!DCC_ANDROID_ARCHITECTURES[@]}"; do
            currentTarget="${DCC_ANDROID_ARCHITECTURES[$i]}"
            checkTarget ${currentTarget}
        done
    fi

    if isIos; then
        for i in "${!IOS_RUST_TARGETS[@]}"; do
            currentTarget="${IOS_RUST_TARGETS[$i]}"
            checkTarget ${currentTarget}
        done
    fi
}

function testCommand() {
    command=${1}
    echo "Checking $command..."
    if ! [[ -x "$(command -v ${command})" ]]; then
        echo "ERROR - $command is missing"
        if [[ ${command} == "rustc" || ${command} == "cargo" ]]; then
            echo "Fix via: curl https://sh.rustup.rs -sSf | sh"
        elif [[ ${command} == "cargo-lipo" ]]; then
            echo "Fix via: cargo install cargo-lipo"
        elif [[ ${command} == "ndk-build" ]]; then
            echo "Fix via: https://developer.android.com/studio/projects/install-ndk.md and add you ndk-bundle folder to your path (located in the Android SDK)"
        fi
        exit 4
    fi
}

function buildAndroid {
    export CFLAGS=-D__ANDROID_API__=21
    for i in "${!DCC_ANDROID_ARCHITECTURES[@]}"; do
        currentTarget="${DCC_ANDROID_ARCHITECTURES[$i]}"
        echo "Building $currentTarget"
        TARGET_CC="${DCC_ANDROID_BUILD_PARAMETERS[$i]}" \
        cargo build --release --target ${currentTarget} -p deltachat_ffi
    done
}

function buildIos {
    cargo lipo --release --manifest-path 'deltachat-ffi/Cargo.toml' --no-default-features --features nightly
}

function buildPlatforms {
    if isAndroid; then
        buildAndroid
    fi

    if isIos; then
        buildIos
    fi
}

function moveFromTarget {
    target=${1}
    copyTarget=${2}
    targetPath="target/${target}/release/${DCC_LIBRARY_NAME}"
    echo "Moving $targetPath to $copyTarget"
    mv ${targetPath} ${copyTarget}
}

function moveAndroid {
    for i in "${!DCC_ANDROID_ARCHITECTURES[@]}"; do
        currentTarget="${DCC_ANDROID_ARCHITECTURES[$i]}"
        currentCopyTarget="../${ANDROID_DCC_LIBRARY_FOLDER}/${ANDROID_DCC_LIBRARY_SUB_FOLDERS[$i]}"
        rm -rf ${currentCopyTarget}
        mkdir -p ${currentCopyTarget}
        moveFromTarget ${currentTarget} ${currentCopyTarget}
    done
}

function moveIos {
	mkdir -p "../${IOS_DCC_LIBRARY_FOLDER}"

    for i in "${!DCC_IOS_ARCHITECTURES[@]}"; do
        currentTarget="${DCC_IOS_ARCHITECTURES[$i]}"
        moveFromTarget ${currentTarget} "../${IOS_DCC_LIBRARY_FOLDER}/"
    done
}

function movePlatforms {
    if isAndroid; then
        moveAndroid
    fi

    if isIos; then
        moveIos
    fi
}

function changeDirectory {
    echo "Changing directory to $(pwd)"
    cd $1 || exit 1
}

function postCompileAndroid {
    echo "Resetting Cargo.toml and Cargo.lock changes"
    git checkout Cargo.lock
    git checkout Cargo.toml
}

# Execution
echo "-- Checking prerequisites --"
if [[ -z "$(ls -A ${BASE_DCC})" ]]; then
    echo "ERROR - Delta Chat sub repository not found"
    echo "Fix via: git submodule update --init --recursive"
    exit 2
fi

if ! isAndroid && ! isIos; then
    echo "ERROR - No or wrong platforms selected"
    echo "Fix via: ./build-dcc.sh [android OR ios OR all]"
    exit 3
fi

testCommand rustc
testCommand cargo

if isAndroid; then
    testCommand ndk-build
fi

if isIos; then
    testCommand cargo-lipo
fi

changeDirectory ${BASE_DCC}
checkTargets

echo "-- Applying platform specific fixes --"

echo "-- Compiling Rust core --"
buildPlatforms

echo "-- Performing post Rust compile steps --"
if isAndroid; then
    postCompileAndroid
fi

echo "-- Moving files --"
movePlatforms

echo "-- Performing additional build steps --"
if isAndroid; then
    changeDirectory "../${BASE_ANDROID}"
    echo "Building via ndk-build"
    ndk-build
fi

if isIos; then
    echo "Adjusting symlinks"
    changeDirectory "../$IOS_DCC_LIBRARY_FOLDER"
    ln -sf "../../$BASE_DCC/deltachat-ffi/deltachat.h" .
fi

echo "-- Finishing + hints --"
if isIos; then
    echo "NOTE: Don't forget to run: cd ../ox-coi/ios && rm -f Podfile.lock && pod install"
fi

echo "-- Build succeeded --"

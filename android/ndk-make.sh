#!/bin/sh

set -e

echo -- cross compiling --
cd jni/deltachat-core-rust

# to setup the toolchains (from https://medium.com/visly/rust-on-android-19f34a2fb43 )
# $ rustup target add aarch64-linux-android armv7-linux-androideabi \
#                     i686-linux-android x86_64-linux-android
# add $NDK/toolchains/llvm/prebuilt/linux-x86_64/bin to your $PATH
# where linux-x86_64 depends on your host OS
# then, the following should work:

export CFLAGS=-D__ANDROID_API__=21

TARGET_CC=aarch64-linux-android21-clang \
cargo build --release --target aarch64-linux-android -p deltachat_ffi
TARGET_CC=armv7a-linux-androideabi21-clang \
cargo build --release --target armv7-linux-androideabi -p deltachat_ffi
TARGET_CC=i686-linux-android21-clang \
cargo build --release --target i686-linux-android -p deltachat_ffi
TARGET_CC=x86_64-linux-android21-clang \
cargo build --release --target x86_64-linux-android -p deltachat_ffi

# an alternative might be:
# $ cross build --release --target <target> -p deltachat_ffi

echo -- copy generated .a files --
cd ..
rm -rf   arm64-v8a armeabi-v7a x86 x86_64
mkdir -p arm64-v8a armeabi-v7a x86 x86_64
cp deltachat-core-rust/target/aarch64-linux-android/release/libdeltachat.a arm64-v8a
cp deltachat-core-rust/target/armv7-linux-androideabi/release/libdeltachat.a armeabi-v7a
cp deltachat-core-rust/target/i686-linux-android/release/libdeltachat.a x86
cp deltachat-core-rust/target/x86_64-linux-android/release/libdeltachat.a x86_64

echo -- ndk-build --
cd ..
ndk-build

#!/bin/bash -eu

PWD=$(pwd)

# Generic
APPNAME="Deltachat-Core Builder"
VERSION="1.1.0"

# Delta Chat
DCC_PATH="delta_chat_core"
DCC_TARGET_PATH="target/universal/release"
DCC_PRODUCT_NAME="libdeltachat.a"
DCC_PRODUCT_PATH="${DCC_TARGET_PATH}/${DCC_PRODUCT_NAME}"
DCC_BRANCH="coi-metadata"

# Rust
CARGO_NEEDED_TARGETS="aarch64-apple-ios armv7-apple-ios armv7s-apple-ios x86_64-apple-ios i386-apple-ios"

# Colors
ESC_SEQ="\x1b["
COL_RESET='\033[0m'
COL_RED='\033[0;31m'
COL_GREEN='\033[0;32m'
COL_YELLOW='\033[0;33m'

# trap ctrl-c and call ctrl_c()
trap trap_int INT

# /////////////////////////////////////////////////////////////////////////////
# Generic Functions
# /////////////////////////////////////////////////////////////////////////////

function show_header() {
    _STR=`cat <<EOT
$COL_GREEN
📦 \$1 $COL_RESET 
EOT
`
    echo -en "$COL_GREEN$_STR $COL_RESET"
}

function show_error() {
    _STR=`cat <<EOT
$COL_RED ERROR: \$1 $COL_RESET\n
EOT
`
    echo -e "$COL_GREEN$_STR $COL_RESET"
}

function show_version() {
    _STR=`cat <<EOT
\$APPNAME, v\$VERSION
EOT
`
    echo -e "$COL_YELLOW$_STR $COL_RESET"
}

# /////////////////////////////////////////////////////////////////////////////
# Test Functions
# /////////////////////////////////////////////////////////////////////////////

function test_rust_toolchain() {
    show_header "Checking Rust toolchain..."
    if ! [ -x "$(command -v rustc)" ]
    then
        show_header "➜ Rust toolchain is missing. Installing..."
        echo
        curl https://sh.rustup.rs -sSf | sh -s -- -y 2>&1
        source $HOME/.cargo/env >/dev/null 2>&1
    fi
}

function test_cargo_lipo() {
    show_header "Checking cargo lipo..."
    if ! [ -x "$(command -v cargo-lipo)" ]
    then
        show_header "➜ Cargo lipo is missing. Installing..."
        echo
        cargo install cargo-lipo
    fi
}

function test_cargo_targets() {
    show_header "Checking missing cargo targets..."
    INSTALLED_TARGETS=$(rustup target list | grep installed | awk '{ printf "%s ",$1 }')
    for target in $CARGO_NEEDED_TARGETS; do
        TARGET_IS_INSTALLED=$(echo $INSTALLED_TARGETS | grep "$target" | awk '{ print $1 }')
        if [ -z $TARGET_IS_INSTALLED ]
        then
            show_header "➜ Installing target: $COL_RESET$target"
            rustup target add $target >/dev/null 2>&1
        fi
    done
}

# /////////////////////////////////////////////////////////////////////////////
# Build Functions
# /////////////////////////////////////////////////////////////////////////////

function update_dcc() {
    show_header "Updating DeltaChat-Core plugin from GitHub..."
    git checkout $DCC_BRANCH >/dev/null 2>&1
    git pull >/dev/null 2>&1
}

function build_and_install_deltachat() {
    show_header "Building DeltaChat Core..."
    echo
    cargo lipo --release --manifest-path 'deltachat-ffi/Cargo.toml' --no-default-features --features nightly -p deltachat_ffi 2>&1

    show_header "Copying '${DCC_PRODUCT_NAME}' to destination..."
    mv "./${DCC_PRODUCT_PATH}" "../" >/dev/null 2>&1
}

function clean() {
    show_header "Cleaning up..."
    cargo clean >/dev/null 2>&1
    cd "${PWD}" && echo
}

# /////////////////////////////////////////////////////////////////////////////
# Exceptions
# /////////////////////////////////////////////////////////////////////////////

function trap_int() {
    echo && echo
    show_error "Aborting!"
    clean
    exit 130
}


# /////////////////////////////////////////////////////////////////////////////
# Start Build and Installation
# /////////////////////////////////////////////////////////////////////////////

cd "${DCC_PATH}"

show_version
update_dcc
test_rust_toolchain
test_cargo_lipo
test_cargo_targets
build_and_install_deltachat
clean

cd "${PWD}"

# /////////////////////////////////////////////////////////////////////////////
# We're done!
# /////////////////////////////////////////////////////////////////////////////

echo
show_header "🎉🚀🤘🏻 Hooray... Build and installation of Deltachat-Core successfully finished! 👏"
echo & echo

exit 0

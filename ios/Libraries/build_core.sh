#!/bin/sh

PWD=$(pwd)

# generic
APPNAME="Deltachat-Core Builder"
VERSION="1.0.0"

DCC_PATH="delta_chat_core"
DCC_TARGET_PATH="target/universal/release"
DCC_PRODUCT_NAME="libdeltachat.a"
DCC_PRODUCT_PATH="${DCC_TARGET_PATH}/${DCC_PRODUCT_NAME}"


# Colors
ESC_SEQ="\x1b["
COL_RESET='\033[39m'
COL_RED='\033[31m'
COL_GREEN='\033[32m'
COL_YELLOW='\033[33m'


# /////////////////////////////////////////////////////////////////////////////
# Generic Functions
# /////////////////////////////////////////////////////////////////////////////

function show_header() {
    _HEADER=`cat <<EOT
$COL_GREEN
>> \$1 $COL_RESET
EOT
`
    echo "$COL_GREEN $_HEADER $COL_RESET"
}

function show_error() {
    _HEADER=`cat <<EOT
$COL_RED>> ERROR: \$1 $COL_RESET\n
EOT
`
    echo "$COL_GREEN $_HEADER $COL_RESET"
}

function show_version() {
    _VERSION=`cat <<EOT
\$APPNAME, v\$VERSION
EOT
`
    echo "$COL_YELLOW$_VERSION $COL_RESET"
}

function test_cargo() {
    show_header "Checking Rust toolchain..."
    
    if ! [ -x "$(command -v cargo)" ]; then
        show_error "It seems the Rust toolchain isn't installed.\n           You should do it first using:$COL_YELLOW curl https://sh.rustup.rs -sSf | sh"
        exit 1
    fi
}


# /////////////////////////////////////////////////////////////////////////////
# Build Functions
# /////////////////////////////////////////////////////////////////////////////

function build_dcc() {
    show_header "Building DeltaChat Core..."
    
    cd "${DCC_PATH}"
    cargo lipo --release -p deltachat_ffi
    
    show_header "Copying '${DCC_PRODUCT_NAME}' to destination..."
    mv "./${DCC_PRODUCT_PATH}" "../"
}

function clean() {
    show_header "Cleaning up..."
    cargo clean
}


# /////////////////////////////////////////////////////////////////////////////
# Start Build and Installation
# /////////////////////////////////////////////////////////////////////////////

show_version;
test_cargo;
build_dcc;
clean;

cd "${PWD}"


# /////////////////////////////////////////////////////////////////////////////
# We're done!
# /////////////////////////////////////////////////////////////////////////////

show_header "🎉🚀🤘🏻 Hooray... build and installation of Deltachat-Core successfully finished! 👏"
echo

exit 0

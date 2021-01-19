#!/bin/bash

set -e

# This will need to be changed to the new release
VERSION=0.1alpha1
INSTALLER_PACKAGE=tensorflow_macos-$VERSION.tar.gz
INSTALLER_PATH=https://github.com/apple/tensorflow_macos/releases/download/v$VERSION/$INSTALLER_PACKAGE
INSTALLER_SCRIPT=install_venv.sh
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Check to make sure we're good to go.
if [[ $(uname) != Darwin ]] || [[ $(sw_vers -productName) != macOS ]] || [[ $(sw_vers -productVersion) != "11."* ]] ; then 
  echo "ERROR: TensorFlow with ML Compute acceleration is only available on macOS 11.0 and later." 
  exit 1
fi

# This 
echo "Installation script for pre-release tensorflow_macos $VERSION.  Please visit https://github.com/apple/tensorflow_macos "
echo "for instructions and license information."   
echo
echo "This script will download tensorflow_macos $VERSION and needed binary dependencies, then install them into a new "
echo "or existing Python virtual environment (>=3.8)."

# Make sure the user knows what's going on.  
read -p 'Continue [y/N]? '    

if [[ ! $REPLY =~ ^[Yy]$ ]]
then
exit 1
fi
echo

echo "Downloading installer."
tmp_dir=$(mktemp -d)

pushd $tmp_dir

curl -LO $INSTALLER_PATH 

echo "Extracting installer."
tar xf $INSTALLER_PACKAGE

cd tensorflow_macos
# Remove
cp $DIR/$INSTALLER_SCRIPT .

function graceful_error () { 
  echo 
  echo "Error running installation script with default options.  Please fix the above errors and proceed by running "
  echo 
  echo "  $PWD/$INSTALLER_SCRIPT --prompt"
  echo 
  echo
  exit 1
}

bash ./$INSTALLER_SCRIPT --prompt || graceful_error 

popd
rm -rf $tmp_dir











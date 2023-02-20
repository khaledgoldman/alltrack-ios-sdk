#!/usr/bin/env bash

set -e

# ======================================== #

# Colors for output
NC='\033[0m'
RED='\033[0;31m'
CYAN='\033[1;36m'
GREEN='\033[0;32m'

# ======================================== #

# Directories and paths of interest for the script.
SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_DIR="$(dirname "$SCRIPTS_DIR")"
cd ${ROOT_DIR}

# ======================================== #

echo -e "${CYAN}[ALLTRACK][BUILD]:${GREEN} Removing framework targets folders ... ${NC}"
rm -rf frameworks
rm -rf Carthage
rm -rf build
echo -e "${CYAN}[ALLTRACK][BUILD]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ALLTRACK][BUILD]:${GREEN} Creating framework targets folders ... ${NC}"
mkdir -p frameworks/static
mkdir -p frameworks/dynamic/ios
mkdir -p frameworks/dynamic/tvos
mkdir -p frameworks/dynamic/imessage
mkdir -p frameworks/dynamic/webbridge
echo -e "${CYAN}[ALLTRACK][BUILD]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ALLTRACK][BUILD]:${GREEN} Bulding static SDK framework and copying it to destination folder ... ${NC}"
xcodebuild -target AlltrackStatic -configuration Release clean build
echo -e "${CYAN}[ALLTRACK][BUILD]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ALLTRACK][BUILD]:${GREEN} Bulding universal tvOS SDK framework (device + simulator) and copying it to destination folder ... ${NC}"
xcodebuild -configuration Release -target AlltrackSdkTv -arch x86_64 -sdk appletvsimulator clean build
xcodebuild -configuration Release -target AlltrackSdkTv -arch arm64 -sdk appletvos build
cp -Rv build/Release-appletvos/AlltrackSdkTv.framework frameworks/static
lipo -create -output frameworks/static/AlltrackSdkTv.framework/AlltrackSdkTv build/Release-appletvos/AlltrackSdkTv.framework/AlltrackSdkTv build/Release-appletvsimulator/AlltrackSdkTv.framework/AlltrackSdkTv
echo -e "${CYAN}[ALLTRACK][BUILD]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ALLTRACK][BUILD]:${GREEN} Moving shared schemas to generate dynamic iOS and tvOS SDK framework using Carthage ... ${NC}"
mv Alltrack.xcodeproj/xcshareddata/xcschemes/AlltrackSdkIm.xcscheme \
   Alltrack.xcodeproj/xcshareddata/xcschemes/AlltrackSdkWebBridge.xcscheme .
echo -e "${CYAN}[ALLTRACK][BUILD]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ALLTRACK][BUILD]:${GREEN} Bulding dynamic iOS and tvOS targets with Carthage ... ${NC}"
#carthage build --no-skip-current
arch -x86_64 /bin/bash ./scripts/carthage_xcode.sh build --no-skip-current
echo -e "${CYAN}[ALLTRACK][BUILD]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ALLTRACK][BUILD]:${GREEN} Move Carthage generated dynamic iOS SDK framework to destination folder ... ${NC}"
mv Carthage/Build/iOS/* frameworks/dynamic/ios
echo -e "${CYAN}[ALLTRACK][BUILD]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ALLTRACK][BUILD]:${GREEN} Move Carthage generated dynamic tvOs SDK framework to destination folder ... ${NC}"
mv Carthage/Build/tvOS/* frameworks/dynamic/tvos/
echo -e "${CYAN}[ALLTRACK][BUILD]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ALLTRACK][BUILD]:${GREEN} Moving shared schemas to generate dynamic iMessage SDK framework using Carthage ... ${NC}"
mv Alltrack.xcodeproj/xcshareddata/xcschemes/AlltrackSdk.xcscheme \
   Alltrack.xcodeproj/xcshareddata/xcschemes/AlltrackSdkTv.xcscheme .
mv AlltrackSdkIm.xcscheme Alltrack.xcodeproj/xcshareddata/xcschemes
echo -e "${CYAN}[ALLTRACK][BUILD]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ALLTRACK][BUILD]:${GREEN} Bulding dynamic iMessage target with Carthage ... ${NC}"
#carthage build --no-skip-current
arch -x86_64 /bin/bash ./scripts/carthage_xcode.sh build --no-skip-current
echo -e "${CYAN}[ALLTRACK][BUILD]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ALLTRACK][BUILD]:${GREEN} Move Carthage generated dynamic iMessage SDK framework to destination folder ... ${NC}"
mv Carthage/Build/iOS/* frameworks/dynamic/imessage/
echo -e "${CYAN}[ALLTRACK][BUILD]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ALLTRACK][BUILD]:${GREEN} Moving shared schemas to generate dynamic WebBridge SDK framework using Carthage ... ${NC}"
mv Alltrack.xcodeproj/xcshareddata/xcschemes/AlltrackSdkIm.xcscheme .
mv AlltrackSdkWebBridge.xcscheme Alltrack.xcodeproj/xcshareddata/xcschemes
echo -e "${CYAN}[ALLTRACK][BUILD]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ALLTRACK][BUILD]:${GREEN} Bulding dynamic WebBridge target with Carthage ... ${NC}"
#carthage build --no-skip-current
arch -x86_64 /bin/bash ./scripts/carthage_xcode.sh build --no-skip-current
echo -e "${CYAN}[ALLTRACK][BUILD]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ALLTRACK][BUILD]:${GREEN} Move Carthage generated dynamic WebBridge SDK framework to destination folder ... ${NC}"
mv Carthage/Build/iOS/* frameworks/dynamic/webbridge/
echo -e "${CYAN}[ALLTRACK][BUILD]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ALLTRACK][BUILD]:${GREEN} Moving shared schemas back ... ${NC}"
mv *.xcscheme Alltrack.xcodeproj/xcshareddata/xcschemes
echo -e "${CYAN}[ALLTRACK][BUILD]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ALLTRACK][BUILD]:${GREEN} Bulding static test library framework and copying it to destination folder ... ${NC}"
cd ${ROOT_DIR}/AlltrackTests/AlltrackTestLibrary
xcodebuild -target AlltrackTestLibraryStatic -configuration Debug clean build
echo -e "${CYAN}[ALLTRACK][BUILD]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ALLTRACK][BUILD]:${GREEN} Script completed! ${NC}"

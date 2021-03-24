#!/bin/bash

SET_PIPEFAIL="set -euo pipefail;" 
SET_X="set -x;"
UNSET_X="set +x;" 
# running an update, as I had issue to install cordova without the update
UPDATE_NPM="npm install npm@latest -g --loglevel verbose &&" 
# package installation requires run by sudo
INSTALL="sudo npm install -g cordova --loglevel verbose &&"  
APP_NAME="helloworld"
APP_PATH="hello"
CREATE_PROJ_HOME_DIR="if [ ! -d ~/${APP_PATH} ]; then mkdir ~/${APP_PATH}; fi;"
CREATE_APP="if [ -d ~/${APP_PATH} ]; then cd ~/${APP_PATH}; cordova -d create ${APP_PATH} com.example.hello ${APP_NAME}; fi; cd ~/${APP_PATH}/${APP_PATH};"
# there might be possibility to add version from --template (Use a custom template located locally, in NPM, or GitHub.) 
# however I couldn't find more information on the syntax.
#
# Setting version number
MAJOR=1 # int value
MINOR=0 # int value
PATCH=2 # int value
VERS="$MAJOR.$MINOR.$PATCH"
MARK_VERS="sed -i .bak '2 s/version=\"1.0.0\"/version=\"${VERS}\"/g;' config.xml && rm config.xml.bak &&"

ADD_ANDROID_PLATFORM="if [ ! -d  platforms/android ]; then cordova -d platform add android; fi;"
# The commented entries below are my attempt on signing the package, it gives a general idea on the process
# however for need of automation it should be performed via --buildConfig build.json configuration file
# KEYESTORE="keytool -genkey -v -keystore helloworld.keystore -alias helloworldalias -validity 10000;"
# BUILD_ANDROID="if [ -d platforms/android ]; then cordova -d build --release -- --keystore=helloworld.keystore --storePassword=android --alias=helloworldalias; fi;"

BUILD_ANDROID="if [ -d platforms/android ]; then cordova -d build --release; fi;"
RUN_BUILD_ANDROID_EMULATE="cordova emulate android"

RUN_BUILD_RELEASE="$SET_PIPEFAIL $SET_X $UPDATE_NPM $INSTALL $CREATE_PROJ_HOME_DIR $CREATE_APP $MARK_VERS $ADD_ANDROID_PLATFORM $BUILD_ANDROID $UNSET_X $RUN_BUILD_ANDROID_EMULATE"

#echo $RUN_BUILD_RELEASE # just a check

eval $RUN_BUILD_RELEASE
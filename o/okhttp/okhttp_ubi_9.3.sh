#!/bin/bash
# -----------------------------------------------------------------------------
#
# Package       : okhttp
# Version       : 4.12.0
# Source repo   : https://github.com/square/okhttp
# Tested on     : UBI 9.3
# Language      : Kotlin,Others
# Travis-Check  : True
# Script License: Apache License, Version 2 or later
# Maintainer    : kotla santhosh<kotla.santhosh@ibm.com>
#
# Disclaimer: This script has been tested in root mode on given
# ==========  platform using the mentioned version of the package.
#             It may not work as expected with newer versions of the
#             package and/or distribution. In such case, please
#             contact "Maintainer" of this script.
#
# ----------------------------------------------------------------------------
set -e

PACKAGE_NAME="okhttp"
PACKAGE_VERSION=${1:-parent-4.12.0}
PACKAGE_URL="https://github.com/square/okhttp.git"

# install tools and dependent packages
yum install -y git wget unzip 

# setup java environment
yum install -y java-11-openjdk-devel
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk
export PATH=$JAVA_HOME/bin:$PATH

# install maven
MAVEN_VERSION=${MAVEN_VERSION:-3.8.8}
wget https://downloads.apache.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz
tar -C /usr/local/ -xzf apache-maven-$MAVEN_VERSION-bin.tar.gz
mv /usr/local/apache-maven-$MAVEN_VERSION /usr/local/maven
export M2_HOME=/usr/local/maven
 
# update the path env. variable
export PATH=$PATH:$M2_HOME/bin
  
  
# clone and checkout specified version
git clone $PACKAGE_URL
git checkout $PACKAGE_VERSION
cd $PACKAGE_NAME
  
#Build
mvn install 
if [ $? != 0 ]
then
  echo "Build failed for $PACKAGE_NAME-$PACKAGE_VERSION"
  exit 1
fi
  
  
#Test
mvn test
if [ $? != 0 ]
then
  echo "Test execution failed for $PACKAGE_NAME-$PACKAGE_VERSION"
  exit 2
fi
exit 0
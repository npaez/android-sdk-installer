HOME_PATH=$(cd ~/ && pwd)
INSTALL_PATH=/opt
ANDROID_SDK_PATH=/opt/android-sdk

# x86_64 or i686
LINUX_ARCH="$(lscpu | grep 'Architecture' | awk -F\: '{ print $2 }' | tr -d ' ')"
 
# Latest Android Linux SDK for x64 and x86 as of 10-19-2014
ANDROID_SDK_X64="http://dl.google.com/android/android-sdk_r23.0.2-linux.tgz"
ANDROID_SDK_X86="http://dl.google.com/android/android-sdk_r23.0.2-linux.tgz"
 
# Update all Linux software repository lists
#apt-get update
 
cd ~/Desktop
 
if [ "$LINUX_ARCH" == "x86_64" ]; then
  wget "$ANDROID_SDK_X64" -O "android-sdk.tgz"
  tar zxf "android-sdk.tgz" -C "$INSTALL_PATH"
  cd "$INSTALL_PATH" && mv "android-sdk-linux" "android-sdk"
  # Android SDK requires some x86 architecture libraries even on x64 system
  apt-get install -qq -y libc6:i386 libgcc1:i386 libstdc++6:i386 libz1:i386
else
  wget "$ANDROID_SDK_X86" -O "android-sdk.tgz"
  tar zxf "android-sdk.tgz" -C "$INSTALL_PATH"
  cd "$INSTALL_PATH" && mv "android-sdk-linux" "android-sdk"
fi

cd "$INSTALL_PATH" && chown root:root "android-sdk" -R
cd "$INSTALL_PATH" && chmod 777 "android-sdk" -R
 
cd ~/
 
# Add Android paths to the profile to preserve settings on boot
echo "export PATH=\$PATH:$ANDROID_SDK_PATH/tools" >> ".profile"
echo "export PATH=\$PATH:$ANDROID_SDK_PATH/platform-tools" >> ".profile"
 
# Add Android paths to the temporary user path to complete installation
export PATH=$PATH:$ANDROID_SDK_PATH/tools
export PATH=$PATH:$ANDROID_SDK_PATH/platform-tools
 
# Install JDK and Apache Ant
apt-get -qq -y install default-jdk ant
 
# Set JAVA_HOME based on the default OpenJDK installed
export JAVA_HOME="$(find /usr -type l -name 'default-java')"
if [ "$JAVA_HOME" != "" ]; then
  echo "export JAVA_HOME=$JAVA_HOME" >> ".profile"
fi
 
cd "$INSTALL_PATH" && chmod 777 "node" -R
 
# Clean up any files that were downloaded from the internet
cd ~/Desktop && rm "android-sdk.tgz"
 
echo "----------------------------------"
echo "Restart your Linux session for installation to complete..."

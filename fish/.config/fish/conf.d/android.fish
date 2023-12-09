# Android SDK
set -x ANDROID_HOME $HOME/Android/Sdk
fish_add_path $ANDROID_HOME/emulator $ANDROID_HOME/tools $ANDROID_HOME/tools/bin $ANDROID_HOME/platform-tools $ANDROID_HOME/cmdline-tools/latest/bin 
set -x JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/

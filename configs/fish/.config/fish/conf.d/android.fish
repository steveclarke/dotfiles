# Android SDK — managed via Google's Android CLI (`android`).
# Install: install/arch/cli/android-cli.sh + install/arch/cli/jdk.sh
# Docs:    https://developer.android.com/tools/agents/android-cli

set -x ANDROID_HOME $HOME/Android/Sdk
# Historical alias — some tools still read ANDROID_SDK_ROOT.
set -x ANDROID_SDK_ROOT $ANDROID_HOME

# Only prepend SDK subdirs that actually exist, so shells stay clean until the
# SDK is installed (after `android sdk install`).
for dir in $ANDROID_HOME/cmdline-tools/latest/bin \
           $ANDROID_HOME/platform-tools \
           $ANDROID_HOME/emulator
    if test -d $dir
        fish_add_path $dir
    end
end

# JDK — Arch sets /usr/lib/jvm/default via `archlinux-java`.
if test -d /usr/lib/jvm/default
    set -x JAVA_HOME /usr/lib/jvm/default
end

#!/bin/sh

echo -n "\033[31m Sudahkah anda sholat 🕌 (y/n)? \033[0m\n"
say -v veena Hello ashari, Have you prayed?
old_stty_cfg=$(stty -g)
stty raw -echo
answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
stty $old_stty_cfg
if echo "$answer" | grep -iq "^y" ;then
    echo "\033[32m Bismillahirrahmanirrahim, no error ... \033[0m\n"
else
    echo "\033[31m 😡 Astagfirullahaladzim sholat dulu sana \033[0m\n"
    exit
fi

WORKSPACE=QiscusRealtime
FRAMEWORK=QiscusRealtime
PUBLISH=Cocoapods
BUILD=build
FRAMEWORK_NAME_WITH_EXT=$FRAMEWORK.framework
DSYM_NAME_WITH_EXT=$FRAMEWORK_NAME_WITH_EXT.dSYM
ZIP_DIR=zip

IOS_ARCHIVE_DIR=Release-iphoneos-archive
IOS_ARCHIVE_FRAMEWORK_PATH=$BUILD/$IOS_ARCHIVE_DIR/Products/Library/Frameworks/$FRAMEWORK_NAME_WITH_EXT
IOS_ARCHIVE_DSYM_PATH=$BUILD/$IOS_ARCHIVE_DIR/dSYMs
IOS_SIM_DIR=Release-iphonesimulator
IOS_UNIVERSAL_DIR=Release-universal-iOS

echo "\033[31m Cleaning up after old builds \033[0m\n"
say -v veena Cleaning up
rm -Rf $BUILD

echo "\033[37m Installing dependencies"
say -v veena Installing dependencies
if ! [ -x "$(command -v xcpretty)" ]; then
  echo " Installing xcpretty....."
  gem install xcpretty
fi

# iOS
echo " Installing cocoapods \033[0m\n"
say -v veena Installing... cocoapods
pod install

echo "\033[32m BUILDING FOR iOS \033[0m\n"

echo "\033[35m ▹ Building for simulator (Release) \033[0m\n"
say -v veena Building for simulator, it will take a long time, - John Johnson said, - 'First, solve the problem. Then, write the code.'
xcodebuild build -workspace $WORKSPACE.xcworkspace -scheme $FRAMEWORK -sdk iphonesimulator SYMROOT=$(PWD)/$BUILD OTHER_CFLAGS="-fembed-bitcode" BITCODE_GENERATION_MODE=bitcode | xcpretty

echo "\033[32m \n ▹ Building for device (Archive) \033[0m\n"
say -v veena Building for device, it will take a long time, – Kent Beck said, - 'Make it work, make it right, make it fast.'
xcodebuild archive -workspace $WORKSPACE.xcworkspace -scheme $FRAMEWORK -sdk iphoneos -archivePath $BUILD/Release-iphoneos.xcarchive OTHER_CFLAGS="-fembed-bitcode" BITCODE_GENERATION_MODE=bitcode | xcpretty

echo "\033[32m Copying framework files \033[0m\n"
say -v veena Copying framework
mv $BUILD/Release-iphoneos.xcarchive $BUILD/$IOS_ARCHIVE_DIR
echo "\033[32m  ▹ Create Universal directory \033[0m\n"
mkdir -p $BUILD/$IOS_UNIVERSAL_DIR
echo "\033[32m  ▹ Create Universal frameworks \033[0m\n"
pwd
cp -RL $IOS_ARCHIVE_FRAMEWORK_PATH $BUILD/$IOS_UNIVERSAL_DIR/$FRAMEWORK_NAME_WITH_EXT
echo "\033[32m  ▹ Create Universal dSYMs \033[0m\n"
pwd
cp -RL $IOS_ARCHIVE_DSYM_PATH/$DSYM_NAME_WITH_EXT $BUILD/$IOS_UNIVERSAL_DIR/$DSYM_NAME_WITH_EXT
echo "\033[32m  ▹ Create Universal swiftmodule \033[0m\n"
pwd
cp -RL $BUILD/$IOS_SIM_DIR/$FRAMEWORK_NAME_WITH_EXT/Modules/$FRAMEWORK.swiftmodule/* $BUILD/$IOS_UNIVERSAL_DIR/$FRAMEWORK_NAME_WITH_EXT/Modules/$FRAMEWORK.swiftmodule
say -v veena lipo-ing the iOS frameworks together into universal framework
echo "\033[35m 🤝 lipo'ing the iOS frameworks together into universal framework \033[0m\n"
lipo -create $IOS_ARCHIVE_FRAMEWORK_PATH/$FRAMEWORK $BUILD/$IOS_SIM_DIR/$FRAMEWORK_NAME_WITH_EXT/$FRAMEWORK -output $BUILD/$IOS_UNIVERSAL_DIR/$FRAMEWORK_NAME_WITH_EXT/$FRAMEWORK
echo "\033[35m 🤝 lipo'ing the iOS dSYMs together into a universal dSYM \033[0m\n"
DSYM_PATH=$DSYM_NAME_WITH_EXT/Contents/Resources/DWARF/$FRAMEWORK
lipo -create $IOS_ARCHIVE_DSYM_PATH/$DSYM_PATH $BUILD/$IOS_SIM_DIR/$DSYM_PATH  -output $BUILD/$IOS_UNIVERSAL_DIR/$DSYM_PATH

# Rename and zip
echo "\033[32m Copying iOS files into zip directory \033[0m\n"
say -v veena Copying iOS files into zip directory
mkdir $ZIP_DIR
cp -RL LICENSE $ZIP_DIR
cp -RL $BUILD/$IOS_UNIVERSAL_DIR/$FRAMEWORK_NAME_WITH_EXT $ZIP_DIR/$FRAMEWORK_NAME_WITH_EXT
cp -RL $BUILD/$IOS_UNIVERSAL_DIR/$DSYM_NAME_WITH_EXT $ZIP_DIR/$DSYM_NAME_WITH_EXT
cd $ZIP_DIR

say -v veena creating universal frameworks
zip -r QiscusCore.zip LICENSE $FRAMEWORK_NAME_WITH_EXT $DSYM_NAME_WITH_EXT
echo "\033[32m Zipped resulting frameworks and dSYMs to $ZIP_DIR/QiscusCore.zip \033[0m\n"
echo "\033[35m Finish creating universal frameworks \n Alhamdulillah 🎊 🎊 🎁 \033[0m\n"

# checking arhitechture
echo "\033[32m \n Checking framework arhitechture, should be 4 arhitechture include arm, i386 and x86_64 \033[0m\n"
cd $FRAMEWORK_NAME_WITH_EXT
file $FRAMEWORK

# copy framework, readme, etc to publish directory
pwd
echo "\033[35m \n Copying framework and dSYMs to cocoapods directory \033[0m\n"
say -v veena Checking framework arhitechture
cd ../../ 
pwd
cp -RL $BUILD/$IOS_UNIVERSAL_DIR/$FRAMEWORK_NAME_WITH_EXT $PUBLISH/$FRAMEWORK_NAME_WITH_EXT
cp -RL $BUILD/$IOS_UNIVERSAL_DIR/$DSYM_NAME_WITH_EXT $PUBLISH/$DSYM_NAME_WITH_EXT
cp -RL LICENSE $PUBLISH
cp -RL README.md $PUBLISH
git add .
git commit -m "finish build for cocoapod"

echo -n "\033[31m Mau sekalian di publish ke github (y/n)? \033[0m\n"
say -v veena Do you want to publish to github?
old_stty_cfg=$(stty -g)
stty raw -echo
answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
stty $old_stty_cfg
if echo "$answer" | grep -iq "^y" ;then
    echo "\033[32m \n Siap bos ku ... \033[0m\n"
    say -v veena Aye aye captain
else
    echo "\033[31m Ya sudah \033[0m\n"
    say -v veena Up to you, see you next build
    exit
fi
cd $PUBLISH
echo "\033[35m Finish copy new framework to publish directory \033[0m\n"
say -v veena copy new framework to publish directory
git add .
git commit -m "update framework"
git push origin master
echo "\033[35m Finish update cocoapod repo \n Alhamdulillah 🎉 🎉 🎉 \033[0m\n"
say -v veena Horree 🎉, - see you next build - Ashari

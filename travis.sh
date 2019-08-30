BUILD_START=$(date +"%s");

# Colours
blue='\033[0;34m';
cyan='\033[0;36m';
yellow='\033[0;33m';
red='\033[0;31m';
nocol='\033[0m';

# Kernel details;
KERNEL_NAME="Icey-z";
VERSION="0.1a";
DATE=$(date +"%d-%m-%Y-%I-%M");
DEVICE="Z00T";
OUT="msm8916";
FINAL_ZIP=$KERNEL_NAME-$VERSION-$DATE-$DEVICE.zip;

# Dirs
ANYKERNEL_DIR=$TRAVIS_BUILD_DIR/AnyKernel2;
KERNEL_IMG=$TRAVIS_BUILD_DIR/arch/arm64/boot/Image.gz-dtb;
UPLOAD_DIR=$TRAVIS_BUILD_DIR/$OUT;

git clone https://bitbucket.org/anupritaisno1/aarch64-linux-gnu -b linaro --single-branch --depth=1 -4 aarch64-linux-gnu -j$(nproc --all);
export CROSS_COMPILE="/usr/bin/ccache ./aarch64-linux-gnu/bin/aarch64-linux-gnu-" ;
export ARCH=arm64;
#export SUBARCH=arm64;
export KBUILD_BUILD_USER="Akagi";
export KBUILD_BUILD_HOST="asus-dev";
STRIP="aarch64-linux-gnu/bin/aarch64-linux-gnu-strip";
export CCOMPILE=$CROSS_COMPILE;
export CROSS_COMPILE="/usr/bin/ccache aarch64-linux-gnu-" ;
export PATH=$PATH:./aarch64-linux-gnu/bin/ ;
make Z00T_defconfig;
make -j8(nproc --all);
mkdir -p tmp_mod;
make -j4 modules_install INSTALL_MOD_PATH=tmp_mod INSTALL_MOD_STRIP=1;
find tmp_mod/ -name '*.ko' -type f -exec cp '{}' $ANYKERNEL_DIR/modules/system/lib/modules/ \;
cp $KERNEL_IMG $ANYKERNEL_DIR;
mkdir -p $UPLOAD_DIR;
cd $ANYKERNEL_DIR;
zip -r9 UPDATE-AnyKernel2.zip * -x README UPDATE-AnyKernel2.zip;
mv $ANYKERNEL_DIR/UPDATE-AnyKernel2.zip $UPLOAD_DIR/$FINAL_ZIP;

# Cleanup
rm $ANYKERNEL_DIR/Image.gz-dtb;

BUILD_END=$(date +"%s");
DIFF=$(($BUILD_END - $BUILD_START));
echo -e "$yellow Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nocol";

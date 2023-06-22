#!/bin/bash
echo -e "\033[31m -------------env configing--------------- \033[0m"
complier="/home/saber/Project/Android/WhyRed/toolchains/toolchain_aarch64"
export CROSS_COMPILE=${complier}/google_gcc/aarch64-linux-android-4.9/bin/aarch64-linux-android-
export CROSS_COMPILE_ARM32=${complier}/google_gcc/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-
export TARGET_CC="gcc"
export ARCH=arm64

make clean
make mrproper
# rm -rf ./out
echo -e "\033[31m -------------env configing end--------------- \033[0m"


echo -e "\033[31m -------------build kernel--------------- \033[0m"
args="-j$(nproc --all) \
O=out \
2>&1 | tee output.txt"

make O=out whyred-saber_docker_defconfig 2>&1 | tee output_1.txt
make ${args}


echo -e "\033[31m ----copy Image.gz-dtb and gen kernel.zip  by anykernel3-------- \033[0m"
AnyKernel3="/home/saber/Project/Android/WhyRed/AnyKernel3"
rm ${AnyKernel3}/kernel.zip
rm ${AnyKernel3}/Image.gz-dtb

cp $(pwd)/out/arch/arm64/boot/Image.gz-dtb ${AnyKernel3}/
cd ${AnyKernel3}/ && ./build.sh
cp kernel.zip kernel_docker.zip
cd -

echo -e "\033[31m ----copy Image.gz-dtb and gen image-new.img  by AIK-------- \033[0m"
AIK="/home/saber/Project/Android/WhyRed/AIK-Linux"
cp $(pwd)/out/arch/arm64/boot/Image.gz-dtb ${AIK}/split_img/stockboot.img-kernel
cd ${AIK}/ && ./repackimg.sh
cp unsigned-new.img boot_docker.img
cd -


setws ./csi2_zybo_z7_example.sdk
createhw -name zybo -hwspec ./csi2_zybo_z7_example.sdk/csi2_zybo_z7_example_wrapper.hdf
createbsp -name zybo_bsp -proc ps7_cortexa9_0 -hwproject zybo -os standalone
setlib -bsp zybo_bsp -lib xilffs
regenbsp -bsp zybo_bsp
createapp -name zybo_app -app {Hello World} -proc ps7_cortexa9_0 -hwproject zybo -bsp zybo_bsp -os standalone
createapp -name zybo_fsbl -app {Zynq FSBL} -proc ps7_cortexa9_0 -hwproject zybo -bsp zybo_bsp -os standalone
projects -build
set OUTPUT_DIR [pwd]/csi2_zybo_z7_example.sdk/zybo_app/
exec echo "the_ROM_image:" > ./output.bif
exec echo "{" >> ./output.bif
exec echo "\t\[bootloader\][pwd]/csi2_zybo_z7_example.sdk/zybo_fsbl/Debug/zybo_fsbl.elf" >> ./output.bif 
exec echo "[pwd]/csi2_zybo_z7_example.sdk/zybo/csi2_zybo_z7_example_wrapper.bit" >> ./output.bif
exec echo "[pwd]/csi2_zybo_z7_example.sdk/zybo_app/Debug/zybo_app.elf" >> ./output.bif
exec echo "}" >> ./output.bif
exec bootgen -arch zynq -image ./output.bif -w -o ./BOOT.bin

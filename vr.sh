#!/bin/bash
sudo apt update
mkdir vr
sleep 1
cd vr
wget https://github.com/SideQuestVR/SideQuest/releases/download/v0.10.33/SideQuest-0.10.33.tar.xz
tar -xf *.tar.xz
echo "SUBSYSTEM="usb", ATTR{idVendor}=="2833", ATTR{idProduct}=="0186", MODE="0660" group="plugdev", symlink+="ocuquest%n"" > 50-oculus.rules
sudo cp 50-oculus.rules /etc/udev/rules.d/
sudo rm 50-oculus.rules
rm *.tar.xz
gpu=$(lspci | grep -i vga | awk '{print $5}')

if [ $gpu == "NVIDIA" ]
then
    sudo apt install nvidia-driver-525 -y
fi
sudo apt install adb -y
sudo adb kill-server
sleep 1
sudo adb start-server
adb devices
adb forward tcp:9943 tcp:9943
wget https://github.com/alvr-org/ALVR/releases/download/v19.1.0/ALVR-x86_64.AppImage
sudo apt install build-essential pkg-config libclang-dev libssl-dev libasound2-dev libjack-dev libgtk-3-dev libvulkan-dev libunwind-dev gcc-8 g++-8 yasm nasm curl libx264-dev libx265-dev libxcb-render0-dev libxcb-shape0-dev libxcb-xfixes0-dev libspeechd-dev libxkbcommon-dev libdrm-dev libva-dev libvulkan-dev vulkan-headers
chmod +x *.AppImage    
sudo echo "[Unit]
After=network.target

[Service]
Type=forking
ExecStart=/usr/local/bin/vrstart.sh

[Install]
WantedBy=default.target
" > vr.service
wget -O start-vr https://github.com/MrScratchcat/alvr-vr-setup/releases/download/alvrsetup/vrstart.sh
sudo cp start-vr /bin
sudo chmod +x /bin/start-vr
sudo cp vr.service /etc/systemd/system
sudo rm vr.service
sudo chmod +x /etc/systemd/system/vr.service
sudo chmod +x /usr/local/bin/vrstart.sh
sudo systemctl daemon-reload
sudo systemctl enable vr.service
sudo systemctl start vr.service
clear
echo "go to settings then connection and then turn on "show advanced options" and then change server streaming port to "9943" "
echo " "
echo "download alvr in sidequest in your vr folder!"
echo " "
echo " to start your cable connection for vr type: start-vr"

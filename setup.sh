sudo apt install -y curl
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get install -y ros-noetic-desktop-full
sudo apt install -y python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential

sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE || sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE
sudo add-apt-repository "deb https://librealsense.intel.com/Debian/apt-repo $(lsb_release -cs) main" -u
sudo apt-get update

sudo apt-get install -y librealsense2-dkms librealsense2-utils librealsense2-dev librealsense2-dbg

sudo rosdep init
rosdep update

sudo apt install -y zsh git build-essential
# This part is optional to install zsh
sh -c "$(wget -O- https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

sudo apt install -y python-rosinstall python-rosinstall-generator python-wstool build-essential python-catkin-tools

# setup autominy
cd /opt/
sudo git clone https://github.com/autominy/autominy.git
sudo chown -R ros:ros /opt/autominy
cd autominy/catkin_ws/src
git clone https://github.com/IntelRealSense/realsense-ros.git
git clone https://github.com/pal-robotics/ddynamic_reconfigure.git
cd ..
#librealsense is not found through packages so add -r to continue on error
rosdep install --from-paths . --ignore-src --rosdistro=noetic -y -r
sudo apt install -y clang
source /opt/ros/noetic/setup.zsh
catkin config --cmake-args -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++
catkin build
cd

git clone https://github.com/autominy/autominy-config
cd autominy-config
sudo chown -R root:root etc
sudo cp -r etc/* /etc
sudo rm /etc/netplan/01-network-manager-all.yaml

# adjust wireless interfaces
sudo nano /etc/netplan/02-wireless.yaml

cp ros-config.sh ..
cp autostart.sh ..
cp .bashrc ..
cp .zshrc ..
sudo chmod +x ../autostart.sh
sudo systemctl enable autominy.service

sudo bash -c 'echo "ros ALL=(ALL) NOPASSWD: /sbin/poweroff, /sbin/reboot, /sbin/shutdown" >> /etc/sudoers'



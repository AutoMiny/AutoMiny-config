sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
sudo apt-get update
sudo apt-get install -y ros-melodic-desktop-full

sudo apt-key adv --keyserver keys.gnupg.net --recv-key C8B3A55A6F3EFCDE || sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key C8B3A55A6F3EFCDE
sudo add-apt-repository "deb http://realsense-hw-public.s3.amazonaws.com/Debian/apt-repo bionic main" -u
sudo apt-get update

sudo apt-get install -y librealsense2-dkms librealsense2-utils librealsense2-dev librealsense2-dbg

sudo rosdep init
rosdep update

sudo apt install -y zsh git
# This part is optional to install zsh
sh -c "$(wget -O- https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k

echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc
echo "source /opt/ros/melodic/setup.zsh" >> ~/.zshrc
source ~/.zshrc

sudo apt install -y python-rosinstall python-rosinstall-generator python-wstool build-essential python-catkin-tools

# setup autominy
cd /opt/
sudo git clone https://github.com/autominy/autominy.git
sudo chown -R ros:ros /opt/autominy
cd autominy/catkin_ws
cd src
git clone https://github.com/IntelRealSense/realsense-ros.git
git clone https://github.com/pal-robotics/ddynamic_reconfigure.git
cd ..
rosdep install --from-paths . --ignore-src --rosdistro=melodic -y
sudo apt install -y clang
catkin config --cmake-args -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++

echo "source /opt/autominy/catkin_ws/devel/setup.bash" >> ~/.bashrc
echo "source /opt/autominy/catkin_ws/devel/setup.zsh" >> ~/.zshrc
cd

# adjust this
echo -e '### ROS Setup
#IP=192.168.43.199       # ETHERNET
IP=192.168.43.130       # WIFI

export ROS_HOSTNAME=$IP
export ROS_MASTER_URI=http://$IP:11311
export ROS_CALIBRATION_MARKER_ID=11
export ROS_CAR_ID=130
export ROS_GPS_MARKER=16
' > ros-config.sh

echo "source /home/ros/ros-config.sh" >> ~/.bashrc
echo "source /home/ros/ros-config.sh" >> ~/.zshrc

git clone https://github.com/autominy/autominy-config
cd autominy-config
sudo chown -R root:root etc
sudo cp -r etc/* /etc
sudo rm /etc/netplan/01-network-manager-all.yaml

# adjust wireless interfaces
nano 02-wireless.yaml

cp autostart.sh ..
sudo chmod +x ../autostart.sh
sudo systemctl enable autominy.service


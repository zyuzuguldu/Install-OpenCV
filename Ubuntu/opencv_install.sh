# Dan Walkes
# 2014-01-29
# Call this script after configuring variables:
# version - the version of OpenCV to be installed
# downloadfile - the name of the OpenCV download file
# dldir - the download directory (optional, if not specified creates an OpenCV directory in the working dir)
if [[ -z "$version" ]]; then
    echo "Please define version before calling `basename $0` or use a wrapper like opencv_latest.sh"
    exit 1
fi
if [[ -z "$downloadfile" ]]; then
    echo "Please define downloadfile before calling `basename $0` or use a wrapper like opencv_latest.sh"
    exit 1
fi
if [[ -z "$dldir" ]]; then
    dldir=OpenCV
fi
if ! sudo true; then
    echo "You must have root privileges to run this script."
    exit 1
fi
set -e

repo=.`dirname $0`/../repo/
echo $repo
exit 1

echo "--- Installing OpenCV" $version

echo "--- Installing Dependencies"
source dependencies.sh

mkdir -p $dldir
cd $dldir
if [ -f "../repo/$downloadfile" ]
then
	echo "../repo/$downloadfile found."
else
	echo "../repo/$downloadfile not found."
	echo "--- Downloading OpenCV" $version
        wget -O ../repo/$downloadfile http://sourceforge.net/projects/opencvlibrary/files/opencv-unix/$version/$downloadfile/download
fi
echo "--- Installing OpenCV" $version
echo ../repo/$downloadfile | grep ".zip"
if [ $? -eq 0 ]; then
    unzip ../repo/$downloadfile
else
    tar -xvf ../repo/$downloadfile
fi
cd opencv-$version
mkdir build
cd build
cmake -D BUILD_SHARED_LIBS=OFF -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D WITH_TBB=ON -D BUILD_NEW_PYTHON_SUPPORT=ON -D WITH_V4L=ON -D INSTALL_C_EXAMPLES=ON -D INSTALL_PYTHON_EXAMPLES=ON -D BUILD_EXAMPLES=ON -D WITH_QT=ON -D WITH_OPENGL=ON ..
make -j 7
sudo make install
sudo sh -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf'
sudo ldconfig
echo "OpenCV" $version "ready to be used"

#!/usr/bin/env bash

# Initial Exports
export \
    DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    JAVA_OPTS=" -Xmx7G " JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

printf "Installing Recommended Programs. This Will Take A Few Minutes...\n"
sudo apt-get -qqy update &>/dev/null
sudo apt-get -qqy install --no-install-recommends \
    lsb-core lsb-security patchutils bc \
    android-sdk-platform-tools adb fastboot \
    openjdk-8-jdk ca-certificates-java maven \
    python-all-dev python-is-python2 \
    lzip lzop xzdec pixz libzstd-dev lib32z1-dev \
    exfat-utils exfat-fuse \
    gcc gcc-multilib g++-multilib clang llvm lld cmake ninja-build \
    libxml2-utils xsltproc expat re2c libxml2-utils xsltproc expat re2c \
    libreadline-gplv2-dev libsdl1.2-dev libtinfo5 xterm rename schedtool bison gperf libb2-dev \
    pngcrush imagemagick optipng advancecomp \
    &>/dev/null

printf "Cleaning Some Programs...\n"
sudo apt-get -qqy purge default-jre-headless openjdk-11-jre-headless &>/dev/null
sudo apt-get -qy clean &>/dev/null && sudo apt-get -qy autoremove &>/dev/null
sudo rm -rf -- /var/lib/apt/lists/* /var/cache/apt/archives/* &>/dev/null

cd /home/runner || exit 1

printf "Adding latest stable git-repo and ghr binary...\n"
curl -sL https://gerrit.googlesource.com/git-repo/+/refs/heads/stable/repo?format=TEXT | base64 --decode  > repo
curl -s https://api.github.com/repos/tcnksm/ghr/releases/latest | jq -r '.assets[] | select(.browser_download_url | contains("linux_amd64")) | .browser_download_url' | wget -qi -
tar -xzf ghr_*_amd64.tar.gz --wildcards 'ghr*/ghr' --strip-components 1 && rm -rf ghr_*_amd64.tar.gz
chmod a+rx ./repo && chmod a+x ./ghr && sudo mv ./repo ./ghr /usr/local/bin/

mkdir -p /home/runner/extra &>/dev/null
printf "Installing Latest make and ccache...\n"
{
    cd /home/runner/extra || exit 1
    wget -q https://ftp.gnu.org/gnu/make/make-4.3.tar.gz
    tar xzf make-4.3.tar.gz && cd make-*/
    ./configure && bash ./build.sh && sudo install ./make /usr/local/bin/make
    cd /home/runner/extra || exit 1
    git clone -q https://github.com/ccache/ccache.git
    cd ccache && git checkout -q v4.2
    mkdir build && cd build
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -DZSTD_FROM_INTERNET=ON ..
    make -j4 && sudo make install
} &>/dev/null
cd /home/runner || exit 1
rm -rf /home/runner/extra

printf "Doing Some Random Stuff...\n"
if [ -e /lib/x86_64-linux-gnu/libncurses.so.6 ] && [ ! -e /usr/lib/x86_64-linux-gnu/libncurses.so.5 ]; then
    ln -s /lib/x86_64-linux-gnu/libncurses.so.6 /usr/lib/x86_64-linux-gnu/libncurses.so.5
fi

# Minor ADB Rules Settings
sudo curl --create-dirs -sL -o /etc/udev/rules.d/51-android.rules -O -L \
    https://raw.githubusercontent.com/M0Rf30/android-udev-rules/master/51-android.rules
sudo chmod 644 /etc/udev/rules.d/51-android.rules
sudo chown root /etc/udev/rules.d/51-android.rules

# Post Setup Exports
echo "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" >> $GITHUB_ENV
export \
    PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    USE_CCACHE=1 CCACHE_COMPRESS=1 CCACHE_COMPRESSLEVEL=8 CCACHE_DIR=/opt/ccache \
    TERM=xterm-256color
. /home/runner/.bashrc 2>/dev/null

printf "Setting ccache...\n"
mkdir -p /opt/ccache &>/dev/null
sudo chown runner:docker /opt/ccache
CCACHE_DIR=/opt/ccache ccache -M 5G &>/dev/null

printf "All Done.\nReady To Build Recoveries...\n"

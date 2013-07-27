#!/bin/sh
git clone http://github.com/jonas/tig
cd tig
make configure
./configure
make
sudo make install 
sudo make install-release-doc
cd ..
rm -rf tig

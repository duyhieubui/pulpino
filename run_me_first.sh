#!/bin/bash

./update-ips.py https://github.com
pushd .
cd ips/apb/apb_spi_master
patch -p1 < ../../../patch/apb_spi_master.patch
popd
pushd .
cd ips/axi/axi_spi_master
patch -p1 < ../../../patch/axi_spi_master_controller.patch
popd

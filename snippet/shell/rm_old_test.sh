#!/usr/bin/bash

TCLIST=(
"dma0"
"emmc0"
"gpio0"
"i2c_master_slave0"
"i2c_master_slave1"
"i2c_master_slave2"
"i2c_master_slave3"
"i2c_slave_master0"
"i2c_slave_master1"
"i2c_slave_master2"
"i2c_slave_master3"
"i2s_slave_receiver0"
"i2s_slave_transmitter0"
"jtag0"
"sdhc0"
"spi_master0"
"spi_master1"
"spi_slave0"
"timer0"
"timer1"
"timer2"
"timer3"
"trace_enc0"
"u540"
"u541"
"uart0"
"uart1"
"wdt0"
"qspi_master0"
"qspi_master1"
"sifive_qspi_master0"
"otp0"
)

for (( i = 0 ; i < ${#TCLIST[@]} ; i++ )) ; do
  echo "Delete : ${TCLIST[$i]}"
  rm -rf  ${TCLIST[$i]}
done

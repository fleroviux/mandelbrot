#!/bin/sh
${DEVKITARM}/bin/arm-none-eabi-as main.s -mcpu=arm7tdmi -o main.o
${DEVKITARM}/bin/arm-none-eabi-objcopy main.o main.gba -O binary
gbafix main.gba -t MANDELBROT -c MNDL -m FX

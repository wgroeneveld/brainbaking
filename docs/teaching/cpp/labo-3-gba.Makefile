.PHONY : clean all
.DEFAULT_GOAL := all

CC=arm-none-eabi-gcc
OBJCOPY=arm-none-eabi-objcopy
EMULATOR=/Applications/mGBA.app/Contents/MacOS/mGBA

clean:
	rm -rf *.o
	rm -rf *.sav
	rm -rf *.elf
	rm -rf *.gba

compile: labo-3-gbabg.c
	$(CC) -c labo-3-gbabg.c -mthumb-interwork -mthumb -O2 -o main.o
	$(CC) main.o -mthumb-interwork -mthumb -specs=gba.specs -o main.elf

copybin: main.elf
	$(OBJCOPY) -v -O binary main.elf main.gba

run: main.gba
	$(EMULATOR) ./main.gba

all: clean compile copybin

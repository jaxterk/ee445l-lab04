# Tiva Makefile
# #####################################
#
# Part of the uCtools project
# uctools.github.com
#
#######################################
# user configuration:
#######################################
# TARGET: name of the output file
TARGET = lab03
# MCU: part number to build for
MCU = TM4C123GH6PM
# SOURCES: list of input source sources
SOURCES = Blynk.c esp8266.c PLL.c PortF.c ST7735.c startup_gcc.c clock.c \
          UART.c numbers.c timer0.c timer1.c timer2.c timer3.c systick.c \
          fixed.c switch.c
ASM_SOURCES = critical.gcc.s
# INCLUDES: list of includes, by default, use Includes directory
INCLUDES = -I../tivaware/inc
# OUTDIR: directory to use for output
OUTDIR = build
# TIVAWARE_PATH: path to tivaware folder
TIVAWARE_PATH = ../tivaware

# LD_SCRIPT: linker script
LD_SCRIPT = $(MCU).ld

# define flags
CFLAGS += -g -mthumb -mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=soft
CFLAGS += -ffunction-sections -fdata-sections -MD -std=c99 -Wall
CFLAGS += -pedantic -DPART_$(MCU) -c -I$(TIVAWARE_PATH)
CFLAGS += -DTARGET_IS_BLIZZARD_RA1 $(INCLUDES)
LDFLAGS += -lc -lgcc
LDFLAGS += -T $(LD_SCRIPT) --entry ResetISR --gc-sections

#######################################
# end of user configuration
#######################################
#
#######################################
# binaries
#######################################
CC = arm-none-eabi-gcc
LD = arm-none-eabi-ld
AS = arm-none-eabi-gcc
OBJCOPY = arm-none-eabi-objcopy
GDB		= arm-none-eabi-gdb
RM      = rm -f
MKDIR	= mkdir -p
#######################################

# Allow local overrides
-include Make.local
-include ../Make.local

# list of object files, placed in the build directory regardless of source path
ASM_OBJECTS = $(addprefix $(OUTDIR)/,$(notdir $(ASM_SOURCES:.gcc.s=.gcc.o)))
OBJECTS = $(addprefix $(OUTDIR)/,$(notdir $(SOURCES:.c=.o)))

# default: build bin
all: $(OUTDIR)/$(TARGET).bin

vpath %.gcc.s $(SOURCE_DIRS)
$(OUTDIR)/%.gcc.o: src/%.gcc.s | $(OUTDIR)
	$(AS) -o $@ $< $(CFLAGS)

vpath %.c $(SOURCE_DIRS)
$(OUTDIR)/%.o: src/%.c | $(OUTDIR) $(ASM_OBJECTS)
	$(CC) -o $@ $^ $(CFLAGS)

$(OUTDIR)/a.out: $(OBJECTS) $(ASM_OBJECTS)
	$(LD) -o $@ $^ $(LDFLAGS)

$(OUTDIR)/$(TARGET).bin: $(OUTDIR)/a.out
	$(OBJCOPY) -O binary $< $@

# create the output directory
$(OUTDIR):
	$(MKDIR) $(OUTDIR)

clean:
	-$(RM) $(OUTDIR)/*

flash: all
	lm4flash -v $(OUTDIR)/$(TARGET).bin

debug: all
	$(GDB) -ex 'target extended-remote | openocd -f board/ek-tm4c1294xl.cfg -c "gdb_port pipe; log_output openocd.log"; monitor reset; monitor halt' build/a.out
#monitor reset init
#continue
#bt

uart:
	screen /dev/ttyACM0 115200

.PHONY: all clean

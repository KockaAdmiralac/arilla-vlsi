PROGRAM = chat
BUILD_DIR = build
LINKER_SCRIPT = linker-script.ld
SRAM_LENGTH = 0x00006000
LINK_VERBOSE = 0

CC = riscv32-unknown-linux-gnu-gcc -c
AS = riscv32-unknown-linux-gnu-gcc -c -x assembler
LD = riscv32-unknown-linux-gnu-ld
OBJCOPY = riscv32-unknown-linux-gnu-objcopy
OBJDUMP = riscv32-unknown-linux-gnu-objdump
CPP = riscv32-unknown-linux-gnu-gcc -E -P -x c

FLAGS_CC =
FLAGS_CC += -Wall -Wextra
FLAGS_CC += -MMD -MP
FLAGS_CC += -march=rv32i -mabi=ilp32 -mstrict-align -nostdlib -ffreestanding

FLAGS_CPP =
FLAGS_CPP += -D_ARILLA_SRAM_LENGTH=$(SRAM_LENGTH)

FLAGS_LD =
FLAGS_LD += --no-warn-rwx-segment
ifeq ($(LINK_VERBOSE), 1)
FLAGS_LD += --verbose -Map=$(BUILD_DIR)/$(PROGRAM).map
endif

SOURCE_C_FILES = $(wildcard *.c */*.c)
SOURCE_S_FILES = $(wildcard *.s */*.s)
OBJECT_FILES = $(addprefix $(BUILD_DIR)/, $(notdir $(SOURCE_S_FILES:.s=.o)))
OBJECT_FILES += $(addprefix $(BUILD_DIR)/, $(notdir $(SOURCE_C_FILES:.c=.o)))

vpath %.s $(sort $(dir $(SOURCE_S_FILES))) 
vpath %.c $(sort $(dir $(SOURCE_C_FILES)))

all: $(BUILD_DIR)/$(PROGRAM).dump $(PROGRAM).mif

$(BUILD_DIR)/$(PROGRAM).dump : $(BUILD_DIR)/$(PROGRAM).elf
	$(OBJDUMP) -xsd $(<) >> $(@)

$(PROGRAM).mif : $(BUILD_DIR)/$(PROGRAM).elf
	$(OBJCOPY) --output-target ihex $(<) out.hex
	srec_cat out.hex -intel -fill 0x00 -within out.hex -intel -range-padding 4 --byte-swap 4 -output $(@) -Memory_Initialization_File 32
	rm -f out.hex

$(BUILD_DIR)/$(PROGRAM).elf : $(OBJECT_FILES) Makefile $(LINKER_SCRIPT) | $(BUILD_DIR)/$(LINKER_SCRIPT) 
	$(LD) -T $(BUILD_DIR)/$(LINKER_SCRIPT) $(FLAGS_LD) -o $(@) $(OBJECT_FILES)

$(BUILD_DIR)/$(LINKER_SCRIPT) : $(LINKER_SCRIPT) Makefile
	$(CPP) $(FLAGS_CPP) $(LINKER_SCRIPT) >> $(@)

$(BUILD_DIR)/%.o : %.s Makefile | $(BUILD_DIR)
	$(AS) $(FLAGS_CC) -o $(@) $(<)

$(BUILD_DIR)/%.o : %.c Makefile | $(BUILD_DIR)
	$(CC) $(FLAGS_CC) -o $(@) $(<)
	
$(BUILD_DIR) :
	mkdir $(@)

clean:
	rm -rf $(BUILD_DIR)

-include $(wildcard $(BUILD_DIR)/*.d)

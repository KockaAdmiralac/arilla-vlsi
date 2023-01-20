PROGRAM = Chat.exe
BIN_DIR = bin
OBJ_DIR = obj
DEBUG_ENABLED = 1
ifeq ($(DEBUG_ENABLED), 1)
TARGET = Debug
else
TARGET = Release
endif

SOURCE_FILES = $(wildcard *.c */*.c)
OBJECT_FILES = $(addprefix $(OBJ_DIR)/$(TARGET)/, $(notdir $(SOURCE_FILES:.c=.o)))

CC = gcc -c -nostartfiles
LD = gcc

FLAGS_CC =
FLAGS_CC += -Wall -Wextra
FLAGS_CC += -MMD -MP
ifeq ($(DEBUG_ENABLED), 1)
FLAGS_CC += -g -DPAINT_TEST
endif

all: $(BIN_DIR)/$(TARGET)/$(PROGRAM)

$(BIN_DIR)/$(TARGET)/$(PROGRAM): $(OBJECT_FILES) Makefile | $(BIN_DIR)/$(TARGET)
	$(LD) -o $(@) $(OBJECT_FILES)

$(OBJ_DIR)/$(TARGET)/%.o: %.c Makefile | $(OBJ_DIR)/$(TARGET)
	$(CC) $(FLAGS_CC) -o $(@) $(<)

$(OBJ_DIR)/$(TARGET):
	mkdir -p $(OBJ_DIR)/$(TARGET)

$(BIN_DIR)/$(TARGET):
	mkdir -p $(BIN_DIR)/$(TARGET)

clean:
	rm -rf $(BIN_DIR)
	rm -rf $(OBJ_DIR)

-include $(wildcard $(OBJ_DIR)/$(TARGET)/*.d)

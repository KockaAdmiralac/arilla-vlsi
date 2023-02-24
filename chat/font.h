#ifndef _FONT_H_
#define _FONT_H_

#include "gpu.h"

extern const unsigned int ASCII_MASK;
extern const char font8x8_basic[128][8];
void drawCharacterAligned(unsigned int character, unsigned int row, unsigned int column, unsigned int color);
void drawStringAligned(const char *string, unsigned int row, unsigned int column, unsigned int color);

#endif

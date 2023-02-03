#ifndef _PERIPHERAL_H_
#define _PERIPHERAL_H_

#include "gpu.h"

#define STACK_SIZE 23*84/4

extern const unsigned int ICON_ETF;
extern const unsigned int ICON_ARILLA;

extern unsigned int stack[STACK_SIZE];

void drawIconOpt(unsigned int x,unsigned int y,unsigned int col,const unsigned int icon,unsigned int bgVal);
void AL(unsigned int x,unsigned int y,unsigned int scale,unsigned int scale2);

#endif // _PERIPHERAL_H_

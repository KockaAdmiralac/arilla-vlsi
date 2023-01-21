#ifndef _KEYBOARD_H_
#define _KEYBOARD_H_

#include "io.h"

extern const unsigned int KEYBOARD_BASE_ADDRESS;
extern const unsigned int KEYBOARD_READ_MASK;
extern const unsigned int KEYBOARD_CHAR_MASK;
extern const unsigned int KEYBOARD_PERR_MASK;
extern const unsigned int KEYBOARD_FERR_MASK;
extern const unsigned int KEYBOARD_CDC_MASK;
extern const unsigned int KEYBOARD_DEB_MASK;
extern const unsigned int KEYBOARD_DEBC_MASK;
extern const unsigned int KEYBOARD_DEB_POS;

extern const unsigned int KEY_CODE_ENTER;
extern const unsigned int KEY_CODE_BACKSPACE;

void keyboardSetCDC(unsigned int val);
void keyboardSetDEB(unsigned int val);

void keyboardRead();

unsigned int keyboardGetChar();

unsigned int keyboardPerr();

unsigned int keyboardFerr();

char keyboardAscii();


#endif // _MOUSE_H_

#ifndef _KEYBOARD_H_
#define _KEYBOARD_H_

#include "io.h"

#define KEY_CODE_F1        129
#define KEY_CODE_F2        130
#define KEY_CODE_F3        131
#define KEY_CODE_F4        132
#define KEY_CODE_F5        134
#define KEY_CODE_F6        135
#define KEY_CODE_F7        136
#define KEY_CODE_F8        137
#define KEY_CODE_F9        138
#define KEY_CODE_F10       139
#define KEY_CODE_F11       140
#define KEY_CODE_F12       141
#define KEY_CODE_RETURN    142
#define KEY_CODE_BACKSPACE 143
#define KEY_CODE_DELETE    144
#define KEY_CODE_HOME      145
#define KEY_CODE_END       146
#define KEY_CODE_INSERT    147
#define KEY_CODE_LEFT      148
#define KEY_CODE_RIGHT     149

extern const unsigned int KEYBOARD_BASE_ADDRESS;
extern const unsigned int KEYBOARD_CHAR_MASK;
extern const unsigned int KEYBOARD_PERR_MASK;
extern const unsigned int KEYBOARD_FERR_MASK;
extern const unsigned int KEYBOARD_CDC_MASK;
extern const unsigned int KEYBOARD_DEB_MASK;

extern const unsigned int KEYBOARD_DEB_SIZE;
extern const unsigned int KEYBOARD_DEB_POS;

void keyboardSetCDC(unsigned int val);

void keyboardSetDEB(unsigned int val);

unsigned int keyboardRead();

unsigned int keyboardPerr();

unsigned int keyboardFerr();

#endif // _MOUSE_H_

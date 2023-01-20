#include "keyboard.h"

const unsigned int KEYBOARD_BASE_ADDRESS = 0x30000000;
const unsigned int KEYBOARD_CHAR_MASK = 0xFFFFFF;
const unsigned int KEYBOARD_PERR_MASK = 0x1000000;
const unsigned int KEYBOARD_FERR_MASK = 0x2000000;
const unsigned int KEYBOARD_CDC_MASK =  0x4000000;
const unsigned int KEYBOARD_DEB_MASK = 0x1F;
const unsigned int KEYBOARD_DEBC_MASK = 0xF8000000;
const unsigned int KEYBOARD_DEB_POS = 27;

const unsigned int KEY_CODE_ENTER = 0x5A;

unsigned int k_lastControl = 0;
unsigned int k_char = 0;
unsigned int k_lastchar = 0;

void keyboardSetCDC(unsigned int val)
{
    k_lastControl &= ~KEYBOARD_CDC_MASK;
    k_lastControl |= val?KEYBOARD_CDC_MASK:0;
    out(KEYBOARD_BASE_ADDRESS,k_lastControl);
}

void keyboardSetDEB(unsigned int val)
{
    k_lastControl &= ~KEYBOARD_DEBC_MASK;
    k_lastControl |= (val&KEYBOARD_DEB_MASK)<<KEYBOARD_DEB_POS;
    out(KEYBOARD_BASE_ADDRESS,k_lastControl);
}

void keyboardRead()
{
    k_lastchar = k_char;
    k_char = in(KEYBOARD_BASE_ADDRESS);
}

unsigned int keyboardGetChar()
{
    return (k_char!=k_lastchar) ? k_char & KEYBOARD_CHAR_MASK : 0;
}

unsigned int keyboardPerr()
{
    return (k_char & KEYBOARD_PERR_MASK) != 0;
}

unsigned int keyboardFerr()
{
    return (k_char & KEYBOARD_FERR_MASK) != 0;
}

char keyboardAscii()
{
    switch(k_char&0xFF)
    {
        case 0x1C: {return 'A';}
        case 0x32: {return 'B';}
        case 0x21: {return 'C';}
        case 0x23: {return 'D';}
        case 0x24: {return 'E';}
        case 0x2B: {return 'F';}
        case 0x34: {return 'G';}
        case 0x33: {return 'H';}
        case 0x43: {return 'I';}
        case 0x3B: {return 'J';}
        case 0x42: {return 'K';}
        case 0x4B: {return 'L';}
        case 0x3A: {return 'M';}
        case 0x31: {return 'N';}
        case 0x44: {return 'O';}
        case 0x4D: {return 'P';}
        case 0x15: {return 'Q';}
        case 0x2D: {return 'R';}
        case 0x1B: {return 'S';}
        case 0x2C: {return 'T';}
        case 0x3C: {return 'U';}
        case 0x2A: {return 'V';}
        case 0x1D: {return 'W';}
        case 0x22: {return 'X';}
        case 0x35: {return 'Y';}
        case 0x1A: {return 'Z';}
        case 0x16: {return '1';}
        case 0x1E: {return '2';}
        case 0x26: {return '3';}
        case 0x25: {return '4';}
        case 0x2E: {return '5';}
        case 0x36: {return '6';}
        case 0x3D: {return '7';}
        case 0x3E: {return '8';}
        case 0x46: {return '9';}
        case 0x45: {return '0';}
    }
    return 0;
}


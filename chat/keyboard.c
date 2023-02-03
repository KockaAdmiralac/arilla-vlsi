#include "keyboard.h"

const unsigned int KEYBOARD_BASE_ADDRESS = 0x30000000;
const unsigned int KEYBOARD_CHAR_MASK    = 0x00FFFFFF;
const unsigned int KEYBOARD_PERR_MASK    = 0x01000000;
const unsigned int KEYBOARD_FERR_MASK    = 0x02000000;
const unsigned int KEYBOARD_CDC_MASK     = 0x04000000;
const unsigned int KEYBOARD_DEB_MASK     = 0xF8000000;

const unsigned int KEYBOARD_DEB_SIZE = 0x1F;
const unsigned int KEYBOARD_DEB_POS = 27;

unsigned int k_lastControl = 0;
unsigned int k_char = 0;
unsigned int k_lastchar = 0;

void keyboardSetCDC(unsigned int val)
{
    k_lastControl &= ~KEYBOARD_CDC_MASK;
    k_lastControl |= val ? KEYBOARD_CDC_MASK : 0;
    out(KEYBOARD_BASE_ADDRESS, k_lastControl);
}

void keyboardSetDEB(unsigned int val)
{
    k_lastControl &= ~KEYBOARD_DEB_MASK;
    k_lastControl |= (val & KEYBOARD_DEB_SIZE) << KEYBOARD_DEB_POS;
    out(KEYBOARD_BASE_ADDRESS, k_lastControl);
}

unsigned int keyboardAscii()
{
    switch(k_char & 0xFF)
    {
        case 0x1C: return 'A';
        case 0x32: return 'B';
        case 0x21: return 'C';
        case 0x23: return 'D';
        case 0x24: return 'E';
        case 0x2B: return 'F';
        case 0x34: return 'G';
        case 0x33: return 'H';
        case 0x43: return 'I';
        case 0x3B: return 'J';
        case 0x42: return 'K';
        case 0x4B: return 'L';
        case 0x3A: return 'M';
        case 0x31: return 'N';
        case 0x44: return 'O';
        case 0x4D: return 'P';
        case 0x15: return 'Q';
        case 0x2D: return 'R';
        case 0x1B: return 'S';
        case 0x2C: return 'T';
        case 0x3C: return 'U';
        case 0x2A: return 'V';
        case 0x1D: return 'W';
        case 0x22: return 'X';
        case 0x35: return 'Y';
        case 0x1A: return 'Z';
        case 0x16: return '1';
        case 0x1E: return '2';
        case 0x26: return '3';
        case 0x25: return '4';
        case 0x2E: return '5';
        case 0x36: return '6';
        case 0x3D: return '7';
        case 0x3E: return '8';
        case 0x46: return '9';
        case 0x45: return '0';
        case 0x29: return ' ';
        case 0x05: return KEY_CODE_F1;
        case 0x06: return KEY_CODE_F2;
        case 0x04: return KEY_CODE_F3;
        case 0x0C: return KEY_CODE_F4;
        case 0x03: return KEY_CODE_F5;
        case 0x0B: return KEY_CODE_F6;
        case 0x83: return KEY_CODE_F7;
        case 0x0A: return KEY_CODE_F8;
        case 0x01: return KEY_CODE_F9;
        case 0x09: return KEY_CODE_F10;
        case 0x78: return KEY_CODE_F11;
        case 0x07: return KEY_CODE_F12;
        case 0x5A: return KEY_CODE_RETURN;
        case 0x66: return KEY_CODE_BACKSPACE;
        case 0x71: return KEY_CODE_DELETE;
        case 0x6C: return KEY_CODE_HOME;
        case 0x69: return KEY_CODE_END;
        case 0x70: return KEY_CODE_INSERT;
        case 0x6B: return KEY_CODE_LEFT;
        case 0x74: return KEY_CODE_RIGHT;
    }
    return 0;
}

unsigned int keyboardRead()
{
    k_lastchar = k_char & KEYBOARD_CHAR_MASK;
    k_char = in(KEYBOARD_BASE_ADDRESS);
    if((k_char & KEYBOARD_CHAR_MASK) != k_lastchar && (k_char & 0xFF00) != 0xF000)
    {
    	return keyboardAscii();
    }
    else
    {
    	return 0;
    }
}

unsigned int keyboardPerr()
{
    return (k_char & KEYBOARD_PERR_MASK) != 0;
}

unsigned int keyboardFerr()
{
    return (k_char & KEYBOARD_FERR_MASK) != 0;
}

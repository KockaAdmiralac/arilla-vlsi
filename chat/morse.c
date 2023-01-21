#include "morse.h"
#include "io.h"

const unsigned int MORSE_CONTROL = 0x40000000;
const unsigned int MORSE_BIT_TIME = 0x40000004;
const unsigned int MORSE_DATA = 0x40000008;
const unsigned int MORSE_DATA_AVAILABLE = 0x01;
const unsigned int MORSE_START_TRANSMISSION = 0x20;
const unsigned int ETX = 0x03;

unsigned m_messagePtr = 0;

void morseSend(char* message)
{
    for (char* ptr = message; *ptr != '\0'; ++ptr)
    {
        out(MORSE_DATA, *ptr);
    }
    out(MORSE_DATA, ETX);
    out(MORSE_CONTROL, MORSE_START_TRANSMISSION);
}

int morseReceive(char* message)
{
    unsigned status = in(MORSE_CONTROL);
    if ((status & MORSE_DATA_AVAILABLE) == 0)
    {
        return 0;
    }
    char charIn = in(MORSE_DATA);
    if ((unsigned)charIn == ETX)
    {
        message[m_messagePtr] = '\0';
        m_messagePtr = 0;
        return 1;
    }
    else
    {
        message[m_messagePtr++] = charIn;
    }
    return 0;
}

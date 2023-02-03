#include "morse.h"

const unsigned int MORSE_CONTROL_STATUS = 0x40000000;
const unsigned int MORSE_BIT_TIME       = 0x40000004;
const unsigned int MORSE_DATA           = 0x40000008;

const unsigned int BYTE_READ_MASK   = 0x800;
const unsigned int LOOPBACK_MASK    = 0x400;
const unsigned int INVERT_MASK      = 0x200;
const unsigned int SAMPLE_SEL_MASK  = 0x100;
const unsigned int SOUND_EN_MASK    = 0x080;
const unsigned int IN_PROGRESS_MASK = 0x040;
const unsigned int START_TRANS_MASK = 0x020;
const unsigned int RX_ENABLE_MASK   = 0x010;
const unsigned int SEND_FULL_MASK   = 0x008;
const unsigned int SEND_NE_MASK     = 0x004;
const unsigned int RECV_FULL_MASK   = 0x002;
const unsigned int RECV_NE_MASK     = 0x001;

const unsigned int ETX = 0x03;

unsigned int m_lastControl=0;
unsigned int m_lastStatus=0;
unsigned int m_messagePtr=0;

void morseSetLoop(unsigned int val)
{
	m_lastControl &= ~LOOPBACK_MASK;
	m_lastControl |= val ? LOOPBACK_MASK : 0;
	out(MORSE_CONTROL_STATUS, m_lastControl);
}

void morseSetInv(unsigned int val)
{
	m_lastControl &= ~INVERT_MASK;
	m_lastControl |= val ? INVERT_MASK : 0;
	out(MORSE_CONTROL_STATUS, m_lastControl);
}

void morseSetSample(unsigned int val)
{
	m_lastControl &= ~SAMPLE_SEL_MASK;
	m_lastControl |= val ? SAMPLE_SEL_MASK : 0;
	out(MORSE_CONTROL_STATUS, m_lastControl);
}

void morseSetSound(unsigned int val)
{
	m_lastControl &= ~SOUND_EN_MASK;
	m_lastControl |= val ? SOUND_EN_MASK : 0;
	out(MORSE_CONTROL_STATUS, m_lastControl);
}

void morseSetRx(unsigned int val)
{
	m_lastControl &= ~RX_ENABLE_MASK;
	m_lastControl |= val ? RX_ENABLE_MASK : 0;
	out(MORSE_CONTROL_STATUS, m_lastControl);
}

void morseSetBaud(unsigned int val)
{
	out(MORSE_BIT_TIME,val);
}

void morseReadStatus()
{
	m_lastStatus = in(MORSE_CONTROL_STATUS);
}

unsigned int morseInProgress()
{
	return (m_lastStatus & IN_PROGRESS_MASK) != 0;
}

unsigned int morseSendFull()
{
	return (m_lastStatus & SEND_FULL_MASK) != 0;
}

unsigned int morseSendNe()
{
	return (m_lastStatus & SEND_NE_MASK) != 0;
}

unsigned int morseReceiveFull()
{
	return (m_lastStatus & RECV_FULL_MASK) != 0;
}

unsigned int morseReceiveNe()
{
	return (m_lastStatus & RECV_NE_MASK) != 0;
}

void morseSend(char* message)
{
    for(char* ptr = message; *ptr != '\0'; ++ptr)
    {
        out(MORSE_DATA, *ptr);
    }
    out(MORSE_DATA, ETX);
    out(MORSE_CONTROL_STATUS, m_lastControl | START_TRANS_MASK);
}

unsigned int morseReceive()
{
    if((m_lastStatus & RECV_NE_MASK) != 0)
    {
    	unsigned int c = in(MORSE_DATA);
		out(MORSE_CONTROL_STATUS, m_lastControl | BYTE_READ_MASK);
		return c;
    }
    return 0;
}

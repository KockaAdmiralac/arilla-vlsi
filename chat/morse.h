#ifndef _MORSE_H_
#define _MORSE_H_

#include "io.h"

extern const unsigned int MORSE_CONTROL_STATUS;
extern const unsigned int MORSE_BIT_TIME;
extern const unsigned int MORSE_DATA;

extern const unsigned int BYTE_READ_MASK;
extern const unsigned int LOOPBACK_MASK;
extern const unsigned int INVERT_MASK;
extern const unsigned int SAMPLE_SEL_MASK;
extern const unsigned int SOUND_EN_MASK;
extern const unsigned int IN_PROGRESS_MASK;
extern const unsigned int START_TRANS_MASK;
extern const unsigned int RX_ENABLE_MASK;
extern const unsigned int SEND_FULL_MASK;
extern const unsigned int SEND_NE_MASK;
extern const unsigned int RECV_FULL_MASK;
extern const unsigned int RECV_NE_MASK;

extern const unsigned int ETX;

void morseSetLoop(unsigned int val);
void morseSetInv(unsigned int val);
void morseSetSample(unsigned int val);
void morseSetSound(unsigned int val);
void morseSetRx(unsigned int val);
void morseSetBaud(unsigned int val);

void morseReadStatus();
unsigned int morseInProgress();
unsigned int morseSendFull();
unsigned int morseSendNe();
unsigned int morseReceiveFull();
unsigned int morseReceiveNe();
void morseSend(char* message);
unsigned int morseReceive();

#endif

#include "peripheral.h"
#include "font.h"
#include "keyboard.h"
#include "morse.h"

// Display resolution: 800x600

const unsigned int COLOR_WHITE = 0xFFF;
const unsigned int COLOR_DARK_GRAY = 0x888;
const unsigned int COLOR_GRAY = 0xCCC;
const unsigned int COLOR_BLUE = 0x0FF;
const unsigned int COLOR_LIME = 0x0F0;
const unsigned int COLOR_RED = 0xF00;
const unsigned int COLOR_DARK_RED = 0x800;
const unsigned int COLOR_DARK_GREEN = 0x080;
const unsigned int COLOR_BLACK = 0x000;

const int HISTORY_LENGTH = 21;

const int NUM_BAUDS = 20;
const unsigned int BAUD_VALS[20] = {20,50,100,200,500,1000,2000,5000,10000,20000,50000,100000,200000,500000,1000000,2000000,5000000,10000000,20000000,50000000};
const char BAUD_STRINGS[20][8] = {"2500000","1000000","500000","250000","100000","50000","25000","10000","5000","2500","1000","500","250","100","50","25","10","5","2.5","1"};

unsigned int lastParityError = 1;
unsigned int lastFrameError = 1;
unsigned int lastTransmission = 1;
unsigned int lastRecv = 1;

unsigned int key_code;
unsigned int cdc = 1;
int Deb = 0;
unsigned int Loop = 0;
unsigned int Inv = 0;
unsigned int Sound = 0;
unsigned int Rxe = 0;
int Baud = 16;
unsigned int LRx = 0;

int cursor = 0;
int msgLen = 0;

int rxptr = 0;

int hptr = 0;
int hsize = 0;

int lrxhptr = -1;

char* sendBuff = (char*) stack;
char* recBuff = ((char*) stack)+82;
char* historyBuff = ((char*) stack)+164;

void setup();
void DrawSplash();
void updateKeyboard();
void updateMorse();
void cursorMove(int dir);
void updateGui();
void updateLowerGui();
void enter();
void backspace();
void delete();
void addToHistory(char* string,char source);
void renderHistory();
void renderMessage(int ind, int pos);

int main(void)
{
    setup();

    while (1)
    {
        updateKeyboard();
        updateMorse();
    	updateGui();
    }
    return 0;
}

void setup()
{
    keyboardSetCDC(cdc);
    keyboardSetDEB(Deb);
    gpuStart();
    gpuSetCursor(0);

    gpuFillRect_c(0, 0, 799, 599, COLOR_WHITE);

    DrawSplash();

    // Wait for splash screen dismisal
    while (keyboardRead() != KEY_CODE_RETURN){};

    // Draw UI
    gpuFillRect_c(0, 0, 799, 599, COLOR_WHITE);

    gpuFillRect_c(0, 0, 799, 23, COLOR_DARK_GRAY);
    gpuFillRect_c(0, 544, 799, 599, COLOR_DARK_GRAY);
    gpuFillRect_c(4, 548, 651, 563, COLOR_WHITE);

    drawStringAligned("Chat:", 1, 1, COLOR_BLACK);
    drawStringAligned("Parity error: X Frame error: X Transmission in progress: X Receiving data: X", 22, 1, COLOR_BLACK);
    drawStringAligned("ENTER to send", 84, 69, COLOR_BLACK);
    drawStringAligned(" F1:   F2:- F3:+    F4:    F5:     F6:     F7:     F8:- F9:+    F10:", 1, 72, COLOR_BLACK);
    drawStringAligned("CDC X   Deb 000   Loop X  Inv X  Sound X  Rxe X  Baud      10  LRx X", 1, 73, COLOR_BLACK);

    updateLowerGui();
    cursorMove(-100);

    drawIconOpt(768, 568, COLOR_BLACK, ICON_ETF, 0);
    AL(704, 568, 0, 1);
}

void DrawSplash()
{
    const unsigned int xpos = 208;
    const unsigned int ypos = 104;
    const unsigned int xsize = 384;
    const unsigned int ysize = 270;
    const unsigned int endx = xpos + xsize - 1;
    const unsigned int endy = ypos + ysize - 1;
    gpuDrawRect_c(xpos - 3, ypos - 3, endx + 3, endy + 3, COLOR_DARK_GRAY);
    gpuDrawRect_c(xpos - 2, ypos - 2, endx + 2, endy + 2, COLOR_DARK_GRAY);
    gpuDrawRect_c(xpos - 1, ypos - 1, endx + 1, endy + 1, COLOR_DARK_GRAY);
    gpuFillRect_c(xpos, ypos, endx, endy, COLOR_GRAY);
    AL(272, 104, 2, 4);
    drawIconOpt(endx - 32, endy - 32, COLOR_BLACK, ICON_ETF, 0);

    drawStringAligned("Arilla VLSI edition", 36, 30, COLOR_BLACK);
    drawStringAligned("Morse Chat V2", 36, 31, COLOR_BLACK);
    drawStringAligned("Projekat iz Racunarskih VLSI sistema.", 36, 33, COLOR_BLACK);
    drawStringAligned("Aleksa Markovic     2019/0248", 36, 35, COLOR_BLACK);
    drawStringAligned("Lazar Premovic      2019/0091", 36, 36, COLOR_BLACK);
    drawStringAligned("Luka Simic          2019/0368", 36, 37, COLOR_BLACK);
    drawStringAligned("Aleksandar Ivanovic 2013/0010", 36, 38, COLOR_BLACK);
    drawStringAligned("Pritisnite ENTER da biste nastavili.", 26, 40, COLOR_BLACK);
    drawStringAligned("ETF Beograd, Januar 2023.", 36, 44, COLOR_BLACK);
}

void updateKeyboard()
{
	key_code = keyboardRead();
	if(key_code!=0)
	{
		if(key_code < 128)
		{
			if(msgLen<80)
			{
				if(cursor == msgLen)
				{
					sendBuff[msgLen++] = (char)key_code;
					drawCharacterAligned(key_code, msgLen, 69, COLOR_BLACK);
				}
				else
				{
					msgLen++;
					for(int i = msgLen-1; i > cursor; i--)
					{
						sendBuff[i] = sendBuff[i-1];
						gpuFillRect_c(i*8+8, 552, i*8+15, 559, COLOR_WHITE);
						drawCharacterAligned(sendBuff[i], i+1, 69, COLOR_BLACK);
					}
					sendBuff[cursor] = key_code;
					gpuFillRect_c(cursor*8+8, 552, cursor*8+15, 559, COLOR_WHITE);
					drawCharacterAligned(sendBuff[cursor], cursor+1, 69, COLOR_BLACK);
				}
				cursorMove(1);
			}
		}
		else
		{
			switch(key_code)
			{

			case KEY_CODE_F1: {cdc = !cdc; keyboardSetCDC(cdc); updateLowerGui(); break;}
			case KEY_CODE_F2: {Deb--; if(Deb<0){Deb = 0;}  keyboardSetDEB(Deb); updateLowerGui(); break;}
			case KEY_CODE_F3: {Deb++; if(Deb>31){Deb = 31;} keyboardSetDEB(Deb); updateLowerGui(); break;}
			case KEY_CODE_F4: {Loop = !Loop; morseSetLoop(Loop); updateLowerGui(); break;}
			case KEY_CODE_F5: {Inv = !Inv; morseSetInv(Inv); updateLowerGui(); break;}
			case KEY_CODE_F6: {Sound = !Sound; morseSetSound(Sound); updateLowerGui(); break;}
			case KEY_CODE_F7: {Rxe = !Rxe; morseSetRx(Rxe); updateLowerGui(); break;}
			case KEY_CODE_F8: {Baud++; if(Baud>=NUM_BAUDS){Baud=NUM_BAUDS-1;} morseSetBaud(BAUD_VALS[Baud]); updateLowerGui(); break;}
			case KEY_CODE_F9: {Baud--; if(Baud<0){Baud=0;} morseSetBaud(BAUD_VALS[Baud]); updateLowerGui(); break;}
			case KEY_CODE_F10: {LRx = !LRx; updateLowerGui(); break;}
			case KEY_CODE_F11: {break;}
			case KEY_CODE_F12: {break;}
			case KEY_CODE_RETURN: {enter(); break;}
			case KEY_CODE_BACKSPACE: {backspace(); break;}
			case KEY_CODE_DELETE: {delete(); break;}
			case KEY_CODE_HOME: {cursorMove(-100); break;}
			case KEY_CODE_END: {cursorMove(100); break;}
			case KEY_CODE_INSERT: {break;}
			case KEY_CODE_LEFT: {cursorMove(-1); break;}
			case KEY_CODE_RIGHT: {cursorMove(1); break;}
			}
		}
	}
}

void updateMorse()
{
	morseReadStatus();
	unsigned int c = morseReceive();
	if (c!=0)
	{
		if(!LRx)
		{
			if(c!=ETX)
			{
				recBuff[rxptr++]=c;
			}
			else if(rxptr > 0)
			{
				recBuff[rxptr]='\0';
				addToHistory(recBuff, -((char)rxptr));
				rxptr=0;
			}
		}
		else
		{
			if(lrxhptr<0)
			{
				lrxhptr = hptr;
				hptr++;
				if(hptr>=HISTORY_LENGTH)
				{
					hptr = 0;
				}
				if(hsize<HISTORY_LENGTH)
				{
					hsize++;
				}
				else
				{
					renderHistory();
				}
				historyBuff[lrxhptr*82]=0;
				historyBuff[lrxhptr*82+1]='\0';
			}
			int pos;
			if(hsize<HISTORY_LENGTH)
			{
				pos = lrxhptr;
			}
			else
			{
				pos = lrxhptr - hptr;
				if(pos<0)
				{
					pos+=HISTORY_LENGTH;
				}
			}
			if(c!=ETX)
			{
				historyBuff[lrxhptr*82+1+rxptr++]=c;
				historyBuff[lrxhptr*82+1+rxptr]='\0';
				historyBuff[lrxhptr*82]--;
				renderMessage(lrxhptr, pos);
			}
			else if(rxptr > 0)
			{
				rxptr=0;
				lrxhptr=-1;
			}
		}
	}
}

void cursorMove(int dir)
{
	if(cursor<80)
	{
		gpuDrawLine_c(cursor*8+8, 559, cursor*8+15, 559, COLOR_WHITE);
	}
	cursor+=dir;
	if(cursor<0){cursor = 0;}
	if(cursor>msgLen){cursor = msgLen;}
	if(cursor<80)
	{
		gpuDrawLine_c(cursor*8+8, 559, cursor*8+15, 559, COLOR_BLACK);
	}
}

void updateGui()
{
	if(lastParityError != keyboardPerr())
	{
		lastParityError = !lastParityError;
		gpuFillRect_c(288, 8, 295, 15, lastParityError?COLOR_RED:COLOR_DARK_RED);
	}
	if(lastFrameError != keyboardFerr())
	{
		lastFrameError = !lastFrameError;
		gpuFillRect_c(408, 8, 415, 15, lastFrameError?COLOR_RED:COLOR_DARK_RED);
	}
	if(lastTransmission != morseInProgress())
	{
		lastTransmission = !lastTransmission;
		gpuFillRect_c(632, 8, 639, 15, lastTransmission?COLOR_LIME:COLOR_DARK_GREEN);
	}
	if(morseReceiveNe())
	{
		lastRecv = 4096;
	}
	if(lastRecv > 0)
	{
		lastRecv--;
	}
	gpuFillRect_c(776, 8, 783, 15, lastRecv?COLOR_LIME:COLOR_DARK_GREEN);
}

void updateLowerGui()
{
	gpuFillRect_c( 40, 584,  47, 591, cdc ? COLOR_LIME : COLOR_RED);
	gpuFillRect_c(192, 584, 199, 591, Loop ? COLOR_LIME : COLOR_RED);
	gpuFillRect_c(248, 584, 255, 591, Inv ? COLOR_LIME : COLOR_RED);
	gpuFillRect_c(320, 584, 327, 591, Sound ? COLOR_LIME : COLOR_RED);
	gpuFillRect_c(376, 584, 383, 591, Rxe ? COLOR_LIME : COLOR_RED);
	gpuFillRect_c(544, 584, 551, 591, LRx ? COLOR_LIME : COLOR_RED);
	gpuFillRect_c(104, 584, 127, 591, COLOR_DARK_GRAY);
	gpuFillRect_c(440, 584, 495, 591, COLOR_DARK_GRAY);
	drawCharacterAligned(Deb >= 30 ? '3' : Deb >= 20 ? '2' : Deb >= 10 ? '1' : '0', 14, 73, COLOR_BLACK);
	drawCharacterAligned(Deb >= 30 ? '0' + Deb - 30 : Deb >= 20 ? '0' + Deb - 20 : Deb >= 10 ? '0' + Deb - 10 : '0' + Deb, 15, 73, COLOR_BLACK);
	drawStringAligned(BAUD_STRINGS[Baud], 55, 73, COLOR_BLACK);
}

void enter()
{
	if(msgLen>0 && !morseInProgress())
	{
		sendBuff[msgLen] = '\0';
		if(sendBuff[0] == 'Q' && sendBuff[1] == 'U' && sendBuff[2] == 'A' && sendBuff[3] == 'C' && sendBuff[4] == 'K' && sendBuff[5] == '\0')
		{
			morseSetSample(1);
		}
		if(sendBuff[0] == 'K' && sendBuff[1] == 'C' && sendBuff[2] == 'A' && sendBuff[3] == 'U' && sendBuff[4] == 'Q' && sendBuff[5] == '\0')
		{
			morseSetSample(0);
		}
		morseSend(sendBuff);
		addToHistory(sendBuff, ((char)msgLen));
		gpuFillRect_c(4, 548, 651, 563, COLOR_WHITE);
		msgLen = 0;
		cursorMove(-100);
	}
}

void backspace()
{
	if(cursor!=0)
	{
		cursorMove(-1);
		delete();
	}
}

void delete()
{
	if(cursor!=msgLen)
	{
		gpuFillRect_c(msgLen*8, 552, msgLen*8+8, 559, COLOR_WHITE);
		for(int i = cursor; i < msgLen-1;i++)
		{
			sendBuff[i] = sendBuff[i+1];
			gpuFillRect_c(i*8+8, 552, i*8+15, 559, COLOR_WHITE);
			drawCharacterAligned(sendBuff[i], i+1, 69, COLOR_BLACK);
		}
		msgLen--;
		cursorMove(0);
	}
}

void addToHistory(char* string, char source)
{
	unsigned int i;
	historyBuff[hptr*82] = source;
	for (i = 0; string[i] != '\0'; i++)
	{
		historyBuff[hptr*82+i+1] = string[i];
	}
	historyBuff[hptr*82+i+1] = string[i];
	hptr++;
	if(hptr>=HISTORY_LENGTH)
	{
		hptr = 0;
	}
	if(hsize<HISTORY_LENGTH)
	{
		hsize++;
	}
	renderHistory();
}


void renderHistory()
{
	if(hsize<HISTORY_LENGTH)
	{
		renderMessage(hsize-1,hsize-1);
	}
	else
	{
		unsigned int startindex = hptr;
		for(int i = 0;i<hsize;i++)
		{
			renderMessage(startindex,i);
			startindex++;
			if(startindex==HISTORY_LENGTH){startindex=0;}
		}
	}

}

void renderMessage(int ind,int pos)
{
	gpuFillRect_c(0, (pos+1)*24, 799, (pos+2)*24, COLOR_WHITE);
	if(((signed char)historyBuff[ind*82])>0)
	{
		gpuFillRect_c(796-((historyBuff[ind*82]+1)*8), pos*24+28, 795, pos*24+44, COLOR_BLUE);
		drawStringAligned(historyBuff+ind*82+1, 99-historyBuff[ind*82], pos*3+4, COLOR_BLACK);
	}
	else
	{
		gpuFillRect_c(4, pos*24+28,4+(-((signed char)historyBuff[ind*82])+1)*8, pos*24+44, COLOR_LIME);
		drawStringAligned(historyBuff+ind*82+1, 1, pos*3+4, COLOR_BLACK);
	}
}

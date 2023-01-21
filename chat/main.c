#define EEG
// TODO Final version should be aggressively inlined and thus merged into single file, lets keep it separated for now
// TODO Final version should be optimized for memory and variable sizes, lets do that after we get it working
#include "peripheral.h"
#include "font.h"
#include "keyboard.h"
#include "morse.h"

// Display resolution: 800x600

const unsigned int COLOR_WHITE = 0xFFF;
const unsigned int COLOR_GRAY = 0xCCC;
const unsigned int COLOR_DARK_GRAY = 0x888;
const unsigned int COLOR_BLACK = 0x000;

const unsigned int MESSAGE_BOX_Y = 600 - 32;
const unsigned int HISTORY_Y = 24;

void setup();
void DrawSplash();

#define LINE_LENGTH 80
#define HISTORY_LENGTH 68
#define LINE_LENGTH_WITH_USERNAME 120
char currentMessage[LINE_LENGTH + 1];
char receivedMessage[LINE_LENGTH + 1];
char allMessages[HISTORY_LENGTH][LINE_LENGTH_WITH_USERNAME];
unsigned int messageCursor = 0;
unsigned int historyCursor = 0;
const char *USERNAME_YOU = "You";
const char *USERNAME_THEY = "They";

int addMessageToHistory(char* message, const char *username)
{
    if (historyCursor == HISTORY_LENGTH - 1)
    {
        for (int messageIndex = 1; messageIndex < HISTORY_LENGTH; ++messageIndex)
        {
            for (int charIndex = 0; charIndex < LINE_LENGTH; ++charIndex)
            {
                allMessages[messageIndex - 1][charIndex] = allMessages[messageIndex][charIndex];
            }
        }
        return 1;
    }
    allMessages[historyCursor][0] = '[';
    int charIndex;
    for (charIndex = 0; username[charIndex] != '\0'; ++charIndex)
    {
        allMessages[historyCursor][charIndex + 1] = username[charIndex];
    }
    allMessages[historyCursor][++charIndex] = ']';
    allMessages[historyCursor][++charIndex] = ' ';
    int prefixLength = charIndex + 1;
    for (charIndex = 0; charIndex < LINE_LENGTH; ++charIndex)
    {
        allMessages[historyCursor][charIndex + prefixLength] = message[charIndex];
        message[charIndex] = '\0';
    }
    messageCursor = 0;
    if (historyCursor != HISTORY_LENGTH - 1)
    {
        ++historyCursor;
    }
    return 0;
}

void renderHistory(char* message, const char *username)
{
    if (addMessageToHistory(message, username))
    {
        gpuFillRect_c(0, HISTORY_Y, 799, MESSAGE_BOX_Y - 1, COLOR_WHITE);
        for (int messageIndex = 0; messageIndex < HISTORY_LENGTH; ++messageIndex)
        {
            for (int charIndex = 0; charIndex < LINE_LENGTH_WITH_USERNAME; ++charIndex)
            {
                char printableChar = allMessages[messageIndex][charIndex];
                if (printableChar == 0)
                {
                    break;
                }
                drawCharacterAligned(printableChar, charIndex, 3 + messageIndex, COLOR_BLACK);
            }
        }
    }
    else
    {
        for (int charIndex = 0; charIndex < LINE_LENGTH_WITH_USERNAME; ++charIndex)
        {
            char printableChar = allMessages[historyCursor - 1][charIndex];
            if (printableChar == 0)
            {
                break;
            }
            drawCharacterAligned(printableChar, charIndex, 2 + historyCursor, COLOR_BLACK);
        }
    }
}

void updateKeyboard(void)
{
    keyboardRead();
    unsigned int readChar = keyboardGetChar();
    if (readChar != 0 && (readChar & 0xFF00) != 0xF000)
    {
        char printableChar = keyboardAscii();
        unsigned charX = messageCursor * 8 + 8;
        unsigned charY = MESSAGE_BOX_Y + 8;
        unsigned endCharX = charX + 7;
        unsigned endCharY = charY + 8;
        if (printableChar != 0 && messageCursor < LINE_LENGTH)
        {
            gpuDrawLine_c(charX, endCharY, endCharX, endCharY, COLOR_WHITE);
            currentMessage[messageCursor] = printableChar;
            drawCharacterAligned(printableChar, charX >> 3, charY >> 3, COLOR_BLACK);
            ++messageCursor;
            charX += 8;
            endCharX += 8;
            if (messageCursor != LINE_LENGTH)
            {
                gpuDrawLine_c(charX, endCharY, endCharX, endCharY, COLOR_BLACK);
            }
        }
        else if (readChar == KEY_CODE_BACKSPACE && messageCursor != 0)
        {
            currentMessage[--messageCursor] = 0;
            charX -= 8;
            endCharX -= 8;
            gpuFillRect_c(charX, charY, charX + 15, endCharY, COLOR_WHITE);
            gpuDrawLine_c(charX, endCharY, endCharX, endCharY, COLOR_BLACK);
        }
        else if (readChar == KEY_CODE_ENTER)
        {
            gpuFillRect_c(1, MESSAGE_BOX_Y + 1, LINE_LENGTH * 8 + 15, 598, COLOR_WHITE);
            gpuDrawLine_c(8, MESSAGE_BOX_Y + 16, 17, MESSAGE_BOX_Y + 16, COLOR_BLACK);
            morseSend(currentMessage);
            renderHistory(currentMessage, USERNAME_YOU);
        }
    }
}

void updateMorse(void)
{
    if (morseReceive(receivedMessage))
    {
        renderHistory(receivedMessage, USERNAME_THEY);
    }
}

int main(void)
{
    setup();

    while (1)
    {
        updateKeyboard();
        updateMorse();
    }
    return 0;
}

void setup()
{
    keyboardSetCDC(1);
    keyboardSetDEB(1);
    gpuStart();
    gpuSetCursor(0);

    gpuFillRect_c(0, 0, 799, 599, COLOR_WHITE);

    // DrawSplash();

    // Wait for splash screen dismisal
    do
    {
        keyboardRead();
    } while (keyboardGetChar() != KEY_CODE_ENTER);

    // Draw UI
    gpuFillRect_c(0, 0, 799, 599, COLOR_WHITE);
    gpuFillRect_c(0, 2, 799, 21, COLOR_DARK_GRAY);
    gpuFillRect_c(LINE_LENGTH * 8 + 16, MESSAGE_BOX_Y, 799, 599, COLOR_DARK_GRAY);
    gpuDrawRect_c(0, MESSAGE_BOX_Y, LINE_LENGTH * 8 + 16, 599, COLOR_BLACK);
    drawStringAligned("Chat:", 5, 1, COLOR_BLACK);

    drawIconOpt(768, MESSAGE_BOX_Y, COLOR_BLACK, ICON_ETF, 0);
    AL(704, 568, 0, 1);

    for (int i = 0; i < LINE_LENGTH + 1; i++)
    {
        currentMessage[i] = '\0';
    }

    gpuDrawLine_c(8, MESSAGE_BOX_Y + 16, 17, MESSAGE_BOX_Y + 16, COLOR_BLACK);
}

void DrawSplash()
{
    unsigned int xpos = 208;
    unsigned int ypos = 104;
    unsigned int xsize = 384;
    unsigned int ysize = 270;
    unsigned int endx = xpos + xsize - 1;
    unsigned int endy = ypos + ysize - 1;
    gpuDrawRect_c(xpos - 3, ypos - 3, endx + 3, endy + 3, COLOR_DARK_GRAY);
    gpuDrawRect_c(xpos - 2, ypos - 2, endx + 2, endy + 2, COLOR_DARK_GRAY);
    gpuDrawRect_c(xpos - 1, ypos - 1, endx + 1, endy + 1, COLOR_DARK_GRAY);
    gpuFillRect_c(xpos, ypos, endx, endy, COLOR_GRAY);
    AL(272, 104, 2, 4);
    drawIconOpt(endx - 32, endy - 32, COLOR_BLACK, ICON_ETF, 0);

    drawStringAligned("Arilla VLSI edition", 36, 30, COLOR_BLACK);
    drawStringAligned("Morse Chat V1", 36, 31, COLOR_BLACK);
    drawStringAligned("Projekat iz Racunarskih VLSI sistema.", 36, 33, COLOR_BLACK);
    drawStringAligned("Aleksa Markovic     2019/0248", 36, 35, COLOR_BLACK);
    drawStringAligned("Lazar Premovic      2019/0091", 36, 36, COLOR_BLACK);
    drawStringAligned("Luka Simic          2019/0368", 36, 37, COLOR_BLACK);
    drawStringAligned("Aleksandar Ivanovic 2013/0010", 36, 38, COLOR_BLACK);
    drawStringAligned("Pritisnite ENTER da biste nastavili.", 26, 40, COLOR_BLACK);
    drawStringAligned("ETF Beograd, Januar 2023.", 36, 44, COLOR_BLACK);
}

#ifndef PAINT_TEST
void _start()
{
    main();
}
#endif

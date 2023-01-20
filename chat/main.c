#define EEG
#define TEXT
//TODO Final version should be aggressively inlined and thus merged into single file, lets keep it separated for now
//TODO Final version should be optimized for memory and variable sizes, lets do that after we get it working
#include "peripheral.h"
#include "font.h"
#include "keyboard.h"

//Display resolution: 800x600

const unsigned int COLOR_WHITE=0xFFF;
const unsigned int COLOR_GRAY=0xCCC;
const unsigned int COLOR_DARK_GRAY=0x888;
const unsigned int COLOR_BLACK=0x000;

const unsigned int UI_START_Y=600-32;

void setup();
void DrawSplash();

char txb[81];
unsigned int line = 0;
unsigned int cursor = 0;

unsigned int rxcursor = 0;
unsigned int rxline = 0;

int main()
{
    setup();

    while (1)
    {
        keyboardRead();
        if(keyboardGetChar()!=0 && (keyboardGetChar() & 0xFF00)!= 0xF000)
        {
            if(keyboardAscii()!=0)
            {
                gpuDrawLine_c(cursor*8,31+line*8,cursor*8+7,31+line*8,COLOR_WHITE);
                txb[cursor]=keyboardAscii();
                drawCharacterAligned(keyboardAscii(),cursor++,line+3,COLOR_BLACK);
                gpuDrawLine_c(cursor*8,31+line*8,cursor*8+7,31+line*8,COLOR_BLACK);
            }
        }
        /*mouseRead();
        struct point p=mousePos();
        if(mouseChanged())
        {
            //Mouse Move
            if(track){
                //Mouse moved while using pen
                if(p.y>=(600-64)){p.y=600-64-1;}
                unsigned int dx=p.x>startPoint.x?p.x-startPoint.x:startPoint.x-p.x;
                unsigned int dy=p.y>startPoint.y?p.y-startPoint.y:startPoint.y-p.y;
                if(dx<2 && dy<2)
                {
                    gpuDrawPoint(p.x,p.y);
                }
                else
                {
                    gpuDrawLine(startPoint.x,startPoint.y,p.x,p.y);
                }
                startPoint=p;
            }
            if(colortrack)
            {
                int colorindex=(p.x>>5)-2;
                if(colorindex < 0){colorindex =0;}
                if(colorindex >15){colorindex = 15;}
                updateColor(channel,colorindex,0);
            }
        }
        if(mouseLDown() && !lastMouse)
        {
            //Mouse Press
            if(p.y<(600-64))
            {
                ui=0;
                if(selectedTool!= 2)
                {
                    if(selectedTool == 0)
                    {
                        track=1;
                        gpuDrawPoint(p.x,p.y);
                    }
                    startPoint=p;
                }
            }
            else
            {
                ui=1;
                #ifdef EEG
                if(p.x>800-32)
                {
                    ui=2;
                }
                #endif
                if(p.x>=64 && p.x<576)
                {
                    int colorindex=(p.x>>5)-2;
                    if(p.y>=UI_START_Y+2 && p.y<UI_START_Y+22)        {colortrack=1;channel=8;updateColor(channel,colorindex,1);}
                    else if(p.y>=UI_START_Y+22 && p.y<UI_START_Y+42)  {colortrack=1;channel=4;updateColor(channel,colorindex,1);}
                    else if(p.y>=UI_START_Y+42 && p.y<UI_START_Y+62)  {colortrack=1;channel=0;updateColor(channel,colorindex,1);}
                }
            }
        }
        if(!mouseLDown() && lastMouse)
        {
            //Mouse Release
            track = 0;
            if(colortrack)
            {
                int colorindex=(p.x>>5)-2;
                if(colorindex < 0){colorindex =0;}
                if(colorindex >15){colorindex = 15;}
                updateColor(channel,colorindex,2);
            }
            colortrack=0;
            if(p.y<(600-64) && !ui)
            {
                switch (selectedTool)
                {
                    case 3:{ gpuDrawLine(startPoint.x,startPoint.y,p.x,p.y); break;}
                    case 1:{ gpuDrawRect(startPoint.x,startPoint.y,p.x,p.y); break;}
                    case 4:{ gpuFillRect(startPoint.x,startPoint.y,p.x,p.y); break;}
                    case 2:{
                        #ifdef EEG
                        untouched=0;
                        #endif
                        floodFill(p.x,p.y,selectedColor);
                        break;}
                    default :{break;}
                }
            }
            else if(p.y>=(600-64) && ui)
            {
                unsigned int ind = p.x>>5;
                if(ind < 2)
                {
                    //Current Color
                    #ifdef EEG
                    if(ui==2 && untouched)
                    {
                        EE();
                    }
                    #endif
                }
                else if(ind < 18)
                {
                }
                else if(ind <21)
                {
                    //Tool Picker
                    ind-=18;
                    ind+=(p.y>=600-32?3:0); //Are we in the second row

                    if(ind==5) //Clear screen cant really be selected
                    {
                        gpuFillRect_c(0,0,799,UI_START_Y-1,COLOR_WHITE);
                        gpuSetColor(selectedColor);
                    }
                    else
                    {
                        selectedTool=ind;
                        #ifdef TEXT
                        if(selectedTool!=4)
                        {
                            gpuFillRect_c(680, UI_START_Y+8, 799, UI_START_Y+23, COLOR_DARK_GRAY);
                            drawStringAligned(toolnames[selectedTool], 85, UI_START_Y/8 + 1, COLOR_BLACK);
                            gpuSetColor(selectedColor);
                        }
                        else
                        {
                            gpuFillRect_c(680, UI_START_Y+8, 799, UI_START_Y+23, COLOR_DARK_GRAY);
                            drawStringAligned(toolnames[selectedTool], 85, UI_START_Y/8 + 1, COLOR_BLACK);
                            drawStringAligned(toolnames[selectedTool+1], 85, UI_START_Y/8 + 2, COLOR_BLACK);
                            gpuSetColor(selectedColor);
                        }
                        #endif
                    }

                }
            }
        }
        lastMouse=mouseLDown();*/
    }
    return 0;
}

void setup()
{
    keyboardSetCDC(1);
    keyboardSetDEB(1);
    gpuStart();
    gpuSetCursor(0);

    gpuFillRect_c(0,0,799,599,COLOR_WHITE);

    //DrawSplash();

    //Wait for splash screen dismisal
    do { keyboardRead(); } while (keyboardGetChar()!=KEY_CODE_ENTER);

    //Draw UI
    gpuFillRect_c(0,0,799,599,COLOR_WHITE);
    gpuFillRect_c(0,2,799,21,COLOR_DARK_GRAY);
    gpuFillRect_c(0,268,799,285,COLOR_DARK_GRAY);
    gpuFillRect_c(0,UI_START_Y,799,599,COLOR_DARK_GRAY);
    drawStringAligned("Transmit:", 5, 1, COLOR_BLACK);
    drawStringAligned("Recieve:", 5, 34, COLOR_BLACK);

    drawIconOpt(768,UI_START_Y,COLOR_BLACK,ICON_ETF,0);
    AL(704,568,0,1);

    for(int i =0;i<81;i++)
    {
        txb[i]='\0';
    }

    gpuDrawLine_c(cursor*8,31+line*8,cursor*8+7,31+line*8,COLOR_BLACK);
}

void DrawSplash()
{
    unsigned int xpos=208;
    unsigned int ypos=104;
    unsigned int xsize=384;
    unsigned int ysize=270;
    unsigned int endx=xpos+xsize-1;
    unsigned int endy=ypos+ysize-1;
    gpuDrawRect_c(xpos-3,ypos-3,endx+3,endy+3,COLOR_DARK_GRAY);
    gpuDrawRect_c(xpos-2,ypos-2,endx+2,endy+2,COLOR_DARK_GRAY);
    gpuDrawRect_c(xpos-1,ypos-1,endx+1,endy+1,COLOR_DARK_GRAY);
    gpuFillRect_c(xpos,ypos,endx,endy,COLOR_GRAY);
    AL(272,104,2,4);
    drawIconOpt(endx-32,endy-32,COLOR_BLACK,ICON_ETF,0);

    #ifdef TEXT
    drawStringAligned("arilla VLSI edition", 36, 30, COLOR_BLACK);
    drawStringAligned("Chat V1", 36, 31, COLOR_BLACK);
    drawStringAligned("Projekat iz Racunarskih VLSI sistema.", 36, 33, COLOR_BLACK);
    drawStringAligned("Aleksa Markovic     2019/0248", 36, 35, COLOR_BLACK);
    drawStringAligned("Lazar Premovic      2019/0091", 36, 36, COLOR_BLACK);
    drawStringAligned("Luka Simic          2019/0368", 36, 37, COLOR_BLACK);
    drawStringAligned("Aleksandar Ivanovic GGGG/BBBB", 36, 38, COLOR_BLACK);
    drawStringAligned("Pritisnite ENTER da biste nastavili.", 26, 40, COLOR_BLACK);
    drawStringAligned("ETF Beograd, Januar 2023.", 36, 44, COLOR_BLACK);
    #endif

}

void _start() {
    main();
}

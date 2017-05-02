.386
.model flat, stdcall
option casemap:none

include .\include\GameSdk.inc

.data

PIC_PNG          BYTE "img/WorldMap.png", 0
MUS_BGM          BYTE "res/audio/bgm/CampFire.wav", 0
Cusor_SE         BYTE "res/audio/se/Cursor1.wav", 0
Confirm_SE       BYTE "res/audio/se/Cursor2.wav", 0
Font_gloria      BYTE "Fonts/GloriaHallelujah.ttf", 0
gFont            DWORD ?
gMusic           DWORD ?
SE_Cusor         DWORD ?
SE_Confirm       DWORD ?

OptionTexture   Texture 2 DUP ({?, ?, ?})
S_GAMESTART      BYTE "New Game", 0
S_GAMEEXIT       BYTE "Exit", 0
.code
MediaLoader PROC gRender:DWORD
     
MediaLoader ENDP  
end
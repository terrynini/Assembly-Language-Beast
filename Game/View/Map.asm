.386
.model flat, stdcall
option casemap:none

include .\include\GameSdk.inc

extern CurrentKeystate:DWORD
extern SE_Cusor:DWORD
extern SE_Confirm:DWORD
extern gRender:DWORD
extern BackgroundTexture:Texture
extern Camera:SDL_Rect

.data

Grass   SDL_Rect {0, 0, 48, 48}
Outside_A2       BYTE "res/img/tilesets/Outside_A2.png", 0
SS_Outside_A2    Texture {?, ?, ?}

.code

Map_Init PROC
    invoke  TextureLoader,addr SS_Outside_A2, addr Outside_A2, gRender
Map_Init ENDP

Map_Render PROC
    LOCAL   tloop:DWORD
    LOCAL   jloop:DWORD
    LOCAL   Xmin:SDWORD
    LOCAL   Xmax:SDWORD
    LOCAL   Ymin:SDWORD
    LOCAL   Ymax:SDWORD
    mov     tloop, 0
    mov     jloop, 0
    mov     eax, Camera.X
    sub     eax, 48
    mov     Xmin, eax
    add     eax, 48
    add     eax, SCREEN_WIDTH
    mov     Xmax, eax
    mov     eax, Camera.Y
    sub     eax, 48
    mov     Ymin, eax
    add     eax, 48
    add     eax, SCREEN_HEIGHT
    mov     Ymax, eax

    .WHILE  tloop < 4800
        .WHILE  jloop < 4800
            mov     eax, tloop
            mov     ebx, jloop
            .IF (eax > Xmin) && (eax < Xmax) && (ebx > Ymin) && (ebx < Ymax)
                sub     eax, Camera.X 
                sub     ebx, Camera.Y 
                invoke  Texturerender, eax, ebx, SS_Outside_A2, gRender,addr Grass
            .ENDIF
            add     jloop, 48
        .ENDW
        mov     jloop, 0
        add     tloop, 48
    .ENDW 

    ret
Map_Render ENDP
end
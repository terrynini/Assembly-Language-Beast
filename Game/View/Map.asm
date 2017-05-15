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

Grass           SDL_Rect {0, 0, 48, 48}
Outside_A2      BYTE "res/img/tilesets/Outside_A2.png", 0
SS_Outside_A2   Texture {?, ?, ?}

Map_arr         BYTE 10000 DUP( 0 )
Rooms           SDL_Rect 50 DUP ({?, ?, ?, ?})

.code

Map_Init PROC
    push    ebp
    mov     ebp, esp
    
    invoke  TextureLoader,addr SS_Outside_A2, addr Outside_A2, gRender
    push    0
    call    time
    push    eax
    call    srand

    leave
    ret
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

    ;push    255
    ;push    0
    ;push    0
    ;push    255
    ;push    gRender
    ;call    SDL_SetRenderDrawColor
    ;mov     esi, offset Rooms
    ;.WHILE tloop < 50
    ;    push    gRender
    ;    push    esi 
    ;    call    SDL_RenderFillRect
    ;    add     esi, TYPE Rooms
    ;    add     tloop, 1
    ;.ENDW
    ;push    255
    ;push    255
    ;push    255
    ;push    255
    ;push    gRender
    ;call    SDL_SetRenderDrawColor
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

GenerateMaze PROC
   
GenerateMaze ENDP
end
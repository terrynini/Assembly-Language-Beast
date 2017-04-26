;gcc Main.obj -IC:\MinGW\include\SDL2 -LC:\MinGW\lib -w -Wl,-subsystem,windows -lmingw32 -lSDL2main -lSDL2 -lSDL2_image -lSDL2_ttf 
.386
.model flat, stdcall
option casemap:none

include ..\include\GameSdk.inc

SCREEN_WIDTH            equ 816d    
SCREEN_HEIGHT           equ 624d


.data
Caption          BYTE "YOURCRAFT X-D", 0
PIC_PNG          BYTE "img/WorldMap.png", 0
rb               BYTE "rb", 0
Font_gloria      BYTE "Fonts/GloriaHallelujah.ttf", 0
Literal_one      BYTE "1", 0
S_GAMESTART      BYTE "The quick brown fox jumps over the lazy dog", 0
gWindow          DWORD ?
gScreenSurface   DWORD ?
gKeyPressSurface DWORD 5 DUP(?)
TEXT_BackGround  DWORD ?
gRender          DWORD ?
gFont            DWORD ?
TEXT_GAME        Texture {?, ?, ?}
SDL_HINT_RENDER_SCALE_QUALITY  BYTE "SDL_HINT_RENDER_SCALE_QUALITY", 0

.code

SDL_main PROC
    ;LOCAL will do the prologue & !!!!epilogue!!!! for you
    LOCAL   event[56]:BYTE
    LOCAL   quit:BYTE
    LOCAL   gCurrentSurface:DWORD
    LOCAL   gPNGSurface:DWORD
    ;init
    mov     quit, 0
    call    GameInit
    ;LoadMedia
    call    LoadMedia
    call    LoadTexture
    mov     TEXT_BackGround, eax
    ;this is the game loop
    .WHILE !quit
        PollLoop:
            lea     eax, event
            push    eax
            call    SDL_PollEvent
            test    eax, eax    ;test if eax equ 0
            setne   al          ;if eax equ zero, set al 
            test    al, al      ;test if al has been set or not
            je      Render    ;if al has been set, break loop
            mov     eax, DWORD ptr event  
            ;if event == SDL_QUIT, then quit = true
            cmp     eax, SDL_QUIT
            sete    quit
        NextEvent:                  
            jmp     PollLoop    ;go back to deal with next event
        Render:
            ;SDL_RenderClear
            push    gRender
            call    SDL_RenderClear
            ;SDL_RenderCopy
            push    0
            push    0
            push    TEXT_BackGround
            push    gRender
            call    SDL_RenderCopy
            ;render text
            call    Texturerender
            ;SDL_RenderPresent
            push    gRender
            call    SDL_RenderPresent
    .ENDW
    ;GameExit
    call    GameExit
    ret
SDL_main ENDP

GameInit PROC
    push    ebp
    mov     ebp, esp
    ;SDL_Init
    push    SDL_INIT_VIDEO
    call    SDL_Init
    ;SDL_SetHint
    push    offset Literal_one
    push    offset SDL_HINT_RENDER_SCALE_QUALITY
    call    SDL_SetHint
    ;SDL_CreateWindow
    push    SDL_WINDOW_SHOWN
    push    SCREEN_HEIGHT
    push    SCREEN_WIDTH
    push    SDL_WINDOWPOS_UNDEFINED
    push    SDL_WINDOWPOS_UNDEFINED
    push    OFFSET Caption
    call    SDL_CreateWindow
    mov     gWindow, eax
    ;SDL_CreateRenderer
    mov     eax, SDL_RENDERER_ACCELERATED
    or      eax, SDL_RENDERER_PRESENTVSYNC
    push    eax
    push    -1
    push    gWindow
    call    SDL_CreateRenderer
    mov     gRender, eax
    ;SDL_SetRenderDrawColor
    push    0ffh
    push    0ffh
    push    0ffh
    push    0ffh
    push    gRender
    call    SDL_SetRenderDrawColor
    ;IMG_Init
    push    IMG_INIT_PNG
    call    IMG_Init
    ;TTF_Init
    call    TTF_Init

    leave
    ret
GameInit ENDP

GameExit PROC
    ;SDL_DestroyTexture
    push    TEXT_BackGround
    call    SDL_DestroyTexture
    ;SDL_FreeSurface
    push    gKeyPressSurface
    call    SDL_FreeSurface
    mov     gKeyPressSurface, 0
    ;SDL_DestroyWindow
    push    gWindow
    call    SDL_DestroyWindow
    mov     gWindow, 0
    ;SDL_Quit
    call    IMG_Quit
    call    SDL_Quit
    ret
GameExit ENDP

LoadTexture PROC    ;return in eax
    LOCAL   loadedSurface:DWORD
    push    OFFSET PIC_PNG
    call    IMG_Load
    push    eax
    push    gRender
    call    SDL_CreateTextureFromSurface
    ret
LoadTexture ENDP

LoadMedia PROC
    LOCAL   color:SDL_Color
    LOCAL   textSurface:DWORD
    mov     color.R, 0
    mov     color.G, 0
    mov     color.B, 0
    ;TTF_OpenFont
    push    28d
    push    offset Font_gloria
    call    TTF_OpenFont
    mov     gFont, eax
    ;loadFromRenderedText
    lea     eax, color
    push    eax
    ;;?????????????????????????????????????????????????
    push    offset S_GAMESTART
    push    gFont
    call    TTF_RenderText_Solid
    mov     textSurface, eax
    ;SDL_CreateTextureFromSurface
    push    textSurface
    push    gRender
    call    SDL_CreateTextureFromSurface
    mov     TEXT_GAME.mTexture, eax
    mov     eax, textSurface
    mov     edx,  [eax + 8]
    mov     TEXT_GAME.mWidth, edx
    mov     edx, [eax + 0ch]
    mov     TEXT_GAME.mHeight, edx
    ret
LoadMedia ENDP 

Texturerender PROC
    LOCAL renderQuad:SDL_Rect
    LOCAL point:SDL_Point
    mov     eax, SCREEN_WIDTH
    sub     eax, TEXT_GAME.mWidth
    shr     eax, 2
    mov     renderQuad.X, eax
    mov     eax, SCREEN_HEIGHT
    sub     eax, TEXT_GAME.mHeight
    shr     eax, 2
    mov     renderQuad.Y, eax
    mov     eax, TEXT_GAME.mWidth
    mov     renderQuad.W, eax
    mov     eax, TEXT_GAME.mHeight
    mov     renderQuad.H, eax
    ;SDL_RenderCopyEx
    push    SDL_FLIP_NONE
    lea     eax, point
    push    eax 
    push    0
    push    0
    lea     eax, renderQuad
    push    eax
    push    0
    push    TEXT_GAME.mTexture
    push    gRender
    call    SDL_RenderCopyEx
    ret
Texturerender ENDP

end
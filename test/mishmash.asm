;gcc Main.obj -IC:\MinGW\include\SDL2 -LC:\MinGW\lib -w -Wl,-subsystem,windows -lmingw32 -lSDL2main -lSDL2 -lSDL2_image -lSDL2_ttf 
.386
.model flat, stdcall
option casemap:none

include ..\include\GameSdk.inc

extern SDL_Init:near
extern SDL_CreateWindow:near
extern SDL_DestroyWindow:near
extern SDL_Quit:near
extern SDL_PollEvent:near
extern SDL_RWFromFile:near
extern SDL_LoadBMP_RW:near
extern SDL_GetWindowSurface:near
extern SDL_UpperBlit:near
extern SDL_UpdateWindowSurface:near
extern SDL_FreeSurface:near
extern SDL_Delay:near
extern IMG_Init:near
extern IMG_Load:near
extern SDL_SetHint:near
extern SDL_CreateRenderer:near
extern SDL_SetRenderDrawColor:near
extern SDL_CreateTextureFromSurface:near
extern SDL_RenderClear:near
extern SDL_RenderCopy:near
extern SDL_RenderPresent:near
extern IMG_Quit:near
extern SDL_DestroyTexture:near
extern TTF_Init:near
extern TTF_OpenFont:near
extern TTF_RenderText_Solid:near

Loadimg   proto :DWORD, :DWORD 

SCREEN_WIDTH            equ 816d    
SCREEN_HEIGHT           equ 624d

.data
Caption          BYTE "YOURCRAFT X-D", 0
PIC_DE           BYTE "press.bmp", 0
PIC_U            BYTE "up.bmp", 0
PIC_D            BYTE "down.bmp", 0
PIC_R            BYTE "right.bmp", 0
PIC_L            BYTE "left.bmp", 0
PIC_PNG          BYTE "img/WorldMap.png", 0
rb               BYTE "rb", 0
Literal_one      BYTE "1", 0
gWindow          DWORD ?
gScreenSurface   DWORD ?
gKeyPressSurface DWORD 5 DUP(?)
Texturepoint     DWORD ?
gRender          DWORD ?
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
    ;load iamge
    call    LoadMedia
    call    LoadTexture
    mov     Texturepoint, eax
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
            ;if event == SDL_KEYDOWN
            cmp     eax, SDL_KEYDOWN
            jne     NextCon          
            mov     eax, DWORD PTR [event+14h] ;position of SDL_Event.key.keysym.sym
            mov     esi, offset gKeyPressSurface
K_UP:       cmp     eax, SDLK_UP
            jne     K_DOWN
            mov     eax, DWORD PTR [esi + 4]
            mov     gCurrentSurface, eax
            jmp     NextCon
K_DOWN:     cmp     eax, SDLK_DOWN
            jne     K_LEFT
            mov     eax, DWORD PTR [esi + 8 ]
            mov     gCurrentSurface, eax
            jmp     NextCon
K_LEFT:     cmp     eax, SDLK_LEFT
            jne     K_RIGHT
            mov     eax, DWORD PTR [esi + 12d ]
            mov     gCurrentSurface, eax
            jmp     NextCon
K_RIGHT:    cmp     eax, SDLK_RIGHT
            jne     K_DEFAULT
            mov     eax, DWORD PTR [esi + 16d ]
            mov     gCurrentSurface, eax
            jmp     NextCon     
K_DEFAULT:  mov     eax, DWORD PTR [esi]
            mov     gCurrentSurface, eax
NextCon:
        NextEvent:                  
            jmp     PollLoop    ;go back to deal with next event
        Render:
            push    gRender
            call    SDL_RenderClear
            push    0
            push    0
            push    Texturepoint
            push    gRender
            call    SDL_RenderCopy
            push    gRender
            call    SDL_RenderPresent
            ;push    0
            ;push    gScreenSurface
            ;push    0
            ;push    gCurrentSurface
            ;call    SDL_UpperBlit
            ;push    gWindow
            ;call    SDL_UpdateWindowSurface
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
    ;;SDL_GetWindowsurface
    ;push    gWindow
    ;call    SDL_GetWindowSurface
    ;mov     gScreenSurface, eax
    leave
    ret
GameInit ENDP

LoadMedia PROC  
    push    ebp
    mov     ebp, esp
    ;call    LoadFromRenderedText
    ;mov     esi, offset gKeyPressSurface
    ;invoke  Loadimg, offset rb, offset PIC_DE
    ;mov     [esi], eax
    ;add     esi, TYPE gKeyPressSurface
    ;invoke  Loadimg, offset rb, offset PIC_U
    ;mov     [esi], eax
    ;add     esi, TYPE gKeyPressSurface
    ;invoke  Loadimg, offset rb, offset PIC_D
    ;mov     [esi], eax
    ;add     esi, TYPE gKeyPressSurface
    ;invoke  Loadimg, offset rb, offset PIC_L
    ;mov     [esi], eax
    ;add     esi, TYPE gKeyPressSurface
    ;invoke  Loadimg, offset rb, offset PIC_R
    ;mov     [esi], eax
    leave
    ret
LoadMedia ENDP

Loadimg PROC mode:DWORD, path:DWORD ;return in eax
    push    mode
    push    path
    call    SDL_RWFromFile
    push    1
    push    eax
    call    SDL_LoadBMP_RW
    ret
Loadimg ENDP

GameExit PROC
    ;SDL_DestroyTexture
    push    Texturepoint
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

end
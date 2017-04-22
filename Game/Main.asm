;gcc  -IC:\MinGW\include\SDL2 -LC:\MinGW\lib -w -Wl,-subsystem,windows -lmingw32 -lSDL2main -lSDL2
.386
.model flat, C 
option casemap:none

include ..\include\GameSdk.inc

extern SDL_Init:near
extern SDL_CreateWindow:proto
extern SDL_DestroyWindow:near
extern SDL_Quit:near
extern ExitProcess :PROC

SDL_WINDOW_SHOWN        equ 4h
SDL_WINDOWPOS_UNDEFINED equ 1fff0000h
SCREEN_WIDTH            equ 640d    
SCREEN_HEIGHT           equ 480d
SDL_INIT_VIDEO          equ 20h

.data

String BYTE "FUCK yeah", 0

.code
SDL_main PROC
    push    ebp
    mov     ebp, esp
    call    GameInit
    ;SDL_DestroyWindow
    mov     eax, DWORD PTR [ebp-12d]
    call    SDL_DestroyWindow
    ;SDL_Quit
    call    SDL_Quit
SDL_main ENDP

GameInit PROC
    push    ebp
    mov     ebp, esp
    ;SDL_Init
    push    SDL_INIT_VIDEO
    call    SDL_Init
    ;SDL_CreateWindow
    push    SDL_WINDOW_SHOWN
    push    SCREEN_HEIGHT
    push    SCREEN_WIDTH
    push    SDL_WINDOWPOS_UNDEFINED
    push    SDL_WINDOWPOS_UNDEFINED
    push    OFFSET String
    call    SDL_CreateWindow
    leave
    ret
GameInit ENDP
end 


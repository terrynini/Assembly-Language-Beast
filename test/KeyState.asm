;gcc Main.obj -IC:\MinGW\include\SDL2 -LC:\MinGW\lib -w -Wl,-subsystem,windows -lmingw32 -lSDL2main -lSDL2 -lSDL2_image -lSDL2_ttf 
.386
.model flat, stdcall
option casemap:none

include ..\include\GameSdk.inc

TextureLoader proto :ptr DWORD 
FontLoader    proto :ptr DWORD

SCREEN_WIDTH            equ 816d    
SCREEN_HEIGHT           equ 624d

.data
Caption          BYTE "YOURCRAFT X-D", 0
PIC_PNG          BYTE "img/WorldMap.png", 0
Font_gloria      BYTE "Fonts/GloriaHallelujah.ttf", 0
S_GAMESTART      BYTE "New Game", 0
S_key            BYTE "UP   DOWN LEFT RIGHT", 0
Literal_one      BYTE "1", 0
gWindow          DWORD ?
Background_text  DWORD ?
gRender          DWORD ?
CurrentKeystate  DWORD ?  
gFont            DWORD ?
TEXT_GAME        Texture {?, ?, ?}

SDL_HINT_RENDER_SCALE_QUALITY  BYTE "SDL_HINT_RENDER_SCALE_QUALITY", 0

.code
SDL_main PROC
    ;LOCAL will do the prologue & !!!!epilogue!!!! for you
    LOCAL   event[56]:BYTE
    LOCAL   quit:BYTE
    ;init
    mov     quit, 0
    call    GameInit
    ;load iamge
    call    LoadMedia
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
            ;SDL_GetKeyboardState
            push    0
            call    SDL_GetKeyboardState
            mov     CurrentKeystate, eax
            ;test for keyboard state
            mov     esi, CurrentKeystate
            add     esi, SDL_SCANCODE_UP
            .IF     BYTE ptr [esi]>0
                invoke  FontLoader, addr S_key
            .ELSEIF BYTE ptr [esi-1]>0
                invoke  FontLoader, addr [S_key+5]
            .ELSEIF BYTE ptr [esi-2]>0
                invoke  FontLoader, addr [S_key+10]
            .ELSEIF BYTE ptr [esi-3]>0
                invoke  FontLoader, addr [S_key+15]
            .ELSE
                invoke  FontLoader, addr S_GAMESTART
            .ENDIF
        NextEvent:                  
            jmp     PollLoop    ;go back to deal with next event
        Render:
            call    GameRender
    .ENDW
    ;GameExit
    call    GameExit
    ret
SDL_main ENDP

LoadMedia PROC
    invoke  TextureLoader, addr PIC_PNG
    mov     Background_text, eax
    ;invoke  FontLoader, addr S_GAMESTART
    ret
LoadMedia ENDP

FontLoader PROC TextField: ptr DWORD
    LOCAL   color:SDL_Color
    LOCAL   textSurface:DWORD
    mov     color.R, 255
    mov     color.G, 255
    mov     color.B, 255
    mov     color.A, 0
    ;TTF_OpenFont
    push    28d
    push    offset Font_gloria
    call    TTF_OpenFont
    mov     gFont, eax
    ;loadFromRenderedText
    push    color
    push    TextField
    push    gFont
    call    TTF_RenderText_Blended
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
FontLoader ENDP 

TextureLoader PROC fileptr: ptr DWORD   ;return in eax
    LOCAL   loadedSurface:DWORD
    push    fileptr
    call    IMG_Load
    push    eax
    push    gRender
    call    SDL_CreateTextureFromSurface
    ret
TextureLoader ENDP

Texturerender PROC  X:DWORD, Y:DWORD, TEXTURE:Texture
    LOCAL renderQuad:SDL_Rect
    LOCAL point:SDL_Point
    mov     eax, X
    mov     renderQuad.X, eax
    mov     eax, Y
    mov     renderQuad.Y, eax
    mov     eax, TEXTURE.mWidth
    mov     renderQuad.W, eax
    mov     eax, TEXTURE.mHeight
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
    push    TEXTURE.mTexture
    push    gRender
    call    SDL_RenderCopyEx
    ret
Texturerender ENDP

GameRender PROC
    push    ebp
    mov     ebp, esp

     ;SDL_RenderClear
    push    gRender
    call    SDL_RenderClear
    ;SDL_RenderCopy
    push    0
    push    0
    push    Background_text
    push    gRender
    call    SDL_RenderCopy
    ;render text
    invoke  Texturerender, 20, 100, TEXT_GAME
    ;SDL_RenderPresent
    push    gRender
    call    SDL_RenderPresent

    leave
    ret
GameRender ENDP

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
    push    Background_text
    call    SDL_DestroyTexture
    ;SDL_DestroyWindow
    push    gWindow
    call    SDL_DestroyWindow
    mov     gWindow, 0
    ;SDL_Quit
    call    IMG_Quit
    call    SDL_Quit
    ret
GameExit ENDP
end

;mov     al, [esi]
;            .IF     BYTE ptr [esi]>0
;                invoke  FontLoader, addr S_key
;            .ENDIF
;            sub     esi, 1
;            mov     al, [esi]
;            .IF     al>0
;                invoke  FontLoader, addr [S_key+5]
;            .ENDIF
;            sub     esi, 1
;            mov     al, [esi]
;            .IF     al>0
;                invoke  FontLoader, addr [S_key+10]
;            .ENDIF
;            sub     esi, 1
;            mov     al, [esi]
;            .IF     al>0
;                invoke  FontLoader, addr [S_key+15]
;            .ENDIF
.386
.model flat, stdcall
option casemap:none

include .\include\GameSdk.inc

extern CurrentKeystate:DWORD
extern SE_Cusor:DWORD
extern gRender:DWORD
extern gFont:DWORD
extern GameExit:PROC

.data
Currentoption    DWORD 0
Option_CD        BYTE 0

BackgroundTexture   Texture {?, ?, ?}
OptionTexture       Texture 2 DUP ({?, ?, ?})

S_GAMESTART      BYTE "New Game", 0
S_GAMEEXIT       BYTE "Exit", 0
PIC_PNG          BYTE "img/WorldMap.png", 0
.code

StateTitle_Init PROC
    push    ebp
    mov     ebp, esp

    invoke  TextureLoader,addr BackgroundTexture, addr PIC_PNG, gRender
    invoke  FontRender, addr S_GAMESTART, addr OptionTexture, gFont, gRender
    invoke  FontRender, addr S_GAMEEXIT, addr [OptionTexture + TYPE OptionTexture], gFont, gRender
    ;init option image
    push    180
    push    OptionTexture.mTexture
    call    SDL_SetTextureAlphaMod

    leave
    ret
StateTitle_Init ENDP

StateTitle_TickTock PROC
    push    ebp
    mov     ebp, esp
    .IF     Option_CD < 30
        add     Option_CD, 1
    .ENDIF
    mov     esi, CurrentKeystate
    .IF     Option_CD > 10 && (BYTE ptr [esi + SDL_SCANCODE_UP]>0 || BYTE ptr [esi + SDL_SCANCODE_DOWN]>0)
        invoke  MusicPlayer, SE_Cusor, AUDIO_WAV
        mov     edi, offset OptionTexture
        push    60
        add     edi, Currentoption
        push    [edi].Texture.mTexture
        call    SDL_SetTextureAlphaMod
        xor     Currentoption, TYPE OptionTexture
        mov     edi, offset OptionTexture
        push    180
        add     edi, Currentoption
        push    [edi].Texture.mTexture
        call    SDL_SetTextureAlphaMod
        mov     Option_CD, 0
    .ELSEIF BYTE ptr [esi + SDL_SCANCODE_SPACE]>0
        invoke  MusicPlayer, SE_Cusor, AUDIO_WAV
        .IF     Currentoption == 0
            call    Mix_PauseMusic
            invoke  SetState, STATE_GAME
        .ELSE
            call    GameExit    
        .ENDIF
    .ENDIF
    leave
    ret
StateTitle_TickTock ENDP

StateTitle_Render PROC
    push    ebp
    mov     ebp, esp

    ;SDL_RenderCopy
    push    0
    push    0
    push    BackgroundTexture.mTexture
    push    gRender
    call    SDL_RenderCopy
    ;render text
    invoke  Texturerender, 20, 100, OptionTexture, gRender, 0
    invoke  Texturerender, 20, 150, [OptionTexture + TYPE OptionTexture], gRender, 0

    leave
    ret
StateTitle_Render ENDP

end
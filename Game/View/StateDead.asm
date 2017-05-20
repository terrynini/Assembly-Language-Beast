.386
.model flat, stdcall
option casemap:none

include .\include\GameSdk.inc

extern CurrentKeystate:DWORD
extern gRender:DWORD
public SE_HAHA
.data
GameOver    BYTE "res/img/system/GameOver.png", 0
GameOverTexture Texture {}

HAHA_SE     BYTE "res/audio/se/Applause2.wav", 0
SE_HAHA     DWORD ?
.code

StateDead_Init  PROC
    push    ebp
    mov     ebp, esp
    invoke  MusicLoader, addr SE_HAHA,addr HAHA_SE, AUDIO_WAV
    invoke  TextureLoader, addr GameOverTexture, addr GameOver, gRender
    push    0
    push    GameOverTexture.mTexture
    call    SDL_SetTextureAlphaMod
    leave
    ret
StateDead_Init  ENDP

StateDead_TickTock PROC
    push    ebp
    mov     ebp, esp

    leave
    ret
StateDead_TickTock ENDP

StateDead_Render   PROC
    call    StateGame_Render
    invoke  Texturerender, 0, 0, GameOverTexture, gRender, 0
    ret
StateDead_Render   ENDP

end
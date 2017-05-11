.386
.model flat, stdcall
option casemap:none

include .\include\GameSdk.inc

extern CurrentKeystate:DWORD

.data
BackPack_CD BYTE 0
Open_SE     BYTE "res/audio/se/Equip2.wav", 0
SE_OpenBP   DWORD ?
.code

StateGame_Init PROC
    push    ebp
    mov     ebp, esp
    invoke  MusicLoader, addr SE_OpenBP, addr Open_SE, AUDIO_WAV
    leave
    ret
StateGame_Init ENDP

StateGame_TickTock PROC
    push    ebp
    mov     ebp, esp

    call    CreatureController_TickTock
    .IF     BackPack_CD < 30
        add     BackPack_CD, 1 
    .ENDIF
    mov     esi, CurrentKeystate
    .IF     BackPack_CD > 20 && BYTE ptr [esi + SDL_SCANCODE_B]>0
        invoke  MusicPlayer, SE_OpenBP, AUDIO_WAV
        invoke  SetState, STATE_BACKPACK
        mov     BackPack_CD, 0
    .ENDIF

    leave
    ret
StateGame_TickTock ENDP
    
StateGame_Render PROC
    push    ebp
    mov     ebp, esp

    call    Map_Render
    call    CreatureController_Render
    call    StatusBar_Render
    leave
    ret
StateGame_Render ENDP
end
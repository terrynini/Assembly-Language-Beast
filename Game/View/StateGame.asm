.386
.model flat, stdcall
option casemap:none

include .\include\GameSdk.inc

extern CurrentKeystate:DWORD

.data

.code
StateGame_TickTock PROC
    push    ebp
    mov     ebp, esp

    mov     esi, CurrentKeystate
    call    CreatureController_TickTock
    .IF     BYTE ptr [esi + SDL_SCANCODE_B]>0
        invoke  SetState, STATE_BACKPACK
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
.386
.model flat, stdcall
option casemap:none

include .\include\GameSdk.inc

.data

CurrentState    DWORD   STATE_TITLE

.code

State_Init PROC
    call    StatusBar_Init
    ret
State_Init ENDP

SetState PROC State:DWORD
    mov     eax, State
    mov     CurrentState, eax
    ret
SetState ENDP

StateTickTock PROC
    push    ebp
    mov     ebp, esp

    .IF CurrentState == STATE_TITLE
        call    StateTitle_TickTock
    .ELSEIF CurrentState == STATE_GAME
        call    StateGame_TickTock
    .ENDIF

    leave
    ret
StateTickTock ENDP

StateRender PROC
    push    ebp
    mov     ebp, esp

    .IF CurrentState == STATE_TITLE
        call    StateTitle_Render
    .ELSEIF CurrentState == STATE_GAME
        call    StateGame_Render
    .ENDIF

    leave
    ret
StateRender ENDP
end


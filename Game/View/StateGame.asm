.386
.model flat, stdcall
option casemap:none

include .\include\GameSdk.inc


.data

.code
StateGame_TickTock PROC
    push    ebp
    mov     ebp, esp
    call    CreatureController_TickTock
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
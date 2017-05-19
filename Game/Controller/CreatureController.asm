.386
.model flat, stdcall
option casemap:none

include .\include\GameSdk.inc

.data

.code
CreatureController_Init PROC
    push    ebp
    mov     ebp, esp

    call    Monsters_Init
    call    MainCharactor_Init
    
    leave
    ret
CreatureController_Init ENDP

CreatureController_TickTock PROC
    push    ebp
    mov     ebp, esp

    call    Monsters_TickTock
    call    MainCharactor_TickTock

    leave
    ret
CreatureController_TickTock ENDP

CreatureController_Render PROC
    push    ebp
    mov     ebp, esp

    call    Monsters_Render
    call    MainCharactor_Render

    leave
    ret
CreatureController_Render ENDP


end
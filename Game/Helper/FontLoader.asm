.386
.model flat, stdcall
option casemap:none

include .\include\GameSdk.inc

.data

.code

FontLoader PROC ttfFileptr:ptr BYTE, FontPtr:ptr DWORD
    ;TTF_OpenFont
    push    28d
    push    ttfFileptr
    call    TTF_OpenFont
    mov     esi, FontPtr
    mov     [esi], eax

    ret
FontLoader ENDP
end
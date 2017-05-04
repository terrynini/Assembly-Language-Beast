.386
.model flat, stdcall
option casemap:none

include .\include\GameSdk.inc

extern gRender:DWORD

.data
Status_Face     BYTE "res\img\faces\Main_Charactor.png", 0
Texture_Face    Texture {?, ?, ?}

.code

StatusBar_Init PROC
    push    ebp
    mov     ebp, esp
    invoke  TextureLoader,addr Texture_Face, addr Status_Face, gRender
    leave
    ret
StatusBar_Init ENDP

StatusBar_Render PROC
    push    ebp
    mov     ebp, esp
    invoke  Texturerender, 10, 10, Texture_Face, gRender, 0
    leave
    ret
StatusBar_Render ENDP
end
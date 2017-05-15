.386
.model flat, stdcall
option casemap:none

include .\include\GameSdk.inc

extern gRender:DWORD
extern Player_Main:Player

.data
Status_Face     BYTE "res\img\faces\Main_Charactor.png", 0
S_Gradient      BYTE "res\img\system\gradients.png", 0

Texture_Face        Texture {?, ?, ?}
Texture_Gradient    Texture {?, ?, ?}

Clip_HP         SDL_Rect  {0, 0, 175, 16}
Clip_MANA       SDL_Rect  {0, 16, 175, 16}

S_HMAX          BYTE "0000000000", 0
S_HCUR          BYTE "0000000000", 0
S_MMAX          BYTE "0000000000", 0
S_MCUR          BYTE "0000000000", 0

.code

StatusBar_Init PROC
    push    ebp
    mov     ebp, esp
    invoke  TextureLoader,addr Texture_Face, addr Status_Face, gRender
    invoke  TextureLoader,addr Texture_Gradient, addr S_Gradient, gRender
    leave
    ret
StatusBar_Init ENDP

StatusBar_TickTock PROC
    push    ebp
    mov     ebp, esp
    
    mov     esi, offset S_HMAX
    mov     eax, Player_Main.Health_Max

    leave
    ret
StatusBar_TickTock ENDP

StatusBar_Render PROC
    push    ebp
    mov     ebp, esp
    invoke  Texturerender, 129, 62, Texture_Gradient, gRender, addr Clip_HP
    invoke  Texturerender, 128, 81, Texture_Gradient, gRender, addr Clip_MANA
    invoke  Texturerender, 10, 10, Texture_Face, gRender, 0
    leave
    ret
StatusBar_Render ENDP
end
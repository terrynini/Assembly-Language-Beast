.386
.model flat, stdcall
option casemap:none

include .\include\GameSdk.inc

Step        equ 8
AniFrame    equ 8
extern gRender:DWORD
extern CurrentKeystate:DWORD
extern Camera:SDL_Rect
extern SS_SideBar:Texture

.data
MonsterSet      BYTE    "res/img/characters/Monster.png", 0

Monster_count   DWORD   0
MonsterA        Monster {}
Monster_array   Monster 100 DUP({})
.code

Monsters_Init PROC
    push    ebp
    mov     ebp, esp
    ;Init position
    mov     MonsterA.Father.X, 400
    mov     MonsterA.Father.Y, 400
    ;Load the Sprite sheet 
    invoke  TextureLoader, addr MonsterA.Father.texture, addr MonsterSet, gRender
    ;Init Clip for Player_one, row first
    mov     eax, 192
    mov     ebx, 288
    mov     esi, offset MonsterA.Father.Clip
    .WHILE  eax < 384
        .WHILE  ebx < 432
            mov     [esi].SDL_Rect.X, ebx
            mov     [esi].SDL_Rect.Y, eax
            add     ebx, 48
            add     esi, TYPE SDL_Rect
        .ENDW
        xor     ebx, ebx
        add     eax, 48
    .ENDW

    leave
    ret
Monsters_Init ENDP

Monsters_TickTock PROC

Monsters_TickTock ENDP

Monsters_Render PROC
    push    ebp
    mov     ebp, esp

    xor     edx, edx
    mov     eax, MonsterA.Father.AniCount
    mov     ebx, AniFrame
    div     ebx
    mov     ebx, 16
    mul     ebx
    .IF MonsterA.Father.AniCount == AniFrame*12
        mov MonsterA.Father.AniCount, 0
    .ENDIF

    mov     ebx, MonsterA.Father.X
    sub     ebx, Camera.X
    mov     ecx, MonsterA.Father.Y
    sub     ecx, Camera.Y
    invoke  Texturerender, ebx, ecx \
            , MonsterA.Father.texture, gRender, addr MonsterA.Father.Clip[eax]
    
    leave
    ret
Monsters_Render ENDP

end
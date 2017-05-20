.386
.model flat, stdcall
option casemap:none

include .\include\GameSdk.inc

Step                            equ 6
AniFrame                        equ 2

extern gRender:DWORD
extern Camera:SDL_Rect
extern Player_Main:Player

public SkillStack
public Skill_now
public Skill_Main
public Main_Casting

.data
SkillStack Skill 100 DUP({})
Skill_now  DWORD 0

Skill_Main  Skill {}
Skill_Enemy Skill {}

Darkness2       BYTE "res/img/animations/ClawSpecial1.png", 0
Main_SE         BYTE "res/audio/se/Wind5.wav", 0
SE_Main         DWORD ?

Main_Casting DWORD 0

Main_Halt   DWORD 0
.code

Skill_Init PROC
    push    ebp
    mov     ebp, esp

    ;Load the Sprite sheet 
    invoke  TextureLoader, addr Skill_Main.Father.texture, addr Darkness2, gRender
    ;Init Clip for Player_one, row first
    xor     eax, eax
    xor     ebx, ebx
    mov     esi, offset Skill_Main.Father.Clip
    .WHILE  eax < 960
        .WHILE  ebx < 960
            mov     [esi].SDL_Rect.X, ebx
            mov     [esi].SDL_Rect.Y, eax
            mov     [esi].SDL_Rect.W, 192
            mov     [esi].SDL_Rect.H, 192
            add     ebx, 192
            add     esi, TYPE SDL_Rect
        .ENDW
        xor     ebx, ebx
        add     eax, 192
    .ENDW

    ;Init BoundBox
    mov     Skill_Main.Father.BoundBox.X, 40
    mov     Skill_Main.Father.BoundBox.Y, 56
    mov     Skill_Main.Father.BoundBox.W, 192-40*2
    mov     Skill_Main.Father.BoundBox.H, 192-56*2
    mov     Skill_Main.Cost, 40
    mov     Skill_Main.Father.AniCount, 0

     invoke  MusicLoader, addr SE_Main, addr Main_SE, AUDIO_WAV

    leave
    ret
Skill_Init ENDP

Skill_TickTock PROC

    .IF Main_Casting == 1 && Main_Halt == 0
       add      Skill_Main.Father.AniCount, 1
       call     C_Monster_Damage
    .ELSE
        mov     Main_Halt,  0
        mov     ebx, Player_Main.Father.Position.X
        mov     Skill_Main.Father.Position.X, ebx
        mov     ecx, Player_Main.Father.Position.Y
        mov     Skill_Main.Father.Position.Y, ecx
        ;
        .IF     Player_Main.Face == 0
            sub     Skill_Main.Father.Position.Y, 48+(192/2)
            sub     Skill_Main.Father.Position.X, 192/2 - 24 
        .ELSEIF Player_Main.Face == 2
            sub     Skill_Main.Father.Position.X, 192/2 - 24
        .ELSEIF Player_Main.Face == 1
            sub     Skill_Main.Father.Position.Y, (192/2) - 24
            add     Skill_Main.Father.Position.X, 24
        .ELSEIF Player_Main.Face == 3
            sub     Skill_Main.Father.Position.X, 192 - 48 
            sub     Skill_Main.Father.Position.Y, (192/2) - 24
        .ENDIF
    .ENDIF
    ret
Skill_TickTock ENDP

Skill_Render PROC
    .IF Main_Casting == 1
        xor     edx, edx
        mov     eax, Skill_Main.Father.AniCount
        mov     ebx, AniFrame
        div     ebx
        mov     ebx, 16
        mul     ebx
        .IF Skill_Main.Father.AniCount == AniFrame*19
            mov     Skill_Main.Father.AniCount, 0
            mov     Main_Casting, 0
            mov     Main_Halt, 1
        .ENDIF
        mov     ebx, Skill_Main.Father.Position.X
        sub     ebx, Camera.X
        mov     ecx, Skill_Main.Father.Position.Y
        sub     ecx, Camera.Y
        invoke  Texturerender, ebx, ecx, Skill_Main.Father.texture, gRender, addr Skill_Main.Father.Clip[eax]
    .ENDIF

    ret
Skill_Render ENDP

Skill_Stack PROC AttackType:DWORD
    mov     eax, Skill_Main.Cost
    .IF     Player_Main.Mana_Now >= eax
        .IF     Main_Casting == 0
            invoke  MusicPlayer, SE_Main, AUDIO_WAV
            mov     eax, Skill_Main.Cost
            sub     Player_Main.Mana_Now, eax
        .ENDIF
        mov     Main_Casting, 1
    .ENDIF
    ret
Skill_Stack ENDP
end
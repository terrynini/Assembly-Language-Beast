.386
.model flat, stdcall
option casemap:none

include .\include\GameSdk.inc

Step                            equ 6
AniFrame                        equ 2

extern gRender:DWORD
extern Camera:SDL_Rect
extern Player_Main:Player
extern Monster_array:Monster
extern Monster_count:DWORD

public SkillStack
public Skill_count
public Skill_Main
public Skill_Enemy
public Main_Casting

.data
SkillStack Skill 100 DUP({})
Skill_count DWORD 0

Skill_Main  Skill {}
Skill_Enemy Skill {}

ClawSpecial1    BYTE "res/img/animations/ClawSpecial1.png", 0
Curse           BYTE "res/img/animations/Curse.png", 0
Main_SE         BYTE "res/audio/se/Wind5.wav", 0
Enemy_SE        BYTE "res/audio/se/Collapse3.wav",0
SE_Main         DWORD ?
SE_Enemy        DWORD ?

Main_Casting DWORD 0

Main_Halt   DWORD 0
.code

Skill_Init PROC
    push    ebp
    mov     ebp, esp

    ;Load the Sprite sheet 
    invoke  TextureLoader, addr Skill_Main.Father.texture, addr ClawSpecial1, gRender
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
    mov     Skill_Main.Cost, 100
    mov     Skill_Main.Father.AniCount, 0

    invoke  TextureLoader, addr Skill_Enemy.Father.texture, addr Curse, gRender
    ;Init Clip for Monster, row first
    xor     eax, eax
    xor     ebx, ebx
    mov     esi, offset Skill_Enemy.Father.Clip
    .WHILE  eax < 768
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
    
    mov     Skill_Enemy.Father.AniCount, 0

    invoke  MusicLoader, addr SE_Main, addr Main_SE, AUDIO_WAV
    invoke  MusicLoader, addr SE_Enemy, addr Enemy_SE, AUDIO_WAV
    leave
    ret
Skill_Init ENDP

Skill_TickTock PROC
    LOCAL   Scounter:DWORD
    LOCAL   Mloop:DWORD
    LOCAL   SID:DWORD

    mov     edi, offset SkillStack
    mov     eax, Skill_count
    mov     Scounter, eax
    
    .WHILE  Scounter != 0
        mov     esi, edi
        .IF [esi].Skill.Father.AniCount == 4*20;AniFrame*20
            mov     eax, [esi].Skill.ID
            mov     SID, eax
            ;search which monster cast this skill
            mov     esi, offset Monster_array
            mov     eax, Monster_count
            mov     Mloop, eax

            .WHILE     Mloop > 0
                mov     eax, SID
                .IF     [esi].Monster.ID == eax
                    mov     [esi].Monster.Casting, 0
                .ENDIF
                add     esi, TYPE Monster_array
                dec     Mloop
            .ENDW

            mov     esi, edi
            mov     [esi].Skill.Father.AniCount, 0
            push    esi
            call    C_Monster_CD

        .ELSE
            .IF     Player_Main.Health_Now > 0
                sub     Player_Main.Health_Now, 1
            .ENDIF
            add     [esi].Skill.Father.AniCount, 1
        .ENDIF
        add     edi, TYPE SkillStack
        dec     Scounter
    .ENDW

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
    LOCAL   Scounter:DWORD
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
    
    mov     edi, offset SkillStack
    mov     eax, Skill_count
    mov     Scounter, eax
    
    .WHILE  Scounter != 0
        mov     esi, edi
    
        xor     edx, edx
        mov     eax, [esi].Skill.Father.AniCount
        mov     ebx, 4;AniFrame
        div     ebx
        mov     ebx, 16
        mul     ebx
        mov     ebx, Player_Main.Father.Position.X
        sub     ebx, Camera.X
        sub     ebx, 192/2 - 24
        mov     ecx, Player_Main.Father.Position.Y
        sub     ecx, Camera.Y
        sub     ecx, 192/2 + 24
        invoke  Texturerender, ebx, ecx, Skill_Enemy.Father.texture, gRender, addr Skill_Enemy.Father.Clip[eax]
    
        add     edi, TYPE SkillStack
        dec     Scounter
    .ENDW
    ret
Skill_Render ENDP

Skill_Stack PROC AttackType:DWORD
    .IF AttackType == PLAYER_ATTACK
        mov     eax, Skill_Main.Cost
        .IF     Player_Main.Mana_Now >= eax
            .IF     Main_Casting == 0
                invoke  MusicPlayer, SE_Main, AUDIO_WAV
                mov     eax, Skill_Main.Cost
                sub     Player_Main.Mana_Now, eax
            .ENDIF
            mov     Main_Casting, 1
        .ENDIF
    .ELSE
        invoke  MusicPlayer, SE_Enemy, AUDIO_WAV
        push    AttackType
        call    C_SkillStack
    .ENDIF
    ret
Skill_Stack ENDP
end
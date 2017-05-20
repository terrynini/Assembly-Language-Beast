.386
.model flat, stdcall
option casemap:none

include .\include\GameSdk.inc
Step                            equ 4
AniFrame                        equ 8

extern gRender:DWORD
extern CurrentKeystate:DWORD
extern Camera:SDL_Rect
extern SS_SideBar:Texture
extern Main_Casting:DWORD
extern gFont_Ration:DWORD

public  Monster_Kinds
public  MonsterKinds
public  Monster_array
public  Monster_count
public  DeadAni
public  DeadClip
.data
MonsterSet      BYTE    "res/img/characters/Monster.png", 0
DeadSet         BYTE    "res/img/animations/StateDark.png", 0
DeadAni         Texture {}
DeadClip        SDL_Rect 20 DUP ({})

Dead_SE         BYTE    "res/audio/se/Monster2.wav", 0
SE_Dead         DWORD ?

MonsterA        Monster {}
Monster_array   Monster 100 DUP({})
Monster_count   DWORD   0
Monster_count_Text BYTE "00", 0
Count_Text_Texture Texture {}
Monster_Kinds   Monster 100  DUP({})
MonsterKinds    DWORD   0

.code

Monsters_Init PROC
    LOCAL   Mloop:SDWORD
    
    call    Monster_Kinds_Init
    push    Max_Monster
    call    C_Monster_Generate
    ;dead se
    invoke  MusicLoader, addr SE_Dead, addr Dead_SE, AUDIO_WAV
    ;load the dead animation
    invoke  TextureLoader, addr DeadAni, addr DeadSet, gRender
    ;init the dead Clip 
    mov     eax, 0;y
    mov     ebx, 0;x
    mov     esi, offset DeadClip
    .WHILE  eax < 768
        .WHILE  ebx < 960
            mov     [esi].SDL_Rect.X, ebx
            mov     [esi].SDL_Rect.Y, eax
            mov     [esi].SDL_Rect.W, 192
            mov     [esi].SDL_Rect.H, 192
            add     ebx, 192
            add     esi, TYPE SDL_Rect
        .ENDW
        mov     ebx, 0
        add     eax, 192
    .ENDW

    mov     edi, offset Monster_array
    mov     eax, Monster_count
    mov     Mloop, eax
    .WHILE  Mloop > 0
    
        invoke  TextureLoader, addr [edi].Monster.Father.texture, addr MonsterSet, gRender

        sub     Mloop, 1
        add     edi, TYPE Monster_array
    .ENDW

    mov     eax, Monster_count
    xor     edx, edx
    mov     ebx, 10
    div     ebx
    add     eax, 48
    add     edx, 48
    mov     Monster_count_Text[0], al
    mov     Monster_count_Text[1], dl
    invoke  FontRender, addr Monster_count_Text, addr Count_Text_Texture, gFont_Ration, gRender, 255

    ret
Monsters_Init ENDP

Monsters_TickTock PROC
    LOCAL   Mloop:SDWORD
    LOCAL   XSpeed:SDWORD
    LOCAL   YSpeed:SDWORD
    mov     edi, offset Monster_array
    mov     eax, Monster_count
    mov     Mloop, eax

    .WHILE  Mloop > 0
        mov     XSpeed, 0
        mov     YSpeed, 0
        
        .IF     [edi].Monster.Health_Now == 0
            mov     [edi].Monster.Father.AniCount, 0
            mov     [edi].Monster.Health_Now, -1
            sub     Mloop, 1
            add     edi, TYPE Monster_array
           invoke  MusicPlayer, SE_Dead, AUDIO_WAV
            .CONTINUE
        .ELSEIF [edi].Monster.Health_Now < 0

            .IF [edi].Monster.Father.AniCount == 2*20;AniFrame*20
                call    C_Monster_Dead
                mov     eax, Monster_count
                xor     edx, edx
                mov     ebx, 10
                div     ebx
                add     eax, 48
                add     edx, 48
                mov     Monster_count_Text[0], al
                mov     Monster_count_Text[1], dl
                invoke  FontRender, addr Monster_count_Text, addr Count_Text_Texture, gFont_Ration, gRender, 255
            .ENDIF

            add     [edi].Monster.Father.AniCount, 1
            sub     Mloop, 1
            add     edi, TYPE Monster_array
            .CONTINUE
        .ENDIF

        .IF     [edi].Monster.WalkCount == 0
            call    rand
            xor     edx, edx
            mov     ebx, UPDATE_MSEC * 2
            div     ebx
            add     edx, UPDATE_MSEC 

            mov     [edi].Monster.WalkCount, edx
            ;Random  direction
            ;X
            call    rand
            xor     edx, edx
            mov     ebx, 3
            div     ebx
            mov     [edi].Monster.WalkX, edx
            ;Y
            call    rand
            xor     edx, edx
            mov     ebx, 3
            div     ebx
            mov     [edi].Monster.WalkY, edx
        .ELSE
            .IF     [edi].Monster.WalkX == 1
                mov     XSpeed, Step
            .ELSEIF [edi].Monster.WalkX == 2
                mov     XSpeed, -Step
            .ENDIF
            
            .IF     [edi].Monster.WalkY == 1
                mov     YSpeed, Step
            .ELSEIF [edi].Monster.WalkY == 2
                mov     YSpeed, -Step
            .ENDIF

            .IF     XSpeed != 0 && YSpeed != 0
                    .IF XSpeed > 0
                        mov     XSpeed, Step*10/12
                    .ELSE
                        mov     XSpeed, Step*10/12
                    .ENDIF
                    .IF YSpeed > 0
                        mov     YSpeed, Step*10/12
                    .ELSE
                        mov     YSpeed, Step*10/12
                    .ENDIF
            .ENDIF
            sub     [edi].Monster.WalkCount, 1
        .ENDIF
        .IF Main_Casting == 0
            push    255
            push    [edi].Monster.Father.texture.mTexture
            call    SDL_SetTextureAlphaMod
        .ENDIF
        push    YSpeed
        push    XSpeed
        push    edi
        call    C_Monster_Move
  
        sub     Mloop, 1
        add     edi, TYPE Monster_array
    .ENDW


    ret
Monsters_TickTock ENDP

Monsters_Render PROC
    LOCAL   Mloop:SDWORD

    mov     edi, offset Monster_array
    mov     eax, Monster_count
    mov     Mloop, eax

    .WHILE  Mloop > 0
        mov     esi, edi


        .IF     [esi].Monster.Health_Now < 0

            xor     edx, edx
            mov     eax, [esi].Monster.Father.AniCount
            mov     ebx, 2
            div     ebx
            mov     ebx, 16
            mul     ebx

            mov     ebx, [esi].Monster.Father.Position.X
            sub     ebx, Camera.X
            sub     ebx, 192/2 - 24
            mov     ecx, [esi].Monster.Father.Position.Y
            sub     ecx, Camera.Y
            sub     ecx, 192/2 - 24
            invoke  Texturerender, ebx, ecx, DeadAni, gRender, addr DeadClip[eax]

        .ELSE
            xor     edx, edx
            mov     eax, [esi].Monster.Father.AniCount
            mov     ebx, AniFrame
            div     ebx
            mov     ebx, 16
            mul     ebx

            .IF [esi].Monster.Father.AniCount == AniFrame*12
                mov [esi].Monster.Father.AniCount, 0
            .ENDIF

            mov     ebx, [esi].Monster.Father.Position.X
            sub     ebx, Camera.X
            mov     ecx, [esi].Monster.Father.Position.Y
            sub     ecx, Camera.Y
            invoke  Texturerender, ebx, ecx, [esi].Monster.Father.texture, gRender, addr [esi].Monster.Father.Clip[eax]
        .ENDIF

        sub     Mloop, 1
        add     edi, TYPE Monster_array
    .ENDW

    invoke      Texturerender, SCREEN_WIDTH - 30, 0, Count_Text_Texture, gRender, 0
    ret
Monsters_Render ENDP

Monster_Kinds_Init PROC
    ;LOCAL   MonsterA:Monster
    push    ebp
    mov     ebp, esp

    ;Monster one
    ;Load the Sprite sheet 
    invoke  TextureLoader, addr MonsterA.Father.texture, addr MonsterSet, gRender
    ;Init Clip for monster, row first
    mov     eax, 192;y
    mov     ebx, 288;x
    mov     esi, offset MonsterA.Father.Clip
    .WHILE  eax < 384
        .WHILE  ebx < 432
            mov     [esi].SDL_Rect.X, ebx
            mov     [esi].SDL_Rect.Y, eax
            add     ebx, 48
            add     esi, TYPE SDL_Rect
        .ENDW
        mov     ebx, 288
        add     eax, 48
    .ENDW
    ;Init Bound
    mov     MonsterA.Father.BoundBox.X, 4
    mov     MonsterA.Father.BoundBox.Y, 10
    mov     MonsterA.Father.BoundBox.W, 42
    mov     MonsterA.Father.BoundBox.H, 36
    ;Add this Monster into Monster_Kind
    mov     esi, offset MonsterA 
    push    esi
    call    C_Add_Monster_Kind

    ;Monster Two
    ;Load the Sprite sheet 
    invoke  TextureLoader, addr MonsterA.Father.texture, addr MonsterSet, gRender
    ;Init Clip for y, row first
    mov     eax, 192
    mov     ebx, 0
    mov     esi, offset MonsterA.Father.Clip
    .WHILE  eax < 384
        .WHILE  ebx < 144
            mov     [esi].SDL_Rect.X, ebx
            mov     [esi].SDL_Rect.Y, eax
            add     ebx, 48
            add     esi, TYPE SDL_Rect
        .ENDW
        xor     ebx, ebx
        add     eax, 48
    .ENDW
    ;Init Bound
    mov     MonsterA.Father.BoundBox.X, 4
    mov     MonsterA.Father.BoundBox.Y, 10
    mov     MonsterA.Father.BoundBox.W, 42
    mov     MonsterA.Father.BoundBox.H, 36
    ;Add this Monster into Monster_Kind
    mov     esi, offset MonsterA 
    push    esi
    call    C_Add_Monster_Kind
    ;Monster three
    ;Load the Sprite sheet 
    invoke  TextureLoader, addr MonsterA.Father.texture, addr MonsterSet, gRender
    ;Init Clip for monster, row first
    mov     eax, 192;y
    mov     ebx, 144;x
    mov     esi, offset MonsterA.Father.Clip
    .WHILE  eax < 384
        .WHILE  ebx < 288
            mov     [esi].SDL_Rect.X, ebx
            mov     [esi].SDL_Rect.Y, eax
            add     ebx, 48
            add     esi, TYPE SDL_Rect
        .ENDW
        mov     ebx, 144
        add     eax, 48
    .ENDW
    ;Init Bound
    mov     MonsterA.Father.BoundBox.X, 4
    mov     MonsterA.Father.BoundBox.Y, 10
    mov     MonsterA.Father.BoundBox.W, 42
    mov     MonsterA.Father.BoundBox.H, 36
    ;Add this Monster into Monster_Kind
    mov     esi, offset MonsterA 
    push    esi
    call    C_Add_Monster_Kind
    leave
    ret
Monster_Kinds_Init ENDP
end
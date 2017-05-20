.386
.model flat, stdcall
option casemap:none

include .\include\GameSdk.inc

Step                            equ 6
AniFrame                        equ 8

extern gRender:DWORD
extern CurrentKeystate:DWORD
extern Camera:SDL_Rect
extern SS_SideBar:Texture
extern Skill_Main:Skill
extern SE_HAHA:DWORD
public Player_Main

Move    proto   :SDWORD, :SDWORD

.data
Actor2      BYTE    "res/img/characters/Actor2.png", 0
Dead_SE     BYTE    "res/audio/se/Battle2.wav", 0
SE_Dead     DWORD   ?
DeadClip    SDL_Rect 10 DUP({})

Deadfile    BYTE    "res/img/animations/Darkness3.png", 0
DeadTexture Texture {}

Player_Main Player  {}
AniDir      SDWORD  1
StartSkill  BYTE    0
.code

MainCharactor_Init PROC
    push    ebp
    mov     ebp, esp
    invoke  MusicLoader, addr SE_Dead, addr Dead_SE, AUDIO_WAV
    ;Init position
    push    offset Player_Main.Father.Position
    call    Map_StartPoint
    ;Init BoundBox
    mov     Player_Main.Father.BoundBox.X, 8
    mov     Player_Main.Father.BoundBox.Y, 10
    mov     Player_Main.Father.BoundBox.W, 32
    mov     Player_Main.Father.BoundBox.H, 36
    mov     eax, 1000
    mov     Player_Main.Health_Max, eax
    mov     Player_Main.Health_Now, eax
    mov     eax, Player_Main.Mana_Max
    mov     Player_Main.Mana_Now, eax
    ;Init Camera position
    mov     eax, Player_Main.Father.Position.X
    mov     Camera.X, eax
    mov     eax, Player_Main.Father.Position.Y
    mov     Camera.Y, eax
    ;Load the Sprite sheet 
    invoke  TextureLoader, addr Player_Main.Father.texture, addr Actor2, gRender
    ;Init Clip for Player_one, row first
    xor     eax, eax
    xor     ebx, ebx
    mov     esi, offset Player_Main.Father.Clip
    .WHILE  eax < 192
        .WHILE  ebx < 144
            mov     [esi].SDL_Rect.X, ebx
            mov     [esi].SDL_Rect.Y, eax
            add     ebx, 48
            add     esi, TYPE SDL_Rect
        .ENDW
        xor     ebx, ebx
        add     eax, 48
    .ENDW
    ;
    invoke  TextureLoader, addr DeadTexture, addr Deadfile, gRender
    ;init the dead Clip 
    mov     eax, 0;y
    mov     ebx, 0;x
    mov     esi, offset DeadClip
    .WHILE  eax < 384
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

    leave
    ret
MainCharactor_Init ENDP

MainCharactor_TickTock PROC
    LOCAL   XSpeed:SDWORD
    LOCAL   YSpeed:SDWORD
    LOCAL   AniGo:SDWORD

    .IF     Player_Main.Health_Now == 0
            mov     Player_Main.Father.AniCount, 0
            mov     Player_Main.Health_Now, -1
            invoke  MusicPlayer, SE_Dead, AUDIO_WAV
            ret
    .ELSEIF  Player_Main.Health_Now < 0
            .IF Player_Main.Father.AniCount == 3*10;AniFrame*12
                invoke  MusicPlayer, SE_HAHA, AUDIO_WAV
                invoke  SetState, STATE_DEAD
            .ENDIF
            add     Player_Main.Father.AniCount, 1
            ret
    .ENDIF
    mov     XSpeed, 0
    mov     YSpeed, 0
    mov     AniGo, 0
    mov     esi, CurrentKeystate
    .IF     StartSkill < 30
        inc     StartSkill 
    .ENDIF

    .IF BYTE ptr [esi + SDL_SCANCODE_DOWN] > 0 
        add     YSpeed, Step
        inc     AniGo
        mov     Player_Main.Face, 2                
    .ENDIF
    .IF BYTE ptr [esi + SDL_SCANCODE_UP] > 0
        sub     YSpeed, Step   
        inc     AniGo
        mov     Player_Main.Face, 0
    .ENDIF
    .IF BYTE ptr [esi + SDL_SCANCODE_LEFT] > 0
        sub     XSpeed, Step
        inc     AniGo
        mov     Player_Main.Face, 3
    .ENDIF
    .IF BYTE ptr [esi + SDL_SCANCODE_RIGHT] > 0 
        add     XSpeed, Step
        inc     AniGo
        mov     Player_Main.Face, 1
    .ENDIF

    .If AniGo > 0
        .IF     AniDir > 0
            inc     Player_Main.Father.AniCount
        .ELSE
            dec     Player_Main.Father.AniCount
        .ENDIF
    .ENDIF
    ;If Step is too big
    .IF YSpeed > Step || YSpeed < -Step
        .IF YSpeed > 0
            mov YSpeed, Step
        .ELSE
            mov YSpeed, -Step
        .ENDIF
    .ENDIF
    .IF XSpeed > Step || XSpeed < -Step 
        .IF XSpeed > 0
            mov XSpeed, Step
        .ELSE
            mov XSpeed, -Step
        .ENDIF
    .ENDIF
    ;If move on the diagonals, reduce the speed
    .IF XSpeed != 0 && YSpeed != 0
        .IF XSpeed > 0
            mov XSpeed, Step*10/12
        .ELSE
            mov XSpeed, -Step*10/12
        .ENDIF

        .IF YSpeed > 0
            mov YSpeed, Step*10/12
        .ELSE
            mov YSpeed, -Step*10/12
        .ENDIF
    .ENDIF
    
    ;Move Charactor
    push    YSpeed
    push    XSpeed
    call    C_Move

    ;Move Camera
    mov     eax, Player_Main.Father.Position.X
    sub     eax, SCREEN_HALF_WIDTH
    add     eax, 24                     ;Player_Main.Father.texture.mWidth/2
    mov     Camera.X, eax
    mov     eax, Player_Main.Father.Position.Y
    sub     eax, SCREEN_HALF_HEIGHT
    add     eax, 24
    mov     Camera.Y, eax
    ;Check the boundary of camera
    .IF Camera.X < 0
        mov Camera.X, 0
    .ELSEIF Camera.X > 48 * MAP_BLOCKS_X- SCREEN_WIDTH
        mov Camera.X,  48 * MAP_BLOCKS_X - SCREEN_WIDTH
    .ENDIF
    .IF Camera.Y < 0
        mov Camera.Y, 0
    .ELSEIF Camera.Y > 48 * MAP_BLOCKS_Y- SCREEN_HEIGHT
        mov Camera.Y, 48 * MAP_BLOCKS_Y - SCREEN_HEIGHT
    .ENDIF
    ;Decide the current picture
    .IF XSpeed > 0
        .IF Player_Main.Father.AniCount >= AniFrame*9
            mov Player_Main.Father.AniCount, AniFrame*8
            mov AniDir, -1
        .ELSEIF Player_Main.Father.AniCount < AniFrame*6 
            mov Player_Main.Father.AniCount, AniFrame*7
            mov AniDir, 1
        .ENDIF
    .ELSEIF XSpeed < 0
        .IF Player_Main.Father.AniCount >= AniFrame*6
            mov Player_Main.Father.AniCount, AniFrame*5
            mov AniDir, -1
        .ELSEIF Player_Main.Father.AniCount < AniFrame*3
            mov Player_Main.Father.AniCount, AniFrame*4
            mov AniDir, 1
        .ENDIF
    .ELSEIF YSpeed > 0
        .IF Player_Main.Father.AniCount >= AniFrame*3
            mov Player_Main.Father.AniCount, AniFrame*2
            mov AniDir, -1
        .ELSEIF Player_Main.Father.AniCount < 0
            mov Player_Main.Father.AniCount, AniFrame*1
            mov AniDir, 1
        .ENDIF
    .ELSEIF YSpeed < 0
        .IF Player_Main.Father.AniCount >= AniFrame*12
            mov Player_Main.Father.AniCount, AniFrame*11
            mov AniDir, -1
        .ELSEIF Player_Main.Father.AniCount < AniFrame*9 
            mov Player_Main.Father.AniCount, AniFrame*10
            mov AniDir, 1
        .ENDIF
    .ENDIF

    .IF XSpeed == 0 && YSpeed == 0
        .IF Player_Main.Father.AniCount >= AniFrame*9
            mov Player_Main.Father.AniCount, AniFrame*10
        .ELSEIF Player_Main.Father.AniCount >= AniFrame*6
            mov Player_Main.Father.AniCount, AniFrame*7
        .ELSEIF Player_Main.Father.AniCount >= AniFrame*3
            mov Player_Main.Father.AniCount, AniFrame*4
        .ELSE 
            mov Player_Main.Father.AniCount, AniFrame*1
        .ENDIF
    .ENDIF

    mov     esi, CurrentKeystate
    .IF     StartSkill > 20 && BYTE ptr [esi + SDL_SCANCODE_SPACE]>0
        invoke  Skill_Stack, PLAYER_ATTACK
    .ENDIF

    mov     eax, Player_Main.Mana_Max
    .IF     Player_Main.Mana_Now  <  eax
            add     Player_Main.Mana_Now, 1
    .ENDIF
    ret
MainCharactor_TickTock ENDP

MainCharactor_Render PROC
    push    ebp
    mov     ebp, esp
    .IF     Player_Main.Health_Now <= 0
        xor     edx, edx
        mov     eax, Player_Main.Father.AniCount
        mov     ebx, 3;AniFrame
        div     ebx
        mov     ebx, 16
        mul     ebx

        mov     ebx, Player_Main.Father.Position.X
        sub     ebx, Camera.X
        sub     ebx, 192/2 - 24
        mov     ecx, Player_Main.Father.Position.Y
        sub     ecx, Camera.Y
        sub     ecx, 192/2 + 24
        invoke  Texturerender, ebx, ecx \
                , DeadTexture, gRender, addr DeadClip[eax]

    .ELSE
        xor     edx, edx
        mov     eax, Player_Main.Father.AniCount
        mov     ebx, AniFrame
        div     ebx
        mov     ebx, 16
        mul     ebx
        .IF Player_Main.Father.AniCount == AniFrame*12
            mov Player_Main.Father.AniCount, 0
        .ENDIF

        mov     ebx, Player_Main.Father.Position.X
        sub     ebx, Camera.X
        mov     ecx, Player_Main.Father.Position.Y
        sub     ecx, Camera.Y
        invoke  Texturerender, ebx, ecx \
                , Player_Main.Father.texture, gRender, addr Player_Main.Father.Clip[eax]
    .ENDIF
    leave
    ret
MainCharactor_Render ENDP

end
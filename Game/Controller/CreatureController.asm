.386
.model flat, stdcall
option casemap:none

include .\include\GameSdk.inc

Step        equ 8
AniFrame    equ 8
extern gRender:DWORD
extern CurrentKeystate:DWORD
extern Camera:SDL_Rect

.data
Actor2      BYTE "res/img/characters/Actor2.png", 0
Player_Main Player  {}
AniDir      SDWORD  1

.code
CreatureController_Init PROC
    push    ebp
    mov     ebp, esp
    ;Init position
    mov     Player_Main.Father.X, 100
    mov     Player_Main.Father.Y, 100
    ;Init Camera position
    mov     eax, Player_Main.Father.X
    mov     Camera.X, eax
    mov     eax, Player_Main.Father.Y
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

    leave
    ret
CreatureController_Init ENDP

CreatureController_TickTock PROC
    LOCAL   XSpeed:SDWORD
    LOCAL   YSpeed:SDWORD
    LOCAL   AniGo:SDWORD
    mov     XSpeed, 0
    mov     YSpeed, 0
    mov     AniGo, 0
    mov     esi, CurrentKeystate

    .IF BYTE ptr [esi + SDL_SCANCODE_DOWN] > 0 
        add     YSpeed, Step
        inc     AniGo
    .ENDIF
    .IF BYTE ptr [esi + SDL_SCANCODE_LEFT] > 0
        sub     XSpeed, Step
        inc     AniGo
    .ENDIF
    .IF BYTE ptr [esi + SDL_SCANCODE_RIGHT] > 0 
        add     XSpeed, Step
        inc     AniGo
    .ENDIF
    .IF BYTE ptr [esi + SDL_SCANCODE_UP] > 0
        sub     YSpeed, Step   
        inc     AniGo
    .ENDIF

    .If AniGo > 0
        .IF     AniDir > 0
            inc     Player_Main.Father.AniCount
        .ELSE
            dec     Player_Main.Father.AniCount
        .ENDIF
    .ENDIF
    ;If Step is too big
    .IF XSpeed > Step || XSpeed < -Step 
        .IF XSpeed > 0
            mov XSpeed, Step
        .ELSE
            mov XSpeed, -Step
        .ENDIF
    .ENDIF
    .IF YSpeed > Step || YSpeed < -Step
        .IF YSpeed > 0
            mov YSpeed, Step
        .ELSE
            mov YSpeed, -Step
        .ENDIF
    .ENDIF
    ;If move on the diagonals, reduce the speed
    .IF XSpeed != 0 && YSpeed != 0
        .IF XSpeed > 0
            mov XSpeed, 9
        .ELSE
            mov XSpeed, -9
        .ENDIF

        .IF YSpeed > 0
            mov YSpeed, 9
        .ELSE
            mov YSpeed, -9
        .ENDIF
    .ENDIF
    
    ;Move Charactor
    mov     eax, XSpeed
    add     Player_Main.Father.X, eax
    mov     eax, YSpeed
    add     Player_Main.Father.Y, eax
    ;Move Camera
    mov     eax, Player_Main.Father.X
    sub     eax, SCREEN_HALF_WIDTH
    mov     Camera.X, eax
    mov     eax, Player_Main.Father.Y
    sub     eax, SCREEN_HALF_HEIGHT
    mov     Camera.Y, eax
    .IF Camera.X < 0
        mov Camera.X, 0
    .ELSEIF Camera.X > 48 * MAP_BLOCKS_ROW- SCREEN_WIDTH
        mov Camera.X,  48 * MAP_BLOCKS_ROW - SCREEN_WIDTH
    .ENDIF
    .IF Camera.Y < 0
        mov Camera.Y, 0
    .ELSEIF Camera.Y > 48 * MAP_BLOCKS_COL- SCREEN_HEIGHT
        mov Camera.Y, 48 * MAP_BLOCKS_COL - SCREEN_HEIGHT
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
    ret
CreatureController_TickTock ENDP

CreatureController_Render PROC
    push    ebp
    mov     ebp, esp

    xor     edx, edx
    mov     eax, Player_Main.Father.AniCount
    mov     ebx, AniFrame
    div     ebx
    mov     ebx, 16
    mul     ebx
    .IF Player_Main.Father.AniCount == AniFrame*12
        mov Player_Main.Father.AniCount, 0
    .ENDIF

    mov     ebx, Player_Main.Father.X
    sub     ebx, Camera.X
    mov     ecx, Player_Main.Father.Y
    sub     ecx, Camera.Y
    invoke  Texturerender, ebx, ecx \
            , Player_Main.Father.texture, gRender, addr Player_Main.Father.Clip[eax]
    
    leave
    ret
CreatureController_Render ENDP

end
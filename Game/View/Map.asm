.386
.model flat, stdcall
option casemap:none

include .\include\GameSdk.inc

extern CurrentKeystate:DWORD
extern SE_Cusor:DWORD
extern SE_Confirm:DWORD
extern gRender:DWORD
extern BackgroundTexture:Texture
extern Camera:SDL_Rect

public Map_arr

.data

Grass           SDL_Rect {0, 0, 48, 48}
Outside_A2      BYTE "res/img/tilesets/Outside_A2.png", 0
Dungeon_A4      BYTE "res/img/tilesets/Dungeon_A4.png", 0
SS_Outside_A2   Texture {?, ?, ?}
SS_Dungeon_A4   Texture {?, ?, ?}

Map_arr         BYTE 10000 DUP( 0 )
Rooms           SDL_Rect MAX_ROOMS DUP ({})
RockGround      SDL_Rect 36 DUP ({?, ?, 48, 48}); lu u ru | lm m rm | lb b rb | dopen uopen lopen ropen 

RoomCounter     SDWORD 0
.code

Map_Init PROC
    LOCAL   iloop:DWORD
    LOCAL   jloop:DWORD
    
    invoke  TextureLoader,addr SS_Outside_A2, addr Outside_A2, gRender
    invoke  TextureLoader,addr SS_Dungeon_A4, addr Dungeon_A4, gRender
    ;init the ground
    mov     esi, offset RockGround
    mov     jloop, 5
    mov     iloop, 3
    xor     eax, eax
    xor     ebx, ebx
    .WHILE jloop > 0
        .WHILE iloop > 0
            mov     [esi].SDL_Rect.X, eax
            mov     [esi].SDL_Rect.Y, ebx
            add     esi, TYPE RockGround
            add     eax, 48
            sub     iloop, 1
        .ENDW
        xor     eax, eax
        add     ebx, 48
        mov     iloop, 3
        sub     jloop, 1
    .ENDW

    mov     jloop, 2
    mov     iloop, 3
    mov     eax, 48*3
    xor     ebx, ebx
    .WHILE jloop > 0
        .WHILE iloop > 0
            mov     [esi].SDL_Rect.X, eax
            mov     [esi].SDL_Rect.Y, ebx
            add     esi, TYPE RockGround
            add     eax, 48
            sub     iloop, 1
        .ENDW
        mov     eax, 48*3
        add     ebx, 48
        mov     iloop, 3
        sub     jloop, 1
    .ENDW

    mov     jloop, 5
    mov     iloop, 3
    mov     eax, 48*6
    xor     ebx, ebx
    .WHILE jloop > 0
        .WHILE iloop > 0
            mov     [esi].SDL_Rect.X, eax
            mov     [esi].SDL_Rect.Y, ebx
            add     esi, TYPE RockGround
            add     eax, 48
            sub     iloop, 1
        .ENDW
        mov     eax, 48*6
        add     ebx, 48
        mov     iloop, 3
        sub     jloop, 1
    .ENDW

    
    ;init the rand function by srand
    push    0
    call    time
    push    eax
    call    srand

    call    GenerateMaze

    ret
Map_Init ENDP

Map_Render PROC

    call    RenderMaze

    ret
Map_Render ENDP

GenerateMaze PROC
    LOCAL   wloop:SDWORD
    LOCAL   hloop:SDWORD
    LOCAL   rloop:SDWORD
    LOCAL   TCounter:SDWORD

    mov     TCounter, 3000 ;generate 1000 rooms for map,but  delete the room which overlaps with others
    mov     esi, offset Rooms

    .WHILE  TCounter > 0
        ;random generate a room and check it's boundary
        .REPEAT
            call    rand 
            xor     edx, edx
            mov     ebx, MAP_BLOCKS_X - 6 
            div     ebx
            add     edx, 1    
            mov     [esi].SDL_Rect.X, edx

            call    rand 
            xor     edx, edx
            mov     ebx, MAP_BLOCKS_Y - 6 
            div     ebx
            add     edx, 1    
            mov     [esi].SDL_Rect.Y, edx

            call    rand 
            xor     edx, edx
            mov     ebx, ROOM_MAX_WIDTH 
            div     ebx
            add     edx, 6
            mov     [esi].SDL_Rect.W, edx

            call    rand 
            xor     edx, edx
            mov     ebx, ROOM_MAX_HEIGHT
            div     ebx
            add     edx, 6    
            mov     [esi].SDL_Rect.H, edx

            mov     eax, [esi].SDL_Rect.X
            add     eax, [esi].SDL_Rect.W
            mov     ebx, [esi].SDL_Rect.Y 
            add     ebx, [esi].SDL_Rect.H
        .UNTIL  eax < MAP_BLOCKS_X - 2 && ebx < MAP_BLOCKS_Y - 2 
        ;CheckOverlap, [esi].SDL_Rect
        xor     eax, eax
        mov     ebx, RoomCounter
        mov     edi, offset Rooms
        .WHILE  ebx > 0
            push    esi
            push    edi
            call    SDL_HasIntersection
            .IF     eax == SDL_TRUE
                jmp     Check_Over
            .ENDIF
            add     edi, TYPE Rooms
            dec     ebx
        .ENDW
        Check_Over:
        ;add the room into rooms array if it was not overlap with others
        .IF     eax != SDL_TRUE
            add     RoomCounter, 1
            add     esi, TYPE Rooms
        .ENDIF
        ;check if the rooms array is full
        mov     ecx, RoomCounter
        .IF     ecx == MAX_ROOMS - 1 
            mov     TCounter, 1
        .ENDIF
        sub     TCounter, 1
    .ENDW

    ;Draw the room on Map_arr
    mov     esi, offset Rooms
    mov     eax, RoomCounter
    mov     rloop, eax

    .WHILE  rloop > 0
        ;Move to the start point of a room
        mov     edi, offset Map_arr
        mov     eax, [esi].SDL_Rect.Y
        add     eax, 3                  ;padding
        mov     ebx, MAP_BLOCKS_X
        mul     ebx
        add     edi, [esi].SDL_Rect.X
        add     edi, 3                  ;padding
        add     edi, eax
        mov     ebx, [esi].SDL_Rect.W
        mov     eax, [esi].SDL_Rect.H
        sub     ebx, 3
        sub     eax, 3
        mov     wloop, ebx
        mov     hloop, eax
        ;Fill the room in Map_arr
        .WHILE  hloop > 0
            .WHILE  wloop > 0
                add     edi, 1
                mov     byte ptr[edi], 1
                sub     wloop, 1
            .ENDW
            add     edi, 100
            sub     edi, ebx 
            mov     wloop, ebx
            sub     hloop, 1
        .ENDW
        add     esi, TYPE Rooms
        sub     rloop, 1
    .ENDW

    ;use flood fill to creat roads
    xor     eax, eax
    .WHILE  !eax
        call    C_FloodFill 
    .ENDW

    leave
    ret
GenerateMaze ENDP

RenderMaze PROC
    LOCAL   tloop:DWORD
    LOCAL   jloop:DWORD
    LOCAL   Xmin:SDWORD
    LOCAL   Xmax:SDWORD
    LOCAL   Ymin:SDWORD
    LOCAL   Ymax:SDWORD

    mov     tloop, 0
    mov     jloop, 0
    mov     eax, Camera.X
    sub     eax, 48
    mov     Xmin, eax
    add     eax, 48
    add     eax, SCREEN_WIDTH
    mov     Xmax, eax
    mov     eax, Camera.Y
    sub     eax, 48
    mov     Ymin, eax
    add     eax, 48
    add     eax, SCREEN_HEIGHT
    mov     Ymax, eax

    .WHILE  tloop < MAP_BLOCKS_X
        .WHILE  jloop < MAP_BLOCKS_Y

            mov     esi, offset Map_arr
            add     esi, tloop
            
            mov     eax, jloop
            mov     ebx, MAP_BLOCKS_X
            mul     ebx
            add     esi, eax
            ;.IF byte ptr [esi] > 0     ;if current block on map is road 
                mov     ebx, tloop
                mov     eax, jloop      ;eax is for x, and ebx is for y. but we exchange them here, for the convenience of mutiplication
                call    RoadRender 
                push    edx             ;maintain the value of edx,because mul will overwrite it     
                mov     ecx, 48
                mul     ecx
                xchg    eax, ebx
                mul     ecx 
                pop     edx
                .IF (eax > Xmin) && (eax < Xmax) && (ebx > Ymin) && (ebx < Ymax)
                    sub     eax, Camera.X
                    mov     ecx, eax        ;eax is reserve for addr pseudo command
                    sub     ebx, Camera.Y 
                    invoke  Texturerender, ecx, ebx, SS_Dungeon_A4, gRender,addr RockGround[edx]
                .ENDIF
            ;.ENDIF
            add     jloop, 1
        .ENDW
        mov     jloop, 0
        add     tloop, 1
    .ENDW 
    ret
RenderMaze ENDP

RoadRender PROC ;return in edx
    LOCAL   X:DWORD
    LOCAL   Y:DWORD
    mov     X, ebx
    mov     Y, eax
    push    ebx
    push    eax
    
    mov     esi, offset Map_arr
    mov     ebx, X
    mov     eax, Y
    mov     ecx, MAP_BLOCKS_X
    mul     ecx
    add     esi, ebx
    add     esi, eax


    ;draw the road
    .IF     byte ptr [esi] == 1
        .IF         byte ptr [esi - 1] == 0 && byte ptr [esi + 1] == 0 && byte ptr [esi - MAP_BLOCKS_X] == 0
            mov     edx, 9*TYPE RockGround 
        .ELSEIF     byte ptr [esi - 1] == 0 && byte ptr [esi + 1] == 0 && byte ptr [esi + MAP_BLOCKS_X] == 0
            mov     edx, 10*TYPE RockGround
        .ELSEIF     byte ptr [esi - 1] == 0 && byte ptr [esi + MAP_BLOCKS_X] == 0 && byte ptr [esi - MAP_BLOCKS_X] == 0
            mov     edx, 11*TYPE RockGround
        .ELSEIF     byte ptr [esi + 1] == 0 && byte ptr [esi + MAP_BLOCKS_X] == 0 && byte ptr [esi - MAP_BLOCKS_X] == 0
            mov     edx, 12*TYPE RockGround
        .ELSEIF     byte ptr [esi - 1] == 0 && byte ptr [esi + 1] == 0
            mov     edx, 13*TYPE RockGround
        .ELSEIF     byte ptr [esi - 1] == 0 && byte ptr [esi - MAP_BLOCKS_X] == 0
            xor     edx, edx
        .ELSEIF     byte ptr [esi - 1] == 0 && byte ptr [esi + MAP_BLOCKS_X] == 0    
            mov     edx, 6*TYPE RockGround
        .ELSEIF     byte ptr [esi + 1] == 0 && byte ptr [esi - MAP_BLOCKS_X] == 0     
            mov     edx, 2*TYPE RockGround
        .ELSEIF     byte ptr [esi + 1] == 0 && byte ptr [esi + MAP_BLOCKS_X] == 0      
            mov     edx, 8*TYPE RockGround
        .ELSEIF     byte ptr [esi - 1] == 0       
            mov     edx, 3*TYPE RockGround
        .ELSEIF     byte ptr [esi + 1] == 0          
            mov     edx, 5*TYPE RockGround
        .ELSEIF     byte ptr [esi - MAP_BLOCKS_X] == 0
            mov     edx, 1*TYPE RockGround 
        .ELSEIF     byte ptr [esi + MAP_BLOCKS_X] == 0
            mov     edx, 7*TYPE RockGround
        .ELSE
            mov     edx, 4*TYPE RockGround
        .ENDIF
    .ELSE
        ;draw the wall
        .IF         byte ptr [esi] == 2
                .IF         byte ptr [esi - 1] != 2 && byte ptr [esi + 1] != 2 && byte ptr [esi - MAP_BLOCKS_X] != 2
                    mov     edx, 30*TYPE RockGround 
                .ELSEIF     byte ptr [esi - 1] != 2 && byte ptr [esi + 1] != 2 && byte ptr [esi + MAP_BLOCKS_X] != 2
                    mov     edx, 31*TYPE RockGround
                .ELSEIF     byte ptr [esi - 1] != 2 && byte ptr [esi + MAP_BLOCKS_X] != 2 && byte ptr [esi - MAP_BLOCKS_X] != 2
                    mov     edx, 32*TYPE RockGround
                .ELSEIF     byte ptr [esi + 1] != 2 && byte ptr [esi + MAP_BLOCKS_X] != 2 && byte ptr [esi - MAP_BLOCKS_X] != 2
                    mov     edx, 33*TYPE RockGround
                .ELSEIF     byte ptr [esi - 1] != 2 && byte ptr [esi + 1] != 2
                    mov     edx, 34*TYPE RockGround
                .ELSEIF     byte ptr [esi - 1] != 2 && byte ptr [esi - MAP_BLOCKS_X] != 2
                    mov     edx, 21*TYPE RockGround
                .ELSEIF     byte ptr [esi - 1] != 2 && byte ptr [esi + MAP_BLOCKS_X] != 2    
                    mov     edx, 27*TYPE RockGround
                .ELSEIF     byte ptr [esi + 1] != 2 && byte ptr [esi - MAP_BLOCKS_X] != 2     
                    mov     edx, 23*TYPE RockGround
                .ELSEIF     byte ptr [esi + 1] != 2 && byte ptr [esi + MAP_BLOCKS_X] != 2      
                    mov     edx, 29*TYPE RockGround
                .ELSEIF     byte ptr [esi - 1] != 2       
                    mov     edx, 24*TYPE RockGround
                .ELSEIF     byte ptr [esi + 1] != 2          
                    mov     edx, 26*TYPE RockGround
                .ELSEIF     byte ptr [esi - MAP_BLOCKS_X] != 2
                    mov     edx, 22*TYPE RockGround 
                .ELSEIF     byte ptr [esi + MAP_BLOCKS_X] != 2
                    mov     edx, 28*TYPE RockGround
                .ELSE
                    mov     edx, 25*TYPE RockGround
                .ENDIF
        .ELSE
            .IF     byte ptr [esi - 1] > 0 && byte ptr [esi + 1] > 0
                mov     edx, 15*TYPE RockGround
            .ELSEIF  byte ptr [esi - 1] > 0
                mov     edx, 16*TYPE RockGround
            .ELSEIF  byte ptr [esi + 1] > 0
                mov     edx, 17*TYPE RockGround
            .ELSE
                mov     edx, 18*TYPE RockGround
            .ENDIF
        .ENDIF


    .ENDIF
    pop     eax
    pop     ebx
    
    ret
RoadRender ENDP


end
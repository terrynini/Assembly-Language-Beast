.386
.model flat, stdcall
option casemap:none

include .\include\GameSdk.inc

extern gRender:DWORD
extern CurrentKeystate:DWORD
extern gFont_Ration:DWORD

DrawSideBar_row proto :SDL_Rect, :SDL_Rect, :SDL_Rect, :SDWORD
DrawSideBar proto :ptr SDL_Rect, :SDWORD, :SDWORD, :SDWORD

.data
ColdDown        BYTE 0
File_System     BYTE "res/img/system/Window.png", 0
S_BackPack      BYTE "BackPack", 0
S_About         BYTE "About", 0
SS_System       Texture {?, ?, ?}
SS_SideBar      Texture {?, ?, ?}
TargetRec       SDL_Rect {0, 0, 48, 48}
OptionTexture   Texture 2 DUP ({?, ?, ?})

Clip_Background SDL_Rect {0, 0, 12, 12}, {12, 0, 12, 12}, {84, 0, 12, 12}, {0, 12, 12, 12} \
, {12, 12, 12, 12}, {84, 12, 12, 12}, {0, 84, 12, 12}, {12, 84, 12, 12}, {84, 84, 12, 12}

Clip_LineCover SDL_Rect {0, 96, 12, 12}, {12, 96, 12, 12}, {84, 96, 12, 12}, {0, 108, 12, 12} \
, {12, 108, 12, 12}, {84, 108, 12, 12}, {0, 180, 12, 12}, {12, 180, 12, 12}, {84, 180, 12, 12}

Clip_Outline SDL_Rect {96, 0, 12, 12}, {108, 0, 12, 12}, {180, 0, 12, 12}, {96, 12, 12, 12} \
, {108, 12, 12, 12}, {180, 12, 12, 12}, {96, 84, 12, 12}, {108, 84, 12, 12}, {180, 84, 12, 12}


SidebarSurface  DWORD ?
MaterialSurface DWORD ?

.code
BackPack_Init PROC
    push    ebp
    mov     ebp, esp
    ;Load picture
    push    offset File_System 
    call    IMG_Load
    mov     MaterialSurface, eax
    ;Create a new Surface
    push    0ff000000h
    push    0ff0000h
    push    0ff00h
    push    0ffh
    push    32d
    push    SCREEN_HEIGHT
    push    SCREEN_WIDTH
    push    0
    call    SDL_CreateRGBSurface
    mov     SidebarSurface, eax
    ;draw on new Surface
    invoke  DrawSideBar,addr Clip_Background, 0, 0, 14
    invoke  DrawSideBar,addr Clip_LineCover, 0, 0, 14
    invoke  DrawSideBar,addr Clip_Outline, 0, 0, 14

    invoke  DrawSideBar,addr Clip_Background, 204, 0, 48
    invoke  DrawSideBar,addr Clip_LineCover, 204, 0, 48
    invoke  DrawSideBar,addr Clip_Outline, 204, 0, 48
    ;Create a new texture
    push    SidebarSurface
    push    gRender
    call    SDL_CreateTextureFromSurface
    mov     esi, offset SS_SideBar 
    mov     [esi].Texture.mTexture, eax
    mov     eax, SidebarSurface
    mov     edx,  [eax + 8]
    mov     [esi].Texture.mWidth, edx
    mov     edx, [eax + 0ch]
    mov     [esi].Texture.mHeight, edx
    ;Draw text on texture
    invoke  FontRender, addr S_BackPack, addr OptionTexture, gFont_Ration, gRender, 255
    invoke  FontRender, addr S_About, addr [OptionTexture + TYPE OptionTexture], gFont_Ration, gRender, 255
    leave
    ret
BackPack_Init ENDP

BackPack_TickTock PROC
    push    ebp
    mov     ebp, esp

     .IF     ColdDown < 30
        add     ColdDown, 1 
    .ENDIF
    mov     esi, CurrentKeystate
    .IF ColdDown > 20 && BYTE ptr [esi + SDL_SCANCODE_B] > 0 
        invoke  SetState, STATE_GAME
        mov     ColdDown, 0
    .ENDIF
 
    leave
    ret
BackPack_TickTock ENDP
    
BackPack_Render PROC
    push    ebp
    mov     ebp, esp

    call    StateGame_Render
    invoke  Texturerender, 0, 0, SS_SideBar, gRender, 0
    
    invoke  Texturerender, 50, 60, OptionTexture, gRender, 0
    invoke  Texturerender, 50, 140, [OptionTexture + TYPE OptionTexture], gRender, 0
    leave
    ret
BackPack_Render ENDP

DrawSideBar PROC ClipArray:ptr SDL_Rect, X:SDWORD, Y:SDWORD, WidthOfWin:SDWORD
    LOCAL   LoopCounter:DWORD
    mov     eax, X
    mov     ebx, Y 
    mov     TargetRec.X, eax
    mov     TargetRec.Y, ebx
    mov     TargetRec.W, 48
    mov     TargetRec.H, 48    

    mov     esi, ClipArray
    invoke  DrawSideBar_row,SDL_Rect ptr [esi +0],SDL_Rect ptr [esi +16],SDL_Rect ptr [esi +32], WidthOfWin
    mov     LoopCounter, 0
    .WHILE LoopCounter < 50
        mov     eax, X
        mov     TargetRec.X, eax
        add     TargetRec.Y, 12
        mov     esi, ClipArray
        invoke  DrawSideBar_row, SDL_Rect ptr [esi +48],SDL_Rect ptr [esi +64],SDL_Rect ptr [esi +80], WidthOfWin
        add     LoopCounter, 1
    .ENDW
    mov     eax, X
    mov     TargetRec.X, eax
    add     TargetRec.Y, 12
    mov     esi, ClipArray
    invoke  DrawSideBar_row, SDL_Rect ptr [esi +96],SDL_Rect ptr [esi +112],SDL_Rect ptr [esi +128], WidthOfWin

    ret
DrawSideBar ENDP

DrawSideBar_row PROC Clip_LEFT:SDL_Rect, Clip_MIDDLE:SDL_Rect, Clip_RIGHT:SDL_Rect, LoopCounter:SDWORD
    push    offset TargetRec
    push    SidebarSurface
    lea     eax, Clip_LEFT
    push    eax
    push    MaterialSurface
    call    SDL_UpperBlit

    .WHILE  LoopCounter >= 0
        add     TargetRec.X, 12
        push    offset TargetRec
        push    SidebarSurface
        lea     eax, Clip_MIDDLE
        push    eax
        push    MaterialSurface
        call    SDL_UpperBlit
        sub     LoopCounter, 1
    .ENDW
    add     TargetRec.X, 12
    push    offset TargetRec
    push    SidebarSurface
    lea     eax, Clip_RIGHT
    push    eax
    push    MaterialSurface
    call    SDL_UpperBlit
    ret
DrawSideBar_row ENDP
end
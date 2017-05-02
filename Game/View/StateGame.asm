.386
.model flat, stdcall
option casemap:none

include .\include\GameSdk.inc

extern CurrentKeystate:DWORD
extern SE_Cusor:DWORD
extern SE_Confirm:DWORD
extern gRender:DWORD
extern BackgroundTexture:Texture
extern SS_Outside_A2:Texture
.data
Grass   SDL_Rect {0, 0, 48, 48}

.code
StateGame_TickTock PROC
    push    ebp
    mov     ebp, esp

    leave
    ret
StateGame_TickTock ENDP
    
StateGame_Render PROC
    push    ebp
    mov     ebp, esp
    
  
    invoke  Texturerender, 0, 0, SS_Outside_A2, gRender,addr Grass
             
    leave
    ret
StateGame_Render ENDP
end
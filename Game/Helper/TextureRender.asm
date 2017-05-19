.386
.model flat, stdcall
option casemap:none

include .\include\GameSdk.inc

.data

.code
Texturerender PROC uses esi  X:DWORD, Y:DWORD, TEXTURE:Texture, gRender:DWORD, Clip:ptr SDL_Rect
    LOCAL renderQuad:SDL_Rect
    LOCAL point:SDL_Point
    
    mov     eax, X
    mov     renderQuad.X, eax
    mov     eax, Y
    mov     renderQuad.Y, eax
    mov     eax, TEXTURE.mWidth
    mov     renderQuad.W, eax
    mov     eax, TEXTURE.mHeight
    mov     renderQuad.H, eax

    .IF Clip != 0
        mov     esi, Clip
        mov     eax, [esi].SDL_Rect.W
        mov     renderQuad.W, eax
        mov     eax, [esi].SDL_Rect.H  
        mov     renderQuad.H, eax
    .ENDIF

    ;SDL_RenderCopyEx
    push    SDL_FLIP_NONE
    lea     eax, point
    push    eax 
    push    0
    push    0
    lea     eax, renderQuad
    push    eax
    push    Clip
    push    TEXTURE.mTexture
    push    gRender
    call    SDL_RenderCopyEx

    ret
Texturerender ENDP
end
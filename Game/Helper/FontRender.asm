.386
.model flat, stdcall
option casemap:none

include .\include\GameSdk.inc

.data

.code

FontRender PROC TextField:ptr DWORD, Texturept:ptr Texture, Font:DWORD, gRender:DWORD
    LOCAL   color:SDL_Color
    LOCAL   textSurface:DWORD

    mov     color.R, 255
    mov     color.G, 255
    mov     color.B, 255
    mov     color.A, 0
    ;loadFromRenderedText
    push    color
    push    TextField
    push    Font
    call    TTF_RenderText_Blended
    mov     textSurface, eax
    ;SDL_CreateTextureFromSurface
    mov     esi, Texturept
    push    textSurface
    push    gRender
    call    SDL_CreateTextureFromSurface
    mov     [esi].Texture.mTexture, eax
    mov     eax, textSurface
    mov     edx,  [eax + 8]
    mov     [esi].Texture.mWidth, edx
    mov     edx, [eax + 0ch]
    mov     [esi].Texture.mHeight, edx
    ;SDL_SetTextureBlendMode
    push    SDL_BLENDMODE_BLEND
    push    [esi].Texture.mTexture
    call    SDL_SetTextureBlendMode
    ;SDL_SetTextureAlphaMod
    push    60
    push    [esi].Texture.mTexture
    call    SDL_SetTextureAlphaMod

    ret
FontRender ENDP 
end


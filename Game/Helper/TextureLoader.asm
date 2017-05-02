.386
.model flat, stdcall
option casemap:none

include .\include\GameSdk.inc

.data

.code
TextureLoader PROC TexturePtr:ptr Texture, fileptr: ptr DWORD, gRender:DWORD 
    LOCAL   ImageSurface:DWORD
    
    push    fileptr
    call    IMG_Load
    mov     ImageSurface, eax
    ;SDL_CreateTextureFromSurface
    push    ImageSurface
    push    gRender
    call    SDL_CreateTextureFromSurface

    mov     esi, TexturePtr
    mov     [esi].Texture.mTexture, eax
    mov     eax, ImageSurface
    mov     edx,  [eax + 8]
    mov     [esi].Texture.mWidth, edx
    mov     edx, [eax + 0ch]
    mov     [esi].Texture.mHeight, edx
    ret
TextureLoader ENDP
end
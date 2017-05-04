all:Game.exe

CC = gcc
INSTDIR = C:\MinGW\bin
INCLUDE = .
CFLAGS = -IC:\MinGW\include\SDL2 -LC:\MinGW\lib -w -Wl,-subsystem,windows -lmingw32 -lSDL2main -lSDL2 -lSDL2_image -lSDL2_ttf -lSDL2_mixer

ML=ml
MLFLAGS=-c -Cp -coff

SRC = Helper/FontLoader.asm Helper/MusicLoader.asm Helper/MusicPlayer.asm Helper/TextureLoader.asm \
 Helper/FontRender.asm Helper/TextureRender.asm Controller/Main.asm Controller/StateController.asm View/StateTitle.asm \
View/StateGame.asm View/Map.asm Controller\CreatureController.asm View\StatusBar.asm

OBJ = FontLoader.obj MusicLoader.obj MusicPlayer.obj TextureLoader.obj FontRender.obj TextureRender.obj Main.obj \
 StateController.obj StateTitle.obj StateGame.obj Map.obj CreatureController.obj StatusBar.obj
#OBJ = $(SRC:%.cc=%.o)

Game.exe: $(OBJ) 
	$(CC) $(OBJ) $(CFLAGS) -o Game.exe

$(OBJ): $(SRC)
	$(ML) $(MLFLAGS) $(SRC)

clean:
	rm -f *.obj *.exe
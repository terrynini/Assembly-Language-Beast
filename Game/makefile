all:Game.exe

CC = gcc
INSTDIR = C:\MinGW\bin
INCLUDE = .
CFLAGS = -IC:\MinGW\include\SDL2 -LC:\MinGW\lib -Wimplicit-function-declaration -Wl,-subsystem,windows -lmingw32 -lSDL2main -lSDL2 -lSDL2_image -lSDL2_ttf -lSDL2_mixer

ML=ml
MLFLAGS=-c -Cp -coff

SRC = Helper/FontLoader.asm Helper/MusicLoader.asm Helper/MusicPlayer.asm Helper/TextureLoader.asm \
 Helper/FontRender.asm Helper/TextureRender.asm Controller/Main.asm Controller/StateController.asm View/StateTitle.asm \
View/StateGame.asm View/Map.asm Controller\CreatureController.asm View\StatusBar.asm View\BackPack.asm Controller\MainCharactor.asm \
Controller\Monsters.asm  Controller\SkillController.asm

OBJ = FontLoader.obj MusicLoader.obj MusicPlayer.obj TextureLoader.obj FontRender.obj TextureRender.obj Main.obj \
 StateController.obj StateTitle.obj StateGame.obj Map.obj CreatureController.obj StatusBar.obj BackPack.obj MainCharactor.obj \
Monsters.obj C_FloodFill.obj C_Map.obj  C_Monster.obj SkillController.obj

#OBJ = $(SRC:%.cc=%.o)

Game.exe: $(OBJ) 
	$(CC) $(OBJ) $(CFLAGS) -o Game.exe
$(OBJ): $(SRC)
	$(ML) $(MLFLAGS) $(SRC)
	gcc	-c C_FloodFill.c -o C_FloodFill.obj
	gcc	-c C_Map.c 		 -o C_Map.obj
	gcc -c C_Monster.c -o  C_Monster.obj
clean:
	rm -f *.obj 
	rm -f Game.exe
	
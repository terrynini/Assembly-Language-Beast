#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <math.h>
#include "C_lib.h"

#define MAX_ROOMS 100
#define MAP_BLOCKS_X 100
#define MAP_BLOCKS_Y 100
#define AniFrame 8
extern int8_t  dx[4], dy[4];
extern int Map_Walkable(SDL_Point*);
extern int gRender;

void C_Add_Monster_Kind(Monster* MonsterA){
    Monster_Kinds [ MonsterKinds ] = *MonsterA;
    MonsterKinds += 1;

    return;
}

void C_Monster_Generate(int Num){
    int kind;
    int X, Y;
    while(Monster_count < Num){
        kind = rand()%MonsterKinds;
        Monster_array[Monster_count] = Monster_Kinds[kind];
        do{
            X = rand()%(MAP_BLOCKS_X-2) + 1;
            Y = rand()%(MAP_BLOCKS_Y-2) + 1;
        }while(Map_arr[Y][X] != 1);
        Monster_array[Monster_count].Father.Position.X = X*48;
        Monster_array[Monster_count].Father.Position.Y = Y*48;
        Monster_array[Monster_count].Health_Max = rand()%500 + 200;
        Monster_array[Monster_count].Health_Now = Monster_array[Monster_count].Health_Max;
        Monster_array[Monster_count].Mana_Now   = Monster_array[Monster_count].Mana_Max;
        
        Monster_count += 1;
    }
    return;
}
 
void C_Monster_Move(Monster* monster, int XSpeed, int YSpeed){
    SDL_Point   Corner[4]; // LU RU LD RD

    //Init Corner
    for(int i = 0 ; i < 4 ; i++){
        Corner[i].X = monster->Father.Position.X + monster->Father.BoundBox.X;
        Corner[i].Y = monster->Father.Position.Y + monster->Father.BoundBox.Y;
    }
 
    Corner[1].X += monster->Father.BoundBox.W;
    Corner[3].X += monster->Father.BoundBox.W;

    Corner[2].Y += monster->Father.BoundBox.H;
    Corner[3].Y += monster->Father.BoundBox.H;

    //IF Player is in attack range of monster
    int range = sqrt(pow((Player_Main.Father.Position.X - monster->Father.Position.X),2) +
                pow((Player_Main.Father.Position.Y - monster->Father.Position.Y),2));
    if( range <= 5 * 48 ){
        if(abs(Player_Main.Father.Position.X - monster->Father.Position.X) < 3)
            XSpeed = 0;
        else if((Player_Main.Father.Position.X > monster->Father.Position.X && XSpeed < 0)||
        (Player_Main.Father.Position.X < monster->Father.Position.X && XSpeed > 0)){
            XSpeed = -XSpeed;
        }
        if(abs(Player_Main.Father.Position.Y - monster->Father.Position.Y) < 3)
            YSpeed = 0;
        else if((Player_Main.Father.Position.Y > monster->Father.Position.Y && YSpeed < 0) ||
        (Player_Main.Father.Position.Y < monster->Father.Position.Y && YSpeed > 0)){
            YSpeed = -YSpeed;
        }
    }
    if( range <= 1*48){
        XSpeed = YSpeed = 0;
    }
    //Check X axis
    for(int i = 0 ; i < 4 ; i++)
        Corner[i].X += XSpeed;
    for(int i = 0 ; i < 4 ; i++){
        if (!Map_Walkable(&Corner[i])){
            break;
        }
        if(i == 3)
                monster->Father.Position.X += XSpeed;
    }

    //Check Y axis
    for(int i = 0 ; i < 4 ; i++){
        Corner[i].X -= XSpeed;
        Corner[i].Y += YSpeed;
    }
        for(int i = 0 ; i < 4 ; i++){
        if (!Map_Walkable(&Corner[i])){
            break;
        }
        if(i == 3)
            monster->Father.Position.Y += YSpeed;
    }
    

    if(XSpeed || YSpeed){
        if(monster->AniDir > 0)
            monster->Father.AniCount += 1;
        else
            monster->Father.AniCount -= 1;
    }
    //Decide which Frame should be rendered
    if (XSpeed > 0){
        if (monster->Father.AniCount >= AniFrame*9){
            monster->Father.AniCount = AniFrame*8;
            monster->AniDir = -1;
        }else if(monster->Father.AniCount < AniFrame*6 ){
            monster->Father.AniCount = AniFrame*7;
            monster->AniDir = 1;
        }
    }else if(XSpeed < 0){
        if(monster->Father.AniCount >= AniFrame*6){
            monster->Father.AniCount = AniFrame*5;
            monster->AniDir = -1;
        }else if(monster->Father.AniCount < AniFrame*3){
            monster->Father.AniCount = AniFrame*4;
            monster->AniDir = 1;
        }
    }else if(YSpeed > 0){
        if(monster->Father.AniCount >= AniFrame*3){
            monster->Father.AniCount = AniFrame*2;
            monster->AniDir = -1;
        }else if(monster->Father.AniCount < AniFrame*0){
            monster->Father.AniCount = AniFrame*1;
            monster->AniDir = 1;
        }
    }else if(YSpeed < 0){
        if(monster->Father.AniCount >= AniFrame*12){
            monster->Father.AniCount = AniFrame*11;
            monster->AniDir = -1;
        }else if(monster->Father.AniCount < AniFrame*9){
            monster->Father.AniCount = AniFrame*10;
            monster->AniDir = 1;
        }
    }

    if(!XSpeed && ! YSpeed){
        if( monster->Father.AniCount >= AniFrame*9)
            monster->Father.AniCount = AniFrame*10;
        else if( monster->Father.AniCount >= AniFrame*6)
            monster->Father.AniCount = AniFrame*7;
        else if( monster->Father.AniCount >= AniFrame*3)
            monster->Father.AniCount = AniFrame*4;
        else
            monster->Father.AniCount = AniFrame*1;
    }
  
    return;
}

void C_Monster_Damage(){
    SDL_Rect TempRect, monster, skill;
    TempRect.W =0;
    TempRect.H =0;
    for(int i = 0 ; i < Monster_count ; i++){
        if(Monster_array[i].Health_Now <= 0)
            continue;
        monster = Monster_array[i].Father.BoundBox;
        skill = Skill_Main.Father.BoundBox;

        monster.X += Monster_array[i].Father.Position.X;
        monster.Y += Monster_array[i].Father.Position.Y;

        skill.X += Skill_Main.Father.Position.X;
        skill.Y += Skill_Main.Father.Position.Y;
 
        if( SDL_IntersectRect(&monster,&skill, &TempRect)){
            SDL_SetTextureAlphaMod(Monster_array[i].Father.texture.mTexture, 170);
            Monster_array[i].Health_Now -= 1;
        }
           
    }
    return;
}

void C_Monster_Dead(){
    
    for(int i = 0 ; i < Monster_count ; i++){
        if(Monster_array[i].Health_Now < 0 && Monster_array[i].Father.AniCount == AniFrame*20){
            Monster temp = Monster_array[i];
            Monster_array[i] = Monster_array[Monster_count-1] ;
            Monster_array[Monster_count-1] = temp;
            Monster_count -= 1;
        }
    }
    return ;
}
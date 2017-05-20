#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include "C_lib.h"

#define MAX_ROOMS 100
#define MAP_BLOCKS_X 100
#define MAP_BLOCKS_Y 100

extern Skill SkillStack[100];
extern int Skill_count;

void C_SkillTickTock(){

}

void C_SkillStack(int AttackType){
    SkillStack[Skill_count] = Skill_Enemy;
    SkillStack[Skill_count].ID = AttackType;
    Skill_count += 1;
    return;
}

void C_SkillRender(){

}
void C_Monster_CD(Skill* skill){
    for(int i = 0 ; i < Skill_count; i++){
        if(SkillStack[i].ID == skill->ID){
            Skill temp = SkillStack[i];
            SkillStack[i] = SkillStack[Skill_count-1];
            SkillStack[Skill_count-1] = temp;
            Skill_count -= 1;
            break;
        }
    }
    return;
}
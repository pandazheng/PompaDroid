//
//  GameLayer.h
//  PompaDroid
//
//  Created by panda zheng on 13-7-11.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Hero.h"
#import "SimpleDPad.h"
#import "HudLayer.h"

@interface GameLayer : CCLayer <SimpleDPadDelegate> {
    CCTMXTiledMap *_tileMap;
    CCSpriteBatchNode *_actors;
    Hero *_hero;
}

@property (nonatomic,weak) HudLayer *hud;
@property (nonatomic,strong) CCArray *robots;

@end

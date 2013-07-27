//
//  GameScene.h
//  PompaDroid
//
//  Created by panda zheng on 13-7-11.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameLayer.h"
#import "HudLayer.h"

@interface GameScene : CCScene {
    
}

@property (nonatomic,weak) GameLayer *gameLayer;
@property (nonatomic,weak) HudLayer *hudLayer;

@end

//
//  GameScene.m
//  PompaDroid
//
//  Created by panda zheng on 13-7-11.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"


@implementation GameScene

- (id) init
{
    self = [super init];
    if (self)
    {
        _gameLayer = [GameLayer node];
        [self addChild:_gameLayer z:0];
        _hudLayer = [HudLayer node];
        [self addChild:_hudLayer z:1];
        
        _hudLayer.dPad.delegate = _gameLayer;
        _gameLayer.hud = _hudLayer;
    }
    
    return self;
}

@end

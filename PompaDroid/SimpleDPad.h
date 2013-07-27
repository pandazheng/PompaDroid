//
//  SimpleDPad.h
//  PompaDroid
//
//  Created by panda zheng on 13-7-11.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class SimpleDPad;

@protocol SimpleDPadDelegate <NSObject>

-(void)simpleDPad:(SimpleDPad *)simpleDPad didChangeDirectionTo:(CGPoint)direction;
-(void)simpleDPad:(SimpleDPad *)simpleDPad isHoldingDirection:(CGPoint)direction;
-(void)simpleDPadTouchEnded:(SimpleDPad *)simpleDPad;

@end

@interface SimpleDPad : CCSprite <CCTargetedTouchDelegate>{
    CGPoint _direction;
    float _radius;
}

@property (nonatomic,weak) id <SimpleDPadDelegate> delegate;
@property (nonatomic,assign) BOOL isHeld;

+(id) dPadWithFile: (NSString*) fileName radius: (float) radius;
-(id) initWithFile: (NSString*) fileName radius: (float) radius;

@end

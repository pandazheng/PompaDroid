//
//  SimpleDPad.m
//  PompaDroid
//
//  Created by panda zheng on 13-7-11.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "SimpleDPad.h"


@implementation SimpleDPad

+(id) dPadWithFile:(NSString *)fileName radius:(float)radius
{
    return [[self alloc] initWithFile:fileName radius:radius];
}

-(id) initWithFile:(NSString *)fileName radius:(float)radius
{
    if (self = [super initWithFile:fileName])
    {
        _radius = radius;
        _direction = CGPointZero;
        _isHeld = NO;
        [self scheduleUpdate];
    }
    return self;
}

-(void) onEnterTransitionDidFinish
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:1 swallowsTouches:YES];
}

-(void) onExit
{
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
}

-(void) update: (ccTime) dt
{
    if (_isHeld)
    {
        [_delegate simpleDPad:self didChangeDirectionTo:_direction];
    }
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    
    float distanceSQ = ccpDistanceSQ(location, position_);
    if (distanceSQ <= _radius * _radius)
    {
        [self updateDirectionForTouchLocation: location];
        _isHeld = YES;
        return YES;
    }
    
    return NO;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    [self updateDirectionForTouchLocation: location];
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    _direction = CGPointZero;
    _isHeld = NO;
    [_delegate simpleDPadTouchEnded:self];
}

-(void) updateDirectionForTouchLocation: (CGPoint) location
{
    float radians = ccpToAngle(ccpSub(location, position_));
    float degress = -1 * CC_RADIANS_TO_DEGREES(radians);
    
    if (degress <= 22.5 && degress >= -22.5)
    {
        //right
        _direction = ccp(1.0,0.0);
    }
    else if (degress > 22.5 && degress < 67.5)
    {
        //bottomright
        _direction = ccp(1.0,-1.0);
    }
    else if (degress >= 67.5 && degress <= 112.5)
    {
        //bottom
        _direction = ccp(0.0,-1.0);
    }
    else if (degress > 112.5 && degress < 157.5)
    {
        //bottomleft
        _direction = ccp(-1.0, -1.0);
    }
    else if (degress >= 157.5 || degress <= -157.5)
    {
        //left
        _direction = ccp(-1.0, 0.0);
    }
    else if (degress < -22.5 && degress > -67.5)
    {
        //topright
        _direction = ccp(1.0, 1.0);
    }
    else if (degress <= -67.5 && degress >= -112.5)
    {
        //top
        _direction = ccp(0.0, 1.0);
    }
    else if (degress < -112.5 && degress > -157.5)
    {
        //topleft
        _direction = ccp(-1.0, 1.0);
    }
    [_delegate simpleDPad:self didChangeDirectionTo:_direction];
}

@end

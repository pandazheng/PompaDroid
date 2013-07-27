//
//  ActionSprite.m
//  PompaDroid
//
//  Created by panda zheng on 13-7-11.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "ActionSprite.h"
#import "SimpleAudioEngine.h"


@implementation ActionSprite

- (void) idle
{
    if (_actionState != kActionStateIdle)
    {
        [self stopAllActions];
        [self runAction:_idleAction];
        _actionState = kActionStateIdle;
        _velocity = CGPointZero;
    }
}

- (void) attack
{
    if (_actionState == kActionStateIdle || _actionState == kActionStateAttack || _actionState == kActionStateWalk)
    {
        [self stopAllActions];
        [self runAction:_attackAction];
        _actionState = kActionStateAttack;
    }
}

- (void) hurtWithDamage: (float) damage
{
    if (_actionState != kActionStateKnockedOut)
    {
        int randomSound = random_range(0, 1);
        [[SimpleAudioEngine sharedEngine] playEffect:[NSString stringWithFormat:@"pd_hit%d.caf",randomSound]];
        [self stopAllActions];
        [self runAction:_hurtAction];
        _actionState = kActionStateHurt;
        _hitPoints -= damage;
        
        if (_hitPoints <= 0.0)
        {
            [self knockout];
        }
    }
}

- (void) knockout
{
    [self stopAllActions];
    [self runAction:_knockedOutAction];
    _hitPoints = 0.0;
    _actionState = kActionStateKnockedOut;
}

- (void) walkWithDirection: (CGPoint) direction
{
    if (_actionState == kActionStateIdle)
    {
        [self stopAllActions];
        [self runAction:_walkAction];
        _actionState = kActionStateWalk;
    }
    if (_actionState == kActionStateWalk)
    {
        _velocity = ccp(direction.x * _walkSpeed,direction.y * _walkSpeed);
        if (_velocity.x >= 0)
        {
            self.scaleX = 1.0;
        }
        else
        {
            self.scaleX = -1.0;
        }
    }
}

- (void) update: (ccTime) dt
{
    if (_actionState == kActionStateWalk)
    {
        _desiredPosition = ccpAdd(position_, ccpMult(_velocity, dt));
    }
}

-(BoundingBox) createBoundingBoxWithOrigin:(CGPoint)origin size:(CGSize)size
{
    BoundingBox boundingBox;
    boundingBox.original.origin = origin;
    boundingBox.original.size = size;
    boundingBox.actual.origin = ccpAdd(position_, ccp(boundingBox.original.origin.x,boundingBox.original.origin.y));
    boundingBox.actual.size = size;
    return boundingBox;
}

-(void) transFormBoxes
{
    _hitBox.actual.origin = ccpAdd(position_, ccp(_hitBox.original.origin.x * scaleX_,_hitBox.original.origin.y * scaleY_));
    _hitBox.actual.size = CGSizeMake(_hitBox.original.size.width * scaleX_, _hitBox.original.size.height * scaleY_);
    _attackBox.actual.origin = ccpAdd(position_, ccp(_attackBox.original.origin.x * scaleX_,_attackBox.original.origin.y * scaleY_));
    _attackBox.actual.size = CGSizeMake(_attackBox.original.size.width * scaleX_, _attackBox.original.size.height * scaleY_);
}

-(void) setPosition:(CGPoint)position
{
    [super setPosition:position];
    [self transFormBoxes];
}


@end

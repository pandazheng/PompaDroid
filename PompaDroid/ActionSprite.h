//
//  ActionSprite.h
//  PompaDroid
//
//  Created by panda zheng on 13-7-11.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ActionSprite : CCSprite {
    
}

//actions
//这些是每种状态下要执行的CCActions(Cocos2d动作)。CCActions动作是当角色切换状态时的精灵动画和其它触发事件
@property (nonatomic,strong) id idleAction;
@property (nonatomic,strong) id attackAction;
@property (nonatomic,strong) id walkAction;
@property (nonatomic,strong) id hurtAction;
@property (nonatomic,strong) id knockedOutAction;

//collision boxes
//碰撞大小范围
@property (nonatomic,assign) BoundingBox hitBox;
@property (nonatomic,assign) BoundingBox attackBox;

//states
//保存精灵的当前动作/状态，这里使用ActionState来定义，很快我们将对其进行定义
@property (nonatomic,assign) ActionState actionState;

//attributes
//一些角色属性值，包括精灵的行走速度，受伤时的失血值，以及攻击值
@property (nonatomic,assign) float walkSpeed;
@property (nonatomic,assign) float hitPoints;
@property (nonatomic,assign) float damage;

//movement
//稍后用于计算精灵如何沿着地图运动
@property (nonatomic,assign) CGPoint velocity;
@property (nonatomic,assign) CGPoint desiredPosition;

//measurements
//其中保存的数值和精灵图片的显示有关。之所以要用到这些数值，是因为所使用精灵图片的画布大小要比其中的图像大很多
@property (nonatomic,assign) float centerToSides;
@property (nonatomic,assign) float centerToBottom;

//action methods
//在程序中我们不会直接调用CCActions，而是使用这些方法来触发每种状态
- (void) idle;
- (void) attack;
- (void) hurtWithDamage: (float) damage;
- (void) knockout;
- (void) walkWithDirection: (CGPoint) direction;

//scheduled methods
//以一定时间间隔进行更新的任何其它事情，比如精灵位置和速度的更新，等等
- (void) update: (ccTime) dt;

//collision box factory method
//碰撞检测
-(BoundingBox) createBoundingBoxWithOrigin:(CGPoint) origin size:(CGSize) size;

@end

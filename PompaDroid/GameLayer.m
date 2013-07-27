//
//  GameLayer.m
//  PompaDroid
//
//  Created by panda zheng on 13-7-11.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"
#import "GameScene.h"
#import "SimpleAudioEngine.h"
#import "Robot.h"


@implementation GameLayer

-(id)init
{
    if ((self = [super init]))
    {
        [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"latin_industries.aifc"];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"latin_industries.aifc"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"pd_hit0.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"pd_hit1.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"pd_herodeath.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"pd_botdeath.caf"];
        
        self.isTouchEnabled = YES;
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"pd_sprites.plist"];
        _actors = [CCSpriteBatchNode batchNodeWithFile:@"pd_sprites.pvr.ccz"];
        [_actors.texture setAliasTexParameters];
        [self addChild:_actors z:-5];
        [self initHero];
        [self initTileMap];
        [self initRobots];
        [self scheduleUpdate];
    }
    return self;
}

-(void)initTileMap
{
    _tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"pd_tilemap.tmx"];
    for (CCTMXLayer *child in [_tileMap children]) {
		[[child texture] setAliasTexParameters];
	}
    [self addChild:_tileMap z:-6];
}

-(void)initHero
{
    _hero = [Hero node];
    [_actors addChild:_hero];
    _hero.position = ccp(_hero.centerToSides, 80);
    _hero.desiredPosition = _hero.position;
    [_hero idle];
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_hero attack];
    
    if (_hero.actionState == kActionStateAttack)
    {
        Robot *robot;
        CCARRAY_FOREACH(_robots, robot)
        {
            if (robot.actionState != kActionStateKnockedOut)
            {
                if (fabsf(_hero.position.y - robot.position.y) < 10)
                {
                    if (CGRectIntersectsRect(_hero.attackBox.actual, robot.hitBox.actual))
                    {
                        [robot hurtWithDamage:_hero.damage];
                    }
                }
            }
        }
    }
}

-(void)simpleDPad:(SimpleDPad *)simpleDPad didChangeDirectionTo:(CGPoint)direction
{
    [_hero walkWithDirection:direction];
}

-(void)simpleDPadTouchEnded:(SimpleDPad *)simpleDPad
{
    if (_hero.actionState == kActionStateWalk)
    {
        [_hero idle];
    }
}

-(void)simpleDPad:(SimpleDPad *)simpleDPad isHoldingDirection:(CGPoint)direction
{
    [_hero walkWithDirection:direction];
}

-(void)update:(ccTime)dt
{
    [_hero update:dt];
    [self updateRobots:dt];
    [self updatePositions];
    [self reorderActors];
    [self setViewpointCenter:_hero.position];
}

-(void)reorderActors
{
    ActionSprite *sprite;
    CCARRAY_FOREACH(_actors.children, sprite)
    {
        [_actors reorderChild:sprite z:(_tileMap.mapSize.height * _tileMap.tileSize.height) - sprite.position.y];
    }
}

-(void)updateRobots:(ccTime)dt
{
    int alive = 0;
    Robot *robot;
    float distanceSQ;
    int randomChoice = 0;
    CCARRAY_FOREACH(_robots, robot)
    {
        [robot update:dt];
        if (robot.actionState != kActionStateKnockedOut)
        {
            //1
            alive++;
            
            //2
            if (CURTIME > robot.nextDecisionTime)
            {
                distanceSQ = ccpDistanceSQ(robot.position, _hero.position);
                
                //3
                if (distanceSQ <= 50 * 50)
                {
                    robot.nextDecisionTime = CURTIME + frandom_range(0.1, 0.5);
                    randomChoice = random_range(0, 1);
                    
                    if (randomChoice == 0)
                    {
                        if (_hero.position.x > robot.position.x)
                        {
                            robot.scaleX = 1.0;
                        }
                        else
                        {
                            robot.scaleX = -1.0;
                        }
                        
                        //4
                        [robot attack];
                        if (robot.actionState == kActionStateAttack)
                        {
                            if (fabsf(_hero.position.y - robot.position.y) < 10)
                            {
                                if (CGRectIntersectsRect(_hero.hitBox.actual, robot.attackBox.actual))
                                {
                                    [_hero hurtWithDamage:robot.damage];
                                    
                                    if (_hero.actionState == kActionStateKnockedOut && [_hud getChildByTag:5] == nil)
                                    {
                                        [self endGame];
                                    }
                                }
                            }
                        }
                    }
                    else
                    {
                        [robot idle];
                    }
                }
                else if (distanceSQ <= SCREEN.width * SCREEN.width)
                {
                    //5
                    robot.nextDecisionTime = CURTIME + frandom_range(0.5, 1.0);
                    randomChoice = random_range(0, 2);
                    if (randomChoice == 0)
                    {
                        CGPoint moveDirection = ccpNormalize(ccpSub(_hero.position, robot.position));
                        [robot walkWithDirection:moveDirection];
                    }
                    else
                    {
                        [robot idle];
                    }
                }
            }
        }
    }
    
    if (alive == 0 && [_hud getChildByTag:5] == nil)
    {
        [self endGame];
    }
}

-(void)endGame
{
    CCLabelTTF *restartLabel = [CCLabelTTF labelWithString:@"RESTART" fontName:@"Arial" fontSize:30];
    CCMenuItemLabel *restartItem = [CCMenuItemLabel itemWithLabel:restartLabel target:self selector:@selector(restartGame)];
    CCMenu *menu = [CCMenu menuWithItems:restartItem, nil];
    menu.position = CENTER;
    menu.tag = 5;
    [_hud addChild:menu z:5];
}

-(void)restartGame
{
    [[CCDirector sharedDirector] replaceScene:[GameScene node]];
}

-(void)updatePositions;
{
    float posX = MIN(_tileMap.mapSize.width * _tileMap.tileSize.width - _hero.centerToSides, MAX(_hero.centerToSides, _hero.desiredPosition.x));
    float posY = MIN(3 * _tileMap.tileSize.height + _hero.centerToBottom, MAX(_hero.centerToBottom, _hero.desiredPosition.y));
    _hero.position = ccp(posX, posY);
    
    Robot *robot;
    CCARRAY_FOREACH(_robots, robot)
    {
        posX = MIN(_tileMap.mapSize.width * _tileMap.tileSize.width - robot.centerToSides, MAX(robot.centerToSides, robot.desiredPosition.x));
        posY = MIN(3 * _tileMap.tileSize.height + robot.centerToBottom, MAX(robot.centerToBottom, robot.desiredPosition.y));
        robot.position = ccp(posX, posY);
    }
}

-(void)setViewpointCenter:(CGPoint) position {
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    int x = MAX(position.x, winSize.width / 2);
    int y = MAX(position.y, winSize.height / 2);
    x = MIN(x, (_tileMap.mapSize.width * _tileMap.tileSize.width)
            - winSize.width / 2);
    y = MIN(y, (_tileMap.mapSize.height * _tileMap.tileSize.height)
            - winSize.height/2);
    CGPoint actualPosition = ccp(x, y);
    
    CGPoint centerOfView = ccp(winSize.width/2, winSize.height/2);
    CGPoint viewPoint = ccpSub(centerOfView, actualPosition);
    self.position = viewPoint;
}

-(void)initRobots
{
    int robotCount = 50;
    self.robots = [[CCArray alloc] initWithCapacity:robotCount];
    
    for (int i = 0; i < robotCount; i++)
    {
        Robot *robot = [Robot node];
        [_actors addChild:robot];
        [_robots addObject:robot];
        
        int minX = SCREEN.width + robot.centerToSides;
        int maxX = _tileMap.mapSize.width * _tileMap.tileSize.width - robot.centerToSides;
        int minY = robot.centerToBottom;
        int maxY = 3 * _tileMap.tileSize.height + robot.centerToBottom;
        robot.scaleX = -1;
        robot.position = ccp(random_range(minX, maxX), random_range(minY, maxY));
        robot.desiredPosition = robot.position;
        [robot idle];
    }
}

@end

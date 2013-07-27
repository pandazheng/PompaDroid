//
//  HudLayer.h
//  PompaDroid
//
//  Created by panda zheng on 13-7-11.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleDPad.h"

@interface HudLayer : CCLayer {
    
}

@property (nonatomic,weak) SimpleDPad *dPad;

@end

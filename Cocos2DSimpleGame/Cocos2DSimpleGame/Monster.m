//
//  Monster.m
//  Cocos2DSimpleGame
//
//  Created by Brian Stewart on 6/2/11.
//  Copyright 2011 Brian Stewart. All rights reserved.
//

#import "Monster.h"


@implementation Monster

@synthesize hp = _curHp;
@synthesize minMoveDuration = _minMoveDuration;
@synthesize maxMoveDuration = _maxMoveDuration;

@end

@implementation WeakAndFastMonster

+ (id)monster {
    
    WeakAndFastMonster *monster = nil;
    if ((monster = [[[super alloc] initWithFile:@"Target.jpg"] autorelease])) {
        monster.hp = 1;
        monster.minMoveDuration = 3;
        monster.maxMoveDuration = 5;
    }
    return monster;
}

@end

@implementation StrongAndSlowMonster

+ (id)monster {
    
    StrongAndSlowMonster *monster = nil;
    if ((monster = [[[super alloc] initWithFile:@"Target2.jpg"] autorelease])) {
        monster.hp = 3;
        monster.minMoveDuration = 6;
        monster.maxMoveDuration = 12;
    }
    return monster;
}

@end

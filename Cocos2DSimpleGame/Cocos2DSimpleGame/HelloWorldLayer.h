//
//  HelloWorldLayer.h
//  Cocos2DSimpleGame
//
//  Created by Brian Stewart on 6/1/11.
//  Copyright Brian Stewart 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayerColor
{
    NSMutableArray *_targets;
    NSMutableArray *_projectiles;
    
    CCSprite *_player;
    
    CCSprite *_nextProjectile;
    
    int _projectilesDestroyed;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end

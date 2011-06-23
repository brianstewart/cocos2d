#import "cocos2d.h"
#import "Terrain.h"

@interface HelloWorldLayer : CCLayer
{
	CCSprite * _background;
    
    Terrain *_terrain;
}

+(CCScene *) scene;

@end
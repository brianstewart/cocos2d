
// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

@class HelloWorldLayer;

@interface HelloWorldHud : CCLayer {
    CCLabelTTF *label;
    HelloWorldLayer *_gameLayer;
}
@property (nonatomic, retain) HelloWorldLayer *gameLayer;

-(void)numCollectedChanged:(int)numCollected;
@end


@interface HelloWorldLayer : CCLayer
{
    CCTMXTiledMap *_tileMap;
    CCTMXLayer *_background;
    CCTMXLayer *_foreground;
    CCTMXLayer *_meta;
    
    CCSprite *_player;
    
    HelloWorldHud *_hud;
    
    int _numCollected;
    
    int _mode;
    
    NSMutableArray *_enemies;
    NSMutableArray *_projectiles;
    
}
@property (nonatomic, retain) CCTMXTiledMap *tileMap;
@property (nonatomic, retain) CCTMXLayer *background;
@property (nonatomic, retain) CCTMXLayer *foreground;
@property (nonatomic, retain) CCTMXLayer *meta;
@property (nonatomic, retain) CCSprite *player;
@property (nonatomic, retain) HelloWorldHud *hud;
@property (nonatomic, assign) int numCollected;
@property (nonatomic, assign) int mode;
@property (nonatomic, assign) NSMutableArray *enemies;
@property (nonatomic, assign) NSMutableArray *projectiles;

-(void)animateEnemy:(CCSprite *)enemy;
-(void)win;
-(void)lose;
+(CCScene *) scene;

@end

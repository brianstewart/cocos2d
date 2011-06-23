#import "cocos2d.h"

typedef enum {
    kEndReasonWin,
    kEndReasonLose
} EndReason;

@interface HelloWorldLayer : CCLayer
{
    CCSpriteBatchNode *_batchNode;
    CCParallaxNode *_backgroundNode;
    
    float _shipPointsPerSecY;
    
    CCSprite *_ship;
    CCSprite *_spacedust1;
    CCSprite *_spacedust2;
    CCSprite *_planetsunrise;
    CCSprite *_galaxy;
    CCSprite *_spacialanomaly;
    CCSprite *_spacialanomaly2;
    
    BOOL _alive;
    int _lives;
    
    double _gameOverTime;
    bool _gameOver;
    
    CCArray *_shipLasers;
    int _nextShipLaser;
    
    CCArray *_asteroids;
    int _nextAsteroid;
    double _nextAsteroidSpawn;
}

+(CCScene *) scene;

@end

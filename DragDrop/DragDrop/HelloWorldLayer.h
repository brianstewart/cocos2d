#import "cocos2d.h"

@interface HelloWorldLayer : CCLayer
{
    CCSprite *background;
    CCSprite *selSprite;
    NSMutableArray *movableSprites;
}

+(CCScene *) scene;

-(void)handlePanFrom:(UIPanGestureRecognizer *)recognizer;
-(void)selectSpriteForTouch:(CGPoint)touchLocation;
-(void)panForTranslation:(CGPoint)translation;
-(CGPoint)boundLayerPos:(CGPoint)newPos;
@end

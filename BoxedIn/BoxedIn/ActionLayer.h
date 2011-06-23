#import "cocos2d.h"
#import "chipmunk.h"

@interface ActionLayer : CCLayerColor {
    cpSpace *space;
    cpBody *ballBody;
    CCSprite *ball;
    
    float degrees;
    CGFloat orbit;
    BOOL orbiting;
    CGPoint touchCenter;
}
+(id)scene;
-(void)orbitAround:(CGPoint)center withRadius:(CGFloat)amplitude;
@end

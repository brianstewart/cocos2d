#import "cocos2d.h"

@class HelloWorldLayer;

#define kMaxHillKeyPoints 1000
#define kHillSegmentWidth 10

@interface Terrain : CCNode {
    int _offsetX;
    CGPoint _hillKeyPoints[kMaxHillKeyPoints];
    CCSprite *_stripes;
    
    int _fromKeyPointI;
    int _toKeyPointI;
}

@property (retain) CCSprite *stripes;
-(void)setoffsetX:(float)newOffsetX;

@end

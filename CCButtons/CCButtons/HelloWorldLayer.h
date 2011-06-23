#import "cocos2d.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
    CCLabelTTF *_label;
    
    CCMenuItem *_plusItem; 
    CCMenuItem *_minusItem;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end

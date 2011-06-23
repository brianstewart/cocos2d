#import "cocos2d.h"
#import "chipmunk.h"
#import "cpMouse.h"

#import "CatSprite.h"
#import "SmallBlockSprite.h"
#import "LargeBlockSprite.h"

@interface ActionLayer : CCLayer {
    cpSpace *space;
    cpMouse *mouse;
    
    CCSpriteBatchNode *batchNode;
    CatSprite *cat;
}

+(id)scene;

@end

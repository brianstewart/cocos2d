#import "cocos2d.h"
#import "chipmunk.h"

@interface CPSprite : CCSprite {
    cpBody *body;
    cpShape *shape;
    cpSpace *space;
    BOOL canBeDestroyed;
}
@property (assign) cpBody *body;

- (id)initWithSpace:(cpSpace *)theSpace location:(CGPoint)location spriteFrameName:(NSString *)spriteFrameName;
- (void)update;
- (void)createBodyAtLocation:(CGPoint)location;
- (void)destroy;

@end
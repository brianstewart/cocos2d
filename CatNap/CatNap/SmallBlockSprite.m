#import "SmallBlockSprite.h"

@implementation SmallBlockSprite

- (id)initWithSpace:(cpSpace *)theSpace location:(CGPoint)location {
    if ((self = [super initWithSpace:theSpace location:location spriteFrameName:@"block_1.png"])) {
    }
    return self;
}

@end
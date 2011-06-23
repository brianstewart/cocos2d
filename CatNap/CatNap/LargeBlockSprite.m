#import "LargeBlockSprite.h"

@implementation LargeBlockSprite

- (id)initWithSpace:(cpSpace *)theSpace location:(CGPoint)location {
    if ((self = [super initWithSpace:theSpace location:location spriteFrameName:@"block_2.png"])) {
    }
    return self;
}

@end
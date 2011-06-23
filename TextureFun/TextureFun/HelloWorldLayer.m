#import "HelloWorldLayer.h"

@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	if( (self=[super init])) {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        // Set low pixel format (8-bit) to load the background
        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB565];
        
        // Load the background and add it to the layer
        CCSprite *background = [CCSprite spriteWithFile:@"flower-hd.pvr.ccz"];
        background.anchorPoint = ccp(0, 0);
        [self addChild:background];
        
        // Set the pixel format to 16-bit
        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
        
        // Load the sprite batch node and add it to the layer
        CCSpriteBatchNode *spritesBgNode;
        spritesBgNode = [CCSpriteBatchNode batchNodeWithFile:@"sprites-hd.pvr.ccz"];
        [self addChild:spritesBgNode];
        
        // Load images into the sprite cache
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"sprites-hd.plist"];
        
        // Add each image to the sprite batch
        NSArray *images = [NSArray arrayWithObjects:@"bear_2x2.png", @"bird.png", @"cat.png", @"dog.png", @"turtle.png", @"ooze_2x2.png", nil];
        for (int i = 0; i < images.count; i++) {
            NSString *image = [images objectAtIndex:i];
            float offsetFraction = ((float)(i + 1)) / (images.count + 1);
            CGPoint spriteOffset = ccp(winSize.width * offsetFraction, winSize.height/2);
            CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:image];
            sprite.position = spriteOffset;
            [spritesBgNode addChild:sprite];
        }
        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_Default];
	}
	return self;
}

- (void) dealloc
{
	[super dealloc];
}
@end

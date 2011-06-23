#import "HelloWorldLayer.h"

@implementation HelloWorldLayer

@synthesize bear = _bear;
@synthesize moveAction = _moveAction;
@synthesize walkAction = _walkAction;

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
        
        self.isTouchEnabled = YES;
        
        // Cache the sprite frames and texture
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"AnimBear.plist"];
        
        // Create a sprite batch node
        CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"AnimBear.png"];
        [self addChild:spriteSheet];
        
        // Gather the list of frames
        NSMutableArray *walkAnimFrames = [NSMutableArray array];
        for (int i = 1; i <= 8; ++i) {
            [walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"bear%d.png", i]]];
        }
        
        // Create the animation object
        CCAnimation *walkAnim = [CCAnimation animationWithFrames:walkAnimFrames delay:0.1f];
         
        // Create the sprite and run the animation action
        CGSize winSize = [CCDirector sharedDirector].winSize;
        self.bear = [CCSprite spriteWithSpriteFrameName:@"bear1.png"];
        _bear.position = ccp(winSize.width/2, winSize.height/2);
        self.walkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:walkAnim restoreOriginalFrame:NO]];
        //[_bear runAction:_walkAction];
        [spriteSheet addChild:_bear];


    }
	return self;
}

- (void) dealloc
{
    self.bear = nil;
    self.walkAction = nil;
    [super dealloc];
}


-(void) registerWithTouchDispatcher
{
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	return YES;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
    // Determine the touch location
    CGPoint touchLocation = [touch locationInView:[touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    touchLocation = [self convertToNodeSpace:touchLocation];
    
    // Set the desired velocity
    float bearVelocity = 480.0/3.0;
    
    // Figure out the amount moved in x and y
    CGPoint moveDifference = ccpSub(touchLocation, _bear.position);
    
    // Figure out the actual length moved
    float distanceToMove = ccpLength(moveDifference);
    
    // Figure out how long it will take to move
    float moveDuration = distanceToMove / bearVelocity;
    
    // Flip the animation if necessary
    if (moveDifference.x < 0) {
        _bear.flipX = NO;
    } else {
        _bear.flipX = YES;
    }
    
    // Run the appropriate actions
    [_bear stopAction:_moveAction];
    
    if (!_moving) {
        [_bear runAction:_walkAction];
    }
    
    self.moveAction =  [CCSequence actions:
                        [CCMoveTo actionWithDuration:moveDuration position:touchLocation],
                        [CCCallFunc actionWithTarget:self selector:@selector(bearMoveEnded)],
                        nil];
    
    [_bear runAction:_moveAction];
    _moving = TRUE;
}

-(void)bearMoveEnded {
    [_bear stopAction:_walkAction];
    _moving = FALSE;
}


@end

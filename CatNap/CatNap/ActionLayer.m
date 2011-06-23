#import "ActionLayer.h"
#import "SimpleAudioEngine.h"
#import "drawSpace.h"

@implementation ActionLayer

+ (id)scene {
    CCScene *scene = [CCScene node];
    ActionLayer *layer = [ActionLayer node];
    [scene addChild:layer];
    return scene;
}

// Create virtual space for chipmunk
- (void)createSpace {
    
    // Create new object for the chipmunk virtual space
    space = cpSpaceNew();
    
    // set chipmunk gravity to be nothing along the x-axis and a decent amount on the y-axis
    space->gravity = ccp(0, -750);
    
    // Create the chipmunk static and active hashes
    // Optimization used to speed up collision detection
    // Divides chipmunk space into grid
    // Param: 2 - setting up the size of the grid cell
    // Param: 3 - number of grid cells    
    cpSpaceResizeStaticHash(space, 400, 200);
    cpSpaceResizeActiveHash(space, 200, 200);
}

// Create ground so objects don't keep falling
- (void)createGround {
    
    // Make the ground as a line from the lower left of the screen to the lower right
    CGSize winSize = [CCDirector sharedDirector].winSize;
    CGPoint lowerLeft = ccp(0,0);
    CGPoint lowerRight = ccp(winSize.width, 0);
    
    // Create a new chipmunk body that's static because it never moves
    // Do not have to add static bodies to the screen
    cpBody *groundBody = cpBodyNewStatic();
    
    // Create a new segment shape and associate it to the body just created
    float radius = 10.0;
    cpShape *groundShape = cpSegmentShapeNew(groundBody, lowerLeft, lowerRight, radius);
    
    // Set the elasticity to be somewhat bouncy and the friction to be not very slippery.
    groundShape->e = 0.5;    // Elasticity
    groundShape->u = 1.0;    // Friction
    
    // Add the shape to the chipmunk space
    cpSpaceAddShape(space, groundShape);
}

// Helper method to create a dynamic chipmunk body to the scene 
- (void)createBoxAtLocation:(CGPoint)location {
    
    float boxSize = 60.0;
    float mass = 1.0;
    
    // Create a dynamic body
    // Pass in mass and moment of intertia
    cpBody *body = cpBodyNew(mass, cpMomentForBox(mass, boxSize, boxSize));
    body->p = location;
    cpSpaceAddBody(space, body);
    
    cpShape *shape = cpBoxShapeNew(body, boxSize, boxSize);
    shape->e = 1.0;
    shape->u = 1.0;
    cpSpaceAddShape(space, shape);
}

// call helper method to draw chipmunk objects
//- (void)draw {
//    
//    drawSpaceOptions options = {
//        0, // drawHash
//        0, // drawBBs,
//        1, // drawShapes
//        4.0, // collisionPointSize
//        4.0, // bodyPointSize,
//        2.0 // lineThickness
//    };
//    
//    drawSpace(space, &options);
//}

- (id)init
{
    self = [super init];
    if (self) {
        /*
        CGSize winSize = [CCDirector sharedDirector].winSize;
        CCLabelBMFont *label = [CCLabelBMFont labelWithString:@"Hello, Chipmunk!" fntFile:@"Arial.fnt"];
        label.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:label];
         */
        
        CCSprite *background = [CCSprite spriteWithFile:@"catnap_bg.png"];
        background.anchorPoint = CGPointZero;
        [self addChild:background z:-1];
        
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"TeaRoots.mp3" loop:YES];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"sleep.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"wake.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"poof.wav"];
        
        [self createSpace];
        [self createGround];
        //[self createBoxAtLocation:ccp(100,100)];
        //[self createBoxAtLocation:ccp(200,200)];
        [self scheduleUpdate];
        
        //mouse = cpMouseNew(space);
        self.isTouchEnabled = YES;
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"catnap.plist"];
        batchNode = [CCSpriteBatchNode batchNodeWithFile:@"catnap.png"];
        [self addChild:batchNode];
        
        cat = [[[CatSprite alloc] initWithSpace:space location:ccp(245, 217)] autorelease];
        [batchNode addChild:cat];  
        
        SmallBlockSprite *block1a = [[[SmallBlockSprite alloc] initWithSpace:space location:ccp(213, 47)] autorelease];
        [batchNode addChild:block1a];
        
        SmallBlockSprite *block1b = [[[SmallBlockSprite alloc] initWithSpace:space location:ccp(272, 59)] autorelease];
        [batchNode addChild:block1b];
        
        SmallBlockSprite *block1c = [[[SmallBlockSprite alloc] initWithSpace:space location:ccp(267, 158)] autorelease];
        [batchNode addChild:block1c];
        
        LargeBlockSprite *block2a = [[[LargeBlockSprite alloc] initWithSpace:space location:ccp(270, 102)] autorelease];
        [batchNode addChild:block2a];
        cpBodySetAngle(block2a.body, CC_DEGREES_TO_RADIANS(90));
        
        LargeBlockSprite *block2b = [[[LargeBlockSprite alloc] initWithSpace:space location:ccp(223, 139)] autorelease];
        cpBodySetAngle(block2b.body, CC_DEGREES_TO_RADIANS(90));
        [batchNode addChild:block2b];
        
        LargeBlockSprite *block2c = [[[LargeBlockSprite alloc] initWithSpace:space location:ccp(214, 85)] autorelease];
        [batchNode addChild:block2c];
    }
    
    return self;
}

- (void)update:(ccTime)dt {
    cpSpaceStep(space, dt);
    for (CPSprite *sprite in batchNode.children) {
        [sprite update];
    }
}

- (void)registerWithTouchDispatcher {
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    //cpMouseGrab(mouse, touchLocation, false);
    cpShape *shape = cpSpacePointQueryFirst(space, touchLocation, GRABABLE_MASK_BIT, 0);
    if (shape) {
        CPSprite *sprite = (CPSprite *) shape->data;
        [sprite destroy];
        [[SimpleAudioEngine sharedEngine] playEffect:@"poof.wav"];
    }
    return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    //CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    //cpMouseMove(mouse, touchLocation);
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    //cpMouseRelease(mouse);
}

- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
    //cpMouseRelease(mouse);    
}

@end

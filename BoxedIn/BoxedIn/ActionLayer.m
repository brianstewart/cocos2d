#import "ActionLayer.h"
#import "drawSpace.h"

#define GRAVITY -750

@implementation ActionLayer

+ (id)scene {
    CCScene *scene = [CCScene node];
    ActionLayer *layer = [ActionLayer node];
    [scene addChild:layer];
    return scene;
}

- (void)createSpace {
    space = cpSpaceNew();
    
    space->gravity = ccp(0,GRAVITY);
    
    cpSpaceResizeStaticHash(space, 400, 200);
    cpSpaceResizeActiveHash(space, 200, 200);
}

- (void)createGround {
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    CGPoint lowerLeft = ccp(0, 0);
    CGPoint lowerRight = ccp(winSize.width, 0);
    
    CGPoint upperLeft = ccp(0, winSize.height);
    CGPoint upperRight = ccp(winSize.width, winSize.height);
    
    cpBody *groundBody = cpBodyNewStatic();
    
    cpShape *groundShape;
    
    cpFloat elasticity = 0.65;
    cpFloat friction = 1.0;
    
    cpFloat radius = 10.0;
    
    // Bottom
    groundShape = cpSegmentShapeNew(groundBody, lowerLeft, lowerRight, radius);
    groundShape->e = elasticity; groundShape->u = friction;
    cpSpaceAddStaticShape(space, groundShape);
    // Top
    groundShape = cpSegmentShapeNew(groundBody, upperLeft, upperRight, radius);
    groundShape->e = elasticity; groundShape->u = friction;
    cpSpaceAddStaticShape(space, groundShape);
    // Left
    groundShape = cpSegmentShapeNew(groundBody, lowerLeft, upperLeft, radius);
    groundShape->e = elasticity; groundShape->u = friction;
    cpSpaceAddStaticShape(space, groundShape);
    // Right
    groundShape = cpSegmentShapeNew(groundBody, lowerRight, upperRight, radius);
    groundShape->e = elasticity; groundShape->u = friction;
    cpSpaceAddStaticShape(space, groundShape);
}

- (void)createWorld {
    [self createSpace];
    [self createGround];
}

- (void)draw {
    
     drawSpaceOptions options = {
     0, // drawHash
     0, // drawBBs,
     1, // drawShapes
     4.0, // collisionPointSize
     4.0, // bodyPointSize,
     2.0 // lineThickness
     };
     
    drawSpace(space, &options);
}

- (id)init
{
    if (self = [super initWithColor:ccc4(150, 150, 255, 255)]) {
        cpInitChipmunk();
        
        [self createWorld];
        
        // Circle
        cpFloat radius = 15.0;
        ballBody = cpBodyNew(1.0, cpMomentForCircle(1.0, radius, radius, cpvzero));
        ballBody->p = ccp(200,300);
        cpSpaceAddBody(space, ballBody);
        
        cpShape *ballShape = cpCircleShapeNew(ballBody, radius, ccp(0,0));
        ballShape->e = 1.0; ballShape->u = 0.5;
        cpSpaceAddShape(space, ballShape);
        
        // Square
        
//        // Line
//        cpBody *lineBody = cpBodyNew(1.0, cpMomentForSegment(1.0, ccp(10,100), ccp(280,200)));
//        lineBody->p = ccp(150,150);
//        
//        cpShape *lineShape = cpSegmentShapeNew(lineBody, ccp(10,100), ccp(280,200), 10.0);
//        lineShape->e = 0.0; lineShape->u = 0.75;
//        cpSpaceAddShape(space, lineShape);
        
        degrees = 0;
        orbit = 0;
        orbiting = NO;
        
        [self scheduleUpdate];
    }
    return self;
}

- (void)update:(ccTime)dt {
    cpSpaceStep(space, dt);
    degrees += CC_DEGREES_TO_RADIANS(5);
    [self orbitAround:touchCenter withRadius:orbit];
}

- (void)orbitAround:(CGPoint)center withRadius:(CGFloat)amplitude {
    
    if (!orbiting) return;
    
    // Orbit around given point
    ballBody->p.x = ( (amplitude) * cosf(degrees) + center.x );
    ballBody->p.y = ( (amplitude) * sinf(degrees) + center.y );
    
    // Stop gravity from acting on it
    ballBody->v = ccp(0,0);
}

- (void)pan:(id)sender {
    
    UIPanGestureRecognizer *recognizer = (UIPanGestureRecognizer *)sender;
    CGPoint touchLocation;
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        ballBody->v = ccp(0,0);
        touchLocation = [recognizer locationInView:recognizer.view];
        touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
        touchLocation = [self convertToNodeSpace:touchLocation];
        ballBody->p = touchLocation;
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        touchLocation = [recognizer locationInView:recognizer.view];
        touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
        touchLocation = [self convertToNodeSpace:touchLocation];
        ballBody->p = touchLocation;
        ballBody->v = ccp(0,0);
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        cpFloat filter = 0.25;
        CGPoint velocity = [recognizer velocityInView:recognizer.view];
        CGPoint newVelocity = ccp ((filter) * velocity.x, (filter) * velocity.y);
        
        NSLog(@"old velocity x: %f", newVelocity.x);
        NSLog(@"old velocity y: %f", newVelocity.y);
        
        newVelocity = [[CCDirector sharedDirector] convertToGL:newVelocity];
        newVelocity = [self convertToNodeSpace:newVelocity];
        
        newVelocity.y *= filter * 3;
        
        if (newVelocity.y < 0) {
            newVelocity.y *= 3.0;
        }
        
        NSLog(@"velocity x: %f", newVelocity.x);
        NSLog(@"velocity y: %f", newVelocity.y);
        
        ballBody->v = newVelocity;
    }
}

- (void)pressure:(id)sender {
    UILongPressGestureRecognizer *recognizer = (UILongPressGestureRecognizer *)sender;
    CGPoint touchLocation;
    
    touchLocation = [recognizer locationInView:recognizer.view];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    touchLocation = [self convertToNodeSpace:touchLocation];
    touchCenter = touchLocation;
    
//    [self orbitAround:touchCenter];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        orbiting = YES;
        orbit = 100.0;
        ballBody->v = ccp(0,0);
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        ballBody->v = ccp(0,0);
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        orbiting = NO;
        cpFloat vEnd = ( (2 * M_PI * orbit) / 1.0 );
        ballBody->v = ccp(vEnd,vEnd);
    }
}

@end

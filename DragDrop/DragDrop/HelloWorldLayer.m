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
        
        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB565];
        background = [CCSprite spriteWithFile:@"blue-shooting-stars.png"];
        background.anchorPoint = ccp(0, 0);
        [self addChild:background];
        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_Default];
        
        movableSprites = [[NSMutableArray alloc] init];
        NSArray *images = [NSArray arrayWithObjects:@"bird.png", @"cat.png", @"dog.png", @"turtle.png", nil];
        for (int i = 0; i < images.count; i++) {
            NSString *image = [images objectAtIndex:i];
            CCSprite *sprite = [CCSprite spriteWithFile:image];
            float offsetFraction = ((float)(i+1))/(images.count+1);
            sprite.position = ccp(winSize.width*offsetFraction, winSize.height/2);
            [self addChild:sprite];
            [movableSprites addObject:sprite];
        }
        // Uncomment to recognize single touch methods
        // Not needed because this app instead recognizes gestures
        //[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	}
	return self;
}

- (void) dealloc
{
    [movableSprites release];
    movableSprites = nil;
    [super dealloc];
}

// Handles a single touch began event
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {    
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    [self selectSpriteForTouch:touchLocation];      
    return TRUE;    
}

// Handles a single touch moved event
- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {       
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
    CGPoint oldTouchLocation = [touch previousLocationInView:touch.view];
    oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
    oldTouchLocation = [self convertToNodeSpace:oldTouchLocation];
    
    CGPoint translation = ccpSub(touchLocation, oldTouchLocation);    
    [self panForTranslation:translation];    
}

// Handles a pan gesture
- (void)handlePanFrom:(UIPanGestureRecognizer *)recognizer {
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {    
        
        CGPoint touchLocation = [recognizer locationInView:recognizer.view];
        touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
        touchLocation = [self convertToNodeSpace:touchLocation];                
        [self selectSpriteForTouch:touchLocation];
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {    
        
        CGPoint translation = [recognizer translationInView:recognizer.view];
        // -y coord to handle difference between UIKit and OpenGL coord
        translation = ccp(translation.x, -translation.y);
        [self panForTranslation:translation];
        [recognizer setTranslation:CGPointZero inView:recognizer.view];
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        float scrollDuration = 0.2;
        CGSize winSize = [CCDirector sharedDirector].winSize;
        CGPoint velocity = [recognizer velocityInView:recognizer.view];
        CGPoint newPos;
        
//        NSLog(@"velocity x: %f", velocity.x);
//        NSLog(@"velocity y: %f", velocity.y);
        
        if (!selSprite) {         
            newPos = ccpAdd(self.position, ccpMult(velocity, scrollDuration));
            newPos = [self boundLayerPos:newPos];
            
            [self stopAllActions];
            CCMoveTo *moveTo = [CCMoveTo actionWithDuration:scrollDuration position:newPos];            
            [self runAction:[CCEaseInOut actionWithAction:moveTo rate:1]];
        } else {
//            NSLog(@"oldPos y: %f", selSprite.position.y);
            CGPoint newVelocity = ccp(0.4 * velocity.x, 0.4 * -velocity.y);
            newPos = ccpAdd(selSprite.position, ccpMult(newVelocity, scrollDuration));
//            NSLog(@"newPos y: %f", newPos.y);
//            newPos.x = MIN(newPos.x, 0);
//            newPos.x = MAX(newPos.x, -background.contentSize.width+winSize.width);
//            newPos = [self boundLayerPos:newPos];
            
            if (newPos.x <= selSprite.contentSize.width / 2) {
                newPos.x = (selSprite.contentSize.width / 2);
            }
            
            if (newPos.x >= background.contentSize.width - (selSprite.contentSize.width / 2)) {
                newPos.x = (background.contentSize.width - (selSprite.contentSize.width / 2));
            }
            
            if (newPos.y <= selSprite.contentSize.height / 2) {
                newPos.y = (selSprite.contentSize.height / 2);
            }
            
            if (newPos.y >= winSize.height - (selSprite.contentSize.height / 2)) {
                newPos.y = winSize.height - (selSprite.contentSize.height / 2);
            }
            
            [self stopAllActions];
            CCMoveTo *moveTo = [CCMoveTo actionWithDuration:scrollDuration position:newPos];            
            [selSprite runAction:[CCEaseInOut actionWithAction:moveTo rate:1]];
        }
    }
}

// Handles a pinch gesture
- (void)handlePinchFrom:(UIPinchGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        CGPoint touchLocation = [recognizer locationInView:recognizer.view];
        touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
        touchLocation = [self convertToNodeSpace:touchLocation];                
        [self selectSpriteForTouch:touchLocation];
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        selSprite.scale = recognizer.scale;
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        CCScaleTo *scaleTo = nil;
        if (selSprite.scale > 1.5) {
            scaleTo = [CCScaleTo actionWithDuration:0.2 scale:1.5];
        } else if (selSprite.scale < 0.75) {
            scaleTo = [CCScaleTo actionWithDuration:0.2 scale:0.75];
        }
        
        if (!scaleTo) return;
        
        [selSprite runAction:[CCEaseOut actionWithAction:scaleTo rate:1]];
    }
}

// Handles a rotation gesture
// Not implemented
- (void)handleRotationFrom:(UIRotationGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        CGPoint touchLocation = [recognizer locationInView:recognizer.view];
        touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
        touchLocation = [self convertToNodeSpace:touchLocation];                
        [self selectSpriteForTouch:touchLocation];
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
    }
}

// Selects the touched sprite and starts a wiggle animation
- (void)selectSpriteForTouch:(CGPoint)touchLocation {
    CCSprite *newSprite = nil;
    for (CCSprite *sprite in movableSprites) {
        if (CGRectContainsPoint(sprite.boundingBox, touchLocation)) {            
            newSprite = sprite;
            break;
        }
    }    
    if (newSprite != selSprite) {
        [selSprite stopAllActions];
        [selSprite runAction:[CCRotateTo actionWithDuration:0.1 angle:0]];
        CCRotateTo *rotLeft = [CCRotateBy actionWithDuration:0.1 angle:-4.0];
        CCRotateTo *rotCenter = [CCRotateBy actionWithDuration:0.1 angle:0.0];
        CCRotateTo *rotRight = [CCRotateBy actionWithDuration:0.1 angle:4.0];
        CCSequence *rotSeq = [CCSequence actions:rotLeft, rotCenter, rotRight, rotCenter, nil];
        [newSprite runAction:[CCRepeatForever actionWithAction:rotSeq]];            
        selSprite = newSprite;
    }
}

// Pans either the selected sprite or the background
- (void)panForTranslation:(CGPoint)translation {    
    if (selSprite) {
        CGPoint newPos = ccpAdd(selSprite.position, translation);
        selSprite.position = newPos;
    } else {
        CGPoint newPos = ccpAdd(self.position, translation);
        self.position = [self boundLayerPos:newPos];      
    }  
}

// Stops the background from panning past itself
- (CGPoint)boundLayerPos:(CGPoint)newPos {
    CGSize winSize = [CCDirector sharedDirector].winSize;
    CGPoint retval = newPos;
    retval.x = MIN(retval.x, 0);
    retval.x = MAX(retval.x, -background.contentSize.width+winSize.width); 
    retval.y = self.position.y;
    return retval;
}

@end

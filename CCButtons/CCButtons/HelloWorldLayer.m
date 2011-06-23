#import "HelloWorldLayer.h"

// HelloWorldLayer implementation
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
    if( (self=[super init] )) {
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        // Create a label for display purposes
        _label = [[CCLabelTTF labelWithString:@"Last button: None" 
                                   dimensions:CGSizeMake(320, 50) alignment:UITextAlignmentCenter 
                                     fontName:@"Arial" fontSize:32.0] retain];
        _label.position = ccp(winSize.width/2, 
                              winSize.height-(_label.contentSize.height/2));
        [self addChild:_label];
        
        // Standard method to create a button
        CCMenuItem *starMenuItem = [CCMenuItemImage 
                                    itemFromNormalImage:@"ButtonStar.png" selectedImage:@"ButtonStarSel.png" 
                                    target:self selector:@selector(starButtonTapped:)];
        starMenuItem.position = ccp(60, 60);
        CCMenu *starMenu = [CCMenu menuWithItems:starMenuItem, nil];
        starMenu.position = CGPointZero;
        [self addChild:starMenu];
        
        _plusItem = [[CCMenuItemImage itemFromNormalImage:@"ButtonPlus.png" 
                                            selectedImage:@"ButtonPlusSel.png" target:nil selector:nil] retain];
        _minusItem = [[CCMenuItemImage itemFromNormalImage:@"ButtonMinus.png" 
                                             selectedImage:@"ButtonMinusSel.png" target:nil selector:nil] retain];
        CCMenuItemToggle *toggleItem = [CCMenuItemToggle itemWithTarget:self 
                                                               selector:@selector(plusMinusButtonTapped:) items:_plusItem, _minusItem, nil];
        CCMenu *toggleMenu = [CCMenu menuWithItems:toggleItem, nil];
        toggleMenu.position = ccp(60, 120);
        [self addChild:toggleMenu];
        
    }
    return self;
}

- (void)starButtonTapped:(id)sender {
    [_label setString:@"Last button: *"];
}

- (void)plusMinusButtonTapped:(id)sender {  
    CCMenuItemToggle *toggleItem = (CCMenuItemToggle *)sender;
    if (toggleItem.selectedItem == _plusItem) {
        [_label setString:@"Visible button: +"];    
    } else if (toggleItem.selectedItem == _minusItem) {
        [_label setString:@"Visible button: -"];
    }  
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    [_label release];
    [_plusItem release];
    [_minusItem release];
    _label = nil;
    _plusItem = nil;
    _minusItem = nil;
    [super dealloc];
}
@end

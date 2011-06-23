//
//  GameOverScene.h
//  Cocos2DSimpleGame
//
//  Created by Brian Stewart on 6/1/11.
//  Copyright 2011 Brian Stewart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameOverLayer : CCLayerColor {
    CCLabelTTF *_label;
}
@property (nonatomic, retain) CCLabelTTF *label;
@end

@interface GameOverScene : CCScene {
    GameOverLayer *_layer;
}
@property(nonatomic, retain) GameOverLayer *layer;
@end

//
//  AppDelegate.h
//  SpaceGame
//
//  Created by Brian Stewart on 6/5/11.
//  Copyright Brian Stewart 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end

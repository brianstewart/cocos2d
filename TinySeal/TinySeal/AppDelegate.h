//
//  AppDelegate.h
//  TinySeal
//
//  Created by Brian Stewart on 6/15/11.
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

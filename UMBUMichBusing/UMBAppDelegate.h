//
//  UMBAppDelegate.h
//  UMBUMichBusing
//
//  Created by Nathan Riley on 9/10/13.
//  Copyright (c) 2013 Nathan Riley. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UMBDeveloperCreditViewController;
@class UMBRootTabBarViewController;

@interface UMBAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UMBDeveloperCreditViewController *viewController;

@property (strong, nonatomic) UMBRootTabBarViewController* tabBarController;


@end

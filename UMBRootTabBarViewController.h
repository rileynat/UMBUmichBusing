//
//  UMBRootTabBarViewController.h
//  UMBUMichBusing
//
//  Created by Nathan Riley on 9/13/13.
//  Copyright (c) 2013 Nathan Riley. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UMBDeveloperCreditViewController;
@class UMBRoutesRootViewController;
@class UMBStopsTableViewController;

@interface UMBRootTabBarViewController : UITabBarController <UITabBarControllerDelegate>

@property (strong, nonatomic) UMBDeveloperCreditViewController* developerViewController;

@property (strong, nonatomic) UMBRoutesRootViewController* routesRootViewController;

@property (strong, nonatomic) UMBStopsTableViewController* stopsTableViewController;

@end

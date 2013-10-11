//
//  UMBRouteDetailViewController.h
//  UMBUMichBusing
//
//  Created by Nathan Riley on 10/11/13.
//  Copyright (c) 2013 Nathan Riley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UMBRouteDetailViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSDictionary* route;

@end

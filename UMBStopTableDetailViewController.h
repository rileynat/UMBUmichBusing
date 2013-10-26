//
//  UMBStopTableDetailViewController.h
//  UMBUMichBusing
//
//  Created by Nathan Riley on 10/11/13.
//  Copyright (c) 2013 Nathan Riley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UMBStopTableDetailViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSString* stopName;

@property (nonatomic, strong) UIRefreshControl* refreshControl;

- (id)initWithStop:(NSDictionary*)stop;

@end

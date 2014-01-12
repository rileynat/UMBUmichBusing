//
//  UMBStopDetailRootViewController.m
//  UMBUMichBusing
//
//  Created by Nathan Riley on 10/26/13.
//  Copyright (c) 2013 Nathan Riley. All rights reserved.
//

#import "UMBStopDetailRootViewController.h"
#import "UMBStopMapDetailViewController.h"
#import "UMBStopTableDetailViewController.h"
#import "UMBLocationDataModel.h"
#import "UMBXMLDataModel.h"

@interface UMBStopDetailRootViewController () {
    UMBStopMapDetailViewController* _mapViewController;
    UMBStopTableDetailViewController* _tableViewController;
    NSString* _stopName;
    NSDictionary* _stop;
}

@end

@implementation UMBStopDetailRootViewController


- (id)initWithStopName:(NSString*)stopName {
    
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _stopName = stopName;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _stop = [[UMBXMLDataModel defaultXMLDataModel] getStopWithName:_stopName];
    [[UMBLocationDataModel defaultLocationDataModel] removeRouteTraces];
    for (NSDictionary* bus in _stop[@"busses"]) {
        [[UMBLocationDataModel defaultLocationDataModel] traceRouteOnMapWithID:bus[@"id"]];
    }
	_mapViewController = [[UMBStopMapDetailViewController alloc] initWithStop:_stop];
    _tableViewController = [[UMBStopTableDetailViewController alloc] initWithStop:_stop];
    [_mapViewController.view setFrame:CGRectMake([UIScreen mainScreen].bounds.origin.x, [UIScreen mainScreen].bounds.origin.y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 0.5)];
    [_tableViewController.view setFrame:CGRectMake([UIScreen mainScreen].bounds.origin.x, [UIScreen mainScreen].bounds.size.height*0.5, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height*0.5)];
    [self.view addSubview:_mapViewController.view];
    [self.view addSubview:_tableViewController.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

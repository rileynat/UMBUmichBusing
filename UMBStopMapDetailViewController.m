//
//  StopMapDetailViewController.m
//  UMBUMichBusing
//
//  Created by Nathan Riley on 10/12/13.
//  Copyright (c) 2013 Nathan Riley. All rights reserved.
//

#import "UMBStopMapDetailViewController.h"

@interface UMBStopMapDetailViewController () {
    MKMapView* _mapView;
    NSDictionary* _stop;
}

@end

@implementation UMBStopMapDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

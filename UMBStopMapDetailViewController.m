//
//  StopMapDetailViewController.m
//  UMBUMichBusing
//
//  Created by Nathan Riley on 10/12/13.
//  Copyright (c) 2013 Nathan Riley. All rights reserved.
//

#import "UMBStopMapDetailViewController.h"
#import "UMBLocationDataModel.h"

#define OFFSET_FOR_HALF_MAP 0.0008

@interface UMBStopMapDetailViewController () {
    MKMapView* _mapView;
    NSDictionary* _stop;
}

@end

@implementation UMBStopMapDetailViewController

- (id)initWithStop:(NSDictionary*)stop {
    self = [super initWithNibName:nil bundle:nil];
        if ( self ) {
        _stop = stop;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setFrame:[UIScreen mainScreen].bounds];
    _mapView = [[UMBLocationDataModel defaultLocationDataModel] getMapView];
    if ( _mapView ) {
    [[UMBLocationDataModel defaultLocationDataModel] recenterMapAtCoordinates:CLLocationCoordinate2DMake([_stop[@"latitude"] doubleValue] + OFFSET_FOR_HALF_MAP, [_stop[@"longitude"] doubleValue])];
    } else  {
        _mapView = [[MKMapView alloc] init];
    }
    [_mapView setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height * 0.5)];
    [[UMBLocationDataModel defaultLocationDataModel] recenterMapAtCoordinates:CLLocationCoordinate2DMake([_stop[@"latitude"] doubleValue] + OFFSET_FOR_HALF_MAP, [_stop[@"longitude"] doubleValue])];
    [self.view addSubview:_mapView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

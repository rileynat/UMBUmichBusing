//
//  UMBLocationDataModel.m
//  UMBUMichBusing
//
//  Created by Nathan Riley on 9/25/13.
//  Copyright (c) 2013 Nathan Riley. All rights reserved.
//

#import "UMBLocationDataModel.h"

@interface UMBLocationDataModel () {
    CLLocationManager* _locationManager;
}

@end

@implementation UMBLocationDataModel

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    _currentLocation = locations[0];
    NSLog(@"%@", _currentLocation);
}

- (void)setUpLocationServices {
    _locationManager = [CLLocationManager new];
    [_locationManager setDelegate:self];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [_locationManager startUpdatingLocation];
}

+ (UMBLocationDataModel*)defaultLocationDataModel {
    static UMBLocationDataModel* instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [UMBLocationDataModel new];
    });
    
    return instance;
}

@end

//
//  UMBLocationDataModel.h
//  UMBUMichBusing
//
//  Created by Nathan Riley on 9/25/13.
//  Copyright (c) 2013 Nathan Riley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface UMBLocationDataModel : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocation* currentLocation;

- (void)setUpLocationServices;

+ (UMBLocationDataModel*)defaultLocationDataModel;

@end

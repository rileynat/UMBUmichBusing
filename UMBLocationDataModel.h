//
//  UMBLocationDataModel.h
//  UMBUMichBusing
//
//  Created by Nathan Riley on 9/25/13.
//  Copyright (c) 2013 Nathan Riley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface UMBLocationDataModel : NSObject <CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic, strong) CLLocation* currentLocation;

- (void)setUpLocationServices;

- (MKMapView*)getMapView;

- (void)setUpMapView;

- (void)togglePinAnnotationViewWithTitle:(NSString*)title;

- (void)recenterMapAtCoordinates:(CLLocationCoordinate2D)coord;

+ (UMBLocationDataModel*)defaultLocationDataModel;

- (CLLocationCoordinate2D)getUserLocation;

- (void)setUpRouteTraces;

- (void)traceRouteOnMapWithID:(NSString*)idNumber;

- (void)removeRouteTraces;

- (void)getWalkingDistanceFromCurrentLocationTo:(CLLocationCoordinate2D)dest;

@end

//
//  UMBLocationDataModel.m
//  UMBUMichBusing
//
//  Created by Nathan Riley on 9/25/13.
//  Copyright (c) 2013 Nathan Riley. All rights reserved.
//

#import "UMBLocationDataModel.h"
#import "UMBXMLDataModel.h"
#import "UMBStopAnnotation.h"
#import "XMLDictionary.h"


#define METERS_PER_MILE 1609.344

NSString* const kUMBRouteTraceURL = @"http://mbus.pts.umich.edu/shared/map_trace_route_#.xml";

@interface UMBLocationDataModel () {
    CLLocationManager* _locationManager;
    MKMapView* _mapView;
    NSArray* _routeIDArray;
    NSMutableArray* _routeTraceArray;
}

@end

@implementation UMBLocationDataModel

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    _currentLocation = locations[0];
    //NSLog(@"%@", _currentLocation);
    
    if ( !_mapView ) {
        [self setUpMapView];
    }
}

- (void)setUpLocationServices {
    _locationManager = [CLLocationManager new];
    [_locationManager setDelegate:self];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [_locationManager startUpdatingLocation];
    _routeIDArray = [[UMBXMLDataModel defaultXMLDataModel] getRouteIDs];
    [self setUpMapView];
    
    [self getRouteTraceDictionaries];
}

- (void)setUpMapView {
    _mapView = [MKMapView new];
    [_mapView setDelegate:self];
    _mapView.showsUserLocation = YES;
    NSArray* stopArray = [[UMBXMLDataModel defaultXMLDataModel] sortStopsWithLatAndLong];
    for ( NSDictionary* stop in stopArray ) {
        UMBStopAnnotation* annotation = [[UMBStopAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake([stop[@"latitude"] doubleValue], [stop[@"longitude"] doubleValue]) andTitle:stop[@"name"]];
        [_mapView addAnnotation:annotation];
    }
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(_currentLocation.coordinate, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    [_mapView setRegion:region];
    
}

- (MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    static NSString* MyIdentifier = @"CinemaMapAnotation";
    MKPinAnnotationView* pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:MyIdentifier];
    if (!pinView)
    {
        pinView = [[MKPinAnnotationView alloc]
                                        initWithAnnotation:annotation reuseIdentifier:MyIdentifier];
        pinView.draggable = NO;
        pinView.animatesDrop = NO;
        pinView.enabled = YES;
    } else {
        pinView.annotation = annotation;
    }
    
    pinView.pinColor = MKPinAnnotationColorRed;
    pinView.canShowCallout = YES;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [button addTarget:self
               action:@selector(viewDetails:) forControlEvents:UIControlEventTouchUpInside];
    pinView.rightCalloutAccessoryView = button;
    pinView.userInteractionEnabled = YES;
    
    return pinView;
}

- (void)getRouteTraceDictionaries {
    _routeTraceArray = [NSMutableArray new];
    for ( NSString* num in _routeIDArray ) {
        NSString* tempURLString = [kUMBRouteTraceURL stringByReplacingOccurrencesOfString:@"#" withString:num];
        NSString* tempString = [NSString stringWithContentsOfURL:[NSURL URLWithString:tempURLString] encoding:NSUTF8StringEncoding error:nil];
        NSDictionary* tempDict = [NSDictionary dictionaryWithXMLString:tempString];
        [_routeTraceArray addObject:tempDict];
    }
    //NSLog(@"%@", _routeTraceArray);
}

- (void)traceRouteOnMapWithID:(NSString*)idNumber {
    
}

- (void)viewDetails:(id)sender {
    NSLog(@"something pressed");
}

- (CLLocationCoordinate2D)getUserLocation {
    return _currentLocation.coordinate;
}

- (MKMapView*)getMapView {
    return _mapView;
}

- (void)recenterMapAtCoordinates:(CLLocationCoordinate2D)coord {
    if ( _mapView ) {
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
        [_mapView setRegion:region];
    }
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

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
#import "UIColor+VFAdditions.h"


#define METERS_PER_MILE 1609.344

NSString* const kUMBRouteTraceURL = @"http://mbus.pts.umich.edu/shared/map_trace_route_#.xml";

@interface UMBLocationDataModel () {
    CLLocationManager* _locationManager;
    MKMapView* _mapView;
    NSArray* _routeIDArray;
    NSMutableDictionary* _routeTraceDict;
}

@end

@implementation UMBLocationDataModel

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    _currentLocation = locations[0];
    NSLog(@"found location");
    
    if ( !_mapView ) {
        [self setUpMapView];
    }
}

- (void)setUpLocationServices {
    _locationManager = [CLLocationManager new];
    [_locationManager setDelegate:self];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [_locationManager startUpdatingLocation];
    //[self setUpMapView];
    
    
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

- (void)setUpRouteTraces {
    _routeIDArray = [[UMBXMLDataModel defaultXMLDataModel] getRouteIDs];
    [self getRouteTraceDictionaries];
}


- (void)getRouteTraceDictionaries {
    _routeTraceDict = [NSMutableDictionary new];
    for ( NSString* num in _routeIDArray ) {
        NSString* tempURLString = [kUMBRouteTraceURL stringByReplacingOccurrencesOfString:@"#" withString:num];
        NSString* tempString = [NSString stringWithContentsOfURL:[NSURL URLWithString:tempURLString] encoding:NSUTF8StringEncoding error:nil];
        NSDictionary* tempDict = [NSDictionary dictionaryWithXMLString:tempString];
        [_routeTraceDict setObject:tempDict forKey:num];
        //[self traceRouteOnMapWithID:num];
    }
    
}

- (void)traceRouteOnMapWithID:(NSString*)idNumber {
    NSArray* routeArray = _routeTraceDict[idNumber][@"item"];
    [self drawRoute:routeArray withColor:_routeTraceDict[idNumber][@"route_info"][@"color"]];
}

- (void)removeRouteTraces {
//    for (id<MKOverlay> overlayToRemove in _mapView.overlays)
//    {
//        if ([overlayToRemove isKindOfClass:[MKPolyline class]])
//        {
//            [_mapView removeOverlay:overlayToRemove];
//        }
//    }
    [_mapView removeOverlays:_mapView.overlays];
}

- (void)togglePinAnnotationViewWithTitle:(NSString *)title {
    for (UMBStopAnnotation *thisAnnotation in [_mapView annotations] ) {
        if ( [thisAnnotation.title isEqualToString:title] ) {
            if ( !thisAnnotation.selected ) {
                thisAnnotation.selected = YES;
                [_mapView selectAnnotation:thisAnnotation animated:YES];
            } else {
                thisAnnotation.selected = NO;
                [_mapView deselectAnnotation:thisAnnotation animated:NO];
            }
        }
    }
}

- (void) drawRoute:(NSArray *)path withColor:(NSString*)color
{
    
    NSInteger numberOfSteps = path.count;
    
    CLLocationCoordinate2D coordinates[numberOfSteps];
    for (NSInteger index = 0; index < numberOfSteps; index++) {
        NSDictionary *location = [path objectAtIndex:index];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([location[@"latitude"] doubleValue], [location[@"longitude"] doubleValue]);
        
        coordinates[index] = coordinate;
    }
    
    MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:coordinates count:numberOfSteps];
    [polyLine setTitle:color];
    [_mapView addOverlay:polyLine];
    
    
}


- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    polylineView.strokeColor = [UIColor colorWithHexString:overlay.title];
    polylineView.lineWidth = 6.0;
    polylineView.alpha = 0.85;
    [polylineView setNeedsDisplayInMapRect:_mapView.visibleMapRect];
    return polylineView;
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

- (void)getWalkingDistanceFromCurrentLocationTo:(CLLocationCoordinate2D)dest {
    NSString* urlString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/distancematrix/json?origins=%f,%f&destinations= %f,%f&mode=walking&language=en-US&sensor=true", _currentLocation.coordinate.latitude, _currentLocation.coordinate.longitude, dest.latitude, dest.longitude];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* url = [NSURL URLWithString:urlString];
    NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSHTTPURLResponse* r = (NSHTTPURLResponse*)response;
        
        if ( ( [r statusCode] == 200 ) &&
            ( data != nil )  ) {
            
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if ( [json[@"rows"][0][@"elements"][0] objectForKey:@"duration"] ) {
                NSNumber *durationValue = json[@"rows"][0][@"elements"][0][@"duration"][@"value"];
            }
            //NSLog(@"%ld", (long)durationValue);
        }
        if ( [r statusCode] == 400 ) {
            NSLog(@"%@", connectionError);
        }
        NSLog(@"%ld", (long)[r statusCode]);
    }];
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

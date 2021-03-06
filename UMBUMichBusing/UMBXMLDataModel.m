//
//  UMBXMLData.m
//  UMBUMichBusing
//
//  Created by Nathan Riley on 9/10/13.
//  Copyright (c) 2013 Nathan Riley. All rights reserved.
//

#import "UMBXMLDataModel.h"
#import "XMLDictionary.h"
#import "UMBLocationDataModel.h"

NSString* const kUMBLiveArrivalFeedURL = @"http://mbus.pts.umich.edu/shared/public_feed.xml";
NSString* const kUMBStopsURL = @"http://mbus.pts.umich.edu/shared/stops.xml";
NSString* const kAskForRefreshNotificationName = @"kAskForRefreshNotificationSent";
NSString* const kRefreshedDataModelNotificationName = @"kRefreshedDataModelNotificationName";

double distanceBetweenUserLocationAndObjectLocation( double userLatitude, double userLongitude, double objectLatitude, double objectLongitude) {
    return sqrt((objectLatitude - userLatitude)*(objectLatitude - userLatitude) + (objectLongitude - userLongitude)*(objectLongitude - userLongitude));
}

@interface UMBXMLDataModel () {
    NSURL* _xmlPublicFeedURL;
    NSDictionary* _xmlPublicFeedDict;
    NSURL* _xmlStopsURL;
    NSDictionary* _xmlStopsDict;
    NSMutableArray* _closestStopsByName;
    NSArray* _stopsArray;
}

@end

@implementation UMBXMLDataModel

- (id)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDataModelFromServer:) name:kAskForRefreshNotificationName object:nil];
    }
    
    return self;
}


- (void)startParsingData {
    
    NSError* error;
    
    _xmlPublicFeedURL = [NSURL URLWithString:kUMBLiveArrivalFeedURL];
    _xmlStopsURL = [NSURL URLWithString:kUMBStopsURL];
    
    NSString *string = [self getURLContentsStringWithURL:_xmlStopsURL];
    
    _xmlPublicFeedDict = [NSDictionary dictionaryWithXMLString:string];
    
    string = [[NSString alloc] initWithContentsOfURL:_xmlStopsURL encoding:NSUTF8StringEncoding error:&error];
    if ( error ) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error in loading data" message:@"When connecting to the Magic Bus server there was a connection error and the information could not be downloaded. Drag upward on any screen to refresh." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    _xmlStopsDict = [NSDictionary dictionaryWithXMLString:string];
    
    [self getActiveStopsSortedByUserLocation];
    
    [[UMBLocationDataModel defaultLocationDataModel] setUpMapView];
    [[UMBLocationDataModel defaultLocationDataModel] setUpRouteTraces];
}

- (NSString*)getURLContentsStringWithURL:(NSURL*)url {
    return [[NSString alloc] initWithContentsOfURL:_xmlPublicFeedURL encoding:NSUTF8StringEncoding error:NULL];
}

//http://mbus.pts.umich.edu/shared/stops.xml
- (NSDictionary*)getPublicFeedDictionary {
    return _xmlPublicFeedDict;
}

- (NSDictionary*)getStopWithName:(NSString*)stopName {
    NSMutableDictionary* returnStop = [NSMutableDictionary new];
    if ( stopName == nil ) {
#warning change implementation to deal with corner case
        NSLog(@"error sent to get stop as stopName was %@", stopName);
        return nil;
    }
    [returnStop setObject:stopName forKey:@"name"];
    NSString* latitudeStr;
    NSString* longitudeStr;
    
    NSMutableArray* busses = [NSMutableArray new];
    if ( [_xmlPublicFeedDict[@"routecount"]  isEqualToString: @"1"] ) {
        for ( NSDictionary* stop in _xmlPublicFeedDict[@"route"][@"stop"] ) {
            if ( [stop[@"name2"] isEqualToString:stopName] ) {
                NSMutableDictionary* tempDict = [NSMutableDictionary new];
                [tempDict setObject:_xmlPublicFeedDict[@"route"][@"name"] forKey:@"routeName"];
                [tempDict setObject:_xmlPublicFeedDict[@"route"][@"busroutecolor"] forKey:@"color"];
                [tempDict setObject:_xmlPublicFeedDict[@"route"][@"id"] forKey:@"id"];
                latitudeStr = stop[@"latitude"];
                longitudeStr = stop[@"longitude"];
                NSString* toa = [NSString new];
                //                if ( toa != nil ) {
                //                    [tempDict setObject:toa forKey:@"toa1"];
                //                }
                //                toa = [stop objectForKey:@"toa2"];
                //                if ( toa != nil ) {
                //                    [tempDict setObject:toa forKey:@"toa2"];
                //                }
                //                toa = [stop objectForKey:@"toa3"];
                //                if ( toa != nil ) {
                //                    [tempDict setObject:toa forKey:@"toa3"];
                //                }
                toa = [stop objectForKey:@"toacount"];
                if ( toa != nil ) {
                    [tempDict setObject:toa forKey:@"toacount"];
                    for ( int i = 0; i < [toa intValue]; i++ )  {
                        toa = [stop objectForKey:[NSString stringWithFormat:@"toa%d", i + 1]];
                        if ( toa != nil ) {
                            [tempDict setObject:toa forKey:[NSString stringWithFormat:@"toa%d", i+1]];
                        }
                    }
                }
                [busses addObject:tempDict];
            }
        }
    } else {
    for ( NSDictionary* route in _xmlPublicFeedDict[@"route"] ) {
        for ( NSDictionary* stop in route[@"stop"] ) {
            if ( [stop[@"name2"] isEqualToString:stopName] ) {
                NSMutableDictionary* tempDict = [NSMutableDictionary new];
                [tempDict setObject:route[@"name"] forKey:@"routeName"];
                [tempDict setObject:route[@"busroutecolor"] forKey:@"color"];
                [tempDict setObject:route[@"id"] forKey:@"id"];
                latitudeStr = stop[@"latitude"];
                longitudeStr = stop[@"longitude"];
                NSString* toa = [NSString new];
//                if ( toa != nil ) {
//                    [tempDict setObject:toa forKey:@"toa1"];
//                }
//                toa = [stop objectForKey:@"toa2"];
//                if ( toa != nil ) {
//                    [tempDict setObject:toa forKey:@"toa2"];
//                }
//                toa = [stop objectForKey:@"toa3"];
//                if ( toa != nil ) {
//                    [tempDict setObject:toa forKey:@"toa3"];
//                }
                toa = [stop objectForKey:@"toacount"];
                if ( toa != nil ) {
                    [tempDict setObject:toa forKey:@"toacount"];
                    for ( int i = 0; i < [toa intValue]; i++ )  {
                        toa = [stop objectForKey:[NSString stringWithFormat:@"toa%d", i + 1]];
                        if ( toa != nil ) {
                            [tempDict setObject:toa forKey:[NSString stringWithFormat:@"toa%d", i+1]];
                        }
                    }
                }
                [busses addObject:tempDict];
            }
        }
    }
    }
    [returnStop setObject:busses forKey:@"busses"];
    [returnStop setObject:longitudeStr forKey:@"longitude"];
    [returnStop setObject:latitudeStr forKey:@"latitude"];
    return returnStop;
}

- (NSArray*)getStopsForRouteWithName:(NSString *)routeName {
    if ( [_xmlPublicFeedDict[@"routecount"] isEqualToString:@"1"] ) {
        //return _xmlPublicFeedDict[@"route"][@"stop"];
        if ( [_xmlPublicFeedDict[@"route"][@"name"] isEqualToString:routeName] ) {
            return _xmlPublicFeedDict[@"route"][@"stop"];
        }
    }
    for ( NSDictionary* tempDict in _xmlPublicFeedDict[@"route"] ) {
        if ( [tempDict[@"name"] isEqualToString:routeName] ) {
            return tempDict[@"stop"];
        }
    }
    return nil;
}

- (NSString*)getClosestStopName {
    if ( _stopsArray ) {
        return _stopsArray[0];
    }
    NSLog(@"error from closest stop being nil");
    return nil;
}

- (NSArray*)getActiveRoutes {
    if ( [_xmlPublicFeedDict[@"routecount"] isEqualToString:@"1"] ) {
        return [NSArray arrayWithObject:_xmlPublicFeedDict[@"route"]];
    }
    NSArray* tempDict = _xmlPublicFeedDict[@"route"];
    return tempDict;
}

- (NSArray*)getAllBusRouteStops {
    return _xmlStopsDict[@"stop"];
}

- (NSArray*)getActiveStops{
    NSMutableSet* _activeSet = [NSMutableSet new];
    for (NSDictionary* routes in _xmlPublicFeedDict[@"route"]) {
        for (NSDictionary* stop in routes[@"stop"]) {
            [_activeSet addObject:stop[@"name2"]];
        }
    }
    NSArray* returnArray = [_activeSet allObjects];
    
    return [returnArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

- (NSArray*)getActiveStopsSortedByUserLocation {
    NSMutableArray* returnArray = [NSMutableArray new];
    //if (_stopsArray == nil ) {
        _stopsArray = [self sortStopsWithLatAndLong];
        for ( NSDictionary* stop in _stopsArray ) {
            [returnArray addObject:stop[@"name"]];
        }
        _stopsArray = returnArray;
    //}
    CLLocationCoordinate2D userLocation = [[UMBLocationDataModel defaultLocationDataModel] getUserLocation];
    return _stopsArray;

}

- (NSArray*)getStopsNameArray {
    return _stopsArray;
}

- (NSArray*)sortStopsWithLatAndLong {
    NSMutableSet* _activeSet = [NSMutableSet new];
    NSMutableArray* stopsArray = [NSMutableArray new];
    if ([_xmlPublicFeedDict[@"routecount"] isEqual: @"1"] ) {
        NSDictionary* routes = _xmlPublicFeedDict[@"route"];
        for ( NSDictionary* stop in routes[@"stop"] ) {
            if ( ![_activeSet containsObject:stop[@"name2"]] && ![stop[@"toacount"] isEqualToString:@"0"]) {
                [stopsArray addObject:@{@"name": stop[@"name2"], @"latitude": stop[@"latitude"], @"longitude": stop[@"longitude"]}];
            }
            [_activeSet addObject:stop[@"name2"]];
        }

    } else {
        for ( NSDictionary* routes in _xmlPublicFeedDict[@"route"] ) {
            for ( NSDictionary* stop in routes[@"stop"] ) {
                if ( ![_activeSet containsObject:stop[@"name2"]] && ![stop[@"toacount"] isEqualToString:@"0"] ) {
                    [stopsArray addObject:@{@"name": stop[@"name2"], @"latitude": stop[@"latitude"], @"longitude": stop[@"longitude"]}];
                }
                [_activeSet addObject:stop[@"name2"]];
            }
        }
    }
    [stopsArray sortUsingComparator:^NSComparisonResult(NSDictionary* obj1, NSDictionary* obj2) {
        CLLocationCoordinate2D userLocation = [[UMBLocationDataModel defaultLocationDataModel] getUserLocation];
        NSString* latitudeString = obj1[@"latitude"];
        NSString* longitudeString = obj1[@"longitude"];
        double distToObject1 = distanceBetweenUserLocationAndObjectLocation(userLocation.latitude, userLocation.longitude, [latitudeString doubleValue], [longitudeString doubleValue]);
        latitudeString = obj2[@"latitude"];
        longitudeString = obj2[@"longitude"];
        double distToObject2 = distanceBetweenUserLocationAndObjectLocation( userLocation.latitude, userLocation.longitude, [latitudeString doubleValue], [longitudeString doubleValue]);
        if ( distToObject1 > distToObject2 ) {
            return (NSComparisonResult) NSOrderedDescending;
        }
        else {
            return (NSComparisonResult) NSOrderedAscending;
        }
    }];
    
    return stopsArray;
}

- (NSArray*)getRouteIDs {
    NSMutableArray* IDArray = [NSMutableArray new];
    if ( [_xmlPublicFeedDict[@"routecount"] isEqualToString:@"1"] ) {
        [IDArray addObject:_xmlPublicFeedDict[@"route"][@"id"]];
    } else {
        for (NSDictionary* route in _xmlPublicFeedDict[@"route"]) {
            NSString* temp = route[@"id"];
            [IDArray addObject:temp];
        }
    }
    return IDArray;
}

- (void)refreshDataModelFromServer:(id)sender {
    [self startParsingData];
    [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshedDataModelNotificationName object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


+ (UMBXMLDataModel*)defaultXMLDataModel {
    static UMBXMLDataModel* instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [UMBXMLDataModel new];
    });
    
    return instance;
}

@end

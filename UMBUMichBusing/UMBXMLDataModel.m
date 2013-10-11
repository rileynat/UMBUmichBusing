//
//  UMBXMLData.m
//  UMBUMichBusing
//
//  Created by Nathan Riley on 9/10/13.
//  Copyright (c) 2013 Nathan Riley. All rights reserved.
//

#import "UMBXMLDataModel.h"
#import "XMLDictionary.h"

NSString* kUMBLiveArrivalFeedURL = @"http://mbus.pts.umich.edu/shared/public_feed.xml";
NSString* kUMBStopsURL = @"http://mbus.pts.umich.edu/shared/stops.xml";

@interface UMBXMLDataModel () {
    NSURL* _xmlPublicFeedURL;
    NSDictionary* _xmlPublicFeedDict;
    NSURL* _xmlStopsURL;
    NSDictionary* _xmlStopsDict;
    NSMutableArray* _closestStopsByName;
}

@end

@implementation UMBXMLDataModel

- (id)init {
    self = [super init];
    if (self) {
        
    }
    
    return self;
}


- (void)startParsingData {
    
    _xmlPublicFeedURL = [NSURL URLWithString:kUMBLiveArrivalFeedURL];
    _xmlStopsURL = [NSURL URLWithString:kUMBStopsURL];
    
    NSString *string = [[NSString alloc] initWithContentsOfURL:_xmlPublicFeedURL encoding:NSUTF8StringEncoding error:NULL];
    _xmlPublicFeedDict = [NSDictionary dictionaryWithXMLString:string];
    
    string = [[NSString alloc] initWithContentsOfURL:_xmlStopsURL encoding:NSUTF8StringEncoding error:NULL];
    _xmlStopsDict = [NSDictionary dictionaryWithXMLString:string];
    
}

//http://mbus.pts.umich.edu/shared/stops.xml
- (NSDictionary*)getPublicFeedDictionary {
    return _xmlPublicFeedDict;
}


- (NSArray*)getActiveRoutes {
    NSArray* tempDict = _xmlPublicFeedDict[@"route"];
    return tempDict;
}

- (NSArray*)getAllBusRouteStops {
    return _xmlStopsDict[@"stop"];
}

- (NSArray*)getActiveStops{
    NSMutableSet* _activeSet = [NSMutableSet new];
    NSArray* tempArray = _xmlPublicFeedDict[@"route"];
    for (NSDictionary* routes in tempArray) {
        for (NSDictionary* stop in routes[@"stop"]) {
            [_activeSet addObject:stop[@"name2"]];
        }
    }
    NSArray* returnArray = [_activeSet allObjects];
    
    return returnArray;
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

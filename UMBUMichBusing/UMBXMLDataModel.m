//
//  UMBXMLData.m
//  UMBUMichBusing
//
//  Created by Nathan Riley on 9/10/13.
//  Copyright (c) 2013 Nathan Riley. All rights reserved.
//

#import "UMBXMLDataModel.h"
#import "XMLDictionary.h"

NSString* const kUMBLiveArrivalFeedURL = @"http://mbus.pts.umich.edu/shared/public_feed.xml";
NSString* const kUMBStopsURL = @"http://mbus.pts.umich.edu/shared/stops.xml";
NSString* const kAskForRefreshNotificationName = @"kAskForRefreshNotificationSent";
NSString* const kRefreshedDataModelNotificationName = @"kRefreshedDataModelNotificationName";

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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDataModelFromServer:) name:kAskForRefreshNotificationName object:nil];
    }
    
    return self;
}


- (void)startParsingData {
    
    NSError* error;
    
    _xmlPublicFeedURL = [NSURL URLWithString:kUMBLiveArrivalFeedURL];
    _xmlStopsURL = [NSURL URLWithString:kUMBStopsURL];
    
    NSString *string = [[NSString alloc] initWithContentsOfURL:_xmlPublicFeedURL encoding:NSUTF8StringEncoding error:NULL];
    _xmlPublicFeedDict = [NSDictionary dictionaryWithXMLString:string];
    
    string = [[NSString alloc] initWithContentsOfURL:_xmlStopsURL encoding:NSUTF8StringEncoding error:&error];
    if ( error ) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error in loading data" message:@"When connecting to the Magic Bus server there was a connection error and the information could not be downloaded. Drag upward on any screen to refresh." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alertView show];
    }
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

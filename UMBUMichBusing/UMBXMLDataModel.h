//
//  UMBXMLData.h
//  UMBUMichBusing
//
//  Created by Nathan Riley on 9/10/13.
//  Copyright (c) 2013 Nathan Riley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UMBXMLDataModel : NSObject <UIAlertViewDelegate>

extern NSString* const kAskForRefreshNotificationName;
extern NSString* const kRefreshedDataModelNotificationName;

+ (UMBXMLDataModel*)defaultXMLDataModel;

- (void)startParsingData;

- (NSDictionary*)getPublicFeedDictionary;

- (NSArray*)getActiveRoutes;

- (NSArray*)getAllBusRouteStops;

- (NSArray*)getStopsForRouteWithName:(NSString*)routeName;

- (NSDictionary*)getStopWithName:(NSString*)stopName;

- (NSString*)getClosestStopName;

- (NSArray*)getActiveStops;

- (NSArray*)getActiveStopsSortedByUserLocation;

- (NSArray*)getStopsNameArray;

- (NSArray*)sortStopsWithLatAndLong;

- (NSArray*)getRouteIDs;

@end

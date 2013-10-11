//
//  UMBXMLData.h
//  UMBUMichBusing
//
//  Created by Nathan Riley on 9/10/13.
//  Copyright (c) 2013 Nathan Riley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UMBXMLDataModel : NSObject

+ (UMBXMLDataModel*)defaultXMLDataModel;

- (void)startParsingData;

- (NSDictionary*)getPublicFeedDictionary;

- (NSArray*)getActiveRoutes;

- (NSArray*)getAllBusRouteStops;

- (NSArray*)getActiveStops;

@end

//
//  UMBStopAnnotation.h
//  UMBUMichBusing
//
//  Created by Nathan Riley on 10/26/13.
//  Copyright (c) 2013 Nathan Riley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface UMBStopAnnotation : NSObject <MKAnnotation>

-(id)initWithCoordinate:(CLLocationCoordinate2D)coordinate andTitle:(NSString*)title;

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy, readonly) NSString* title;

@property BOOL selected;

@end

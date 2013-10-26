//
//  UMBStopAnnotation.m
//  UMBUMichBusing
//
//  Created by Nathan Riley on 10/26/13.
//  Copyright (c) 2013 Nathan Riley. All rights reserved.
//

#import "UMBStopAnnotation.h"

@interface UMBStopAnnotation () {

}

@end

@implementation UMBStopAnnotation

-(id)initWithCoordinate:(CLLocationCoordinate2D)coordinate andTitle:(NSString*)title {
    self = [super init];
    if ( self ) {
        _coordinate = coordinate;
        [self setTitle:title];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    self.coordinate = newCoordinate;
}

@end

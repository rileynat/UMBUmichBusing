//
//  UMBXMLData.m
//  UMBUMichBusing
//
//  Created by Nathan Riley on 9/10/13.
//  Copyright (c) 2013 Nathan Riley. All rights reserved.
//

#import "UMBXMLData.h"

NSString* kUMBLiveArrivalFeedURL = @"http://mbus.pts.umich.edu/shared/public_feed.xml";

@interface UMBXMLData () {
    NSURL* _xmlPublicFeedURL;
    NSXMLDocument* _xmlPublicFeedDoc;
}

@end

@implementation UMBXMLData

- (id)init {
    self = [super init];
    if (self) {
        
        
        
        
        
        
//        _xmlPublicFeedParser = [[NSXMLParser alloc] initWithContentsOfURL:_xmlPulicFeedURL];
//        [_xmlPublicFeedParser setDelegate:self];
//        BOOL test = [_xmlPublicFeedParser parse];
//        NSLog(@"%d", test);
    }
    
    return self;
}

//- (void)parserDidStartDocument:(NSXMLParser *)parser {
//    
//}


+ (UMBXMLData*)defaultXMLDataModel {
    static UMBXMLData* instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [UMBXMLData new];
    });
    
    return instance;
}

@end

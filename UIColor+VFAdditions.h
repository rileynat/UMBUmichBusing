//
//  UIColor+Moonwalk.h
//  VFMoonWalk
//
//  Created by jmeador on 9/24/12.
//  Copyright (c) 2012 Vectorform. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (VFAdditions)

UIColor * UIColorBlend(UIColor*color1,UIColor*color2,CGFloat ratio);

+(UIColor*)colorWithHexString:(NSString*)hexStr;

+ (UIColor*) colorWithHexRGBValue:(uint32_t)rgbValue alphaComponent:(CGFloat)alpha;

+ (UIColor*) colorWithHexRGBValue:(uint32_t)rgbValue;

// Get RGB components for UIColor (kCGColorSpaceModelMonochrome or kCGColorSpaceModelRGB)
- (void) getRGBAComponents:(CGFloat*)rgbComponents;

@end

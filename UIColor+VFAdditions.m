//
//  UIColor+Moonwalk.m
//  VFMoonWalk
//
//  Created by jmeador on 9/24/12.
//  Copyright (c) 2012 Vectorform. All rights reserved.
//

#import "UIColor+VFAdditions.h"

@implementation UIColor (VFAdditions)


+(UIColor *)colorWithHexString:(NSString *)hexStr{
    
    
    if([hexStr length] < 6)
        return nil;
    
    NSUInteger startIndex = 0;
    
    if ([[hexStr substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"#"])
    {
        if([hexStr length] < 7)
            return nil;
        
        startIndex = 1;
    } else if ( [[hexStr substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"0x"] ) {
        if( ([hexStr length]) < 8) {
            return nil;
        }
        startIndex = 2;
    }
    
    unsigned red   = 0;
    unsigned green = 0;
    unsigned blue  = 0;
    
    NSScanner * scanner;
    
    scanner = [NSScanner scannerWithString:[hexStr substringWithRange:NSMakeRange(startIndex, 2)]];
    [scanner scanHexInt:&red];
    
    scanner = [NSScanner scannerWithString:[hexStr substringWithRange:NSMakeRange(startIndex+2, 2)]];
    [scanner scanHexInt:&green];
    
    scanner = [NSScanner scannerWithString:[hexStr substringWithRange:NSMakeRange(startIndex+4, 2)]];
    [scanner scanHexInt:&blue];
    
        static const CGFloat inverse = 1 / 255.0f;
    
    UIColor *color = [UIColor colorWithRed:(CGFloat)red   * inverse
                                     green:(CGFloat)green * inverse
                                      blue:(CGFloat)blue  * inverse
                                     alpha:1.0f];
    
    return color;
    
}

UIColor * UIColorBlend(UIColor*color1,UIColor*color2,CGFloat ratio)
{
    UIColor * newColor = nil;
    
    if(!color1)
    {
        newColor = color2;
    }
    else if(!color2)
    {
        newColor = color1;
    }
    else if(CGColorEqualToColor(color1.CGColor, color2.CGColor))
    {
        newColor = color1;
    }
    
    if(!newColor)
    {
        ratio = MIN(1.0f,ratio);
        ratio = MAX(0.0f,ratio);
        
        CGFloat color1Components[4]     = {0.0f,0.0f,0.0f,0.0f};
        CGFloat color2Components[4]     = {0.0f,0.0f,0.0f,0.0f};
        
        [color1 getRGBAComponents:color1Components];
        [color2 getRGBAComponents:color2Components];
        
        CGFloat newColorComponents[4] = {0.0f,0.0f,0.0f,0.0f};
        
        for(int i = 0; i < 4; i++)
        {
            newColorComponents[i] = color1Components[i] + ((color2Components[i]-color1Components[i])*ratio);
        }
        
        newColor =  [UIColor colorWithRed:newColorComponents[0]
                                    green:newColorComponents[1]
                                     blue:newColorComponents[2]
                                    alpha:newColorComponents[3]];
    }
    
    return newColor;
}

+ (UIColor*)colorWithHexRGBValue:(uint32_t)rgbValue  alphaComponent:(CGFloat)alpha
{
    static const CGFloat inverse = 1 / 255.0f;
    
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) * inverse
                           green:((float)((rgbValue & 0xFF00) >> 8)) * inverse
                            blue:((float)(rgbValue & 0xFF))* inverse
                           alpha:alpha];
}

+ (UIColor*)colorWithHexRGBValue:(uint32_t)rgbValue;
{
    return [self colorWithHexRGBValue:rgbValue alphaComponent:1.0f];
}

-  (void) getRGBAComponents:(CGFloat*)rgbComponents
{
    int componentCount = CGColorGetNumberOfComponents([self CGColor]);
    
    if(2 == componentCount || 4 == componentCount)
    {
        const CGFloat * components = CGColorGetComponents([self CGColor]);
        
        for(int i = 0; i < 4; i++)
        {
            if(2 == componentCount && i < 3)
            {
                rgbComponents[i] = components[0];
            }
            else
            {
                rgbComponents[i] = components[i];
            }
        }
    }
}

@end

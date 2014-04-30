//
//  AlisaRGBA.m
//  AlisaPaint
//
//  Created by Влад Агиевич on 30.04.14.
//  Copyright (c) 2014 uubo. All rights reserved.
//

#import "AlisaRGBA.h"

@implementation AlisaRGBA

- (instancetype)initWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha
{
    self = [super init];
    if (self) {
        self.red = red;
        self.green = green;
        self.blue = blue;
        self.alpha = alpha;
    }
    return self;
}

NSString *AlisaRGBARed = @"AlisaRGBARed";
NSString *AlisaRGBAGreen = @"AlisaRGBAGreen";
NSString *AlisaRGBABlue = @"AlisaRGBABlue";
NSString *AlisaRGBAAlpha = @"AlisaRGBAAlpha";

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _red = [aDecoder decodeFloatForKey:AlisaRGBARed];
        _green = [aDecoder decodeFloatForKey:AlisaRGBAGreen];
        _blue = [aDecoder decodeFloatForKey:AlisaRGBABlue];
        _alpha = [aDecoder decodeFloatForKey:AlisaRGBAAlpha];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeFloat:self.red forKey:AlisaRGBARed];
    [aCoder encodeFloat:self.green forKey:AlisaRGBAGreen];
    [aCoder encodeFloat:self.blue forKey:AlisaRGBABlue];
    [aCoder encodeFloat:self.alpha forKey:AlisaRGBAAlpha];
}

@end

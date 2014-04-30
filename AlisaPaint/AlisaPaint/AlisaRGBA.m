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

@end

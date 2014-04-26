//
//  AlisaFigure.m
//  AlisaPaint
//
//  Created by Влад Агиевич on 21.04.14.
//  Copyright (c) 2014 uubo. All rights reserved.
//

#import "AlisaFigure.h"

AlisaRGBA AlisaRGBAMake(CGFloat r, CGFloat g, CGFloat b, CGFloat a)
{
    AlisaRGBA rgba;
    rgba.r = r;
    rgba.g = g;
    rgba.b = b;
    rgba.a = a;
    return rgba;
}

@implementation AlisaFigure

- (instancetype)initWithRGBA:(AlisaRGBA)rgba
{
    self = [super init];
    if (self) {
        self.rgba = rgba;
    }
    return self;
}

@end

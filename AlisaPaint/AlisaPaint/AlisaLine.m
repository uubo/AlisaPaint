//
//  AlisaLine.m
//  AlisaPaint
//
//  Created by Влад Агиевич on 21.04.14.
//  Copyright (c) 2014 uubo. All rights reserved.
//

#import "AlisaLine.h"

@implementation AlisaLine

- (instancetype)initWithRGBA:(AlisaRGBA)rgba point1:(CGPoint)point1 point2:(CGPoint)point2
{
    self = [super initWithRGBA:rgba];
    if (self) {
        self.point1 = point1;
        self.point2 = point2;
    }
    return self;
}

@end

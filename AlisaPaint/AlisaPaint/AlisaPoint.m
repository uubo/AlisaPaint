//
//  AlisaPoint.m
//  AlisaPaint
//
//  Created by Влад Агиевич on 21.04.14.
//  Copyright (c) 2014 uubo. All rights reserved.
//

#import "AlisaPoint.h"

@implementation AlisaPoint

#define RADIUS 5

- (instancetype)initWithRGBA:(AlisaRGBA)rgba point:(CGPoint)point
{
    self = [super initWithRGBA:rgba];
    if (self) {
        self.point = point;
    }
    return self;
}

@end

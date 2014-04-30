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

- (instancetype)initWithRGBA:(AlisaRGBA *)rgba point:(CGPoint)point
{
    self = [super initWithRGBA:rgba];
    if (self) {
        _point = point;
    }
    return self;
}

NSString *AlisaPointPoint = @"AlisaPointPoint";

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _point = [aDecoder decodeCGPointForKey:AlisaPointPoint];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeCGPoint:self.point forKey:AlisaPointPoint];
}

@end

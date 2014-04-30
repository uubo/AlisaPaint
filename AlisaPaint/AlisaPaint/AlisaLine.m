//
//  AlisaLine.m
//  AlisaPaint
//
//  Created by Влад Агиевич on 21.04.14.
//  Copyright (c) 2014 uubo. All rights reserved.
//

#import "AlisaLine.h"

@implementation AlisaLine

- (instancetype)initWithRGBA:(AlisaRGBA *)rgba point1:(CGPoint)point1 point2:(CGPoint)point2
{
    self = [super initWithRGBA:rgba];
    if (self) {
        self.point1 = point1;
        self.point2 = point2;
    }
    return self;
}

NSString *AlisaLinePoint1 = @"AlisaLinePoint1";
NSString *AlisaLinePoint2 = @"AlisaLinePoint2";

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _point1 = [aDecoder decodeCGPointForKey:AlisaLinePoint1];
        _point2 = [aDecoder decodeCGPointForKey:AlisaLinePoint2];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeCGPoint:self.point1 forKey:AlisaLinePoint1];
    [aCoder encodeCGPoint:self.point2 forKey:AlisaLinePoint2];
}

@end

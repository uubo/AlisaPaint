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

- (instancetype)initWithColor:(UIColor *)color point:(CGPoint)point
{
    self = [super initWithColor:color];
    if (self) {
        self.point = point;
    }
    return self;
}

- (void)draw
{
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.point
                                                        radius:RADIUS
                                                    startAngle:0
                                                      endAngle:2*M_PI
                                                     clockwise:YES];
    [self.color setFill];
    [path fill];
}

- (void)transform:(CGPoint)currentImagePoint;
{
    CGPoint transformedPoint = CGPointMake(currentImagePoint.x + self.point.x,
                                           currentImagePoint.y + self.point.y);
    self.point = transformedPoint;
}

@end

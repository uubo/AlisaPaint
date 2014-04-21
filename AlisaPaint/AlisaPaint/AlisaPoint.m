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

- (void)draw
{
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.point radius:RADIUS startAngle:0 endAngle:2*M_PI clockwise:YES];
    [path fill];
}

@end

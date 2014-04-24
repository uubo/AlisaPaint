//
//  AlisaLine.m
//  AlisaPaint
//
//  Created by Влад Агиевич on 21.04.14.
//  Copyright (c) 2014 uubo. All rights reserved.
//

#import "AlisaLine.h"

@implementation AlisaLine

- (instancetype)initWithColor:(UIColor *)color point1:(CGPoint)point1 point2:(CGPoint)point2
{
    self = [super initWithColor:color];
    if (self) {
        self.point1 = point1;
        self.point2 = point2;
    }
    return self;
}

- (void)draw
{
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:[AlisaFigure scaledPoint:self.point1]];
    [path addLineToPoint:[AlisaFigure scaledPoint:self.point2]];
    
    [self.color setStroke];
    path.lineWidth *= [AlisaFigure scale];
    [path stroke];
}

@end

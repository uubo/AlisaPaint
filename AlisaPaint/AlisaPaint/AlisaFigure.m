//
//  AlisaFigure.m
//  AlisaPaint
//
//  Created by Влад Агиевич on 21.04.14.
//  Copyright (c) 2014 uubo. All rights reserved.
//

#import "AlisaFigure.h"

@implementation AlisaFigure

- (instancetype)initWithColor:(UIColor *)color
{
    self = [super init];
    if (self) {
        self.color = color;
    }
    return self;
}

- (void)draw
{
    
}

+ (CGFloat)scale
{
    return [UIScreen mainScreen].scale;
}

+ (CGPoint)scaledPoint:(CGPoint)point
{
    return CGPointApplyAffineTransform(point, CGAffineTransformMakeScale([AlisaFigure scale], [AlisaFigure scale]));
}

@end

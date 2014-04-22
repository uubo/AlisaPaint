//
//  AlisaLine.h
//  AlisaPaint
//
//  Created by Влад Агиевич on 21.04.14.
//  Copyright (c) 2014 uubo. All rights reserved.
//

#import "AlisaFigure.h"

@interface AlisaLine : AlisaFigure
@property (nonatomic) CGPoint point1;
@property (nonatomic) CGPoint point2;

- (instancetype)initWithColor:(UIColor *)color point1:(CGPoint)point1 point2:(CGPoint)point2;

@end

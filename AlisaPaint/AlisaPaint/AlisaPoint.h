//
//  AlisaPoint.h
//  AlisaPaint
//
//  Created by Влад Агиевич on 21.04.14.
//  Copyright (c) 2014 uubo. All rights reserved.
//

#import "AlisaFigure.h"

@interface AlisaPoint : AlisaFigure
@property (nonatomic) CGPoint point;

- (instancetype)initWithRGBA:(AlisaRGBA)rgba point:(CGPoint)point;

@end

//
//  AlisaFigure.m
//  AlisaPaint
//
//  Created by Влад Агиевич on 21.04.14.
//  Copyright (c) 2014 uubo. All rights reserved.
//

#import "AlisaFigure.h"

@implementation AlisaFigure

- (instancetype)initWithRGBA:(AlisaRGBA *)rgba
{
    self = [super init];
    if (self) {
        self.rgba = rgba;
    }
    return self;
}

NSString *AlisaFigureRGBA = @"AlisaFigureRGBA";

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _rgba = [aDecoder decodeObjectForKey:AlisaFigureRGBA];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.rgba forKey:AlisaFigureRGBA];
}

@end

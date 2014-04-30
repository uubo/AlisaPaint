//
//  AlisaFigure.h
//  AlisaPaint
//
//  Created by Влад Агиевич on 21.04.14.
//  Copyright (c) 2014 uubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlisaRGBA.h"

@interface AlisaFigure : NSObject <NSCoding>

@property (strong, nonatomic) AlisaRGBA *rgba;

- (instancetype)initWithRGBA:(AlisaRGBA *)rgba;

- (instancetype)initWithCoder:(NSCoder *)aDecoder;
- (void)encodeWithCoder:(NSCoder *)aCoder;

@end
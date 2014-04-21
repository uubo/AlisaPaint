//
//  AlisaFigure.h
//  AlisaPaint
//
//  Created by Влад Агиевич on 21.04.14.
//  Copyright (c) 2014 uubo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlisaFigure : NSObject
@property (strong, nonatomic) UIColor *color;

- (instancetype)initWithColor:(UIColor *)color;
- (void)draw;

@end

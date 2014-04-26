//
//  AlisaFigure.h
//  AlisaPaint
//
//  Created by Влад Агиевич on 21.04.14.
//  Copyright (c) 2014 uubo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct {
    CGFloat r;
    CGFloat g;
    CGFloat b;
    CGFloat a;
} AlisaRGBA;

AlisaRGBA AlisaRGBAMake(CGFloat r, CGFloat g, CGFloat b, CGFloat a);

@interface AlisaFigure : NSObject
@property (nonatomic) AlisaRGBA rgba;

- (instancetype)initWithRGBA:(AlisaRGBA)rgba;

@end

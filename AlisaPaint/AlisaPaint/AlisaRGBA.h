//
//  AlisaRGBA.h
//  AlisaPaint
//
//  Created by Влад Агиевич on 30.04.14.
//  Copyright (c) 2014 uubo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlisaRGBA : NSObject <NSCoding>

@property (nonatomic) CGFloat red;
@property (nonatomic) CGFloat green;
@property (nonatomic) CGFloat blue;
@property (nonatomic) CGFloat alpha;

- (instancetype)initWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

- (instancetype)initWithCoder:(NSCoder *)aDecoder;
- (void)encodeWithCoder:(NSCoder *)aCoder;

@end

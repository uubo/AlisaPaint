//
//  AlisaView.m
//  AlisaPaint
//
//  Created by Влад Агиевич on 18.04.14.
//  Copyright (c) 2014 uubo. All rights reserved.
//

#import "AlisaView.h"

@interface AlisaView ()
@property (strong, nonatomic) NSMutableArray *points;
@end

@implementation AlisaView

- (void)addPoint:(CGPoint)point
{
    NSValue *boxedPoint = [NSValue valueWithBytes:&point objCType:@encode(CGPoint)];
    [self.points addObject:boxedPoint];
    [self setNeedsDisplay];
}

- (NSMutableArray *)points
{
    if (!_points) {
        _points = [[NSMutableArray alloc] init];
    }
    return _points;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#define RADIUS 0.5
#define SIDE 10

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    UIBezierPath *path = [[UIBezierPath alloc] init];
    for (NSValue *boxedPoint in self.points) {
        if (strcmp([boxedPoint objCType], @encode(CGPoint)) == 0) {
            CGPoint center;
            [boxedPoint getValue:&center];
            [path moveToPoint:CGPointMake(center.x+RADIUS, center.y)];
            //[path addArcWithCenter:center radius:RADIUS startAngle:0 endAngle:2*M_PI clockwise:YES];
            [path appendPath:[UIBezierPath bezierPathWithOvalInRect:CGRectMake(center.x-SIDE/2, center.y-SIDE/2, SIDE, SIDE)]];
        }
    }
    [[UIColor redColor] setFill];
    [[UIColor blackColor] setStroke];
    [path fill];
    [path stroke];
}


@end

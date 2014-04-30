//
//  AlisaView.m
//  AlisaPaint
//
//  Created by Влад Агиевич on 18.04.14.
//  Copyright (c) 2014 uubo. All rights reserved.
//

#import "AlisaView.h"
#import "AlisaPoint.h"
#import "AlisaLine.h"

@interface AlisaView ()
@property (strong, nonatomic) NSMutableArray *figures; // of NSValues with CGPoint inside;
@end

@implementation AlisaView

#pragma mark Drawing

- (void)addFigure:(AlisaFigure *)figure
{
    [self.figures addObject:figure];
    
    __weak typeof(self) weakSelf = self;
    dispatch_queue_t onImageDrawingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(onImageDrawingQueue, ^{
        UIGraphicsBeginImageContextWithOptions(weakSelf.bounds.size, NO, [UIScreen mainScreen].scale);
        
        for (AlisaFigure *figure in [weakSelf.figures copy]) {
            [self drawFigure:figure];
        }
        
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            weakSelf.image = newImage;
        });
    });
}

- (void)drawFigure:(AlisaFigure *)figure
{
    if ([figure isMemberOfClass:[AlisaPoint class]]) {
        AlisaPoint *alisaPoint = (AlisaPoint *)figure;
        [self drawPoint:alisaPoint];
    } else if ([figure isMemberOfClass:[AlisaLine class]]){
        AlisaLine *alisaLine = (AlisaLine *)figure;
        [self drawLine:alisaLine];
    }
}

#define RADIUS 5

- (void)drawPoint:(AlisaPoint *)alisaPoint
{
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:alisaPoint.point
                                                        radius:RADIUS
                                                    startAngle:0
                                                      endAngle:2*M_PI
                                                     clockwise:YES];
    UIColor *color = [UIColor colorWithRed:alisaPoint.rgba.red
                                     green:alisaPoint.rgba.green
                                      blue:alisaPoint.rgba.blue
                                     alpha:alisaPoint.rgba.alpha];
    [color setFill];
    [path fill];
}

- (void)drawLine:(AlisaLine *)alisaLine
{
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:alisaLine.point1];
    [path addLineToPoint:alisaLine.point2];
    
    UIColor *color = [UIColor colorWithRed:alisaLine.rgba.red
                                     green:alisaLine.rgba.green
                                      blue:alisaLine.rgba.blue
                                     alpha:alisaLine.rgba.alpha];
    [color setStroke];
    [path stroke];
}

#pragma mark Initialization

- (void)awakeFromNib
{
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(screenSize.width * 4, screenSize.height * 4), NO, [UIScreen mainScreen].scale);
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self sizeToFit];
}

- (NSMutableArray *)figures
{
    if (!_figures) {
        _figures = [[NSMutableArray alloc] init];
    }
    return _figures;
}

@end

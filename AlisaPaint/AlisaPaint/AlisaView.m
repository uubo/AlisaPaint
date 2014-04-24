//
//  AlisaView.m
//  AlisaPaint
//
//  Created by Влад Агиевич on 18.04.14.
//  Copyright (c) 2014 uubo. All rights reserved.
//

#import "AlisaView.h"

@interface AlisaView ()
@property (strong, nonatomic) NSMutableArray *figures; // of NSValues with CGPoint inside;
@property (readwrite, nonatomic) CGFloat scale;
@end

@implementation AlisaView

- (void)addFigure:(AlisaFigure *)figure
{
    [self.figures addObject:figure];
    //[self setNeedsDisplay];
    
    __weak typeof(self) weakSelf = self;
    dispatch_queue_t onImageDrawingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(onImageDrawingQueue, ^{
        UIGraphicsBeginImageContext(CGSizeApplyAffineTransform(weakSelf.bounds.size,
                                                               CGAffineTransformMakeScale([AlisaFigure scale], [AlisaFigure scale])));
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        UIGraphicsPushContext(context);
        for (AlisaFigure *figure in weakSelf.figures) {
            [figure draw];
        }
        UIGraphicsPopContext();
        
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            weakSelf.image = newImage;
        });
    });
}

- (NSMutableArray *)figures
{
    if (!_figures) {
        _figures = [[NSMutableArray alloc] init];
    }
    return _figures;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

/*
- (void)drawRect:(CGRect)rect
{
    for (AlisaFigure *figure in self.figures) {
        [figure draw];
    }
}*/


@end

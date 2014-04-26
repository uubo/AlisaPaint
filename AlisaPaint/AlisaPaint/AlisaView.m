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
@end

@implementation AlisaView


- (NSMutableArray *)figures
{
    if (!_figures) {
        _figures = [[NSMutableArray alloc] init];
    }
    return _figures;
}

- (void)addFigure:(AlisaFigure *)figure
{
    [self.figures addObject:figure];
    
    __weak typeof(self) weakSelf = self;
    dispatch_queue_t onImageDrawingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(onImageDrawingQueue, ^{
        UIGraphicsBeginImageContextWithOptions(weakSelf.bounds.size, NO, [UIScreen mainScreen].scale);
        
        for (AlisaFigure *figure in weakSelf.figures) {
            [figure draw];
        }
        
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            weakSelf.image = newImage;
        });
    });
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


@end

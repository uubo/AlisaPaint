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
@property (strong, nonatomic) UIImage *baseImage;
@property (nonatomic) CGRect currentImageRect;
@end

@implementation AlisaView

- (UIImage *)baseImage
{
    if (!_baseImage) {
        _baseImage = [[UIImage alloc] init];
    }
    return _baseImage;
}

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
        UIGraphicsBeginImageContext([AlisaFigure scaledSize:weakSelf.bounds.size]);
        
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

- (void)move:(CGPoint)translation
{
    CGRect newRect = CGRectMake(self.currentImageRect.origin.x + translation.x,
                                self.currentImageRect.origin.y + translation.y,
                                self.currentImageRect.size.width,
                                self.currentImageRect.size.height);
    self.currentImageRect = newRect;
    [self resetImage];
}

- (void)scale:(CGFloat)scale
{
    CGFloat scaledWidth = self.currentImageRect.size.width / scale;
    CGFloat scaledHeight = self.currentImageRect.size.height / scale;
    CGRect newRect = CGRectMake(self.currentImageRect.origin.x + (self.currentImageRect.size.width - scaledWidth)/2,
                                self.currentImageRect.origin.y + (self.currentImageRect.size.height - scaledHeight)/2,
                                scaledWidth,
                                scaledHeight);
    self.currentImageRect = newRect;
    [self resetImage];
}

- (void)resetImage
{
    CGImageRef newImage = CGImageCreateWithImageInRect(self.baseImage.CGImage, self.currentImageRect);
    self.image = [UIImage imageWithCGImage:newImage];
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

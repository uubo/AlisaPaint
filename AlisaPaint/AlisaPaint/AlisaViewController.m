//
//  AlisaViewController.m
//  AlisaPaint
//
//  Created by Влад Агиевич on 17.04.14.
//  Copyright (c) 2014 uubo. All rights reserved.
//

#import "AlisaViewController.h"
#import "AlisaView.h"
#import "AlisaPoint.h"
#import "AlisaLine.h"

@interface AlisaViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPanGestureRecognizer *panRecognizer;
@property (weak, nonatomic) IBOutlet AlisaView *alisaView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *figureButtons;
@property (nonatomic) AlisaFigureType figureType;
@property (strong, nonatomic) UIColor *activeColor;
@end

@implementation AlisaViewController

- (void)setScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 4.0;
    self.scrollView.delegate = self;
    CGSize boundsSize = self.alisaView.bounds.size;
    CGSize imageSize = self.alisaView.image.size;
    self.scrollView.contentSize = self.alisaView ? self.alisaView.image.size : CGSizeZero;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.alisaView;
}

- (IBAction)tap:(UITapGestureRecognizer *)sender
{
    CGPoint gesturePoint = [sender locationInView:self.alisaView];
    
    switch (self.figureType) {
        case AlisaPointType:
            [self.alisaView addFigure:[[AlisaPoint alloc]initWithColor:self.activeColor point:gesturePoint]];
            break;
            
        default:
            break;
    }
}

- (IBAction)pan:(UIPanGestureRecognizer *)recognizer
{
    static CGPoint firstPoint;
    CGPoint gesturePoint = [recognizer locationInView:self.alisaView];
    
    switch (self.figureType) {
        case AlisaLineType:
            if (recognizer.state == UIGestureRecognizerStateBegan) {
                firstPoint = gesturePoint;
            } else if (recognizer.state == UIGestureRecognizerStateChanged) {
                AlisaLine *line = [[AlisaLine alloc]initWithColor:self.activeColor
                                                           point1:firstPoint
                                                           point2:gesturePoint];
                [self.alisaView addFigure:line];
                firstPoint = gesturePoint;
            } else if (recognizer.state == UIGestureRecognizerStateEnded) {
                AlisaLine *line = [[AlisaLine alloc]initWithColor:self.activeColor
                                                           point1:firstPoint
                                                           point2:gesturePoint];
                [self.alisaView addFigure:line];
            }
            break;
            
        default:
            break;
    }
}

- (IBAction)colorChosen:(UIButton *)sender
{
    self.activeColor = sender.backgroundColor;
}

- (IBAction)figureChosen:(UIButton *)sender
{
    self.scrollView.scrollEnabled = NO;
    self.panRecognizer.enabled = YES;
    int index = [self.figureButtons indexOfObject:sender];
    switch (index) {
        case 0:
            self.figureType = AlisaMoveType;
            self.scrollView.scrollEnabled = YES;
            self.panRecognizer.enabled = NO;
            break;
        case 1: self.figureType = AlisaPointType; break;
        case 2: self.figureType = AlisaLineType; break;
        default: break;
    }
}

@end

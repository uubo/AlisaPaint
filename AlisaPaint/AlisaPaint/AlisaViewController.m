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

@interface AlisaViewController ()
@property (weak, nonatomic) IBOutlet AlisaView *alisaView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *figureButtons;
@property (nonatomic) AlisaFigureType figureType;
@property (strong, nonatomic) UIColor *activeColor;
@end

@implementation AlisaViewController


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

- (IBAction)pan:(UIPanGestureRecognizer *)sender
{
    static CGPoint firstPoint;
    CGPoint gesturePoint = [sender locationInView:self.alisaView];
    
    switch (self.figureType) {
        case AlisaLineType:
            if (sender.state == UIGestureRecognizerStateBegan) {
                firstPoint = gesturePoint;
            } else if (sender.state == UIGestureRecognizerStateChanged) {
                AlisaLine *line = [[AlisaLine alloc]initWithColor:self.activeColor
                                                           point1:firstPoint
                                                           point2:gesturePoint];
                [self.alisaView addFigure:line];
                firstPoint = gesturePoint;
            } else if (sender.state == UIGestureRecognizerStateEnded) {
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
    int index = [self.figureButtons indexOfObject:sender];
    switch (index) {
        case 0:
            self.figureType = AlisaPointType;
            break;
        case 1:
            self.figureType = AlisaLineType;
        default:
            break;
    }
}

@end

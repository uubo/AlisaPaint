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

@interface AlisaViewController ()
@property (weak, nonatomic) IBOutlet AlisaView *alisaView;
@property (strong, nonatomic) UIColor *activeColor;
@end

@implementation AlisaViewController

- (UIColor *)activeColor
{
    if (!_activeColor) {
        _activeColor = [UIColor blackColor];
    }
    return _activeColor;
}

- (IBAction)tap:(UITapGestureRecognizer *)sender
{
    CGPoint gesturePoint = [sender locationInView:self.alisaView];
    [self.alisaView addFigure:[[AlisaPoint alloc] initWithColor:self.activeColor point:gesturePoint]];
}

- (IBAction)pan:(UIPanGestureRecognizer *)sender
{
    /*CGPoint gesturePoint = [sender locationInView:self.gameView];
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self attachDroppingViewToPoint:gesturePoint];
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        self.attachment.anchorPoint = gesturePoint;
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        [self.animator removeBehavior:self.attachment];
    }*/
    //CGPoint gesturePoint = [sender locationInView:self.alisaView];
    //[self.alisaView addPoint:gesturePoint];
}

- (IBAction)colorChosen:(UIButton *)sender
{
    self.activeColor = sender.backgroundColor;
}

@end

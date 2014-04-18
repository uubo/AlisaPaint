//
//  AlisaViewController.m
//  AlisaPaint
//
//  Created by Влад Агиевич on 17.04.14.
//  Copyright (c) 2014 uubo. All rights reserved.
//

#import "AlisaViewController.h"
#import "AlisaView.h"

@interface AlisaViewController ()
@property (weak, nonatomic) IBOutlet AlisaView *alisaView;

@end

@implementation AlisaViewController

- (IBAction)tap:(UITapGestureRecognizer *)sender
{
    CGPoint touchPoint = [sender locationInView:self.alisaView];
    [self.alisaView addPoint:touchPoint];
}

@end

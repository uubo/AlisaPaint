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

- (void)addFigure:(AlisaFigure *)figure
{
    [self.figures addObject:figure];
    [self setNeedsDisplay];
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
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    for (AlisaFigure *figure in self.figures) {
        [figure draw];
    }
}


@end

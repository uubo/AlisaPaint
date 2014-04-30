//
//  AlisaView.h
//  AlisaPaint
//
//  Created by Влад Агиевич on 18.04.14.
//  Copyright (c) 2014 uubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlisaFigure.h"

@interface AlisaView : UIImageView

- (void)addFigure:(AlisaFigure *)figure;
- (void)addFigures:(NSArray *)figures;
- (void)drawFigure:(AlisaFigure *)figure;

@end

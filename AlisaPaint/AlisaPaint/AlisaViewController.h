//
//  AlisaViewController.h
//  AlisaPaint
//
//  Created by Влад Агиевич on 17.04.14.
//  Copyright (c) 2014 uubo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    AlisaMoveType,
    AlisaPointType,
    AlisaLineType,
    AlisaRectType,
} AlisaFigureType;

@interface AlisaViewController : UIViewController

@end

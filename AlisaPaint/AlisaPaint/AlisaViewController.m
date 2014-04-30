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

@interface AlisaViewController () <UIScrollViewDelegate, NSStreamDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet AlisaView *alisaView;
@property (weak, nonatomic) IBOutlet UIPanGestureRecognizer *panRecognizer;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *figureButtons;

@property (nonatomic) AlisaFigureType figureType;
@property (strong, nonatomic) UIColor *activeColor;
@property (nonatomic) NSUInteger freshIndex;

@property (strong, nonatomic) NSInputStream *inputStream;
@property (strong, nonatomic) NSOutputStream *outputStream;
@end

@implementation AlisaViewController

- (IBAction)sendButtonTouched
{
    NSArray *figuresToSend = [self.alisaView figuresFromIndex:self.freshIndex];
    [self sendFigures:figuresToSend];
    self.freshIndex += figuresToSend.count;
}

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    
	switch (streamEvent) {
            
		case NSStreamEventOpenCompleted:
			NSLog(@"Stream opened");
			break;
            
		case NSStreamEventHasBytesAvailable:
            if (theStream == self.inputStream) {
                
                uint8_t buffer[1024];
                int len;
                
                while ([self.inputStream hasBytesAvailable]) {
                    len = [self.inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        NSData *receivedData = [NSData dataWithBytes:buffer length:len];
                        [self receiveFigures:receivedData];
                    }
                }
            }
			break;
            
		case NSStreamEventErrorOccurred:
			NSLog(@"Can not connect to the host!");
			break;
            
		case NSStreamEventEndEncountered:
			break;
            
		default:
			NSLog(@"Unknown event");
	}
    
}

- (void)initNetworkCommunication {
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"localhost", 10022, &readStream, &writeStream);
    self.inputStream = (__bridge NSInputStream *)readStream;
    self.outputStream = (__bridge NSOutputStream *)writeStream;
    
    [self.inputStream setDelegate:self];
    [self.outputStream setDelegate:self];
    
    [self.inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [self.inputStream open];
    [self.outputStream open];
}

- (void)receiveFigures:(NSData *)figuresData
{
    NSArray *figures = [NSKeyedUnarchiver unarchiveObjectWithData:figuresData];
    [self.alisaView addFigures:figures];
}

- (void)sendFigures:(NSArray *)figures
{
    NSData *figuresData = [NSKeyedArchiver archivedDataWithRootObject:figures];
    [self.outputStream write:[figuresData bytes] maxLength:[figuresData length]];
}

#define SCREEN_SCALE_FACTOR 4

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNetworkCommunication];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGSize imageSize = CGSizeMake(screenSize.width * SCREEN_SCALE_FACTOR, screenSize.height * SCREEN_SCALE_FACTOR);
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
    UIImage *startImage = UIGraphicsGetImageFromCurrentImageContext();
    self.alisaView.image = startImage;
    UIGraphicsEndImageContext();
    [self.alisaView sizeToFit];
    
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 4.0;
    self.scrollView.delegate = self;
    self.scrollView.contentSize = imageSize;
}

- (UIColor *)activeColor
{
    if (!_activeColor) {
        _activeColor = [UIColor blackColor];
    }
    return _activeColor;
}
- (AlisaRGBA *)activeColorRGBA
{
    CGFloat r, g, b, a;
    [self.activeColor getRed:&r green:&g blue:&b alpha:&a];
    return [[AlisaRGBA alloc] initWithRed:r green:g blue:b alpha:a];
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
            [self.alisaView addFigure:[[AlisaPoint alloc]initWithRGBA:[self activeColorRGBA] point:gesturePoint]];
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
                AlisaLine *line = [[AlisaLine alloc]initWithRGBA:[self activeColorRGBA]
                                                          point1:firstPoint
                                                          point2:gesturePoint];
                [self.alisaView addFigure:line];
                firstPoint = gesturePoint;
            } else if (recognizer.state == UIGestureRecognizerStateEnded) {
                AlisaLine *line = [[AlisaLine alloc]initWithRGBA:[self activeColorRGBA]
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

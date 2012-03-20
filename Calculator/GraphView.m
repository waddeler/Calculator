//
//  GraphView.m
//  Calculator
//
//  Created by Paul Fellows on 14/02/2012.
//  Copyright (c) 2012 Lichfield Mobile Development. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"
#import "GraphViewController.h"

@implementation GraphView

@synthesize dataSource = _dataSource;
@synthesize scale = _scale;
@synthesize graphOrigin = _graphOrigin;

#define DEFAULT_SCALE 10
#define DEFAULT_ORIGIN_X 160.0
#define DEFAULT_ORIGIN_Y 208.0

//NSUserDefaults *defaults = [NSUserDefaults ];

-(double)scale
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (!_scale) {
        if([defaults doubleForKey:@"scale"] > 0 ) {
            return [defaults doubleForKey:@"scale"];    
        }
        else {
            return DEFAULT_SCALE;
        }
    
    } else {
       // NSLog(@"scale returned %f",_scale);
        return _scale;
    }
}

-(void)setScale:(double)scale
{
    if(scale != _scale) {
        _scale = scale;
        [self setNeedsDisplay];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setDouble:self.scale forKey:@"scale"];
        [defaults synchronize];
    }
}

-(CGPoint)graphOrigin
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(_graphOrigin.x == 0&&_graphOrigin.y == 0){
       if ([defaults floatForKey:@"origin_x"]==0.0 && [defaults floatForKey:@"origin_y"] == 0) {
        return CGPointMake((CGFloat)DEFAULT_ORIGIN_X, (CGFloat)DEFAULT_ORIGIN_Y);
       } else {
           return CGPointMake([defaults floatForKey:@"origin_x"],
                              [defaults floatForKey:@"origin_y"]);
       }
    } else {
        return _graphOrigin;
    }

}

-(void)setGraphOrigin:(CGPoint)graphOrigin
{   
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (CGPointEqualToPoint(graphOrigin, _graphOrigin)==NO) {
        _graphOrigin = graphOrigin;
        [self setNeedsDisplay];
        [defaults setFloat:self.graphOrigin.x forKey:@"origin_x"];
        [defaults setFloat:self.graphOrigin.y forKey:@"origin_y"];
        [defaults synchronize];
        
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// helper function to convert point data to relevant x value
// taking into account contentScaleFactor, scale and number
// of points away from y-axis
-(CGFloat)convertGraphX:(CGFloat)graphX
{
    CGFloat result;
    result = (graphX - self.graphOrigin.x)/(CGFloat)(self.scale * self.contentScaleFactor);
   // NSLog(@" outbound scale factor is %f",self.contentScaleFactor);
    
           // (CGFloat)self.scale*self.contentScaleFactor;
    return result;
}

// helper function to convert y value to a corresponding screen
// point value. Note the rounding is so we guarantee to have a valid 
// point value
-(CGFloat)convertRealY:(CGFloat)realY
{
    CGFloat roundedY = (CGFloat)roundf(realY*self.scale*self.contentScaleFactor);
    CGFloat result = self.graphOrigin.y - roundedY;//self.contentScaleFactor);
    //NSLog(@" inbound scale factor is %f",self.contentScaleFactor);
    return result;
}

// graph plotting code
// starts witgh a single point and then joins
// a line to each subsequent point
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat step = 1/self.contentScaleFactor; // the size of each pixel in points
    CGFloat x, y, tempY; // temp variables for clarity
    
    // create starting point
    x = [self convertGraphX:self.bounds.origin.x];
    //NSLog(@"starting x value %f",x);
    tempY = [self.dataSource yValueForGraphView:self withX:x];
    //NSLog(@"starting y value %f",tempY);
    y = [self convertRealY:tempY];
    //NSLog(@"Finishing value y %f",y);
    
    // Draw the axis
   [AxesDrawer drawAxesInRect:self.bounds                              
        originAtPoint:self.graphOrigin scale:self.scale];
    
    // start the defining the path
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, x, y);
    CGFloat a;
    
    // iterate over every pixel across width
    for (a = self.bounds.origin.x+step; a < self.bounds.size.width; a+=step) {
      //  NSLog(@"the value of a is %f",a);
        x = [self convertGraphX:a];
       // NSLog(@"converted value %f",x);
        tempY = [self.dataSource yValueForGraphView:self withX:x];
       // NSLog(@"tempY value is %f",tempY);
        y = [self convertRealY:tempY];
        CGContextAddLineToPoint(context, a, y);
    }
    [[UIColor blueColor] setStroke];
    CGContextDrawPath(context, kCGPathStroke);
}

-(void)pan:(UIPanGestureRecognizer *)recognizer
{
    if ((recognizer.state == UIGestureRecognizerStateChanged) 
        || (recognizer.state == UIGestureRecognizerStateEnded)){
        CGPoint translation = [recognizer translationInView:self];
        //move something in myself (i'm a UIView) by translation.x
        //and translation.y for example, if I were a graph and my origin was set
        //by a @property called graphOrigin
        self.graphOrigin = CGPointMake(self.graphOrigin.x + translation.x, 
                                       self.graphOrigin.y + translation.y);
        [recognizer setTranslation:CGPointZero inView:self];
        
    }
}

-(void)pinch:(UIPinchGestureRecognizer *)pinchRecognizer
{
    if ((pinchRecognizer.state == UIGestureRecognizerStateChanged)||(pinchRecognizer.state == UIGestureRecognizerStateEnded)){
        self.scale *= (pinchRecognizer.scale);
       //ß NSLog(@"the current pinch is %f", pinchRecognizer.scale);
        
        
        pinchRecognizer.scale = 1;
    }
}

-(void)tripleTap:(UITapGestureRecognizer *)tapRecognizer
{
    if (tapRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [tapRecognizer locationInView:self];
        self.graphOrigin = CGPointMake(location.x, location.y);
        
        
    }
}


@end


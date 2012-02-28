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

#define DEFAULT_SCALE 1
#define DEFAULT_ORIGIN_X 160.0
#define DEFAULT_ORIGIN_Y 208.0

-(int)scale
{
    if (!_scale) {
        return DEFAULT_SCALE;
    } else {
        return _scale;
    }
}

-(void)setScale:(int)scale
{
    if(scale != _scale) {
        _scale = scale;
        [self setNeedsDisplay];
    }
}

-(CGPoint)graphOrigin
{
    if(_graphOrigin.x == 0&&_graphOrigin.y == 0) {
        return CGPointMake((CGFloat)DEFAULT_ORIGIN_X, (CGFloat)DEFAULT_ORIGIN_Y);
    } else {
        return _graphOrigin;
    }

}

-(void)setGraphOrigin:(CGPoint)graphOrigin
{
    if (CGPointEqualToPoint(graphOrigin, _graphOrigin)==NO) {
        _graphOrigin = graphOrigin;
        [self setNeedsDisplay];
        
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


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGFloat x = 160; //temperary  x value for GraphOriginPoint
    CGFloat y = 208; //temperary  y value for GraphOriginPoint
    CGPoint myPoint = CGPointMake(x, y);// temperary GraphOriginPoint 
  //  CGContextRef context = UIGraphicsGetCurrentContext();
   [AxesDrawer drawAxesInRect:self.bounds originAtPoint:myPoint scale:1];
   // int temp = [self.dataSource yValueForGraphView:self];
   // NSLog(@" The value sent through was %d",temp);
    //The statement below has confirmed that data was effectively transfered the program listing in time to be displayed when the drawRect is drawn. It is not appropriate 
    //for the final program
//NSLog(@"the localprogram listing is %@",[[self.dataSource yValueForGraphView:self] componentsJoinedByString:@","]);
    CGFloat temp =[self.dataSource yValueForGraphView:self  withX:9.0]; 
    NSLog(@"The result is %f",temp);
    // for each horiontal point in the GraphView
    
    //      set the y component to the results of the dataSource
    //      draw a line to that coordinate
    
    //      
     
     }
     
@end

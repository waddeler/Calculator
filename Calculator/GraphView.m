//
//  GraphView.m
//  Calculator
//
//  Created by Paul Fellows on 14/02/2012.
//  Copyright (c) 2012 Lichfield Mobile Development. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

@implementation GraphView

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
    CGFloat x = 160;
    CGFloat y = 200;
    CGPoint myPoint = CGPointMake(x, y);
    //CGContextRef context = UIGraphicsGetCurrentContext();
   [AxesDrawer drawAxesInRect:self.bounds originAtPoint:myPoint scale:5];
    
    
    // going to draw the axis to understand them
    // 
     }
     
@end

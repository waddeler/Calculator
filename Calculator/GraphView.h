//
//  GraphView.h
//  Calculator
//
//  Created by Paul Fellows on 14/02/2012.
//  Copyright (c) 2012 Lichfield Mobile Development. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GraphView;

@protocol GraphViewDataSource
-(CGFloat)yValueForGraphView:(GraphView *)graphView withX:(CGFloat)graph_x;
//@property CGFloat yResult;
@end



@interface GraphView : UIView

@property (nonatomic,weak) id <GraphViewDataSource> dataSource;
@property (nonatomic) int scale;
@property (nonatomic) CGPoint graphOrigin;

@end

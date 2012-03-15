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
@property (nonatomic) double scale;
@property (nonatomic) CGPoint graphOrigin;
// gesture handling methods
-(void)pan:(UIPanGestureRecognizer *)recognizer;
-(void)pinch:(UIPinchGestureRecognizer *)pinchRecognizer;
-(void)tripleTap:(UITapGestureRecognizer *)tapRecognizer;
@end

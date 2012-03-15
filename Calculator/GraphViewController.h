//
//  GraphViewController.h
//  Calculator
//
//  Created by Paul Fellows on 13/02/2012.
//  Copyright (c) 2012 Lichfield Mobile Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphView.h"
@class GraphViewController;

@protocol GraphViewControllerDelegate <NSObject>

-(NSArray *)programForGraphView:(GraphViewController *)sender;

@end

@interface GraphViewController : UIViewController <UISplitViewControllerDelegate>
//@property (nonatomic, weak) IBOutlet GraphView *myGraphView;
@property (nonatomic, copy) NSArray *localProgram;
@property (weak, nonatomic) IBOutlet UIToolbar *graphViewToolbar;
@property (nonatomic, weak) id <GraphViewControllerDelegate> gVCdelegate;//GraphViewController delegate object
@property (nonatomic) CGFloat yResult;
@property (nonatomic, weak) IBOutlet GraphView *myGraphView;

//this will be GraphView object that requires GraphViewDatasource//@property (nonatomic) CGFloat yResult;
//-(CGFloat)yValueForGraphView:(GraphView *)graphView withX:(CGFloat)graph_x;
@end

//
//  CalculatorViewController.h
//  Calculator
//
//  Created by Paul Fellows on 12/01/2012.
//  Copyright (c) 2012 Lichfield Mobile Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphViewController.h"


@interface CalculatorViewController : UIViewController  <GraphViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *display;
@property (nonatomic, weak) GraphViewController *myGraphViewController;

@property (weak, nonatomic) IBOutlet UILabel*longDisplay;
@property (weak, nonatomic) IBOutlet UILabel *variablesUsedDisplay;
@end

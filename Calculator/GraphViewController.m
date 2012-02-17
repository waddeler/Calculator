//
//  GraphViewController.m
//  Calculator
//
//  Created by Paul Fellows on 13/02/2012.
//  Copyright (c) 2012 Lichfield Mobile Development. All rights reserved.
//

#import "GraphViewController.h"
#import "CalculatorBrain.h"
#import "CalculatorViewController.h"

@implementation GraphViewController

@synthesize myGraphView = _myGraphView;
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
//                               TEST TO SEE IF CAN GET INFO VIA NAVIGATION  CONTROLLER                //
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//





//______________________________________________________________________________________________________//

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSLog(@"i got called when graph was created");
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"i got called when graph was created");
    CalculatorViewController *myCalcViewController = [self.navigationController.viewControllers objectAtIndex:0]; 
    NSLog(@" The description of the program currently loaded is %@", myCalcViewController.longDisplay.text);
   // NSLog(@" The array of the program currentlu loaded is %@",[myCalcViewController self.)
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

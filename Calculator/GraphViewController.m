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
#import "GraphView.h"
@interface GraphViewController ()<GraphViewDataSource>  //defining that this object complies with GraphViewDataSource protocol
@property (nonatomic,strong) UIBarButtonItem *graphViewBarButtonItem;

@end

@implementation GraphViewController

@synthesize myGraphView = _myGraphView;
@synthesize yResult = _yResult;
@synthesize localProgram =_localProgram;
@synthesize graphViewToolbar = _graphViewToolbar;
@synthesize gVCdelegate = _gVCdelegate;
@synthesize graphViewBarButtonItem = _graphViewBarButtonItem;
    
-(void)setGraphViewBarButtonItem:(UIBarButtonItem *)graphViewBarButtonItem
{
    NSLog(@"setGraphViewBarButtonItem");
    if (graphViewBarButtonItem != _graphViewBarButtonItem) {
        NSMutableArray *toolbarItems = [self.graphViewToolbar.items mutableCopy];
        if(_graphViewBarButtonItem) [toolbarItems removeObject:_graphViewBarButtonItem];
        if(graphViewBarButtonItem) [toolbarItems insertObject:graphViewBarButtonItem atIndex:0];
        self.graphViewToolbar.items = toolbarItems;
        _graphViewBarButtonItem = graphViewBarButtonItem;
        
        
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.splitViewController.delegate = self;
 //   UIBarButtonItem graphViewBarButtonItem = [[UIBarButtonItem alloc]init ];
}

-  (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc 
               inOrientation:(UIInterfaceOrientation)orientation

{
   // NSLog(@"should hide was called");
    return UIInterfaceOrientationIsPortrait(orientation);
}

-(void)splitViewController:(UISplitViewController *)svc 
    willHideViewController:(UIViewController *)aViewController 
         withBarButtonItem:(UIBarButtonItem *)barButtonItem 
      forPopoverController:(UIPopoverController *)pc

{
    NSLog(@"will Hide is called");
    barButtonItem.title = @"Calculator";
    [self setGraphViewBarButtonItem:barButtonItem];
    // tell the detailview to put this button up
 //   NSArray *tempArray = [NSArray arrayWithObject:barButtonItem];
   // [self setToolbarItems:tempArray animated:YES];
}

-(void)splitViewController:(UISplitViewController *)svc 
    willShowViewController:(UIViewController *)aViewController 
 invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem  
{
    // tell the detail view to take the button away
    [self setGraphViewBarButtonItem:nil];
}
//-(void)setGraphViewBarButtonItem:(UIBarButtonItem *)barButtonItem
//{
  //  NSMutableArray *toolbarItems = [self.graphViewToolbar.items mutableCopy];
    //if (_graphViewBarButtonItem) [toolbarItems removeObject:_graphViewBarButtonItem];
    // put the bar button on the left of our existing toolbar
   // if (barButtonItem) [toolbarItems insertObject:barButtonItem  atIndex:0];
   // self.graphViewToolbar.items = toolbarItems;
   // _graphViewBarButtonItem = barButtonItem;    
//}




-(void)setMyGraphView:(GraphView *)myGraphView
{
    _myGraphView = myGraphView;
    self.myGraphView.dataSource = self;
    
    // adding pan gesture recognizer
    UIPanGestureRecognizer *myPangr = [[UIPanGestureRecognizer alloc] initWithTarget:myGraphView action:@selector(pan:)];
    [myGraphView addGestureRecognizer:myPangr];
    
    // adding pinch gesture recognizer
    UIPinchGestureRecognizer *myPinchgr = [[UIPinchGestureRecognizer alloc] initWithTarget:myGraphView action:@selector(pinch:)];
    [myGraphView addGestureRecognizer:myPinchgr];
    
    // adding a triple tap gesture recognizer
    UITapGestureRecognizer  *tripleTapgr = 
    [[UITapGestureRecognizer alloc] initWithTarget:myGraphView action:@selector(tripleTap:)];
    tripleTapgr.numberOfTapsRequired = 3;
    [myGraphView addGestureRecognizer:tripleTapgr];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil

{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSLog(@"i got called first when graph was created");
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
  //  NSLog(@"i got called when graph was created");
   // CalculatorViewController *myCalcViewController = [self.navigationController.viewControllers objectAtIndex:0]; 
   // NSLog(@" The description of the program currently loaded is %@", [self.localProgram componentsJoinedByString:@","]);
   // NSLog(@" The array of the program currentlu loaded is %@",[myCalcViewController self.)
    self.title = [NSString stringWithFormat:@"y = %@",[CalculatorBrain descriptionOfProgram:self.localProgram]];
}

-(CGFloat)yValueForGraphView:(GraphView *)graphView withX:(CGFloat)graph_x
{
    // get the required values
    //CGPoint origin = self.myGraphView.graphOrigin;
   // int scale = self.myGraphView.scale;
   // CGFloat real_x,graph_y,real_y,yResult;
    
    // convert graph_x to real_x
 //   real_x = (graph_x - origin.x)/scale;
 //   NSLog(@"the real x was %f",real_x);
    
    // send x and the program to calculator brain
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:graph_x] forKey:@"x"];
    self.yResult = [CalculatorBrain runProgram:self.localProgram usingVaribleValues:dict];
    
    
    // convert real y to graph y
  //  NSLog(@"the real result was %f", real_y);
  //   graph_y = (origin.y - real_y)/scale;
   // yResult = graph_y;
    
    
    // return result
    return self.yResult;
}

// method required to 

-(NSArray *)yValueForGraphView:(GraphView *)sender
{
    return self.localProgram; //temperary value of one sent in order to confirm that datasource is connected;
}

-(void)viewWillAppear:(BOOL)animated
{
    // NSLog(@" The description of the program currently loaded is %@ and is about to appear", [self.localProgram componentsJoinedByString:@","]);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.myGraphView.scale = [defaults doubleForKey:@"scale"];
    self.myGraphView.graphOrigin = CGPointMake([defaults floatForKey:@"origin_x"],[defaults floatForKey:@"origin_y"]);
    
    
    

}

-(void)viewDidAppear:(BOOL)animated
{
    //NSLog(@" The description of the program currently loaded is %@ and did appear", [self.localProgram componentsJoinedByString:@","]);
}

-(void)viewWillDisappear:(BOOL)animated
{
    // create user defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setDouble:self.myGraphView.scale forKey:@"scale"];
    [defaults setFloat:self.myGraphView.graphOrigin.x forKey:@"origin_x"];
    [defaults setFloat:self.myGraphView.graphOrigin.y forKey:@"origin_y"];
    [defaults synchronize];
   // NSLog(@" The description of the program currently loaded is %@ and is about to dissappear", [self.localProgram componentsJoinedByString:@","]);
}

- (void)viewDidUnload
{
  //  [self setToolbar:nil];
   // [self setToolbar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (self.splitViewController)?YES:NO;
}

@end

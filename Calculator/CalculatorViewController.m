//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Paul Fellows on 12/01/2012.
//  Copyright (c) 2012 Lichfield Mobile Development. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;

// boolean flag used to make sure only one decimal point is entered
@property (nonatomic) BOOL decimalPointHasBeenUsed;
@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize longDisplay = _longDisplay;
@synthesize variablesUsedDisplay = _variablesUsedDisplay;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;

@synthesize decimalPointHasBeenUsed = _decimalPointHasBeenUsed;

-(CalculatorBrain *)brain
{
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}
- (IBAction)GraphButtonPushed {
    NSLog(@"I got sent over as well");
}

// instance method that as required iterates through variablesUsedInProgram
// and creates a string with each variables' current value
// and then displays this list in variablesUsedDisplay

- (void) updateVariableValuesDisplayed
{
    NSEnumerator *variablesEnumerator = [[CalculatorBrain variablesUsedInProgram:self.brain.program] objectEnumerator];
    NSString *variable, *displayString;
    
    while (variable = [variablesEnumerator nextObject]) {
        if (!displayString) {
            displayString = [NSString stringWithFormat:@"%@ = %@ ",variable,
                             [self.brain.testVariableValues objectForKey:variable]];
        } else {
            displayString = [displayString stringByAppendingFormat:@" %@ = %@ ", variable,
                             [self.brain.testVariableValues objectForKey:variable]];
        }
    }
    self.variablesUsedDisplay.text = displayString;
}

- (IBAction)testerButton:(id)sender {
    NSString *name = [sender currentTitle];
   NSDictionary *myTempDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1],@"TEST1",[NSNumber numberWithInt:2]
                                     ,@"TEST2",[NSNumber numberWithInt:3],@"TEST3",  nil]; 
    
    switch ([[myTempDictionary objectForKey:name] integerValue]) {
        case 1:
            [self.brain setTestVariableValues:[NSDictionary dictionaryWithObjectsAndKeys:@"10.00" ,@"a",[NSNumber numberWithInt:-1],@"b",@"u", @"x", @"sqrt", @"y",[NSNumber numberWithFloat:0.0], @"Foo",nil]];                                  
                                              
            break;
        case 2:
            [self.brain setTestVariableValues:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:23333.9889999999999999],
                                            @"a",[NSNumber numberWithFloat:67.00],@"b",[NSNumber numberWithInt:2],@"x",
                                               [NSNumber numberWithInt:0],@"y",[NSNumber numberWithInt:-99],@"Foo",nil]];
             break;
        case 3:
             [self.brain setTestVariableValues:[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"a",@"0",@"b",@"0",@"x",@"0",@"y",@"0",@"Foo",nil]];
        default:
            break;
    }
    [self updateVariableValuesDisplayed];    
    double result = [CalculatorBrain runProgram:self.brain.program usingVaribleValues:self.brain.testVariableValues];
    // double result = [CalculatorBrain runProgram:self.brain.program usingVaribleValues:self.brain.testVariableValues];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    
}

- (IBAction)backSaceButton 
{
   // NSNumber *test = [NSNumber numberWithInt:2];
    if (self.userIsInTheMiddleOfEnteringANumber) {
        if (self.display.text.length > 0) {
            self.display.text = [self.display.text substringToIndex:self.display.text.length -1];
    
        }
        }
    if (self.display.text.length == 0) {
        self.display.text = @"0";
        self.userIsInTheMiddleOfEnteringANumber = NO;
    }
}

- (IBAction)clearButtonPressed 
{
    self.display.text = @"0";
    self.longDisplay.text = @" ";
    self.variablesUsedDisplay.text = @" ";
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.decimalPointHasBeenUsed = NO;
    [self.brain clearOperandStack]; //calls model API to clear model 
    
}

- (IBAction)digitPressed:(UIButton *)sender 
{
    NSString *digit = [sender currentTitle];
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
    
}  
- (IBAction)variablePressed:(id)sender {
    NSString *name = [sender currentTitle];
    self.display.text = name;
    [self.brain pushVariableOperand:name];
}

// processing for decimal point
- (IBAction)decimalPoint 
{
if (!self.decimalPointHasBeenUsed) {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:@"."];
        
    } else {
        self.display.text = @"0.";
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
    self.decimalPointHasBeenUsed = YES;
    }
}
- (IBAction)enterPressed 
{
    //code to copy digit pressed to longDisplay
   //if (self.longDisplay.text.length == 0) {
        //NSLog(@"The string is empty");
    //    self.longDisplay.text = self.display.text;
    //} else {
  //      self.longDisplay.text = [self.longDisplay.text 
         //   stringByAppendingFormat:@" %@",self.display.text];  
  //  }
    //Test values as follows
    //NSArray *testArray = [NSArray arrayWithObjects:@"3",@"5",@"+",@"6",@"7",@"*",@"9",@"sqrt", nil];
    [self.brain pushOperand:[self.display.text doubleValue]];    
    self.userIsInTheMiddleOfEnteringANumber = NO;
    //required too reset decimal point
    self.decimalPointHasBeenUsed = NO;
    self.longDisplay.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
    //self.longDisplay.text = [CalculatorBrain descriptionOfProgram:testArray];
    //NSLog(@" helpme %@",[CalculatorBrain descriptionOfProgram:testArray]);
    //[self updateVariableValuesDisplayed];
}

// simply removes the last character entered and updates interface 
- (IBAction)undoPressed 
{
    if(self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text substringToIndex:self.display.text.length - 1];
        if (self.display.text.length == 0) {
            self.userIsInTheMiddleOfEnteringANumber = FALSE;
            self.display.text = [NSString stringWithFormat:@"%g",
                                 [CalculatorBrain runProgram:self.brain.program usingVaribleValues:self.brain.testVariableValues]];
            
        }
    } else {
        [self.brain popTop];
        self.display.text = [NSString stringWithFormat:@"%g",[CalculatorBrain runProgram:self.brain.program usingVaribleValues:self.brain.testVariableValues]];
        self.longDisplay.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
        [self updateVariableValuesDisplayed];
    }
}
- (IBAction)operationPressed:(UIButton *)sender 
{   // add = when enter is pressed
   // self.longDisplay.text = [self.longDisplay.text stringByAppendingFormat:@" ="];
    if (self.userIsInTheMiddleOfEnteringANumber) {
        
        [self enterPressed];
    }
    NSString *operation = [sender currentTitle];
    double result = [self.brain performOperation:operation];
   // double result = [CalculatorBrain runProgram:self.brain.program usingVaribleValues:self.brain.testVariableValues];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    
    //code to copy operand to long display
    //self.longDisplay.text = [self.longDisplay.text 
     //                        stringByAppendingFormat:@" %@ =",operation];
    self.longDisplay.textAlignment = UITextAlignmentRight;
    self.longDisplay.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
    [self updateVariableValuesDisplayed];
}

- (void)viewDidUnload {
    [self setLongDisplay:nil];
    [self setVariablesUsedDisplay:nil];
    [self setVariablesUsedDisplay:nil];
    [super viewDidUnload];
}
@end

//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Paul Fellows on 12/01/2012.
//  Copyright (c) 2012 Lichfield Mobile Development. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain() 
@property (nonatomic, strong) NSMutableArray *programStack;
//@property (nonatomic, strong) NSMutableDictionary *testVariables;
@end

@implementation CalculatorBrain

@synthesize testVariableValues = _testVariableValues;
@synthesize programStack = _programStack;

-(void)popTop
{   
    if ([self.programStack lastObject]) {
        [self.programStack removeLastObject];
    }
}
        
-(NSMutableArray *)programStack
{
    if (_programStack == nil) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}

-(NSMutableDictionary *)testVariableValues
{
    if(_testVariableValues == nil) _testVariableValues = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0],@"x",
    [NSNumber numberWithInt:0],@"y",[NSNumber numberWithInt:0],@"a",[NSNumber numberWithInt:0],@"b",[NSNumber numberWithInt:0],@"Foo" ,nil];
    return _testVariableValues;                                            
                                                
}

//required to clear operandstack
-(void)clearOperandStack
{
    self.programStack = nil;
}

- (id)program {
    return [self.programStack copy];
}




-(void)pushOperand:(double)operand
{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

// the following is to make sure a variable is not mistaken for an operator

-(void)pushVariableOperand:(NSString *)variable
{
    NSSet *mySet = [NSSet setWithObjects:@"+",@"-",@" /",@"*",@"sin",
        @"cos", @"sqrt", @"∏",nil] ;         
    if (![mySet containsObject:variable]) {
        [self.programStack addObject:variable];
    }

    
    
}

//-(double)popOperand
//{
//    NSNumber *operandObject = [self.operandStack lastObject];
//    if (operandObject) [self.operandStack removeLastObject];
//    return [operandObject doubleValue];
//}

-(double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    //NSDictionary *variables = self.testVariableValues;
    return [[self class] runProgram:self.program usingVaribleValues:self.testVariableValues];
}

+ (double)popOperandOffProgramStack:(NSMutableArray *)stack
{

    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack  removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) 
    {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffProgramStack:stack] + 
                     [self popOperandOffProgramStack:stack];
        } else if([@"*" isEqualToString:operation]) {
            result = [self popOperandOffProgramStack:stack] * 
                     [self popOperandOffProgramStack:stack];
        } else if([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffProgramStack:stack];
            result = [self popOperandOffProgramStack:stack] - subtrahend;
        } else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffProgramStack:stack];
            if (divisor) result = [self popOperandOffProgramStack:stack] / divisor;
        } else if ([operation isEqualToString:@"sin"]) { //sin function
            result = sin([self popOperandOffProgramStack:stack]);
        } else if ([operation isEqualToString:@"cos"]) { //cos function
            result = cos([self popOperandOffProgramStack:stack]);
        } else if ([operation isEqualToString:@"sqrt"]) { //sqrt function
            result = sqrt([self popOperandOffProgramStack:stack]);
        } else if ([operation isEqualToString:@"∏"]) {  //PI function
            result = M_PI;
    }
    
    }// [self pushOperand:result];
    
    return result;
}
//Need to protect against 
+ (double)runProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]){
        stack = [program mutableCopy];
    }
    else return 0.0;
    // searches through through the program looking for variables
    // if it finds any it creates a mutableNSDictionary
    // then for each variable a value of zero is entered
    // then the program is processed using runProgram:usingVariables
    NSSet *myVariableSet = [self variablesUsedInProgram:stack];
    NSMutableDictionary *myMutableDictionary = [NSMutableDictionary dictionaryWithCapacity:1];
    if (myVariableSet) {
        NSArray *myTempArray = [myVariableSet allObjects];
        for (NSString *element in myTempArray) {
            [myMutableDictionary setObject:[NSNumber numberWithInt:0] forKey:element];
        }
       // [self runProgram:stack usingVaribleValues:myMutableDictionary];
    }
    NSLog(@"came back");
    return [self runProgram:stack usingVaribleValues:myMutableDictionary];
}

// Internal function to identify operations
+ (BOOL)isOperation:(NSString *)operation
{
   // NSLog(@"operation sent was %@",operation);
          
          
    NSSet *mySet = [NSSet setWithObjects:@"+",@"-",@"/",@"*",
                    @"sin", @"cos", @"sqrt", @"∏", nil];
   // NSLog(@"all operation objects %@",[[mySet allObjects] componentsJoinedByString:@" "]);
    BOOL result = [mySet containsObject:operation];
   // NSLog(@"result is %d",result);
    return result;
}

// The following method works out where to insert comma by pre-processing
// the program on the basis that binary operations require at least 2 operands
// but if there are already two operands, only one further is required
// and a function must have one operator. When these requirements are satisfied
// a comma should be added if there are further program entries
+ (NSMutableArray *)returnCommaSeperatedProgram:(id)program
{
    //NSLog(@"returnComma called");
    NSArray *stack = [program copy];
    //NSArray *stack2;
    //NSLog(@"The transfered array is %@",[stack componentsJoinedByString:@" "]);
    NSMutableArray *workingArray = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *outputArray = [NSMutableArray arrayWithCapacity:1];
    int valueCounter = 0;
    NSSet *binaryOps = [NSSet setWithObjects:@"+",@"-",@"*",@"/", nil];
    NSSet *unaryOps = [NSSet setWithObjects:@"sin", @"cos",@"sqrt", nil];
    NSEnumerator *enumerator = [stack reverseObjectEnumerator];
        id arrayObject, workingArrayObject;
    
    while (arrayObject = [enumerator nextObject]) {
        [workingArray addObject:arrayObject];
       // NSLog(@"working Array is %@",[workingArray componentsJoinedByString:@" "]);
        
    
       // NSLog(@"array object is %@",arrayObject);
        if ([self isOperation:arrayObject]) {
          //  NSLog(@"operand is %@",arrayObject);   
        
            if ([binaryOps containsObject:arrayObject]) {
              //  NSLog(@"if value > 0");
                if (valueCounter > 0) {
                    valueCounter++;
                }
                else    
                    valueCounter = 2;
            } else 
                if ([unaryOps containsObject:arrayObject]) {
                    if (valueCounter < 1) {
                        valueCounter = 1;
       
                    }
                }
        } else {
                    
                if (valueCounter > 0) 
                 //   NSLog(@"valueCounter > 1");
                    valueCounter--;
            
                 if ( valueCounter == 0) 
                        [workingArray addObject:@","];
                                                   
                }
           
            
            
        //NSLog(@"valueCounter %d",valueCounter);           
    }
    // if the last element of the working array is a comma remove it
    if ([[workingArray lastObject] isEqual:@","]) {
        [workingArray removeLastObject];
    }
   // stack2 = [workingArray copy];
    NSEnumerator *workingEnumerator = [workingArray reverseObjectEnumerator];
  //  NSLog(@"working array %@",[workingArray componentsJoinedByString:@" "]);
    while (workingArrayObject = [workingEnumerator nextObject]) {
   //     NSLog(@"workingArrayObject %@",workingArrayObject);
        [outputArray addObject:workingArrayObject];
    }
//NSLog(@"outputArray is %@",[outputArray componentsJoinedByString:@" "]);
    return outputArray;
        //return workingArray;
}

// This method constructs the program string via recursion
// the bracketing rules is based on the assumption that in
// revers polish notation, brackets are required when + or -
// follows * or / so in the recursion we send a boolean
// related to the prescedence of the calling operation

+(NSString *)descriptionOfTopOfStack:(NSMutableArray *)stack hiPresLast:(BOOL)hiLow
{
    NSString *result = [[NSString alloc] init];
    NSSet *hiOpSet = [NSSet setWithObjects:@"*",@"/", nil];
    NSSet *lowOpSet = [NSSet setWithObjects:@"+",@"-", nil];
    NSSet *unaryOpSet = [NSSet setWithObjects:@"cos",@"sin",@"sqrt", nil];
   // NSDictionary *reverseOps = [NSDictionary dictionaryWithObjectsAndKeys:@"trqs",@"sqrt",
                             //   @"soc",@"cos",@"nis",@"sin", nil];
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if([topOfStack isKindOfClass:[NSNumber class]])
    {
        result = [NSString stringWithFormat:@"%@",topOfStack];
    }
    else if([topOfStack isKindOfClass:[NSString class]])
        {
            if ([hiOpSet containsObject:topOfStack]) {
                result = [NSString stringWithFormat:@"%3$@ %2$@ %1$@",
                          [self descriptionOfTopOfStack:stack hiPresLast:TRUE],topOfStack,
                          [self descriptionOfTopOfStack:stack hiPresLast:TRUE]];
            }else if([lowOpSet containsObject:topOfStack]) {
                if (hiLow) {
                    result = [NSString stringWithFormat:@"(%3$@ %2$@ %1$@) ",
                              [self descriptionOfTopOfStack:stack hiPresLast:FALSE], topOfStack,
                              [self descriptionOfTopOfStack:stack hiPresLast:FALSE]];
                } else  {
                    result = [NSString stringWithFormat:@"%3$@ %2$@ %1$@",
                              [self descriptionOfTopOfStack:stack hiPresLast:FALSE], topOfStack,
                              [self descriptionOfTopOfStack:stack hiPresLast:FALSE]];
                }
            
            } else if([unaryOpSet containsObject:topOfStack]) {
                    result = [NSString stringWithFormat:@"%@(%@)",
                              topOfStack,[self descriptionOfTopOfStack:stack hiPresLast:FALSE]];
            
            } else 
                result = [NSString stringWithFormat:@"%@", topOfStack];
            
            
                          
        }
    
    return result;
        
    
}

  



// Redundant function made uneccessary by printf location format
// which ables you to change the order of the arguments used in a printf statement
// otherwise the output string is reversed.

+(NSString *)reverseString:(NSString *)inputString
{
    NSString *workingString, *outputString;
  //  NSLog(@"inputString %@",inputString);
   // NSLog(@" length is %d",[inputString length]-1);
    workingString = [inputString copy];
    outputString = [[NSString alloc] init];
  //  int temp = [inputString length] -1;
    int index;
    
    // keep removing the last character in the string
    // then append each onto the result string
    for (index = [inputString length] -1; index >= 0; index--) {
       // NSLog(@"index %d",index);
        outputString = [outputString stringByAppendingString:
                        [workingString substringFromIndex:index]];
      workingString = [workingString substringToIndex:index];
    }
   // NSLog(@" outputString %@",outputString);
    return outputString;
}

/////////////////////////////////////////////////////////////////////////

//                   END OF REDUNDANT METHOD                           //

/////////////////////////////////////////////////////////////////////////







+ (NSString *)descriptionOfProgram:(id)program
{
    NSMutableArray *stack, *stackin ,*mutableSmallArray;
    NSArray *smallStack;
    NSRange theRange;
    NSString *resultString, *rightedString, *tempResult;
    int topOfSmallStack, index;
    
    if([program isKindOfClass:[NSArray class]]) {
        stackin = [program mutableCopy];
       // NSLog(@"descriptionOfProgram1 %@",[stackin componentsJoinedByString:@" "]);
    }
       
    if(stackin)
       {
           //insert commas  in the array
           stack = [self returnCommaSeperatedProgram:stackin];
         //  NSLog(@"returnCommaSeperatedProgram %@", [stack componentsJoinedByString:@" "]);
           topOfSmallStack = [stack count]-1;
           for (index = [stack count]-1; index >= 0; index--) 
           {
               //divide array
               
               if([@"," isEqualToString:[stack objectAtIndex:index]])   
                {
                    theRange.location = index + 1;
                    theRange.length = topOfSmallStack - index;
                  //  NSLog(@"topRange is %d location %d length",theRange.location, theRange.length);
                    smallStack = [stack subarrayWithRange:theRange];
                    mutableSmallArray = [smallStack mutableCopy];
                    topOfSmallStack = index - 1;
                    // process array between commas
                    
                    tempResult = [self descriptionOfTopOfStack:(NSMutableArray *)mutableSmallArray hiPresLast:FALSE];
                    rightedString = tempResult; // [self reverseString:tempResult];
                    //NSLog(@"tempResult %@",tempResult);
                   // NSLog(@"rightedString %@", rightedString);
                    //if ([@"," isEqualToString:[stack objectAtIndex:index]]) {
                   
               
                   if (resultString) {
                       resultString = [resultString stringByAppendingFormat:
                                       @"%@",rightedString];
                   } else {
                       resultString = [NSString stringWithString:rightedString];
                   }
                    resultString = [resultString stringByAppendingString:@", "];
                    
                } else if(index == 0){
                    theRange.location = index;
                    theRange.length = topOfSmallStack + 1;
                   // NSLog(@"bottomRange is %d location %d length",theRange.location, theRange.length);
                    
                    smallStack = [stack subarrayWithRange:theRange];
                    mutableSmallArray = [smallStack mutableCopy];
                    topOfSmallStack = index - 1;
                    // process array between commas
                    tempResult = [self descriptionOfTopOfStack:(NSMutableArray *)mutableSmallArray hiPresLast:FALSE];
                    //rightedString = [self reverseString:tempResult]; 
                    rightedString = tempResult;
                   // NSLog(@"tempResult %@",tempResult);
                   // NSLog(@"rightedString %@", rightedString);
                    
                   
                   
                   
                   if(resultString)
                        resultString = [resultString stringByAppendingString:rightedString];
                    else
                        resultString = [NSString stringWithString:rightedString];
                }
           } 
       }
    else resultString = nil;
      //  NSLog(@"incorrect form of program");
    return resultString;

}




+ (NSSet *)variablesUsedInProgram:(id)program
{
    NSMutableSet *myMutableSet;
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]])
        stack = [program mutableCopy];
    //NSSet *mySet = [NSDictionary allK   
        for (id element in stack) {
            if (!([self isOperation:element]||[element isKindOfClass:[NSNumber class]])) {
                if (!myMutableSet) {
                    myMutableSet = [NSMutableSet setWithCapacity:1]; ///Users/paulfellows67/Developer/Calculator/Calculator/CalculatorBrain.m
                } 
            [myMutableSet addObject:element];
                
            }
            
        }if (myMutableSet) {
            return myMutableSet;
        } else  return nil;
}   

+ (double)runProgram:(id)program usingVaribleValues:(NSDictionary *)variableValues
{
    // check that program is actually an array
    NSMutableArray *stack;
    if([program isKindOfClass:[NSArray class]])
    {
        stack = [program mutableCopy];
    }
    else return 0.0;
    NSLog(@"my program stack at the start looks like %@", [stack componentsJoinedByString:@" "] );    
    NSSet *myVariableSet = [self variablesUsedInProgram:stack];
    NSLog(@" my variables = %@ ", [[myVariableSet allObjects] componentsJoinedByString:@" "]);
    int index;                    
    // this loop searches through the program stack for variables 
    // and replaces them with the correct values from the dictionary
    
    for (index = 0; index < stack.count; index++) {
        if ([myVariableSet containsObject:[stack objectAtIndex:index]]) {
            NSLog(@"match found, index = %d",index);
            [stack replaceObjectAtIndex:index withObject:[variableValues objectForKey:
                [stack objectAtIndex:index]]];
            NSLog(@"my program stack looks like %@ in the middle of the loop", [stack componentsJoinedByString:@" "] );
        } // else {
          //  [stack replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:0]];
      //  } These changes made because the line above was erroneously overwriting the last entered operation 
            
    }
    
    NSLog(@"my program stack looks like %@", [stack componentsJoinedByString:@" "] );
    return [self popOperandOffProgramStack:stack];
}

@end

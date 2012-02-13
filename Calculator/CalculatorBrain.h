//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Paul Fellows on 12/01/2012.
//  Copyright (c) 2012 Lichfield Mobile Development. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

-(void)pushOperand:(double)operand;
-(double)performOperation:(NSString *)operation;
-(void)clearOperandStack;
-(void)popTop;

@property (nonatomic, readonly) id program;
@property (nonatomic, strong) NSMutableDictionary* testVariableValues;

+ (NSString *)descriptionOfProgram: (id)program;
+ (double)runProgram:(id)program;
- (void)pushVariableOperand:(NSString *)variable;
+ (double)runProgram:(id)program usingVaribleValues:(NSDictionary *)variableValues;
+ (NSSet *)variablesUsedInProgram:(id)program;


//+ (NSMutableArray *)returnCommaSeperatedProgram:(id)program; tested
//+(NSString *)reverseString:(NSString *)inputString; tested
//- (void)pushOperand:(NSString *)variable;
@end

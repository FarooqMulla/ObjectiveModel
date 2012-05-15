/*!
 * Copyright © 2011-2012 Michael R. Fleet (github.com/f1337)
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */



#import "PresenceValidatorTest.h"



@implementation PresenceValidatorTest



#pragma mark - SETUP/TEARDOWN



- (void)setUp
{
    [super setUp];
    model = [[Payee alloc] init];
}



- (void)tearDown
{
    [model release];
    [super tearDown];
}



#pragma mark - TESTS



// TODO: implement RoR validation tests:
// https://github.com/rails/rails/blob/master/activemodel/test/cases/validations/presence_validation_test.rb



- (void)testIfValueIsNilItShouldBeInvalid
{
    [model setName:nil];
    [self assertPropertyIsInvalid:@"name" forModel:model];
}



- (void)testIfValueIsEmptyStringItShouldBeInvalid
{
    [model setName:@""];
    [self assertPropertyIsInvalid:@"name" forModel:model];
}



- (void)testIfValueIsNotEmptyItShouldBeValid
{
    [model setName:@"Winnie the Pooh"];
    [self assertPropertyIsValid:@"name" forModel:model];
}



@end

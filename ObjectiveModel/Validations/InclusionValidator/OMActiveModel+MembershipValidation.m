/*!
 * Copyright © 2011-2012 Michael R. Fleet (github.com/f1337)
 *
 * Portions of this software were transliterated from Ruby on Rails.
 * https://github.com/rails/rails/blob/master/activemodel/lib/active_model/validations/exclusion.rb
 * https://github.com/rails/rails/blob/master/activemodel/lib/active_model/validations/inclusion.rb
 * Ruby on Rails is Copyright © 2004-2012 David Heinemeier Hansson.
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



#import "OMMembershipValidator.h"



@implementation OMActiveModel (MembershipValidation)



+ (void)validatesExclusionOf:(NSObject *)properties withOptions:(NSDictionary *)options andSet:(id <OMCollection>)set
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:options];
    [dictionary setObject:[NSNumber numberWithInt:OMMembershipValidationExclusion] forKey:@"mode"];
    [self validatesInclusionOf:properties withOptions:dictionary andSet:set];
}



+ (void)validatesExclusionOf:(NSObject *)properties withOptions:(NSDictionary *)options andBlock:(OMMembershipValidatorCollectionBlock)block
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:options];
    [dictionary setObject:[NSNumber numberWithInt:OMMembershipValidationExclusion] forKey:@"mode"];
    [self validatesInclusionOf:properties withOptions:dictionary andBlock:block];
}



+ (void)validatesInclusionOf:(NSObject *)properties withOptions:(NSDictionary *)options andSet:(id <OMCollection>)set
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:options];
    [dictionary setObject:set forKey:@"collection"];
    [self validates:properties withValidators:[NSArray arrayWithObject:[OMMembershipValidator class]] andOptions:dictionary];
}



+ (void)validatesInclusionOf:(NSObject *)properties withOptions:(NSDictionary *)options andBlock:(OMMembershipValidatorCollectionBlock)block
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:options];
    [dictionary setObject:block forKey:@"block"];
    [self validates:properties withValidators:[NSArray arrayWithObject:[OMMembershipValidator class]] andOptions:dictionary];
}



@end

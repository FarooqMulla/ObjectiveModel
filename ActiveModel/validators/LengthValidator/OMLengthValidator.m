/*!
 * Copyright © 2011-2012 Michael R. Fleet (github.com/f1337)
 *
 * Portions of this software were transliterated from Ruby on Rails.
 * https://github.com/rails/rails/blob/master/activemodel/lib/active_model/validations/length.rb
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



#import "OMLengthValidator.h"



@interface OMLengthValidator (Private)



+ (NSDictionary *)constraints;
+ (NSDictionary *)defaultMessages;
+ (NSDictionary *)messageKeys;



@end



@implementation OMLengthValidator



@synthesize equals = _equals;
@synthesize maximum = _maximum;
@synthesize minimum = _minimum;
@synthesize tokenizer = _tokenizer;
@synthesize tooLongMessage = _tooLongMessage;
@synthesize tooShortMessage = _tooShortMessage;
@synthesize wrongLengthMessage = _wrongLengthMessage;



#pragma mark - INIT & DEALLOC



- (void)dealloc
{
    [self setEquals:nil];
    [self setMaximum:nil];
    [self setMinimum:nil];
    [self setTokenizer:nil];
    [self setTooLongMessage:nil];
    [self setTooShortMessage:nil];
    [self setWrongLengthMessage:nil];
    [super dealloc];
}



#pragma mark - STATIC METHODS



+ (NSDictionary *)constraints
{
    static NSDictionary *constraints;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        constraints = [NSDictionary dictionaryWithObjectsAndKeys:
                       @"isEqualToNumber:", @"equals",
                       @"isGreaterThanOrEqualToNumber:", @"minimum",
                       @"isLessThanOrEqualToNumber:", @"maximum",
                       nil];
        [constraints retain];
    });

    return constraints;
}



+ (NSDictionary *)defaultMessages
{
    static NSDictionary *defaultMessages;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultMessages = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"is the wrong length (should be %{count} characters)", @"wrongLengthMessage",
                           @"is too short (minimum is %{count} characters)", @"tooShortMessage",
                           @"is too long (maximum is %{count} characters)", @"tooLongMessage",
                           nil];
        [defaultMessages retain];
    });
    
    return defaultMessages;
}



+ (NSDictionary *)messageKeys
{
    static NSDictionary *messageKeys;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        messageKeys = [NSDictionary dictionaryWithObjectsAndKeys:
                       @"wrongLengthMessage", @"equals",
                       @"tooShortMessage", @"minimum",
                       @"tooLongMessage", @"maximum",
                       nil];
        [messageKeys retain];
    });
    
    return messageKeys;
}



#pragma mark - INSTANCE METHODS



- (NSString *)checkOptionValidityWithValue:(id)value forKey:(NSString *)key
{
    if ( [self respondsToSelector:NSSelectorFromString(key)] )
    {
        if ( [[[self class] constraints] objectForKey:key] )
        {
            // value must be an NSNumber, a block, or a selector string
            if (
                [value isKindOfClass:[NSNumber class]]
                ||
                [value isKindOfClass:NSClassFromString(@"NSBlock")]
                ||
                ( [value isKindOfClass:[NSValue class]] && [value pointerValue] && strcmp([value objCType], @encode(SEL)) == 0)
                )
            {
                // all is well
                return nil;
            }
            else
            {
                return [NSString stringWithFormat:@"Value (%@) is not an NSNumber, block, or selector.", value];
            }
        }
    }
    else
    {
        return [NSString stringWithFormat:@"Key (%@) is not a valid property name.", key];
    }
    
    return nil;
}



- (NSString *)message
{
    return [super message];
}



- (void)setEquals:(NSNumber *)equals
{
    if ( [equals isLessThanNumber:[NSNumber numberWithInt:0]] )
    {
        [NSException raise:NSInvalidArgumentException format:@"%@ Invalid Argument! Value (%@) must be a positive NSNumber.", NSStringFromClass([self class]), equals, nil];
        return;
    }

    [_equals release];
    _equals = [equals copy];
}



- (void)setMaximum:(NSNumber *)maximum
{
    if ( [maximum isLessThanNumber:[NSNumber numberWithInt:0]] )
    {
        [NSException raise:NSInvalidArgumentException format:@"%@ Invalid Argument! Value (%@) must be a positive NSNumber.", NSStringFromClass([self class]), maximum, nil];
        return;
    }
    
    [_maximum release];
    _maximum = [maximum copy];
}



- (void)setMinimum:(NSNumber *)minimum
{
    if ( [minimum isLessThanNumber:[NSNumber numberWithInt:0]] )
    {
        [NSException raise:NSInvalidArgumentException format:@"%@ Invalid Argument! Value (%@) must be a positive NSNumber.", NSStringFromClass([self class]), minimum, nil];
        return;
    }
    
    [_minimum release];
    _minimum = [minimum copy];
}



- (BOOL)validateModel:(OMActiveModel *)model withValue:(NSObject *)value forKey:(NSString *)inKey error:(NSError **)outError
{
    // the superclass' validation will return YES if validation is to be skipped
    if ( [self shouldSkipValidationForValue:value] )
    {
        return YES;
    }

    // split the string into tokens?
    // use case: counting words
    // value = tokenize(value)
    if ( [self tokenizer] )
    {
        value = [self tokenizer](value);
    }

    // value_length = value.respond_to?(:length) ? value.length : value.to_s.length
    NSNumber *valueLength;
    if ( [value respondsToSelector:@selector(length)] )
    {
        valueLength = [NSNumber numberWithUnsignedInteger:[(id)value length]];
    }
    else if ( [value respondsToSelector:@selector(count)] )
    {
        valueLength = [NSNumber numberWithUnsignedInteger:[(id)value count]];
    }
    else
    {
        valueLength = [NSNumber numberWithUnsignedInteger:[[value description] length]];
    }


    BOOL valid = YES;
    NSDictionary *constraints = [[self class] constraints];
    NSDictionary *defaultMessages = [[self class] defaultMessages];
    NSDictionary *messageKeys = [[self class] messageKeys];

    // CHECKS.each do |key, validity_check|
    for (NSString *key in constraints)
    {
        NSNumber *checkValue;
        SEL validityCheckSelector;

        if (
            // next unless check_value = options[key]
            // skip the check if it isn't defined
            ( checkValue = [self valueForKey:key] )
            // extra sanity check to ensure the selector isn't nil
            && ( validityCheckSelector = NSSelectorFromString([constraints objectForKey:key]) )
            // next if value_length.send(validity_check, check_value)
            // if the selector returns true, skip to the next check
            && ( ! ([valueLength performSelector:validityCheckSelector withObject:checkValue]) )
        )
        {
            valid = NO;

            //errors_options = options.except(*RESERVED_OPTIONS)
            //errors_options[:count] = check_value
            //default_message = options[MESSAGES[key]]
            //errors_options[:message] ||= default_message if default_message
            NSString *message;
            if ( ! (
                    ( message = [self message] )
                    ||
                    (message = [self valueForKey:[messageKeys objectForKey:key]])
            ))
            {
                message = [defaultMessages objectForKey:[messageKeys objectForKey:key]];
            }
            message = [message stringByReplacingOccurrencesOfString:@"%{count}" withString:[checkValue stringValue]];

            //record.errors.add(attribute, MESSAGES[key], errors_options)
            [self errorWithOriginalError:outError value:value forKey:inKey message:message];
        }

    }

    return valid;
}



@end

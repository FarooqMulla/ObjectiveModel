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



#import "OMActiveModel+OMValidator.h"



@interface OMValidator : NSObject
{
    /*! A custom error message (default is set by subclasses). */
    NSString *_message;
}



@property (nonatomic, readonly, assign) BOOL allowBlank;
@property (nonatomic, readonly, assign) BOOL allowNil;
/*! The validation options. */
@property (nonatomic, retain) NSDictionary *options;



- (void)errorWithOriginalError:(NSError **)originalError
                         value:(NSObject *)value
                        forKey:(NSString *)inKey
                       message:(NSString *)message;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)message;
- (BOOL)shouldSkipValidationForValue:(NSObject *)value;
- (BOOL)validateModel:(OMActiveModel *)model withValue:(NSObject *)value forKey:(NSString *)inKey error:(NSError **)outError;



@end

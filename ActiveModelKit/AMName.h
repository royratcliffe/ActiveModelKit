// ActiveModelKit AMName.h
//
// Copyright © 2011–2013, Roy Ratcliffe, Pioneering Software, United Kingdom
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the “Software”), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED “AS IS,” WITHOUT WARRANTY OF ANY KIND, EITHER
// EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO
// EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES
// OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
// ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
// DEALINGS IN THE SOFTWARE.
//
//------------------------------------------------------------------------------

#import <Foundation/Foundation.h>

/**
 * Describes the name of a model entity.
 *
 * ### String Subclassing
 * In Rails, `ActiveModel::Name` is a `String` subclass but not so
 * here. Instead, use the [AMName value] accessor for the underlying name
 * string. Objective-C utilises class clustering for `NSString` objects. Hence
 * what appears to be an `NSString` might well be some other class posing as an
 * `NSString`; this includes non-Objective-C objects such as
 * `CFStringRef`. Therefore, in Objective-C, if you want the underlying name
 * string, send `-[name value]`.
 */
@interface AMName : NSObject

/**
 * Answers the model name.
 */
@property(copy, readonly, NS_NONATOMIC_IOSONLY) NSString *value;
@property(copy, readonly, NS_NONATOMIC_IOSONLY) NSString *singular;
@property(copy, readonly, NS_NONATOMIC_IOSONLY) NSString *plural;
@property(copy, readonly, NS_NONATOMIC_IOSONLY) NSString *element;

/**
 * Initialises a new Active Model Name. The string argument gives the name of
 * the model, in singular form, never plural.
 */
- (id)initWithString:(NSString *)string;

/**
 * Initialises a new Active Model Name using the given Objective-C class.
 *
 * The argument identifies an Objective-C class. By convention in
 * Objective-C, the initial sequence of capital letters identify the class' name
 * space, e.g. `NS` in `NSObject` puts the class within the NextStep name
 * space. The active model name strips off these initial name-spacing
 * capitals. Hence `NSObject` yields the name `Object`.
 */
- (id)initWithClass:(Class)aClass;

@end

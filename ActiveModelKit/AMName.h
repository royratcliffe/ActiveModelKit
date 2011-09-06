// ActiveModelKit AMName.h
//
// Copyright © 2011, Roy Ratcliffe, Pioneering Software, United Kingdom
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

// Define NS_NONATOMIC_IOSONLY here for now if not already defined. This is
// necessary during the transition between iOS 4.3 and iOS 5.0. Lion already
// defines NS_NONATOMIC_IOSONLY but iOS 4.3 does not. Instead it defines
// NS_NONATOMIC_IPHONEONLY; the phone has become the OS!
#if !defined(NS_NONATOMIC_IOSONLY)
#if TARGET_OS_IPHONE
#define NS_NONATOMIC_IOSONLY nonatomic
#else
#define NS_NONATOMIC_IOSONLY
#endif
#endif

@interface AMName : NSObject

@property(copy, readonly, NS_NONATOMIC_IOSONLY) NSString *name;
@property(copy, readonly, NS_NONATOMIC_IOSONLY) NSString *singular;
@property(copy, readonly, NS_NONATOMIC_IOSONLY) NSString *plural;
@property(copy, readonly, NS_NONATOMIC_IOSONLY) NSString *element;

/*!
 * Initialises a new Active Model Name. The string argument gives the name of
 * the model, in singular form, never plural.
 */
- (id)initWithString:(NSString *)string;
- (id)initWithClass:(Class)aClass;

@end

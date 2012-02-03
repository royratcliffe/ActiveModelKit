// ActiveModelKit AMSerialization.m
//
// Copyright © 2011, 2012, Roy Ratcliffe, Pioneering Software, United Kingdom
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

#import "AMSerialization.h"

// Import Objective-C Message Header
// When using Automatic Reference Counting, avoid using -[NSObject
// performSelector:] to circumvent the "may cause a leak because its selector is
// unknown" warning. Instead use objc_msgSend, but this requires Objective-C
// run-time headers.
#import <objc/message.h>

NSString *const kAMOnlyOptionKey = @"only";
NSString *const kAMExceptOptionKey = @"except";
NSString *const kAMMethodsOptionKey = @"methods";

// Rails implements Active Model serialisation using mix-ins. Objective-C has
// nothing similar, let alone equivalent. Protocols are the only thing you can
// ‘mix in,’ so to speak. However, Objective-C protocols cannot implement
// behaviour but can only declare interfaces. Hence wrap the behaviour as a
// functional helper.
NSDictionary *AMSerializableHash(id<AMAttributeMethods> objectWithAttributes, NSDictionary *options)
{
	NSMutableDictionary *hash = [NSMutableDictionary dictionaryWithDictionary:[objectWithAttributes attributes]];
	
	NSArray *only = [options objectForKey:kAMOnlyOptionKey];
	if (only)
	{
		NSMutableSet *attributeNames = [NSMutableSet setWithArray:[hash allKeys]];
		[attributeNames minusSet:[NSSet setWithArray:only]];
		[hash removeObjectsForKeys:[attributeNames allObjects]];
	}
	else
	{
		NSArray *except = [options objectForKey:kAMExceptOptionKey];
		if (except)
		{
			[hash removeObjectsForKeys:except];
		}
	}
	
	for (NSString *methodName in [options objectForKey:kAMMethodsOptionKey])
	{
		SEL selector = NSSelectorFromString(methodName);
		if ([objectWithAttributes respondsToSelector:selector])
		{
			[hash setObject:objc_msgSend(objectWithAttributes, selector) forKey:methodName];
		}
	}
	
	// Unlike the Rails counterpart, do not send the attribute names as
	// getters. Optimise by assuming that the original message (above) to access
	// all attributes along with attribute names as keys constitutes the getting
	// phase for attributes.
	return [hash copy];
}

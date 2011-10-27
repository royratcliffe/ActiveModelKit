// ActiveModelKit AMJSONSerializers.m
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

#import "AMJSONSerializers.h"
#import "AMSerialization.h"
#import "AMName.h"

NSString *const kAMRootOptionKey = @"root";

NSDictionary *AMAsJSON(id<AMAttributeMethods> objectWithAttributes, NSDictionary *options)
{
	NSDictionary *hash = AMSerializableHash(objectWithAttributes, options);
	
	NSString *root = [options objectForKey:kAMRootOptionKey];
	if (root == nil)
	{
		// Send +includesRootInJSON to the object's class, if the class responds
		// to that selector. If it does not, assume that the class wants to
		// include the root, as the default. Use the class name as the root.
		Class classWithAttributes = [objectWithAttributes class];
		SEL includesRootInJSONSelector = @selector(includesRootInJSON);
		if (![classWithAttributes respondsToSelector:includesRootInJSONSelector] || [[classWithAttributes performSelector:includesRootInJSONSelector] boolValue])
		{
			root = [[[[AMName alloc] initWithClass:classWithAttributes] autorelease] element];
		}
	}
	
	return root ? [NSDictionary dictionaryWithObject:hash forKey:root] : hash;
}

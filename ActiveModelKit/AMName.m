// ActiveModelKit AMName.m
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

#import "AMName.h"

#import <ActiveSupportKit/ActiveSupportKit.h>

// Use a class continuation to modify the properties, changing readonly to
// “readwrite.” Privately therefore, the class can modify its own properties
// using standard accessors.
@interface AMName()

@property(copy, readwrite, NS_NONATOMIC_IPHONEONLY) NSString *name;
@property(copy, readwrite, NS_NONATOMIC_IPHONEONLY) NSString *singular;
@property(copy, readwrite, NS_NONATOMIC_IPHONEONLY) NSString *plural;
@property(copy, readwrite, NS_NONATOMIC_IPHONEONLY) NSString *element;

@end

@implementation AMName

@synthesize name = _name;
@synthesize singular = _singular;
@synthesize plural = _plural;
@synthesize element = _element;

// designated initialiser
- (id)initWithString:(NSString *)string
{
	self = [super init];
	if (self)
	{
		// Everything depends on the name. Every other property derives from
		// it. Normally, the name equates to the class name.
		//
		// Regarding singular, underscoring translates dashes to
		// underscores. Here, singularizing the name undoes that last step by
		// converting the underscores back to dashes.
		[self setName:string];
		[self setSingular:[ASInflectorUnderscore([self name]) stringByReplacingOccurrencesOfString:@"_" withString:@"-"]];
		[self setPlural:[[ASInflector defaultInflector] pluralize:[self singular]]];
		[self setElement:ASInflectorUnderscore(ASInflectorDemodulize([self name]))];
	}
	return self;
}

- (id)initWithClass:(Class)aClass
{
	return [self initWithString:NSStringFromClass(aClass)];
}

- (NSString *)description
{
	return [self name];
}

@end

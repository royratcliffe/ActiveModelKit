// ActiveModelKitTests ActiveModelKitTests.m
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

#import "ActiveModelKitTests.h"
#import <ActiveModelKit/ActiveModelKit.h>

@interface Person : NSObject<AMAttributeMethods>

@property(copy, NS_NONATOMIC_IOSONLY) NSString *name;

@end

@implementation Person

@synthesize name = _name;

- (NSDictionary *)attributes
{
	NSString *name = [self name];
	return [NSDictionary dictionaryWithObject:name ? name : [NSNull null] forKey:@"name"];
}

@end

@implementation ActiveModelKitTests

//------------------------------------------------------------------------------
#pragma                                                        Active Model Name
//------------------------------------------------------------------------------

- (void)testNameDescriptionEqualsClassDescription
{
	AMName *name = [[[AMName alloc] initWithClass:[NSObject class]] autorelease];
	STAssertEqualObjects([name description], [NSObject description], nil);
	// Note that NSObject has a class-scoped +description method as well as an
	// instance method by the same name.
}

- (void)testSingular
{
	STAssertEqualObjects([[[[AMName alloc] initWithClass:[NSObject class]] autorelease] singular], @"ns-object", nil);
}

- (void)testPlural
{
	STAssertEqualObjects([[[[AMName alloc] initWithClass:[NSObject class]] autorelease] plural], @"ns-objects", nil);
}

- (void)testElement
{
	STAssertEqualObjects([[[[AMName alloc] initWithClass:[NSObject class]] autorelease] plural], @"ns-objects", nil);
}

//------------------------------------------------------------------------------
#pragma mark                                                       Serialisation
//------------------------------------------------------------------------------

- (void)testSerializableHash
{
	Person *person = [[[Person alloc] init] autorelease];
	NSDictionary *hash = AMSerializableHash(person, nil);
	STAssertEqualObjects(hash, [NSDictionary dictionaryWithObject:[NSNull null] forKey:@"name"], nil);
	
	person.name = @"Bob";
	STAssertEqualObjects(AMSerializableHash(person, nil), [NSDictionary dictionaryWithObject:@"Bob" forKey:@"name"], nil);
	
	// only
	NSDictionary *options = [NSDictionary dictionaryWithObject:[NSArray arrayWithObject:@"name"] forKey:kAMOnlyOptionKey];
	STAssertEqualObjects(AMSerializableHash(person, options), [NSDictionary dictionaryWithObject:@"Bob" forKey:@"name"], nil);
	
	// except
	options = [NSDictionary dictionaryWithObject:[NSArray arrayWithObject:@"name"] forKey:kAMExceptOptionKey];
	STAssertEqualObjects(AMSerializableHash(person, options), [NSDictionary dictionary], nil);
}

- (void)testAsJSON
{
	Person *person = [[[Person alloc] init] autorelease];
	[person setName:@"Bob"];
	NSDictionary *options = [NSDictionary dictionaryWithObject:@"person" forKey:kAMRootOptionKey];
	STAssertEqualObjects(AMAsJSON(person, options), [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:@"Bob" forKey:@"name"] forKey:@"person"], nil);
}

@end

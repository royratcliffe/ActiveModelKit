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

@interface User : NSObject<AMAttributeMethods>

@property(copy, NS_NONATOMIC_IOSONLY) NSString *name;
@property(copy, NS_NONATOMIC_IOSONLY) NSNumber *age;
@property(copy, NS_NONATOMIC_IOSONLY) NSDate   *createdAt;
@property(copy, NS_NONATOMIC_IOSONLY) NSNumber *awesome;

@end

@implementation User

@synthesize name      = _name;
@synthesize age       = _age;
@synthesize createdAt = _createdAt;
@synthesize awesome   = _awesome;

- (NSDictionary *)attributes
{
	id name      = [self name];
	id age       = [self age];
	id createdAt = [self createdAt];
	id awesome   = [self awesome];
	
	if (name == nil)      name = [NSNull null];
	if (age == nil)       age = [NSNull null];
	if (createdAt == nil) createdAt = [NSNull null];
	if (awesome == nil)   awesome = [NSNull null];
	
	return [NSDictionary dictionaryWithObjectsAndKeys:name, @"name", age, @"age", createdAt, @"created_at", awesome, @"awesome", nil];
}

@end

@implementation ActiveModelKitTests

//------------------------------------------------------------------------------
#pragma                                                        Active Model Name
//------------------------------------------------------------------------------

- (void)testNameDescriptionEqualsClassDescriptionWithoutNamespace
{
	AMName *name = [[AMName alloc] initWithClass:[NSObject class]];
	STAssertEqualObjects([name description], @"Object", nil);
	// Note that NSObject has a class-scoped +description method as well as an
	// instance method by the same name.
}

- (void)testSingular
{
	STAssertEqualObjects([[[AMName alloc] initWithClass:[NSObject class]] singular], @"object", nil);
}

- (void)testPlural
{
	STAssertEqualObjects([[[AMName alloc] initWithClass:[NSObject class]] plural], @"objects", nil);
}

- (void)testElement
{
	STAssertEqualObjects([[[AMName alloc] initWithClass:[NSObject class]] element], @"object", nil);
}

//------------------------------------------------------------------------------
#pragma mark                                                       Serialisation
//------------------------------------------------------------------------------

- (void)testSerializableHash
{
	Person *person = [[Person alloc] init];
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

- (void)testPersonAsJSON
{
	Person *person = [[Person alloc] init];
	[person setName:@"Bob"];
	
	NSString *root = @"root";
	NSDictionary *options = [NSDictionary dictionaryWithObject:root forKey:kAMRootOptionKey];
	NSDictionary *hash = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:@"Bob" forKey:@"name"] forKey:root];
	STAssertEqualObjects(AMAsJSON(person, options), hash, nil);
	
	hash = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:@"Bob" forKey:@"name"] forKey:@"person"];
	STAssertEqualObjects(AMAsJSON(person, nil), hash, nil);
}

- (void)testUserAsJSON
{
	User *user = [[User alloc] init];
	user.name = @"Konata Izumi";
	user.age = [NSNumber numberWithInt:16];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy/MM/dd"];
	[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	user.createdAt = [dateFormatter dateFromString:@"2006/08/01"];
	user.awesome = [NSNumber numberWithBool:YES];
	
	NSDictionary *hash = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObjectsAndKeys:user.name, @"name", user.age, @"age", user.createdAt, @"created_at", user.awesome, @"awesome", nil] forKey:@"user"];
	STAssertEqualObjects(AMAsJSON(user, nil), hash, nil);
	
	// only name
	NSDictionary *options = [NSDictionary dictionaryWithObject:[NSArray arrayWithObject:@"name"] forKey:kAMOnlyOptionKey];
	hash = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObjectsAndKeys:user.name, @"name", nil] forKey:@"user"];
	STAssertEqualObjects(AMAsJSON(user, options), hash, nil);
	
	// except created_at and age
	options = [NSDictionary dictionaryWithObject:[NSArray arrayWithObjects:@"created_at", @"age", nil] forKey:kAMExceptOptionKey];
	hash = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObjectsAndKeys:user.name, @"name", user.awesome, @"awesome", nil] forKey:@"user"];
	STAssertEqualObjects(AMAsJSON(user, options), hash, nil);
}

@end

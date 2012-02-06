// ActiveModelKit AMSerialization.h
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

#import <ActiveModelKit/AMAttributeMethods.h>

extern NSString *const kAMOnlyOptionKey;
extern NSString *const kAMExceptOptionKey;
extern NSString *const kAMMethodsOptionKey;

/*!
 * @brief Serialises an object's attributes.
 * @param objectWithAttributes Object answering an NSDictionary of attribute
 * name-values when sent -[NSObject attributes] message.
 * @param options Dictionary of options where:
 * - @ref kAMOnlyOptionKey specifies an array of attribute name strings. The
 *   “only” option defines an array of attribute names, strings, which should @e
 *   only appear in the serializable hash.
 * - @ref kAMExceptOptionKey specifies an array of attribute name strings.
 * - @ref kAMMethodsOptionKey specifies an array of selector strings.
 * @details Requires that a given object implements the -attributes method which
 * answers a dictionary of attribute name-value pairs.
 * @par Only Takes Precedence
 * Note that “only” takes precedence over “except.” You cannot have only some
 * attributes and except other attributes. If your options include both types of
 * inclusion or exclusion, the former modifies the attributes serialised, and
 * the serialisation operation ignores the latter.
 */
NSDictionary *AMSerializableHash(id<AMAttributeMethods> objectWithAttributes, NSDictionary *options);

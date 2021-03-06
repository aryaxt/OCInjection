//
//  DIInjector.m
//  OCDependencyInjection
//
//  Created by Aryan Gh on 4/28/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//
// https://github.com/aryaxt/OCInjection
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "DIInjector.h"

@interface DIInjector()
@property (nonatomic, strong) DIAbstractModule *module;
@end

@implementation DIInjector
@synthesize module;

#pragma mark - Initialization -

static DIInjector *singleton;

+ (id)sharedInstance
{
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		singleton = [[DIInjector alloc] _init];
	});
	
	return singleton;
}

- (id)_init
{
	if (self = [super init])
	{
		Method originalMethod = class_getClassMethod([NSObject class], @selector(resolveInstanceMethod:));
		Method swizzleMethod = class_getInstanceMethod([self class], @selector(replacement_resolveInstanceMethod:));
		method_exchangeImplementations(originalMethod, swizzleMethod);
	}
	
	return self;
}

- (id)init
{
	@throw ([NSException exceptionWithName:@"IllegalInitializerException"
									reason:@"Illegal init call, use the sharedInstance method to access the singleton instance."
								  userInfo:nil]);
}

#pragma mark - Public Methods -

- (id)resolveForClass:(Class)class
{
	return [self.module injectionObjectForClass:class];
}

- (id)resolveForProtocol:(Protocol *)protocol
{
	return [self.module injectionObjectForProtocol:protocol];
}

- (void)setDefaultModule:(DIAbstractModule *)aModeule
{
	self.module = aModeule;
	[self.module configure];
}

#pragma mark - Private MEthods -

- (BOOL)replacement_resolveInstanceMethod:(SEL)aSEL
{
    NSString *methodName = NSStringFromSelector(aSEL);
	
    if ([[methodName substringFromIndex:methodName.length-1] isEqual:@":"])
    {
		NSString *propertyName = propertyNameFromSetterName(methodName);
		id objectTypeString = typeForProperty([self class], propertyName);
		
		if ([singleton.module canResolveObjectForType:objectTypeString])
		{
			class_addMethod([self class], aSEL, (IMP)accessorSetter, "v@:@");
			return YES;
		}
    }
    else
    {
		id objectTypeString = typeForProperty([self class], methodName);
		
		if ([singleton.module canResolveObjectForType:objectTypeString])
		{
			class_addMethod([self class], aSEL, (IMP)accessorGetter, "@@:");
			return YES;
		}
    }
	
    return NO;
}

#pragma mark - C Functions -

bool classHasProperty(Class class, NSString *testPropertyName)
{
	unsigned int propertyCount = 0;
	objc_property_t *properties = class_copyPropertyList(class, &propertyCount);
	
	for (unsigned int i=0; i<propertyCount; ++i)
	{
		objc_property_t property = properties[i];
		const char *name = property_getName(property);
		
		if ([[NSString stringWithUTF8String:name] isEqual:testPropertyName])
		{
			free(properties);
			return YES;
		}
	}
	
	free(properties);
	return NO;
}

/* 
 returns a protocol or a class representing a property 
*/
id typeForProperty(Class class, NSString *propertyName)
{
	if (!classHasProperty(class, propertyName))
		return nil;
	
	const char *type = property_getAttributes(class_getProperty(class, [propertyName UTF8String]));
	NSString *typeString = [NSString stringWithUTF8String:type];
	NSArray *attributes = [typeString componentsSeparatedByString:@","];
	NSString *typeAttribute = [attributes objectAtIndex:0];
	
	// Type Attribute For Class       T@"ClassName"
	// Type Attribute For Protocol    T@"<ProtocolName>"
	// Here we trim these characters to end of with a raw class/protocol name
	
	BOOL isProtocol = [typeAttribute rangeOfString:@"<"].length ? YES : NO;;
	
	typeAttribute = [[[[typeAttribute substringFromIndex:3]
			   stringByReplacingOccurrencesOfString:@"\"" withString:@""]
			   stringByReplacingOccurrencesOfString:@"<" withString:@""]
			   stringByReplacingOccurrencesOfString:@">" withString:@""];
	
	if (isProtocol)
		return NSProtocolFromString(typeAttribute);
	else
		return NSClassFromString(typeAttribute);
}

NSString* propertyNameFromSetterName(NSString *setterName)
{
	NSString *propertyName = [setterName substringFromIndex:3];
	propertyName = [propertyName stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[propertyName substringToIndex:1] lowercaseString]];
	propertyName = [propertyName substringToIndex:propertyName.length-1];
	return propertyName;
}

id accessorGetter(id self, SEL _cmd)
{
	NSString *propertyName = NSStringFromSelector(_cmd);
	objc_property_t property = class_getProperty([self class], [propertyName UTF8String]);
	id currentValue = objc_getAssociatedObject(self, property);
	
	if (!currentValue)
	{
		id typeString = typeForProperty([self class], propertyName);
		currentValue = currentValue = [singleton.module injectionObjectForType:typeString];
		objc_setAssociatedObject(self, property, currentValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	
	return currentValue;
}

void accessorSetter(id self, SEL _cmd, id newValue)
{
	NSString *propertyName = propertyNameFromSetterName(NSStringFromSelector(_cmd));
	objc_property_t property = class_getProperty([self class], [propertyName UTF8String]);
	objc_setAssociatedObject(self, property, newValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

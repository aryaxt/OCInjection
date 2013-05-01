//
//  DIInjector.m
//  OCDependencyInjection
//
//  Created by Aryan Gh on 4/28/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

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
	@throw ([NSException exceptionWithName:@"Illegal Initializer"
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
	
    if ([methodName hasPrefix:@"set"])
    {
		NSString *getterName = [[methodName substringFromIndex:3] lowercaseString];
		getterName = [getterName substringToIndex:getterName.length-1];
		NSString *objectTypeString = typeForProperty([self class], getterName);
		
		if ([singleton.module canResolveObjectForType:objectTypeString])
		{
			class_addMethod([self class], aSEL, (IMP)accessorSetter, "v@:@");
			return YES;
		}
    }
    else
    {
		NSString *objectTypeString = typeForProperty([self class], methodName);
		
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

NSString* typeForProperty(Class class, NSString *propertyName)
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
	
	return [[[[[typeAttribute substringFromIndex:1]
			   stringByReplacingOccurrencesOfString:@"@" withString:@""]
			  stringByReplacingOccurrencesOfString:@"\"" withString:@""]
			 stringByReplacingOccurrencesOfString:@"<" withString:@""]
			stringByReplacingOccurrencesOfString:@">" withString:@""];
}

id accessorGetter(id self, SEL _cmd)
{
	NSString *propertyName = NSStringFromSelector(_cmd);
	NSString *typeString = typeForProperty([self class], propertyName);
	char const * const objectTagKey = [NSStringFromSelector(_cmd) UTF8String];
	id currentValue = objc_getAssociatedObject(self, objectTagKey);
	
	if (!currentValue)
	{
		currentValue = currentValue = [singleton.module injectionObjectForType:typeString];
		objc_setAssociatedObject(self, objectTagKey, currentValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	
	return currentValue;
}

void accessorSetter(id self, SEL _cmd, id newValue)
{
	char const * const objectTagKey = [NSStringFromSelector(_cmd) UTF8String];
	objc_setAssociatedObject(self, objectTagKey, newValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

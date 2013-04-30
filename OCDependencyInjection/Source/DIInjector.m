//
//  DIInjector.m
//  OCDependencyInjection
//
//  Created by Aryan Gh on 4/28/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import "DIInjector.h"

static NSMutableDictionary *bindingDictionary;
static DIInjector *singleton;

@implementation DIInjector

#pragma mark - Initialization -

+ (id)sharedInstance
{
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		singleton = [[DIInjector alloc] init];
	});
	
	return singleton;
}

- (id)init
{
	if (self = [super init])
	{
		bindingDictionary = [NSMutableDictionary dictionary];
		
		[self initializeInjector];
	}
	
	return self;
}

- (void)initializeInjector
{
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		Method originalMethod = class_getClassMethod([NSObject class], @selector(resolveInstanceMethod:));
		Method swizzleMethod = class_getInstanceMethod([self class], @selector(replacement_resolveInstanceMethod:));
		method_exchangeImplementations(originalMethod, swizzleMethod);
	});
}

#pragma mark - Public Methods -

- (void)bindClass:(Class)from toClass:(Class)to
{
	[bindingDictionary setObject:NSStringFromClass(from) forKey:NSStringFromClass(to)];
}

- (void)bindProtocol:(Protocol *)protocol toClass:(Class)class
{
	if (![class conformsToProtocol:protocol])
		@throw ([NSException exceptionWithName:@"INvalid Binding"
				reason:[NSString stringWithFormat:@"%@ does not conform to %@",
						NSStringFromClass(class),
						NSStringFromProtocol(protocol)]
				userInfo:nil]);
	
	[bindingDictionary setObject:NSStringFromClass(class) forKey:NSStringFromProtocol(protocol)];
}

- (void)bindClass:(Class)class toInstance:(id)instance
{
	[bindingDictionary setObject:instance forKey:NSStringFromClass(class)];
}

- (void)bindProtocol:(Protocol *)protocol toInstance:(id)instance
{
	[bindingDictionary setObject:instance forKey:NSStringFromProtocol(protocol)];
}

- (id)resolveForClass:(Class)class
{
	return injectingObjectForTypeString(NSStringFromClass(class));
}

- (id)resolveForProtocol:(Protocol *)protocol
{
	return injectingObjectForTypeString(NSStringFromProtocol(protocol));
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
		
		if ([bindingDictionary objectForKey:objectTypeString])
		{
			class_addMethod([self class], aSEL, (IMP)accessorSetter, "v@:@");
			return YES;
		}
    }
    else
    {
		NSString *objectTypeString = typeForProperty([self class], methodName);
		if ([bindingDictionary objectForKey:objectTypeString])
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

id injectingObjectForTypeString(NSString *typeString)
{
	id object;
	id injectionBinding = [bindingDictionary objectForKey:typeString];
	
	#warning If it's string it's class name otherwise it's an instance of object
	#warning Very hacky fix this later
	if ([injectionBinding respondsToSelector:@selector(substringFromIndex:)])
	{
		Class class = NSClassFromString([bindingDictionary objectForKey:typeString]);
		object = [[class alloc] init];
	}
	else
	{
		object = injectionBinding;
	}
	
	return object;
}

NSString* typeForProperty(Class class, NSString *propertyName)
{
	if (!classHasProperty(class, propertyName))
		return nil;
	
	const char *type = property_getAttributes(class_getProperty(class, [propertyName UTF8String]));
	NSString *typeString = [NSString stringWithUTF8String:type];
	NSArray *attributes = [typeString componentsSeparatedByString:@","];
	NSString *typeAttribute = [attributes objectAtIndex:0];
	
	// Type Attribute For Class       T@"NSString"
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
		currentValue = injectingObjectForTypeString(typeString);
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

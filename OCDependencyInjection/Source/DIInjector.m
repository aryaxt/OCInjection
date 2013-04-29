//
//  DIInjector.m
//  OCDependencyInjection
//
//  Created by Aryan Gh on 4/28/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import "DIInjector.h"

static NSMutableDictionary *bindingDictionary;

@implementation DIInjector

+ (id)sharedInstance
{
	static DIInjector *singleton;
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

- (void)initializeInjector
{
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		Method originalMethod = class_getClassMethod([NSObject class], @selector(resolveInstanceMethod:)); // save the oringinal implementation so it can be restored
		Method swizzleMethod = class_getInstanceMethod([self class], @selector(replacement_resolveInstanceMethod:)); // save the replacement method
		method_exchangeImplementations(originalMethod, swizzleMethod);
	});
}

- (Class)classForKey:(NSString *)key
{
	return NSClassFromString([bindingDictionary objectForKey:key]);
}

- (BOOL)replacement_resolveInstanceMethod:(SEL)aSEL
{
    NSString *method = NSStringFromSelector(aSEL);
	
    if ([method hasPrefix:@"set"])
    {
		NSString *getterName = [[method substringFromIndex:3] lowercaseString];
		getterName = [getterName substringToIndex:getterName.length-1];
		NSString *objectTypeString = [DIInjector typeForProperty:getterName andClass:[self class]];
		
		if ([bindingDictionary objectForKey:objectTypeString])
		{
			class_addMethod([self class], aSEL, (IMP) accessorSetter, "v@:@");
			return YES;
		}
    }
    else
    {
		NSString *objectTypeString = [DIInjector typeForProperty:method andClass:[self class]];
		if ([bindingDictionary objectForKey:objectTypeString])
		{
			class_addMethod([self class], aSEL, (IMP) accessorGetter, "@@:");
			return YES;
		}
    }
	
    return NO;
}

id accessorGetter(id self, SEL _cmd)
{
	NSString *propertyName = NSStringFromSelector(_cmd);
	const char *type = property_getAttributes(class_getProperty([self class], [propertyName UTF8String]));
	NSString *typeString = [NSString stringWithUTF8String:type];
	NSArray *attributes = [typeString componentsSeparatedByString:@","];
	NSString *typeAttribute = [attributes objectAtIndex:0];
	typeAttribute = [[[[[typeAttribute substringFromIndex:1]
			   stringByReplacingOccurrencesOfString:@"@" withString:@""]
			  stringByReplacingOccurrencesOfString:@"\"" withString:@""]
			 stringByReplacingOccurrencesOfString:@"<" withString:@""]
			stringByReplacingOccurrencesOfString:@">" withString:@""];
	
	char const * const ObjectTagKey = [NSStringFromSelector(_cmd) UTF8String];
	id currentValue = objc_getAssociatedObject(self, ObjectTagKey);
	
	if (!currentValue)
	{
		id injectionBinding = [bindingDictionary objectForKey:typeAttribute];
		
		#warning If it's string it's class name otherwise it's an instance of object
		#warning Very hacky fix this later
		if ([injectionBinding respondsToSelector:@selector(substringFromIndex:)])
		{
			Class class = NSClassFromString([bindingDictionary objectForKey:typeAttribute]);
			currentValue = [[class alloc] init];
		}
		else
		{
			currentValue = injectionBinding;
		}
		
		objc_setAssociatedObject(self, ObjectTagKey, currentValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	
	return currentValue;
}

void accessorSetter(id self, SEL _cmd, NSString* newValue)
{
	char const * const ObjectTagKey = [NSStringFromSelector(_cmd) UTF8String];
	objc_setAssociatedObject(self, ObjectTagKey, newValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (BOOL)class:(Class)class hasProperty:(NSString *)testProperty
{
	unsigned int propertyCount = 0;
	objc_property_t * properties = class_copyPropertyList(class, &propertyCount);
	
	for (unsigned int i = 0; i < propertyCount; ++i)
	{
		objc_property_t property = properties[i];
		const char * name = property_getName(property);
		
		if ([[NSString stringWithUTF8String:name] isEqual:testProperty])
			return YES;
	}
	
	free(properties);
	return NO;
}

+ (NSString *)typeForProperty:(NSString *)property andClass:(Class)class
{
	if (![DIInjector class:class hasProperty:property])
		return nil;
	
	const char *type = property_getAttributes(class_getProperty(class, [property UTF8String]));
	NSString *typeString = [NSString stringWithUTF8String:type];
	NSArray *attributes = [typeString componentsSeparatedByString:@","];
	NSString *typeAttribute = [attributes objectAtIndex:0];
	return [[[[[typeAttribute substringFromIndex:1]
			   stringByReplacingOccurrencesOfString:@"@" withString:@""]
			  stringByReplacingOccurrencesOfString:@"\"" withString:@""]
			 stringByReplacingOccurrencesOfString:@"<" withString:@""]
			stringByReplacingOccurrencesOfString:@">" withString:@""];
}



@end

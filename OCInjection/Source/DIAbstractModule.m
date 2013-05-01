//
//  DIAbstractModule.m
//  OCInjection
//
//  Created by Aryan Ghassemi on 4/30/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import "DIAbstractModule.h"

@interface DIAbstractModule()
@property (nonatomic, strong) NSMutableDictionary *bindingDictionary;
@end

@implementation DIAbstractModule
@synthesize bindingDictionary;

#pragma mark - Initialization -

- (id)init
{
	if (self = [super init])
	{
		self.bindingDictionary = [NSMutableDictionary dictionary];
	}
	
	return self;
}

#pragma mark - Public Methods -

- (void)configure
{
	// Do nothing here
}

- (void)bindClass:(Class)from toClass:(Class)to asSingleton:(BOOL)isSingleton
{
	if (!isSingleton)
		[self bindClass:from toClass:to];
	else
		[self bindClass:from toInstance:[[to alloc] init]];
}

- (void)bindClass:(Class)from toClass:(Class)to
{
	[self storeBinding:NSStringFromClass(from) forKey:NSStringFromClass(to)];
}

- (void)bindClass:(Class)class toInstance:(id)instance
{
	[self storeBinding:instance forKey:NSStringFromClass(class)];
}

- (void)bindProtocol:(Protocol *)protocol toClass:(Class)class asSingleton:(BOOL)isSingleton
{
	if (!isSingleton)
		[self bindProtocol:protocol toClass:class];
	else
		[self bindProtocol:protocol toInstance:[[class alloc] init]];
}

- (void)bindProtocol:(Protocol *)protocol toClass:(Class)class
{
	if (![class conformsToProtocol:protocol])
		@throw ([self invalidBindingExceptionFrom:NSStringFromClass(class) to:NSStringFromProtocol(protocol)]);
	
	[self storeBinding:NSStringFromClass(class) forKey:NSStringFromProtocol(protocol)];
}

- (void)bindProtocol:(Protocol *)protocol toInstance:(id)instance
{
	if (![instance conformsToProtocol:protocol])
		@throw ([self invalidBindingExceptionFrom:[instance description] to:NSStringFromProtocol(protocol)]);
	
	[self storeBinding:instance forKey:NSStringFromProtocol(protocol)];
}

- (BOOL)canResolveObjectForType:(NSString *)type
{
	if ([self.bindingDictionary objectForKey:type])
		return YES;
	
	return NO;
}

- (id)injectionObjectForClass:(Class)class
{
	return [self injectionObjectForType:NSStringFromClass(class)];
}

- (id)injectionObjectForProtocol:(Protocol *)protocol
{
	return [self injectionObjectForType:NSStringFromProtocol(protocol)];
}

- (id)injectionObjectForType:(NSString *)type
{
	id injectionBinding = [self.bindingDictionary objectForKey:type];
	
	#warning If it's string it's class name otherwise it's an instance of object
	#warning Very hacky fix this later
	if ([injectionBinding respondsToSelector:@selector(substringFromIndex:)])
	{
		Class class = NSClassFromString(injectionBinding);
		return [[class alloc] init];
	}
	else
	{
		return injectionBinding;
	}
}

#pragma mark - Private Methods -

- (void)storeBinding:(id)binding forKey:(NSString *)key
{
	[self validateForExistingBindingForKey:key];
	[self.bindingDictionary setObject:binding forKey:key];
}

- (NSException *)invalidBindingExceptionFrom:(NSString *)from to:(NSString *)to
{
	return [NSException exceptionWithName:@"Invalid Binding"
								   reason:[NSString stringWithFormat:@"%@ does not conform to %@",
										   from,
										   to]
								 userInfo:nil];
}

- (void)validateForExistingBindingForKey:(NSString *)key
{
	if ([bindingDictionary objectForKey:key])
		@throw ([NSException exceptionWithName:@"Invalid Binding"
										reason:[NSString stringWithFormat:@"Binding already exists for %@", key]
									  userInfo:nil]);
}

@end

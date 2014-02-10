//
//  DIAbstractModule.m
//  OCInjection
//
//  Created by Aryan Ghassemi on 4/30/13.
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

#import "DIAbstractModule.h"

@interface DIAbstractModule() <DIContructorInjectorProxyDelegate>
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

#pragma mark - Class Methods -

+ (id)_injectMacro:(id)x
{
	id result;
	
	@try {
		result = NSStringFromProtocol(x);
	}
	@catch (NSException *exception) {
		
	}
	
	if (result)
		return result;
	
	@try {
		result = NSStringFromClass(x);
	}
	@catch (NSException *exception) {
		
	}
	
	return result;
}

#pragma mark - Public Methods -

- (void)configure
{
	[self bindClassToSelf:[NSDateFormatter self]];
	[self bindClassToSelf:[NSMutableArray self]];
	[self bindClassToSelf:[NSArray self]];
	[self bindClassToSelf:[NSMutableDictionary self]];
	[self bindClassToSelf:[NSDictionary self]];
}

- (DIContructorInjectorProxy *)bindClassToSelf:(Class)class
{
	return [self bindClass:class toClass:class];
}

- (DIContructorInjectorProxy *)bindClass:(Class)from toClass:(Class)to asSingleton:(BOOL)isSingleton
{
	if (!isSingleton)
		return [self bindClass:from toClass:to];
	else
		return [self bindClass:from toInstance:[[to alloc] init]];
}

- (DIContructorInjectorProxy *)bindClass:(Class)from toClass:(Class)to
{
	return [self storeBinding:NSStringFromClass(from) forKey:NSStringFromClass(to)];
}

- (DIContructorInjectorProxy *)bindClass:(Class)class toInstance:(id)instance
{
	return [self storeBinding:instance forKey:NSStringFromClass(class)];
}

- (DIContructorInjectorProxy *)bindProtocol:(Protocol *)protocol toClass:(Class)class asSingleton:(BOOL)isSingleton
{
	if (!isSingleton)
		return [self bindProtocol:protocol toClass:class];
	else
		return [self bindProtocol:protocol toInstance:[[class alloc] init]];
}

- (DIContructorInjectorProxy *)bindProtocol:(Protocol *)protocol toClass:(Class)class
{
	if (![class conformsToProtocol:protocol])
		@throw ([self invalidBindingExceptionFrom:NSStringFromClass(class) to:NSStringFromProtocol(protocol)]);
	
	return [self storeBinding:NSStringFromClass(class) forKey:NSStringFromProtocol(protocol)];
}

- (DIContructorInjectorProxy *)bindProtocol:(Protocol *)protocol toInstance:(id)instance
{
	if (![instance conformsToProtocol:protocol])
		@throw ([self invalidBindingExceptionFrom:[instance description] to:NSStringFromProtocol(protocol)]);
	
	return [self storeBinding:instance forKey:NSStringFromProtocol(protocol)];
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
	DIInjectionInfo *info = [self.bindingDictionary objectForKey:type];
	
	// #warning If it's string it's class name otherwise it's an instance of object
	// #warning Very hacky fix this later
	// #warning using isKindOfClass won't work, because a mock of protocol doesn't implement that method
	if ([info.injectionClassNameOrInstance respondsToSelector:@selector(substringFromIndex:)])
	{
		Class class = NSClassFromString(info.injectionClassNameOrInstance);
		
		if (info.constructorSelector)
		{
			id initInvocationResult = [class alloc];
			
			NSMethodSignature *signature = [class instanceMethodSignatureForSelector:info.constructorSelector];
			NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
			[invocation setSelector:info.constructorSelector];
			[invocation setTarget:initInvocationResult];
			
			for (int i=0 ; i<info.constructorArgumentTypes.count ; i++)
			{
				NSString *argumentType = [info.constructorArgumentTypes objectAtIndex:i];
				id injectingArgument = [self injectionObjectForType:argumentType];
				[invocation setArgument:&injectingArgument atIndex:i+2];
			}
			
			[invocation retainArguments];
			[invocation invoke];
			[invocation getReturnValue:&initInvocationResult];
			
			return initInvocationResult;
		}
		else
		{
			return [[class alloc] init];
		}
	}
	else
	{
		return info.injectionClassNameOrInstance;
	}
}

#pragma mark - Private Methods -

- (DIContructorInjectorProxy *)storeBinding:(id)binding forKey:(NSString *)key
{
	[self validateForExistingBindingForKey:key];
	
	DIInjectionInfo *info = [[DIInjectionInfo alloc] init];
	info.injectionClassNameOrInstance = binding;
	[self.bindingDictionary setObject:info forKey:key];
	
	Class class;
	
	// NSString is class name
	if ([binding isKindOfClass:[NSString class]])
		class = NSClassFromString(binding);
	// Non NSStirng is an actual instance
	else
		class = [binding class];
		
	return [[DIContructorInjectorProxy alloc] initWithClass:class bindingKey:key andDelegate:self];
}

- (NSException *)invalidBindingExceptionFrom:(NSString *)from to:(NSString *)to
{
	return [NSException exceptionWithName:@"InvalidBindingException"
								   reason:[NSString stringWithFormat:@"%@ does not conform to %@",
										   from,
										   to]
								 userInfo:nil];
}

- (void)validateForExistingBindingForKey:(NSString *)key
{
	if ([bindingDictionary objectForKey:key])
		@throw ([NSException exceptionWithName:@"InvalidBindingException"
										reason:[NSString stringWithFormat:@"Binding already exists for %@", key]
									  userInfo:nil]);
}

#pragma mark - DIContructorInjectorProxyDelegate -

- (void)dIContructorInjectorProxy:(DIContructorInjectorProxy *)proxy didSelectSelector:(SEL)selector withArgumentTypes:(NSArray *)arguments
{
	DIInjectionInfo *info = [self.bindingDictionary objectForKey:proxy.bindingKey];
	info.constructorSelector = selector;
	info.constructorArgumentTypes = arguments;
}

@end

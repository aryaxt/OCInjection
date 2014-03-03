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
@property (nonatomic, strong) NSMutableDictionary *singletonContainer;
@end

@implementation DIAbstractModule

#pragma mark - Initialization -

- (id)init
{
	if (self = [super init])
	{
		self.bindingDictionary = [NSMutableDictionary dictionary];
		self.singletonContainer = [NSMutableDictionary dictionary];
	}
	
	return self;
}

#pragma mark - Class Methods -

+ (DIConstructorArgument *)bindingConstructorArgumentFromClassOrProtocol:(id)classOrProtocol
{
	DIConstructorArgument *argument = [[DIConstructorArgument alloc] init];
	argument.isBinding = YES;
	argument.value = [DIAbstractModule stringFromClassOrProtocol:classOrProtocol];
	
	return argument;
}

+ (DIConstructorArgument *)valueConstructorArgumentFromValue:(NSObject *)value
{
	DIConstructorArgument *argument = [[DIConstructorArgument alloc] init];
	argument.isBinding = NO;
	argument.value = [value copy];
	return argument;
}

+ (NSString *)stringFromClassOrProtocol:(id)classOrProtocol
{
	if ([classOrProtocol isKindOfClass:NSClassFromString(@"Protocol")])
		return NSStringFromProtocol(classOrProtocol);
	else
		return NSStringFromClass(classOrProtocol);
}

+ (id)classOrProtocolFromString:(NSString *)string
{
	id result;
	
	result = NSProtocolFromString(string);
	
	if (!result)
		result = NSClassFromString(string);
	
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
	return [self storeBinding:to forKey:from asSingleton:isSingleton];
}

- (DIContructorInjectorProxy *)bindClass:(Class)from toClass:(Class)to
{
	return [self storeBinding:from forKey:to asSingleton:NO];
}

- (DIContructorInjectorProxy *)bindClass:(Class)class toInstance:(id)instance
{
	[self storeObjectAsSingleton:instance forBinding:class];
	return [self storeBinding:[instance class] forKey:class asSingleton:YES];
}

- (DIContructorInjectorProxy *)bindProtocol:(Protocol *)protocol toClass:(Class)class asSingleton:(BOOL)isSingleton
{
	return [self storeBinding:class forKey:protocol asSingleton:isSingleton];
}

- (DIContructorInjectorProxy *)bindProtocol:(Protocol *)protocol toClass:(Class)class
{
	if (![class conformsToProtocol:protocol])
		@throw ([self invalidBindingExceptionFrom:NSStringFromClass(class) to:NSStringFromProtocol(protocol)]);
	
	return [self storeBinding:class forKey:protocol asSingleton:NO];
}

- (DIContructorInjectorProxy *)bindProtocol:(Protocol *)protocol toInstance:(id)instance
{
	if (![instance conformsToProtocol:protocol])
		@throw ([self invalidBindingExceptionFrom:[instance description] to:NSStringFromProtocol(protocol)]);
	
	[self storeObjectAsSingleton:instance forBinding:protocol];
	return [self storeBinding:[instance class] forKey:protocol asSingleton:YES];
	
}

- (BOOL)canResolveObjectForType:(id)classOrProtocol
{
	if ([self.bindingDictionary objectForKey:[DIAbstractModule stringFromClassOrProtocol:classOrProtocol]])
		return YES;
	
	return NO;
}

- (id)injectionObjectForClass:(Class)class
{
	return [self injectionObjectForType:class];
}

- (id)injectionObjectForProtocol:(Protocol *)protocol
{
	return [self injectionObjectForType:protocol];
}

- (id)injectionObjectForType:(id)classOrProtocol
{
	id instance = nil;
	NSString *classOrProtocolString = [DIAbstractModule stringFromClassOrProtocol:classOrProtocol];
	DIInjectionInfo *info = [self.bindingDictionary objectForKey:classOrProtocolString];
	
	if (info.isSingleton)
	{
		instance = [self.singletonContainer objectForKey:classOrProtocolString];
		
		if (instance)
			return instance;
	}

	if (info.constructorSelector)
	{
		instance = [info.injectionClass alloc];
		
		NSMethodSignature *signature = [info.injectionClass instanceMethodSignatureForSelector:info.constructorSelector];
		NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
		[invocation setSelector:info.constructorSelector];
		[invocation setTarget:instance];
		
		for (int i=0 ; i<info.constructorArguments.count ; i++)
		{
			DIConstructorArgument *argument = [info.constructorArguments objectAtIndex:i];
			id injectingArgument;
			
			if (argument.isBinding)
				injectingArgument = [self injectionObjectForType:[DIAbstractModule classOrProtocolFromString:argument.value]];
			else
				injectingArgument = [argument.value copy];
				
			[invocation setArgument:&injectingArgument atIndex:i+2];
		}
		
		[invocation retainArguments];
		[invocation invoke];
		[invocation getReturnValue:&instance];
	}
	else
	{
		instance = [[info.injectionClass alloc] init];
	}
	
	if (info.isSingleton && instance)
		[self storeObjectAsSingleton:instance forBinding:classOrProtocol];

	return instance;
}

#pragma mark - Private Methods -

- (DIContructorInjectorProxy *)storeBinding:(Class)class forKey:(id)classOrProtocol asSingleton:(BOOL)singleton
{
	NSString *classOrProtocolName = [DIAbstractModule stringFromClassOrProtocol:classOrProtocol];
	[self validateForExistingBindingForKey:classOrProtocolName];
	
	DIInjectionInfo *info = [[DIInjectionInfo alloc] init];
	info.injectionClass = class;
	info.isSingleton = singleton;
	[self.bindingDictionary setObject:info forKey:classOrProtocolName];
	
	return [[DIContructorInjectorProxy alloc] initWithClass:class bindingKey:classOrProtocolName andDelegate:self];
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
	if ([self.bindingDictionary objectForKey:key])
		@throw ([NSException exceptionWithName:@"InvalidBindingException"
										reason:[NSString stringWithFormat:@"Binding already exists for %@", key]
									  userInfo:nil]);
}

- (void)storeObjectAsSingleton:(id)object forBinding:(id)classOrProtocol
{
	[self.singletonContainer setObject:object forKey:[DIAbstractModule stringFromClassOrProtocol:classOrProtocol]];
}

#pragma mark - DIContructorInjectorProxyDelegate -

- (void)diContructorInjectorProxy:(DIContructorInjectorProxy *)proxy didInvokeSelector:(SEL)selector withArgumentTypes:(NSArray *)arguments
{
	DIInjectionInfo *info = [self.bindingDictionary objectForKey:proxy.bindingKey];
	info.constructorSelector = selector;
	info.constructorArguments = arguments;
}

@end

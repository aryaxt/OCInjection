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
	[self bindClassToSelf:[NSDateFormatter self]];
	[self bindClassToSelf:[NSMutableArray self]];
	[self bindClassToSelf:[NSArray self]];
	[self bindClassToSelf:[NSMutableDictionary self]];
	[self bindClassToSelf:[NSDictionary self]];
}

- (void)bindClassToSelf:(Class)class
{
	[self bindClass:class toClass:class];
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
	#warning using isKindOfClass won't work, because a mock of protocol doesn't implement that method
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

@end

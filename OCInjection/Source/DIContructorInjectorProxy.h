//
//  DIContructorInjectorProxy.h
//  OCInjection
//
//  Created by Aryan Gh on 2/9/14.
//  Copyright (c) 2014 Aryan Ghassemi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DIContructorInjectorProxy;
@protocol DIContructorInjectorProxyDelegate <NSObject>
- (void)dIContructorInjectorProxy:(DIContructorInjectorProxy *)proxy didSelectSelector:(SEL)selector withArgumentTypes:(NSArray *)arguments;
@end

@interface DIContructorInjectorProxy : NSProxy

@property (nonatomic, assign, readonly) Class proxyClass;
@property (nonatomic, assign, readonly) NSString *bindingKey;

- (id)initWithClass:(Class)class bindingKey:(NSString *)bindingKey andDelegate:(id <DIContructorInjectorProxyDelegate>)delegate;
- (id)withConstructor;

@end

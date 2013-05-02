//
//  DIAbstractModule.h
//  OCInjection
//
//  Created by Aryan Ghassemi on 4/30/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DIAbstractModule : NSObject

- (BOOL)canResolveObjectForType:(NSString *)type;
- (void)configure;

- (void)bindClassToSelf:(Class)class;
- (void)bindClass:(Class)from toClass:(Class)to;
- (void)bindClass:(Class)from toClass:(Class)to asSingleton:(BOOL)isSingleton;
- (void)bindClass:(Class)class toInstance:(id)instance;
- (void)bindProtocol:(Protocol *)protocol toClass:(Class)class;
- (void)bindProtocol:(Protocol *)protocol toClass:(Class)class asSingleton:(BOOL)isSingleton;
- (void)bindProtocol:(Protocol *)protocol toInstance:(id)instance;

- (id)injectionObjectForClass:(Class)class;
- (id)injectionObjectForProtocol:(Protocol *)protocol;
- (id)injectionObjectForType:(NSString *)type;

@end

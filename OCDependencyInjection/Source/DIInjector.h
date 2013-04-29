//
//  DIInjector.h
//  OCDependencyInjection
//
//  Created by Aryan Gh on 4/28/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface DIInjector : NSObject

+ (id)sharedInstance;
- (void)bindClass:(Class)from toClass:(Class)to;
- (void)bindProtocol:(Protocol *)protocol toClass:(Class)class;

@end
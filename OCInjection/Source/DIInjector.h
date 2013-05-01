//
//  DIInjector.h
//  OCDependencyInjection
//
//  Created by Aryan Gh on 4/28/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "DIAbstractModule.h"

@interface DIInjector : NSObject

+ (id)sharedInstance;
- (id)resolveForClass:(Class)class;
- (id)resolveForProtocol:(Protocol *)protocol;
- (void)setDefaultModule:(DIAbstractModule *)modeule;

@end

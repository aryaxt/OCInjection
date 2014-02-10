//
//  DIAbstractModule.h
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

#import <Foundation/Foundation.h>
#import "DIContructorInjectorProxy.h"
#import "DIInjectionInfo.h"

#define Inject(x) [DIAbstractModule _injectMacro:x]

@interface DIAbstractModule : NSObject

- (BOOL)canResolveObjectForType:(NSString *)type;
- (void)configure;
- (id)bindClassToSelf:(Class)class;
- (DIContructorInjectorProxy *)bindClass:(Class)from toClass:(Class)to;
- (DIContructorInjectorProxy *)bindClass:(Class)from toClass:(Class)to asSingleton:(BOOL)isSingleton;
- (DIContructorInjectorProxy *)bindClass:(Class)class toInstance:(id)instance;
- (DIContructorInjectorProxy *)bindProtocol:(Protocol *)protocol toClass:(Class)class;
- (DIContructorInjectorProxy *)bindProtocol:(Protocol *)protocol toClass:(Class)class asSingleton:(BOOL)isSingleton;
- (DIContructorInjectorProxy *)bindProtocol:(Protocol *)protocol toInstance:(id)instance;
- (id)injectionObjectForClass:(Class)class;
- (id)injectionObjectForProtocol:(Protocol *)protocol;
- (id)injectionObjectForType:(NSString *)type;
+ (id)_injectMacro:(id)x; /* For internal use only */

@end

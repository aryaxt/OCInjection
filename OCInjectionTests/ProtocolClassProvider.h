//
//  ProtocolInstanceProvider.h
//  OCInjection
//
//  Created by Aryan Gh on 2/13/14.
//  Copyright (c) 2014 Aryan Ghassemi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProtocolClassProvider : NSProxy

+ (Class)classFromProtocol:(Protocol *)protocol;

@end

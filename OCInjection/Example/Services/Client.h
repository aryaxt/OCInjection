//
//  Client.h
//  OCDependencyInjection
//
//  Created by Aryan Gh on 4/28/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClientProtocol.h"
#import "ApplicationConfigurationProtocol.h"

@interface Client : NSObject <ClientProtocol>

- (id)initWithApplicationConfiguration:(id <ApplicationConfigurationProtocol>)config;

@end

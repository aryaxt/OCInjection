//
//  GoogleClient.h
//  OCDependencyInjection
//
//  Created by Aryan Gh on 4/28/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoogleClientProtocol.h"
#import "ClientProtocol.h"

@interface GoogleClient : NSObject <GoogleClientProtocol>

@property (nonatomic, strong) id <ClientProtocol> client;

@end

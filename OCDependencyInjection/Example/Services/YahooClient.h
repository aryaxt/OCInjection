//
//  SomeClient.h
//  OCDependencyInjection
//
//  Created by Aryan Gh on 4/28/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClientProtocol.h"

@interface YahooClient : NSObject

@property (nonatomic, strong) id <ClientProtocol> client;

- (id)fetchYahooHomePage;

@end

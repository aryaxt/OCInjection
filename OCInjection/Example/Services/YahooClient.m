//
//  SomeClient.m
//  OCDependencyInjection
//
//  Created by Aryan Gh on 4/28/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import "YahooClient.h"

@implementation YahooClient
@dynamic client;

- (id)fetchYahooHomePage
{
	return [self.client fetchDataWithUrl:@"http://www.yahoo.com"];
}

@end

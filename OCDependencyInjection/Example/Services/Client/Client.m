//
//  Client.m
//  OCDependencyInjection
//
//  Created by Aryan Gh on 4/28/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import "Client.h"
#import "ClientProtocol.h"

@implementation Client

- (NSString *)fetchDataWithUrl:(NSString *)urlStirng
{
	NSURL *url = [NSURL URLWithString:urlStirng];
	NSData *data = [NSData dataWithContentsOfURL:url];
	return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end

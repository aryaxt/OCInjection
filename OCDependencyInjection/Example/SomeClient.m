//
//  SomeClient.m
//  OCDependencyInjection
//
//  Created by Aryan Gh on 4/28/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import "SomeClient.h"

@implementation SomeClient

- (id)fetchDataFromUrl:(NSString *)urlString
{
	NSURL *url = [NSURL URLWithString:urlString];
	NSData *data = [NSData dataWithContentsOfURL:url];
	return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end

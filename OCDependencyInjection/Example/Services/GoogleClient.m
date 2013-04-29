//
//  GoogleClient.m
//  OCDependencyInjection
//
//  Created by Aryan Gh on 4/28/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import "GoogleClient.h"

@implementation GoogleClient
@dynamic client;

- (NSString *)fetchSearchResultForKeyword:(NSString *)keyWord
{
	NSString *urlString = [NSString stringWithFormat:@"https://www.google.com/#output=search&q=%@", keyWord];
	return [self.client fetchDataWithUrl:urlString];
}

@end

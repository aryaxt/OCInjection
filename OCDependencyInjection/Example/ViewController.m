//
//  ViewController.m
//  OCDependencyInjection
//
//  Created by Aryan Gh on 4/28/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>


@implementation ViewController
@synthesize webView;
@dynamic client;
@dynamic clientProtocol;

- (IBAction)FetchDataUsingInjectedClientByClass:(id)sender
{
	NSString *htmlString = [self.client fetchDataFromUrl:@"http://www.google.com"];
	[self.webView loadHTMLString:htmlString baseURL:nil];
}

- (IBAction)FetchDataUsingInjectedClientByProtocol:(id)sender
{
	NSString *htmlString = [self.client fetchDataFromUrl:@"http://www.yahoo.com"];
	[self.webView loadHTMLString:htmlString baseURL:nil];
}

@end

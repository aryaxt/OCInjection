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
@dynamic googleClient;
@dynamic yahooClient;

static NSString *searchKeyWord = @"DependencyInjection";

- (IBAction)fetchGoogleDate:(id)sender
{
	NSString *htmlString = [self.googleClient fetchSearchResultForKeyword:searchKeyWord];
	[self.webView loadHTMLString:htmlString baseURL:nil];
}

- (IBAction)fetchYahooData:(id)sender
{
	NSString *htmlString = [self.yahooClient fetchYahooHomePage];
	[self.webView loadHTMLString:htmlString baseURL:nil];
}

@end

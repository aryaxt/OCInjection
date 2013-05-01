//
//  OCDependencyInjectionTests.m
//  OCDependencyInjectionTests
//
//  Created by Aryan Gh on 4/28/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import "ViewControllerTests.h"

@implementation ViewControllerTests
@synthesize viewController;

#pragma mark - Setup & TearDown -

- (void)setUp
{
    [super setUp];
    
	DIMockConfig *module = [[DIMockConfig alloc] init];
	[[DIInjector sharedInstance] setDefaultModule:module];
	
    self.viewController = [[ViewController alloc] init];
}

- (void)tearDown
{
    self.viewController =  nil;
    
    [super tearDown];
}

#pragma mark - Tests -

- (void)testShouldCallCleintWithGoogleUrl
{
	static NSString *expectedSearchTerm = @"DependencyInjection";
	[[(OCMockObject *)self.viewController.googleClient expect] fetchSearchResultForKeyword:expectedSearchTerm];
	[self.viewController fetchGoogleDate:nil];
	[(OCMockObject *)self.viewController.googleClient verify];
}

- (void)testShouldCallCleintWithYahoo
{
	[[(OCMockObject *)self.viewController.yahooClient expect] fetchYahooHomePage];
	[self.viewController fetchYahooData:nil];
	[(OCMockObject *)self.viewController.yahooClient verify];
}

@end

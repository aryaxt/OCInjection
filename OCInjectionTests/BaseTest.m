//
//  BaseTest.m
//  OCInjection
//
//  Created by Aryan Ghassemi on 2/11/14.
//  Copyright (c) 2014 Aryan Ghassemi. All rights reserved.
//

#import "BaseTest.h"

@implementation BaseTest

- (void)setUp
{
    [super setUp];
    
	DIMockConfig *module = [[DIMockConfig alloc] init];
	[[DIInjector sharedInstance] setDefaultModule:module];
}

- (void)tearDown
{
    
    [super tearDown];
}

@end

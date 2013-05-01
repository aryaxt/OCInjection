//
//  DIInjectorTest.h
//  OCInjection
//
//  Created by Aryan Ghassemi on 5/1/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "OCInjection.h"
#import "YahooClient.h"
#import "GoogleClient.h"
#import "Client.h"

@interface DIInjectorTest : SenTestCase

@property (nonatomic, strong) DIAbstractModule *module;

@end

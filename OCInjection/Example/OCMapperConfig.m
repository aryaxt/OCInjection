//
//  OCMapperConfig.m
//  OCInjection
//
//  Created by Aryan Ghassemi on 2/11/14.
//  Copyright (c) 2014 Aryan Ghassemi. All rights reserved.
//

#import "OCMapperConfig.h"
#import	"OCMapper.h"
#import "User.h"
#import "Repository.h"

@implementation OCMapperConfig

+ (void)configure
{
	ObjectInstanceProvider *instanceProvider = [[ObjectInstanceProvider alloc] init];
	InCodeMappingProvider *mappingProvider = [[InCodeMappingProvider alloc] init];
	[[ObjectMapper sharedInstance] setInstanceProvider:instanceProvider];
	[[ObjectMapper sharedInstance] setMappingProvider:mappingProvider];
	
	[mappingProvider mapFromDictionaryKey:@"description" toPropertyKey:@"detail" forClass:[Repository class]];
	[mappingProvider mapFromDictionaryKey:@"avatar_url" toPropertyKey:@"avatarUrl" forClass:[User class]];
	[mappingProvider mapFromDictionaryKey:@"owner" toPropertyKey:@"owner" withObjectType:[User class] forClass:[Repository class]];
}

@end

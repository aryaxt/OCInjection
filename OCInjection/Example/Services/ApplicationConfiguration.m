//
//  ApplicationConfiguration.m
//  OCInjection
//
//  Created by Aryan Ghassemi on 2/11/14.
//  Copyright (c) 2014 Aryan Ghassemi. All rights reserved.
//

#import "ApplicationConfiguration.h"

@implementation ApplicationConfiguration

- (id)configurationValueForKey:(NSString *)key
{
	return [[NSBundle mainBundle] objectForInfoDictionaryKey:key];
}

@end

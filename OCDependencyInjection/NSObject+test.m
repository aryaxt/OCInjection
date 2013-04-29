//
//  NSObject+test.m
//  OCDependencyInjection
//
//  Created by Aryan Gh on 4/28/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import "NSObject+test.h"
#import "ViewController.h"

@implementation NSObject (test)

/*+ (BOOL)resolveInstanceMethod:(SEL)selector
{
	if ([self class] == [ViewController class])
	{
		class_addMethod([self class], selector, (IMP)dynamicMethodIMP, "v@:");
		return YES;
	}
	
    //return [super resolveInstanceMethod:selector];
}

void dynamicMethodIMP(id self, SEL _cmd)
{
    // implementation ....
}
*/


@end

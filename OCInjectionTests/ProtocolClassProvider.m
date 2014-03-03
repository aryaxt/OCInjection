//
//  ProtocolInstanceProvider.m
//  OCInjection
//
//  Created by Aryan Gh on 2/13/14.
//  Copyright (c) 2014 Aryan Ghassemi. All rights reserved.
//

#import "ProtocolClassProvider.h"
#import <objc/runtime.h>

@implementation ProtocolClassProvider

+ (Class)classFromProtocol:(Protocol *)protocol
{
	Class class = objc_allocateClassPair([NSObject class], MYCFStringCopyUTF8String([ProtocolClassProvider uuid]), 0);
	class_addProtocol(class, protocol);
	return class;
}

+ (CFStringRef)uuid
{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    return uuidStringRef;
}

/*
http://stackoverflow.com/questions/9166291/converting-a-cfstringref-to-char
*/
char * MYCFStringCopyUTF8String(CFStringRef aString) {
	if (aString == NULL) {
		return NULL;
	}
	
	CFIndex length = CFStringGetLength(aString);
	CFIndex maxSize =
	CFStringGetMaximumSizeForEncoding(length,
									  kCFStringEncodingUTF8);
	char *buffer = (char *)malloc(maxSize);
	if (CFStringGetCString(aString, buffer, maxSize,
						   kCFStringEncodingUTF8)) {
		return buffer;
	}
	return NULL;
}

@end

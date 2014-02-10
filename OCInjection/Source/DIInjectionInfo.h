//
//  DIConstructorInjectionInfo.h
//  OCInjection
//
//  Created by Aryan Gh on 2/9/14.
//  Copyright (c) 2014 Aryan Ghassemi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DIInjectionInfo : NSObject

@property (nonatomic, strong) id injectionClassNameOrInstance;
@property (nonatomic, assign) SEL constructorSelector;
@property (nonatomic, strong) NSArray *constructorArgumentTypes;

@end

//
//  ApplicationConfigurationProtocol.h
//  OCInjection
//
//  Created by Aryan Ghassemi on 2/11/14.
//  Copyright (c) 2014 Aryan Ghassemi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ApplicationConfigurationProtocol <NSObject>

- (id)configurationValueForKey:(NSString *)key;

@end

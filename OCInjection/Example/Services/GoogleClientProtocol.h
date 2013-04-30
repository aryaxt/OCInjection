//
//  ClientProtocol.h
//  OCDependencyInjection
//
//  Created by Aryan Gh on 4/28/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GoogleClientProtocol <NSObject>

- (NSString *)fetchSearchResultForKeyword:(NSString *)keyWord;

@end

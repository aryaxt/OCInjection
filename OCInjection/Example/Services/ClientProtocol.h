//
//  ClientProtocol.h
//  OCDependencyInjection
//
//  Created by Aryan Gh on 4/28/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ClientProtocol <NSObject>

typedef enum {
	HttpMethodGet,
	HttpMethodPost,
	HttpMethodPut,
	HttpMethodDelete
} HttpMethod;

- (void)fetchGetWithUrl:(NSString *)urlString
			 resultType:(Class)resultType
		  andCompletion:(void (^)(id result, NSError *error))completion;

- (void)fetchRequestWithUrl:(NSString *)urlString
				 httpMethod:(HttpMethod)httpMethod
				 resultType:(Class)resultType
				   postData:(NSDictionary *)postData
			  andCompletion:(void (^)(id result, NSError *error))completion;

@end

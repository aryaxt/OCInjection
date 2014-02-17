//
//  Client.m
//  OCDependencyInjection
//
//  Created by Aryan Gh on 4/28/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//
// https://github.com/aryaxt/OCInjection
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "Client.h"
#import "AFNetworking.h"
#import "OCMapper.h"

@interface Client()
@property (nonatomic, strong) NSString *baseUrl;
@property (nonatomic, assign) NSInteger timeout;
@end

@implementation Client

#pragma mark - Initialization -

- (id)initWithApplicationConfiguration:(id <ApplicationConfigurationProtocol>)config andTimeout:(NSNumber *)timeout
{
	if (self = [super init])
	{
		self.baseUrl = [config configurationValueForKey:@"Service_URL"];
		self.timeout = [timeout intValue];
	}
	
	return self;
}

#pragma mark - Public Methods -

- (void)fetchGetWithUrl:(NSString *)urlString resultType:(Class)resultType andCompletion:(void (^)(id result, NSError *error))completion
{
	[self fetchRequestWithUrl:urlString httpMethod:HttpMethodGet resultType:resultType postData:nil andCompletion:completion];
}

- (void)fetchRequestWithUrl:(NSString *)urlString httpMethod:(HttpMethod)httpMethod resultType:(Class)resultType postData:(NSDictionary *)postData  andCompletion:(void (^)(id result, NSError *error))completion
{
	AFHTTPClient* httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:self.baseUrl]];
	[httpClient setParameterEncoding:AFJSONParameterEncoding];
	NSMutableURLRequest *request = [httpClient requestWithMethod:[self httpMethodString:httpMethod] path:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:postData];
	
	[request setTimeoutInterval:self.timeout];
	
	[self startOperationWithRequest:request resultType:resultType  withCompletion:completion];
}

#pragma mark - Private Methods -

- (void)startOperationWithRequest:(NSMutableURLRequest *)request
					   resultType:(Class)resultType
				   withCompletion:(void (^)(id result, NSError *error))completion
{
	AFHTTPRequestOperation *jsonOperation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id json) {
		
		id result = (resultType) ? [resultType objectFromDictionary:json] : json;
		
		if (completion)
			completion (result, nil);
		
	} failure:^(NSURLRequest *curentRequest, NSHTTPURLResponse *response, NSError *error, id json) {
		
		if (completion)
			completion (nil, error);
	}];
	
	[jsonOperation start];
}

- (NSString *)httpMethodString:(HttpMethod)httpMethod
{
	switch (httpMethod)
	{
		case HttpMethodGet:
			return @"GET";
			break;
			
		case HttpMethodPost:
			return @"POST";
			break;
			
		case HttpMethodPut:
			return @"PUT";
			break;
			
		case HttpMethodDelete:
			return @"DELETE";
			break;
			
		default:
			return @"";
			break;
	}
}

@end

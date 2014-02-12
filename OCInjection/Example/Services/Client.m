//
//  Client.m
//  OCDependencyInjection
//
//  Created by Aryan Gh on 4/28/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import "Client.h"
#import "AFNetworking.h"
#import "OCMapper.h"

@interface Client()
@property (nonatomic, strong) NSString *baseUrl;
@end

@implementation Client

#pragma mark - Initialization -

- (id)initWithApplicationConfiguration:(id <ApplicationConfigurationProtocol>)config
{
	if (self = [super init])
	{
		self.baseUrl = [config configurationValueForKey:@"Service_URL"];
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
	
	[self startOperationWithRequest:request resultType:resultType  withCompletion:completion];
}

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

#pragma mark - Private Methods -

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

//
//  ViewController.h
//  OCDependencyInjection
//
//  Created by Aryan Gh on 4/28/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YahooClient.h"
#import "GoogleClientProtocol.h"

@interface ViewController : UIViewController

@property (nonatomic, assign) IBOutlet UIWebView *webView;
@property (nonatomic, strong) YahooClient *yahooClient;
@property (nonatomic, strong) id <GoogleClientProtocol> googleClient;

- (IBAction)fetchGoogleDataSelected:(id)sender;
- (IBAction)fetchYahooDataSelected:(id)sender;

@end

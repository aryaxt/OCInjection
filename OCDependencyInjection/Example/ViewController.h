//
//  ViewController.h
//  OCDependencyInjection
//
//  Created by Aryan Gh on 4/28/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SomeClient.h"
#import "ClientProtocol.h"

@interface ViewController : UIViewController

@property (nonatomic, strong) SomeClient *client;
@property (nonatomic, strong) id <ClientProtocol> clientProtocol;
@property (nonatomic, strong) NSString *s;

@end

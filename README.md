OCInjector
==========

DI framework for Objective C
DI Container LazyInitializes properties which can boost performance.
Making properties to be Injected is as simple as marking property as @dynamic

Configuring DI Container
_____________
```
@implementation DIConfig

+ (void)setup
{
  [[DIInjector sharedInstance] bindClass:[YahooClient class] toClass:[YahooClient class]];
	[[DIInjector sharedInstance] bindProtocol:@protocol(GoogleClientProtocol)  toClass:[GoogleClient class]];
	[[DIInjector sharedInstance] bindProtocol:@protocol(ClientProtocol)  toClass:[Client class]];
}

@end
```
Using DI
______________
```
@interface ViewController : UIViewController

@property (nonatomic, assign) IBOutlet UIWebView *webView;
@property (nonatomic, strong) YahooClient *yahooClient;
@property (nonatomic, strong) id <GoogleClientProtocol> googleClient;

@end

@implementation ViewController
@synthesize webView;
@dynamic googleClient;
@dynamic yahooClient;

@end
```

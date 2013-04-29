OCInjector
==========

DI framework for Objective C.
The DI Container LazyInitializes properties which can boost performance.
Injecting properties is as easy as marking them as @dynamic

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

- (void)viewDidLoad
{
   [super viewDidLoad];
   
   NSString *htmlString = [self.googleClient fetchSearchResultForKeyword:@"Hello-World"];
   NSString *htmlString2 = [self.yahooClient fetchYahooHomePage];
}

@end
```

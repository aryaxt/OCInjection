OCInjector
==========

DI framework for Objective C.
The DI Container LazyInitializes properties which can boost performance.
Injecting properties is as easy as marking them as @dynamic

This framework is still under development, and it is not meant to be used in production yet.

Configuring DI Container
----------
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
```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[DIConfig setup];
	
    return YES;
}
```
Using DI
----------
```
@interface ViewController : UIViewController

@property (nonatomic, assign) IBOutlet UIWebView *webView;
@property (nonatomic, strong) YahooClient *yahooClient;
@property (nonatomic, strong) id <GoogleClientProtocol> googleClient;

@end
```
```
@implementation ViewController
@synthesize webView;
@dynamic googleClient;
@dynamic yahooClient;

- (IBAction)fetchGoogleDate:(id)sender
{
	NSString *htmlString = [self.googleClient fetchSearchResultForKeyword:searchKeyWord];
	[self.webView loadHTMLString:htmlString baseURL:nil];
}

- (IBAction)fetchYahooData:(id)sender
{
	NSString *htmlString = [self.yahooClient fetchYahooHomePage];
	[self.webView loadHTMLString:htmlString baseURL:nil];
}

@end
```

Mocking Dependencies for Unit Testing
----------
```
@implementation DIMockConfig

+ (void)setup
{
	OCMockObject *yahooClientMock = [OCMockObject niceMockForClass:[YahooClient class]];
	OCMockObject *googleClientMock = [OCMockObject mockForProtocol:@protocol(GoogleClientProtocol)];
	OCMockObject *mockClient = [OCMockObject mockForProtocol:@protocol(ClientProtocol)];
	
	[[DIInjector sharedInstance] bindClass:[YahooClient class] toInstance:yahooClientMock];
	[[DIInjector sharedInstance] bindProtocol:@protocol(GoogleClientProtocol) toInstance:googleClientMock];
	[[DIInjector sharedInstance] bindProtocol:@protocol(ClientProtocol) toInstance:mockClient];
}

@end
```
Sample Unit Test
----------
```
@interface ViewControllerTests : SenTestCase

@property (nonatomic, strong) ViewController *viewController;

@end
```
```
@implementation ViewControllerTests
@synthesize viewController;

#pragma mark - Setup & TearDown -

- (void)setUp
{
    [super setUp];
    
	[DIMockConfig setup];
    self.viewController = [[ViewController alloc] init];
}

- (void)tearDown
{
    self.viewController =  nil;
    
    [super tearDown];
}

#pragma mark - Tests -

- (void)testShouldCallCleintWithGoogleUrl
{
	static NSString *expectedSearchTerm = @"DependencyInjection";
	[[(OCMockObject *)self.viewController.googleClient expect] fetchSearchResultForKeyword:expectedSearchTerm];
	[self.viewController fetchGoogleDate:nil];
	[(OCMockObject *)self.viewController.googleClient verify];
}

- (void)testShouldCallCleintWithYahoo
{
	[[(OCMockObject *)self.viewController.yahooClient expect] fetchYahooHomePage];
	[self.viewController fetchYahooData:nil];
	[(OCMockObject *)self.viewController.yahooClient verify];
}

@end
```


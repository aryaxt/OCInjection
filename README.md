OCInjection
==========

DI framework for Objective C. This framework is still under development, and it is not meant to be used in production yet.

OCInjection supports both property injection and constructor injection.
In order to inject a property you need to mark the property as @dynamic. 

Property injection is required on root level (ex:Injecting property in a ViewContorller).
On lower levels you can decide to either go with property injection or constructor injection, but constructor injection is always preferred.

Configuring DI Container
----------
In order to configure binding create a new class inheriting from 'DIAbstractModule', and implement configure 'method'
```objective-c
#import "DIAbstractModule.h"

@interface DIConfig : DIAbstractModule

@end
```
```objective-c
@implementation DIConfig

- (void)configure
{
        // Binding protocol to a class, and mamarking it a singleton object
        // Since constrcutor is not defined the standard init method will be used for initialization
        [self bindProtocol:@protocol(ServiceClientProtocl) toClass:[ServiceClient class] asSingleton:YES];
        
        // Binding a protocol to a class, and defining a constructor
        // Objective c doesn't preserve method argument types (Class info) at runtime
        // So you must provide the type of parameters when binding
	[[[self bindProtocol:@protocol(GithubClientProtocol) toClass:[GithubClient class]] withConstructor]
		initWithServiceClient:Inject(@protocol(ServiceClientProtocl))];
}

@end
```
```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    DIConfig *config = [[DIConfig alloc] init];
    [[DIInjector sharedInstance] setDefaultModule:config];
	
    return YES;
}
```
Using DI
----------
```objective-c
@interface ViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIWebView *webView;

@end
```
```objective-c
@interface ViewController()
@property (nonatomic, strong) id <GithubClientProtocol> githubClient;
@end

@implementation ViewController
@synthesize webView;
@dynamic githubClient;

- (void)viewDidLoad
{
   [super viewDidLoad];
   
   [self.githubClient fetchDataByUsername:@"aryaxt"];
}

@end
```

Mocking Dependencies for Unit Testing
----------
```objective-c
@implementation DIMockConfig

- (void)configure
{
	OCMockObject *githubClient = [OCMockObject mockForProtocol:@protocol(GithubClientProtocol)];
	OCMockObject *serviceClient = [OCMockObject mockForProtocol:@protocol(ServiceClientProtocol)];
	
	[self bindProtocol:@protocol(ServiceClientProtocol) toInstance:serviceClient];
	[self bindProtocol:@protocol(GithubClientProtocol) toInstance:githubClient];
}

@end
```
Sample Unit Test
----------
```objective-c
@interface ViewControllerTests : SenTestCase

@property (nonatomic, strong) ViewController *viewController;

@end
```
```objective-c
@interface ViewControllerTests()
@property (nonatomic, strong) id <GithubClientProtocol> githubClient;
@end

@implementation ViewControllerTests
@dynamic githubClient;
@synthesize viewController;

#pragma mark - Setup & TearDown -

- (void)setUp
{
    [super setUp];
    
	DIMockConfig *module = [[DIMockConfig alloc] init];
	[[DIInjector sharedInstance] setDefaultModule:module];
	
    self.viewController = [[ViewController alloc] init];
}

- (void)tearDown
{
    self.viewController =  nil;
    
    [super tearDown];
}

#pragma mark - Tests -

- (void)testShouldFetchDataWithCorrectUsername
{
       // Since we bind GithubClientProtocol to an instance
       // The instance injected in viewController is the same as the one injected in test file
       // So we can mock the object and test it without having to make it a public property

	static NSString *expectedUsername = @"DependencyInjearyaxtction";
	[[(OCMockObject *)self.githubClient expect] fetchDataByUsername:expectedUsername];
	[self.viewController view]; // Trigger viewDidLoad
	[(OCMockObject *)self.githubClient verify];
}

@end
```
In-Line Dependency Resolving
----------
```objective-c
// Resolving Protocol
id <GoogleClientProtocol> googleClient = [[DIInjector sharedInstance] resolveForProtocol:@protocol(GoogleClientProtocol)];

// Resolving Class
YahooClient *yahooClient = [[DIInjector sharedInstance] resolveForClass:[YahooClient class]];
```

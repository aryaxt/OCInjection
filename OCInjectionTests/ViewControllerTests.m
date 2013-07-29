//
//  OCDependencyInjectionTests.m
//  OCDependencyInjectionTests
//
//  Created by Aryan Gh on 4/28/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//
// https://github.com/aryaxt/OCInjection
//
// Permission to use, copy, modify and distribute this software and its documentation
// is hereby granted, provided that both the copyright notice and this permission
// notice appear in all copies of the software, derivative works or modified versions,
// and any portions thereof, and that both notices appear in supporting documentation,
// and that credit is given to Aryan Ghassemi in all documents and publicity
// pertaining to direct or indirect use of this code or its derivatives.
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

#import "ViewControllerTests.h"

@implementation ViewControllerTests
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

- (void)testShouldCallCleintWithGoogleUrl
{
	static NSString *expectedSearchTerm = @"DependencyInjection";
	[[(OCMockObject *)self.viewController.googleClient expect] fetchSearchResultForKeyword:expectedSearchTerm];
	[self.viewController fetchGoogleDataSelected:nil];
	[(OCMockObject *)self.viewController.googleClient verify];
}

- (void)testShouldCallCleintWithYahoo
{
	[[(OCMockObject *)self.viewController.yahooClient expect] fetchYahooHomePage];
	[self.viewController fetchYahooDataSelected:nil];
	[(OCMockObject *)self.viewController.yahooClient verify];
}

@end

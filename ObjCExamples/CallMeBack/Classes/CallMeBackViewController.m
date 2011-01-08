//  CallMeBackViewController.m
//  CallMeBack
//
//  Created by Adam Duke on 10/7/10.
//  Copyright None 2010. All rights reserved.
//

#import "CallMeBackViewController.h"
#import "JSON.h"

#define kRateLimitUrl @"http://api.twitter.com/1/account/rate_limit_status.json"
#define kFailureMessage @"FAIL!"
#define kNetworkQueueName "com.callmeback.network"

typedef void(^CallMeBack)(NSString *rawData);

@interface CallMeBackViewController (Private)

- (void)getURL:(NSURL *)url callMeBackWith:(CallMeBack)doWhatNow;

@end

@implementation CallMeBackViewController

@synthesize textField, spinner;

- (void)viewDidLoad
{
	[spinner setAlpha:0.0];
	isBusy = NO;
}

- (IBAction)makeACall
{
	// Create an NSURL to get data from
	NSURL *url = [NSURL URLWithString:kRateLimitUrl];
	
	// call getURL and pass the block to be executed as a callback
	// the block just sets the text of the textField to whatever parameter
	// is passed to the callback
	[self getURL:url callMeBackWith:^(NSString *rawData){
		NSDictionary *jsonValue = [rawData JSONValue];
		NSString *key = @"remaining_hits";
		NSNumber *value = [jsonValue objectForKey:key];
		self.textField.text = [NSString stringWithFormat:@"%@:%@", key, [value description]];
	}];
}

- (void)getURL:(NSURL *)url callMeBackWith:(CallMeBack)doWhatNow
{
	// create a queue called com.callmeback.network
	dispatch_queue_t networkQueue = dispatch_queue_create(kNetworkQueueName, NULL);
	
	// start the activity indicators
	[self startProgress];
	
	// dispatch getting the result of the call to the URL to the network queue
	dispatch_async(networkQueue, ^{
		
		// create an NSString with the contents of the NSURL
		// simulate a slow network connection with an NSThread sleepForTimeInterval
		NSString *raw = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
		[NSThread sleepForTimeInterval:2];
		if (raw) {
			
			// if the NSURL had some content this would be the place to parse it
			// execute the callback and pass the string from the url
			// then stop the activity indicators
			dispatch_async(dispatch_get_main_queue(), ^{
				doWhatNow(raw);
				[self stopProgress];
			});
		}
		else {
			
			// if the NSURL had no content this would be the place to construct some error message
			// execute the callback and pass "FAIL!", then stop the activity indicators
			dispatch_async(dispatch_get_main_queue(), ^{
				doWhatNow(kFailureMessage);
				[self stopProgress];
			});
		}
	});
}

- (void)startProgress
{
	self.textField.text = @"";
	[spinner setAlpha:1.0];
	[spinner startAnimating];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	isBusy = YES;
}

- (void)stopProgress
{
	[spinner setAlpha:0.0];
	[spinner stopAnimating];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	isBusy = NO;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	return isBusy;
}

- (void)didReceiveMemoryWarning {
	
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
	[textField release];
	[spinner release];
    [super dealloc];
}

@end

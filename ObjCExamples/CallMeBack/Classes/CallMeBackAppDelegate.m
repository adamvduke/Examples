//
//  CallMeBackAppDelegate.m
//  CallMeBack
//
//  Created by Adam Duke on 10/7/10.
//  Copyright None 2010. All rights reserved.
//

#import "CallMeBackAppDelegate.h"
#import "CallMeBackViewController.h"

@implementation CallMeBackAppDelegate

@synthesize window;
@synthesize viewController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    

    // Add the view controller's view to the window and display.
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
	
    return YES;
}

- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end

//
//  CallMeBackAppDelegate.h
//  CallMeBack
//
//  Created by Adam Duke on 10/7/10.
//  Copyright None 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CallMeBackViewController;

@interface CallMeBackAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    CallMeBackViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet CallMeBackViewController *viewController;

@end


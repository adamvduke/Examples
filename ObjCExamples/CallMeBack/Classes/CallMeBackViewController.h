//
//  CallMeBackViewController.h
//  CallMeBack
//
//  Created by Adam Duke on 10/7/10.
//  Copyright None 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CallMeBackViewController : UIViewController <UITextFieldDelegate>
{
	IBOutlet UITextField *textField;
	IBOutlet UIActivityIndicatorView *spinner;
	BOOL isBusy;
}

@property (nonatomic, retain) UITextField *textField;
@property (nonatomic, retain) UIActivityIndicatorView *spinner;

- (IBAction)makeACall;
- (void)startProgress;
- (void)stopProgress;

@end


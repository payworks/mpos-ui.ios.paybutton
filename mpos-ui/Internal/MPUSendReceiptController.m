/*
 * mpos-ui : http://www.payworks.com
 *
 * The MIT License (MIT)
 *
 * Copyright (c) 2015 Payworks GmbH
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "MPUSendReceiptController.h"
#import "MPUMposUi.h"
#import "MPUMposUiConfiguration.h"
#import "MPUMposUiAppearance.h"
#import "MPUProgressView.h"
#import "MPUUIHelper.h"

@interface MPUSendReceiptController() <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UILabel *statusIcon;

@property (nonatomic, assign) CGSize keyboardSize;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardHeight;
@property (weak, nonatomic) IBOutlet MPUProgressView *progressView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *marginBetweenStatusIconAndTextField;


@property (nonatomic, assign) BOOL keyboardShown;

@end

@implementation MPUSendReceiptController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = NO;
    
    MPUMposUiConfiguration *configuration = self.mposUi.configuration;
    self.statusIcon.textColor = configuration.appearance.navigationBarTint;
    self.statusIcon.text = @"\uf0e0";
    self.progressView.hidden = YES;
    self.sendButton.enabled = NO;
    
    [self.emailField becomeFirstResponder];
    
    [self l10n];
    [self registerForNotifications];
}

- (void)l10n {
    [self.sendButton setTitle:[MPUUIHelper localizedString:@"MPUSend"] forState:UIControlStateNormal];
    [self.emailField setPlaceholder:[MPUUIHelper localizedString:@"MPUEnterEmailAddress"]];
}

#pragma mark - IBActions

- (IBAction)sendTapped:(id)sender {
    if (![self isEmailValid:self.emailField.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[MPUUIHelper localizedString:@"MPUInvalidEmailAddress"]
                                                        message:[MPUUIHelper localizedString:@"MPUEnterValidEmailAddress"]
                                                       delegate:self
                                              cancelButtonTitle:[MPUUIHelper localizedString:@"MPUOK"]
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        
        [self.emailField resignFirstResponder];
        self.progressView.hidden = NO;
        self.progressView.animating = YES;
        self.sendButton.enabled = NO;
        self.navigationItem.hidesBackButton = YES;
        self.emailField.enabled = NO;
        
        __weak typeof(self) weakSelf = self;
        [self.mposUi.transactionProvider.transactionModule sendCustomerReceiptForTransactionIdentifier:self.transactionIdentifier emailAddress:self.emailField.text completed:^(NSString *transactionIdentifier, NSString *emailAddress, NSError *error) {
            
            if (error == nil){
                [weakSelf success];
            }
            else {
                weakSelf.mposUi.error = error;
                [weakSelf fail:error];
            }
        }];
    }
}

#pragma mark - Private

- (void)success {
    self.statusIcon.text = @"\uf00c";
    self.progressView.hidden = YES;
    self.progressView.animating = NO;;
    [self.delegate sendReciptSuccess];
}

- (void)fail:(NSError *) error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[MPUUIHelper localizedString:@"MPUCouldNotSendReceipt"]
                                                    message:[error localizedDescription]
                                                   delegate:self
                                          cancelButtonTitle:[MPUUIHelper localizedString:@"MPUOK"]
                                          otherButtonTitles:nil];
    [alert show];
    alert.delegate = self;
    
    self.sendButton.enabled = [self isEmailValid:self.emailField.text];
    self.progressView.animating = NO;
    self.progressView.hidden = YES;
    self.emailField.enabled = YES;
    self.navigationItem.hidesBackButton = NO;
}

- (BOOL)isEmailValid:(NSString *)emailToCheck {
    if (!emailToCheck) {
        return NO;
    }
    NSRegularExpression *emailMatcher = [[NSRegularExpression alloc] initWithPattern:@"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,6}$" options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *match = [emailMatcher firstMatchInString:emailToCheck options:0 range:NSMakeRange(0, emailToCheck.length)];
    
    // Check if there was a match. If yes return YES
    if (match != nil && !NSEqualRanges(match.range, NSMakeRange(NSNotFound, 0))) {
        return YES;
    }
    return NO;
}

#pragma mark - UITextFieldDelegate
- (IBAction)textDidChange:(id)sender {
    self.sendButton.enabled = [self isEmailValid:self.emailField.text];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self.emailField becomeFirstResponder];
    }
}

#pragma mark - UI-Lifecycle and Keyboard Events
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self unregisterForNotifications];
}

- (void)orientationChanged:(NSNotification *)note {
    if (!self.keyboardShown) {
        CGFloat viewHeight = (self.emailField.frame.origin.y + self.emailField.frame.size.height) - self.statusIcon.frame.origin.y;
        self.keyboardHeight.constant = (self.view.frame.size.height - viewHeight) / 2.0f;
    }
}

- (void)registerForNotifications {
    //Keyboard
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:[UIDevice currentDevice]];
}

- (void)unregisterForNotifications {
    //Keyboard
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification object:nil];
}


- (void)keyboardWillShow:(NSNotification *)aNotification {
     NSDictionary* info = [aNotification userInfo];
     self.keyboardSize = [self.view convertRect:[[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:self.view.window].size;
     self.keyboardShown = YES;
     
     CGFloat height = self.keyboardSize.height;
     self.keyboardHeight.constant = height + 10 /* PADDING */;
 
     [UIView animateWithDuration:[[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                           delay:0.0
                         options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^
      {
          [self.view layoutIfNeeded];
      } completion:nil];
}
 
- (void)keyboardWillBeHidden:(NSNotification *)aNotification {
     NSDictionary* info = [aNotification userInfo];
     self.keyboardSize = CGSizeMake(0.0, 0.0);
     self.keyboardShown = NO;
     
     
     CGFloat viewHeight = (self.emailField.frame.origin.y + self.emailField.frame.size.height) - self.statusIcon.frame.origin.y;
     self.keyboardHeight.constant = (self.view.frame.size.height - viewHeight) / 2.0f; /* CENTER THIS */
 
     [UIView animateWithDuration:[[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                           delay:0.0
                         options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^
      {
          [self.view layoutIfNeeded];
      } completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

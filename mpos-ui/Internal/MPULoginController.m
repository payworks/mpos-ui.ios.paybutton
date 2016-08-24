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

#import "MPULoginController.h"
#import "MPUUIHelper.h"
#import "MPUApplicationData.h"


@interface MPULoginController ()

@property (nonatomic, weak) IBOutlet UITextField *usernameTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic, weak) IBOutlet UIImageView *providerImageView;
@property (nonatomic, weak) IBOutlet UIButton *loginButton;
@property (nonatomic, weak) IBOutlet UIButton *forgotButton;
@property (nonatomic, weak) IBOutlet UIButton *requestPasswordButton;
@property (nonatomic, weak) IBOutlet UIButton *backToLoginButton;
@property (nonatomic, weak) IBOutlet UIButton *helpButton;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *loadingIndicator;

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *loginView;
@property (nonatomic, weak) IBOutlet UIView *emailAddressView;
@property (nonatomic, weak) IBOutlet UIView *dividerView;
@property (nonatomic, weak) IBOutlet UILabel *emailLabel;
@property (nonatomic, weak) IBOutlet UILabel *passwordLabel;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *logoTopMargin;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *logoBottomMargin;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *hairlineHeight;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *loginViewHeight;

@end

@implementation MPULoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initLoginCustomization];
    [self l10n];
}

- (void) l10n {
    [self.forgotButton setTitle:[MPUUIHelper localizedString:@"MPUForgot"] forState:UIControlStateNormal];
    [self.helpButton setTitle:[MPUUIHelper localizedString:@"MPUHelp"] forState:UIControlStateNormal];
    [self.loginButton setTitle:[MPUUIHelper localizedString:@"MPULogin"] forState:UIControlStateNormal];
    [self.requestPasswordButton setTitle:[MPUUIHelper localizedString:@"MPURequestPassword"] forState:UIControlStateNormal];
    [self.backToLoginButton setTitle:[MPUUIHelper localizedString:@"MPUBack"] forState:UIControlStateNormal];
    self.passwordLabel.text = [MPUUIHelper localizedString:@"MPUPassword"];
    self.emailLabel.text = [MPUUIHelper localizedString:@"MPUEmail"];
    self.passwordTextField.placeholder = [MPUUIHelper localizedString:@"MPURequired"];
    self.usernameTextField.placeholder = [MPUUIHelper localizedString:@"MPUEmailAddress"];
}

- (void) initLoginCustomization {
    self.closeButtonEnabled = YES;
    self.providerImageView.image = self.mposUi.applicationData.applicationLogo;
    
    //border radius
    [self.loginView.layer setCornerRadius:4.0f];
    
    //border
    [self.loginView.layer setBorderColor:[UIColor darkGrayColor].CGColor];
    [self.loginView.layer setBorderWidth:0.5f];
    
    self.requestPasswordButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.requestPasswordButton.titleLabel.minimumScaleFactor = 18.0f/self.requestPasswordButton.titleLabel.font.pointSize;
    
}

#pragma mark - IBActions

- (IBAction)didEndEditingOnUsername:(id)sender {
    if (self.usernameTextField.returnKeyType == UIReturnKeyNext) {
        [self.passwordTextField becomeFirstResponder];
    } else {
        [self didTapRequestPassword:sender];
    }
}

- (IBAction)didTapForgotPassword:(id)sender {
    [self switchForgotState:YES];
}

- (IBAction)didTapBack:(id)sender {
    [self switchForgotState:NO];
}

- (IBAction)didTapLogin:(id)sender {
    [self enableUI:NO];
    [self.loadingIndicator startAnimating];
    [MPMpos loginWithMode:self.mposUi.providerMode applicationIdentifier:self.mposUi.applicationData.identifier username:self.usernameTextField.text password:self.passwordTextField.text success:^(NSString *username, NSString *merchantIdentifier, NSString *merchantSecretKey) {
        [self enableUI:YES];
        [self.loadingIndicator stopAnimating];
        self.prefillUsername = username;
        self.passwordTextField.text = @"";
        [self.mposUi storeMerchantCredentials:merchantIdentifier merchantSecretKey:merchantSecretKey username:username];
        [self.delegate loginSuccess:username merchantIdentifier:merchantIdentifier merchantSecret:merchantSecretKey];
    
    } failure:^(NSString *username, NSError *error) {
        [self displayError:error];
        [self enableUI:YES];
        [self.loadingIndicator stopAnimating];
    }];
}

- (IBAction)didTapRequestPassword:(id)sender {
    [self.loadingIndicator startAnimating];
    [self enableUI:NO];
    [MPMpos passwordResetRequest:self.mposUi.providerMode applicationIdentifier:self.mposUi.applicationData.identifier username:self.usernameTextField.text success:^(NSString *username) {
        [self enableUI:YES];
        [self switchForgotState:NO];
        [self.loadingIndicator stopAnimating];
        [[[UIAlertView alloc] initWithTitle: [MPUUIHelper localizedString:@"MPUPasswordReset"] message:nil delegate:nil cancelButtonTitle:[MPUUIHelper localizedString:@"MPUClose"] otherButtonTitles:nil, nil] show];
        /*@"We've sent you an email. Please check it for further instructions."*/
    } failure:^(NSString *username, NSError *error) {
        [self displayError:error];
        [self enableUI:YES];
        [self.loadingIndicator stopAnimating];
    }];
}


- (IBAction)didTapHelp:(id)sender {
    [[UIApplication sharedApplication] openURL:self.mposUi.applicationData.helpUrl];
}

#pragma mark - Private

- (void)switchForgotState:(BOOL)forgot {
    float forgotAlpha = (forgot ? 1.0f : 0.0f);
    
    self.loginViewHeight.constant = forgot ? self.emailAddressView.frame.size.height : self.emailAddressView.frame.size.height*2.0;
    [self.view setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.25 animations:^{
        self.backToLoginButton.alpha = forgotAlpha;
        self.requestPasswordButton.alpha = forgotAlpha;
        self.passwordTextField.alpha = 1 - forgotAlpha;
        self.forgotButton.alpha = 1 - forgotAlpha;
        self.loginButton.alpha = 1 - forgotAlpha;
        self.passwordLabel.alpha = 1 - forgotAlpha;
        self.dividerView.alpha = 1 - forgotAlpha;
        
        [self.view layoutIfNeeded];
    }];
    
    if (forgot) {
        self.usernameTextField.returnKeyType = UIReturnKeyDone;
    } else {
        self.usernameTextField.returnKeyType = UIReturnKeyNext;
    }
}

- (void)enableUI:(BOOL)enable {
    self.usernameTextField.enabled = enable;
    self.passwordTextField.enabled = enable;
    self.loginButton.enabled = enable;
    self.forgotButton.enabled = enable;
    self.helpButton.enabled = enable;
    self.requestPasswordButton.enabled = enable;
    self.backToLoginButton.enabled = enable;
    self.closeButtonEnabled = enable;
}

- (void)displayError:(NSError *)error {
    // display a special error message if the credentials are incorrect as the error message from the SDK is not descriptive.
    NSString *title;
    if (error.type == MPErrorTypeServerAuthenticationFailed) {
        title = [MPUUIHelper localizedString:@"MPUWrongCredentials"]; // @"You entered a wrong password or no account exists for your email address.";
    } else if(error.type == MPErrorTypeServerUnknownUsername) {
        title = [MPUUIHelper localizedString:@"MPUUnknownUsername"]; // @"No account exists for this email address.";
    } else {
        title = error.localizedDescription;
    }
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message: nil delegate:nil cancelButtonTitle:[MPUUIHelper localizedString:@"MPUClose"] otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark - UI-Lifecycle

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // iPhone 4s
    if ([UIScreen mainScreen].bounds.size.height <= 480.0f) {
        self.logoTopMargin.constant = 20;
        self.logoBottomMargin.constant = 20;
        [self.view setNeedsUpdateConstraints];
    }
    self.hairlineHeight.constant = 0.5;
    [self.view layoutSubviews];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.usernameTextField.text = self.prefillUsername;
    [self registerForKeyboardNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Keyboard handling

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)unregisterForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification *)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [self.view convertRect:[[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:self.view.window].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.scrollView.contentInset.top, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification *)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.scrollView.contentInset.top, 0.0, 0.0, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}



@end

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

#import "MPULoginContainerViewController.h"
#import "MPUUIHelper.h"

NSString* const MPUSegueIdentifierLogin_Login = @"lnPushLogin";

@interface MPULoginContainerViewController ()

@property (nonatomic, weak) MPULoginController *loginViewController;

@end

@implementation MPULoginContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // If already logged in, we force logout.
    if ([self.mposUi isApplicationLoggedIn]) {
        [self.mposUi clearMerchantCredentialsIncludingUsername:NO];
    }
    self.viewTransitionInProgress = NO;
    self.previousSegueIdentifier = MPUSegueIdentifierLogin_Login;
    [self performSegueWithIdentifier:MPUSegueIdentifierLogin_Login sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    // we can to show/hide the close button only after the first view is added.
    // we wait till the view is ready to appear and then hide/show naivgation bar buttons.
    [self.delegate hideCloseButton:NO];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.previousSegueIdentifier = self.currentSegueIdentifier;
    self.currentSegueIdentifier = segue.identifier;
    
    if ([segue.identifier isEqualToString:MPUSegueIdentifierLogin_Login]) {
        DDLogDebug(@"prepareForSegue:Login");
        self.loginViewController = segue.destinationViewController;
        [self showLogin];
        [self swapToViewController:self.loginViewController];
    }
}

- (void)showLogin {
    [self.delegate titleChanged:[MPUUIHelper localizedString:@"MPULogin"]];
    self.loginViewController.prefillUsername = self.mposUi.username;
    self.loginViewController.delegate = self;
}

#pragma mark - MPULoginDelegate

- (void)loginSuccess:(NSString *)username merchantIdentifier:(NSString *)merchantIdentifier merchantSecret:(NSString *)merchantSecret {
    self.completed(self, MPULoginResultSuccessful);
}

#pragma mark - Public

- (void)backButtonPressed {
    //NO OP
}

- (void)closeButtonPressed {
    //Close only if the close button is enabled.
    if ([self.currentSegueIdentifier isEqualToString:MPUSegueIdentifierLogin_Login]
       && self.loginViewController
       && self.loginViewController.closeButtonEnabled) {
        self.completed(self, MPULoginResultFailed);
    }
}

@end

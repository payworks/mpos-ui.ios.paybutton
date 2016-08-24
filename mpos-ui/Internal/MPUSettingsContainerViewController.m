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

#import "MPUSettingsContainerViewController.h"
#import "MPUUIHelper.h"

NSString* const MPUSegueIdentifierSettings_Settings = @"stPushSettings";
NSString* const MPUSegueIdentifierSettings_Login = @"stPushLogin";

@interface MPUSettingsContainerViewController ()

@property (nonatomic, weak) MPULoginController *loginViewController;
@property (nonatomic, weak) MPUSettingsController *settingsViewController;

@end

@implementation MPUSettingsContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewTransitionInProgress = NO;
    
    if (self.showLoginScreen) {
        self.previousSegueIdentifier = MPUSegueIdentifierSettings_Login;
        [self performSegueWithIdentifier:MPUSegueIdentifierSettings_Login sender:nil];
    } else {
        self.previousSegueIdentifier = MPUSegueIdentifierSettings_Settings;
        [self performSegueWithIdentifier:MPUSegueIdentifierSettings_Settings sender:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    self.previousSegueIdentifier = self.currentSegueIdentifier;
    self.currentSegueIdentifier = segue.identifier;
    
    if ([segue.identifier isEqualToString:MPUSegueIdentifierSettings_Settings]) {
        DDLogDebug(@"prepareForSegue:Settings");
        self.settingsViewController = segue.destinationViewController;
        [self showSettings];
        [self swapToViewController:self.settingsViewController];
    }
    
    if ([segue.identifier isEqualToString:MPUSegueIdentifierSettings_Login]) {
        DDLogDebug(@"prepareForSegue:Login");
        self.loginViewController = segue.destinationViewController;
        [self showLogin];
        [self swapToViewController:self.loginViewController];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    // we can to show/hide the close button only after the first view is added.
    // we wait till the view is ready to appear and then hide/show naivgation bar buttons.
    [self.delegate hideCloseButton:NO];
}

- (void)showSettings {
    [self.delegate titleChanged:[MPUUIHelper localizedString:@"MPUSettings"]];
    self.settingsViewController.username = self.mposUi.username;
    self.settingsViewController.delegate = self;
}

- (void)showLogin {
    [self.delegate titleChanged:[MPUUIHelper localizedString:@"MPULogin"]];
    self.loginViewController.prefillUsername = self.mposUi.username;
    self.loginViewController.delegate = self;
}

#pragma mark - Public

- (void)backButtonPressed {
    //NO OP
}

- (void)closeButtonPressed {
    // Close only if the close button is enabled in login.
    // Close immediately from the Settigns screen.
    if ([self.currentSegueIdentifier isEqualToString:MPUSegueIdentifierSettings_Login]
       && self.loginViewController
       && self.loginViewController.closeButtonEnabled) {
        self.completed(self);
    } else if ([self.currentSegueIdentifier isEqualToString:MPUSegueIdentifierSettings_Settings]) {
        self.completed(self);
    }
}

#pragma mark - MPULoginDelegate

- (void)loginSuccess:(NSString *)username merchantIdentifier:(NSString *)merchantIdentifier merchantSecret:(NSString *)merchantSecret {
    [self performSegueWithIdentifier:MPUSegueIdentifierSettings_Settings sender:nil];
}


#pragma mark - MPUSettingsDelegate

- (void)logoutPressed {
    [self performSegueWithIdentifier:MPUSegueIdentifierSettings_Login sender:nil];
}

@end

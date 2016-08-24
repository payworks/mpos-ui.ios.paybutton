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

#import "MPUPrintReceiptContainerViewController.h"
#import "MPUUIHelper.h"

NSString* const MPUSegueIdentifierPrint_PrintReceipt = @"ptPushPrint";
NSString* const MPUSegueIdentifierPrint_Error = @"ptPushError";
NSString* const MPUSegueIdentifierPrint_Login = @"ptPushLogin";

@interface MPUPrintReceiptContainerViewController ()

@property (nonatomic, weak) MPUPrintReceiptController *printReceiptViewController;
@property (nonatomic, weak) MPUErrorController *errorViewController;
@property (nonatomic, weak) MPULoginController *loginViewController;
@property (nonatomic, strong) NSError *lastError;

@end

@implementation MPUPrintReceiptContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewTransitionInProgress = NO;
    
    if (self.showLoginScreen) {
        self.previousSegueIdentifier = MPUSegueIdentifierPrint_Login;
        [self performSegueWithIdentifier:MPUSegueIdentifierPrint_Login sender:nil];
    } else {
        self.previousSegueIdentifier = MPUSegueIdentifierPrint_PrintReceipt;
        [self performSegueWithIdentifier:MPUSegueIdentifierPrint_PrintReceipt sender:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    // we can to show/hide the close button only after the first view is added.
    // we wait till the view is ready to appear and then hide/show naivgation bar buttons.
    if ([self.currentSegueIdentifier isEqualToString:MPUSegueIdentifierPrint_Login]) {
        [self.delegate hideCloseButton:NO];
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
    
    if ([segue.identifier isEqualToString:MPUSegueIdentifierPrint_PrintReceipt]) {
        DDLogDebug(@"prepareForSegue:Print Receipt");
        self.printReceiptViewController = segue.destinationViewController;
        DDLogDebug(@"Container:Segue:%@",self.transactionIdentifer);
        [self showPrintReceipt:self.transactionIdentifer];
        [self swapToViewController:self.printReceiptViewController];
    }
    
    if ([segue.identifier isEqualToString:MPUSegueIdentifierPrint_Error]) {
        DDLogDebug(@"prepareForSegue:Error");
        self.errorViewController = segue.destinationViewController;
        [self showError:self.lastError];
        [self swapToViewController:self.errorViewController];
    }
    
    if ([segue.identifier isEqualToString:MPUSegueIdentifierPrint_Login]) {
        DDLogDebug(@"prepareForSegue:Login");
        self.loginViewController = segue.destinationViewController;
        [self showLogin];
        [self swapToViewController:self.loginViewController];
    }
}

- (void)showPrintReceipt:(NSString *)transactionIdentifier {
    [self.delegate titleChanged:[MPUUIHelper localizedString:@"MPUPrinting"]];
    self.printReceiptViewController.transactionIdentifer = transactionIdentifier;
    self.printReceiptViewController.delegate = self;
}

- (void)showError:(NSError *)error{
    [self.delegate titleChanged:[MPUUIHelper localizedString:@"MPUError"]];
    self.errorViewController.error = error;
    self.errorViewController.delegate = self;
    self.errorViewController.retryEnabled = YES;
}

- (void)showLogin {
    [self.delegate hideCloseButton:NO];
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
    if ([self.currentSegueIdentifier isEqualToString:MPUSegueIdentifierPrint_Login]
       && self.loginViewController
       && self.loginViewController.closeButtonEnabled) {
        self.completed(self, MPUPrintReceiptResultFailed);
    }
}

#pragma mark - MPUPrintReceiptDelegate

- (void)printReceiptFailed:(NSError *)error {
    self.lastError = error;
    [self performSegueWithIdentifier:MPUSegueIdentifierPrint_Error sender:nil];
}

- (void)printReceiptSuccess {
    self.completed(self, MPUPrintReceiptResultSuccessful);
}

- (void)printReceiptAborted {
    self.completed(self, MPUPrintReceiptResultFailed);
}

#pragma mark - MPULoginDelegate

- (void)loginSuccess:(NSString *)username merchantIdentifier:(NSString *)merchantIdentifier merchantSecret:(NSString *)merchantSecret {
    [self.delegate hideCloseButton:YES];
    [self performSegueWithIdentifier:MPUSegueIdentifierPrint_PrintReceipt sender:nil];
}

#pragma mark - MPUErrorDelegate
- (void)errorCancelClicked:(BOOL)authenticationFailed {
    if (self.mposUi.mposUiMode == MPUMposUiModeApplication && authenticationFailed) {
        [self performSegueWithIdentifier:MPUSegueIdentifierPrint_Login sender:nil];
    } else {
        self.completed(self, MPUPrintReceiptResultFailed);
    }
}

- (void)errorRetryClicked {
    [self performSegueWithIdentifier:MPUSegueIdentifierPrint_PrintReceipt sender:nil];
}

@end

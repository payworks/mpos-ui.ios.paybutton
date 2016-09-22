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

#import "MPUTransactionContainerViewController.h"
#import "MPUUIHelper.h"
#import <MPBSignatureViewController/MPBSignatureViewController.h>

NSString* const MPUSegueIdentifierTransaction_Transaction = @"txPushTransaction";
NSString* const MPUSegueIdentifierTransaction_ApplicationSelection = @"txPushApplicationSelection";
NSString* const MPUSegueIdentifierTransaction_Error = @"txPushError";
NSString* const MPUSegueIdentifierTransaction_Summary = @"txPushSummary";
NSString* const MPUSegueIdentifierTransaction_SendReceipt = @"txPushSend";
NSString* const MPUSegueIdentifierTransaction_PrintReceipt = @"txPushPrint";
NSString* const MPUSegueIdentifierTransaction_LoadTransaction = @"txPushLoad";
NSString* const MPUSegueIdentifierTransaction_Login = @"txPushLogin";

@interface MPUTransactionContainerViewController ()

//The view controllers
@property (nonatomic, strong) MPUTransactionController *transactionViewController;  // We reuse this. So we keep this strong.
@property (nonatomic, strong) MPUSummaryController *summaryViewController;          // We reuse this. So we keep this strong.
@property (nonatomic, weak) MPULoginController *loginViewController;
@property (nonatomic, weak) MPUApplicationSelectionController *applicationSelectionViewController;
@property (nonatomic, weak) MPUErrorController *errorViewController;
@property (nonatomic, weak) MPUSendReceiptController *sendReceiptViewController;
@property (nonatomic, weak) MPUPrintReceiptController *printReceiptViewController;
@property (nonatomic, weak) MPULoadTransactionController *loadTransactionViewController;

@property (nonatomic, strong) NSArray *applications;
@property (nonatomic, strong) NSError *lastError;
@property (nonatomic, strong) MPTransaction *transaction;
@property (nonatomic, strong) MPTransaction *refundedTransaction;
@property (nonatomic, strong) NSString *transactionIdentifier;
@property (nonatomic, strong) NSString *sendPrintTransactionIdentifier;
@property (nonatomic, assign) BOOL transactionInProgress;
@property (nonatomic, assign) BOOL summaryShown;

@end

@implementation MPUTransactionContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.viewTransitionInProgress = NO;
    
    if (self.showLoginScreen) {
        self.previousSegueIdentifier = MPUSegueIdentifierTransaction_Login;
        [self performSegueWithIdentifier:MPUSegueIdentifierTransaction_Login sender:nil];
        self.transactionInProgress = NO;
    } else {
        self.previousSegueIdentifier = MPUSegueIdentifierTransaction_Transaction;
        [self performSegueWithIdentifier:MPUSegueIdentifierTransaction_Transaction sender:nil];
        self.transactionInProgress = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    // we can to show/hide the close button only after the first view is added.
    // we wait till the view is ready to appear and then hide/show naivgation bar buttons.
    if ([self.currentSegueIdentifier isEqualToString:MPUSegueIdentifierTransaction_Login]) {
        [self.delegate hideCloseButton:NO];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    self.previousSegueIdentifier = self.currentSegueIdentifier;
    self.currentSegueIdentifier = segue.identifier;
    
    [self.delegate hideBackButton:YES];
    [self.delegate hideCloseButton:YES];
    
    if ([segue.identifier isEqualToString:MPUSegueIdentifierTransaction_Transaction]) {
        DDLogDebug(@"Transaction");
        // we do this mainly to handle coming back from the application-selection view controller.
        // so just want to swap view controller back in so that we dont lose state when the transactoin is ongoing.
        if (!self.transactionInProgress) {
            self.transactionViewController = segue.destinationViewController;
            [self showTransaction:self.parameters processParameters:self.processParameters sessionIdentifier:self.sessionIdentifier];
        }
        [self swapToViewController:self.transactionViewController];
    }
    
    if ([segue.identifier isEqualToString:MPUSegueIdentifierTransaction_Login]) {
        DDLogDebug(@"Login");
        self.loginViewController = segue.destinationViewController;
        [self showLogin];
        [self swapToViewController:self.loginViewController];
    }
    
    if ([segue.identifier isEqualToString:MPUSegueIdentifierTransaction_ApplicationSelection]) {
        DDLogDebug(@"Application Selection");
        self.applicationSelectionViewController = segue.destinationViewController;
        [self showApplicaitonSelection:self.applications];
        [self swapToViewController:self.applicationSelectionViewController];
    }
    
    if ([segue.identifier isEqualToString:MPUSegueIdentifierTransaction_Error]) {
        DDLogDebug(@"Error");
        self.errorViewController = segue.destinationViewController;
        [self showError:self.lastError];
        [self swapToViewController:self.errorViewController];
    }
    
    if ([segue.identifier isEqualToString:MPUSegueIdentifierTransaction_Summary]) {
        DDLogDebug(@"Summary");
        
        if(!self.summaryShown) {
            self.summaryViewController = segue.destinationViewController;
        }

        self.summaryShown = YES;
        [self showSummary:self.transaction];
        [self swapToViewController:self.summaryViewController];
    }
    
    if ([segue.identifier isEqualToString:MPUSegueIdentifierTransaction_SendReceipt]) {
        DDLogDebug(@"Send");
        self.sendReceiptViewController = segue.destinationViewController;
        [self showSendReceipt:self.sendPrintTransactionIdentifier];
        [self swapToViewController:self.sendReceiptViewController];
    }
    
    if ([segue.identifier isEqualToString:MPUSegueIdentifierTransaction_PrintReceipt]) {
        DDLogDebug(@"Print");
        self.printReceiptViewController = segue.destinationViewController;
        [self showPrintReceipt:self.sendPrintTransactionIdentifier];
        [self swapToViewController:self.printReceiptViewController];
    }
    
    if ([segue.identifier isEqualToString:MPUSegueIdentifierTransaction_LoadTransaction]) {
        DDLogDebug(@"Load Transaction that was refunded");
        self.loadTransactionViewController = segue.destinationViewController;
        [self showLoadRefundedTransaction:self.transactionIdentifier];
        [self swapToViewController:self.loadTransactionViewController];
    }
}

- (void)showTransaction:(MPTransactionParameters *)parameters processParameters:(MPTransactionProcessParameters*)processParameters sessionIdentifier:(NSString*)sessionIdentifier {
    NSString *title = [MPUUIHelper defaultControllerTitleBasedOnParameters:self.parameters
                                                               transaction:self.transaction
                                                                   toolbox:self.mposUi.transactionProvider.localizationToolbox];
    [self.delegate titleChanged:title];
    self.transactionViewController.parameters = parameters;
    self.transactionViewController.processParameters = processParameters;
    self.transactionViewController.sessionIdentifier = sessionIdentifier;
    self.transactionViewController.delegate = self;
}

- (void)showLogin {
    [self.delegate hideCloseButton:NO];
    [self.delegate titleChanged:[MPUUIHelper localizedString:@"MPULogin"]];
    self.loginViewController.prefillUsername = self.mposUi.username;
    self.loginViewController.delegate = self;
}

- (void)showApplicaitonSelection:(NSArray *)applications {
    self.applicationSelectionViewController.applications = applications;
    self.applicationSelectionViewController.delegate = self;
}

- (void)showError:(NSError *)error {
    [self.delegate titleChanged:[MPUUIHelper localizedString:@"MPUError"]];
    self.errorViewController.error = error;
    self.errorViewController.delegate = self;
    if ([self.previousSegueIdentifier isEqualToString:MPUSegueIdentifierTransaction_Transaction] ||
       [self.previousSegueIdentifier isEqualToString:MPUSegueIdentifierTransaction_PrintReceipt]) {
        self.errorViewController.retryEnabled = YES;
    }
}

- (void)showSummary:(MPTransaction *)transaction {
    [self.delegate titleChanged:[MPUUIHelper localizedString:@"MPUSummary"]];
    self.summaryViewController.transaction = transaction;
    self.summaryViewController.refundEnabled = NO;
    self.summaryViewController.retryEnabled = YES;
    self.summaryViewController.parameters = self.parameters;
    self.summaryViewController.sessionIdentifier = self.sessionIdentifier;
    self.summaryViewController.delegate = self;
    self.summaryViewController.mposUi = self.mposUi;
}

- (void)showSignatureScreenForScheme:(MPPaymentDetailsScheme)scheme amount:(NSString *) amount {

    MPBSignatureViewControllerConfiguration *config = [MPBSignatureViewControllerConfiguration configurationWithMerchantName:nil formattedAmount:amount];
    switch(scheme) {
        case MPPaymentDetailsSchemeMasterCard:
            config.scheme = MPBSignatureViewControllerConfigurationSchemeMastercard;
            break;
        case MPPaymentDetailsSchemeVISA:
        case MPPaymentDetailsSchemeVISAElectron:
            config.scheme = MPBSignatureViewControllerConfigurationSchemeVisa;
            break;
        case MPPaymentDetailsSchemeMaestro:
            config.scheme = MPBSignatureViewControllerConfigurationSchemeMaestro;
            break;
        case MPPaymentDetailsSchemeAmericanExpress:
            config.scheme = MPBSignatureViewControllerConfigurationSchemeAmex;
            break;
        case MPPaymentDetailsSchemeDinersClub:
            config.scheme = MPBSignatureViewControllerConfigurationSchemeDinersClub;
            break;
        case MPPaymentDetailsSchemeDiscover:
            config.scheme = MPBSignatureViewControllerConfigurationSchemeDiscover;
            break;
        case MPPaymentDetailsSchemeJCB:
            config.scheme = MPBSignatureViewControllerConfigurationSchemeJCB;
            break;
        case MPPaymentDetailsSchemeUnionPay:
            config.scheme = MPBSignatureViewControllerConfigurationSchemeUnionPay;
            break;
        case MPPaymentDetailsSchemeUnknown:
            config.scheme = MPBSignatureViewControllerConfigurationSchemeNone;
            break;
    }

    MPBMposUIStyleSignatureViewController *vc = [[MPBMposUIStyleSignatureViewController alloc] initWithConfiguration: config];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
    } else { // on iPad
        vc.modalPresentationStyle = UIModalPresentationCurrentContext;
    }

    vc.continueBlock = ^(UIImage *signature) {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            [self.transactionViewController continueWithCustomerSignature:signature verified:YES];
        }];
    };
    vc.cancelBlock = ^{
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            [self.transactionViewController continueWithCustomerSignature:nil verified:NO];
        }];
    };

    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

- (void)showSendReceipt:(NSString *)transactionIdentifier {
    [self.delegate titleChanged:[MPUUIHelper localizedString:@"MPUSendReceipt"]];
    [self.delegate hideBackButton:NO];
    self.sendReceiptViewController.transactionIdentifier = transactionIdentifier;
    self.sendReceiptViewController.delegate = self;
}

- (void)showPrintReceipt:(NSString *)transactionIdentifier {
    [self.delegate titleChanged:[MPUUIHelper localizedString:@"MPUPrinting"]];
    self.printReceiptViewController.transactionIdentifer = transactionIdentifier;
    self.printReceiptViewController.delegate = self;
}

- (void)showLoadRefundedTransaction:(NSString *)transactionIdentifier {
    self.loadTransactionViewController.transactionIdentifer = self.transactionIdentifier;
    self.loadTransactionViewController.delegate = self;
}

#pragma mark - Public

- (void)backButtonPressed {
    
    [self.delegate hideBackButton:YES];
    
    if ([self.currentSegueIdentifier isEqualToString:MPUSegueIdentifierTransaction_SendReceipt]) {
        [self performSegueWithIdentifier:MPUSegueIdentifierTransaction_Summary sender:nil];
    }
}

- (void)closeButtonPressed {
    // Close only if the close button is enabled in login.
    if ([self.currentSegueIdentifier isEqualToString:MPUSegueIdentifierTransaction_Login]
       && self.loginViewController
       && self.loginViewController.closeButtonEnabled) {
        self.completed(self, MPUTransactionResultFailed, self.mposUi.transaction);
    }
}

#pragma mark - MPUTransactionDelegate

- (void)transactionApplicationSelectionRequired:(NSArray *)applications {
    self.applications = applications;
    [self performSegueWithIdentifier:MPUSegueIdentifierTransaction_ApplicationSelection sender:nil];
}

- (void)transactionSignatureRequired:(MPPaymentDetailsScheme)scheme amount:(NSString *)amount {
    [self showSignatureScreenForScheme:scheme amount:amount];
}

- (void)transactionError:(NSError *)error {
    self.transactionInProgress = NO;
    self.lastError = error;
    [self performSegueWithIdentifier:MPUSegueIdentifierTransaction_Error sender:nil];
}

- (void)transactionSummary:(MPTransaction *)transaction {
    self.transactionInProgress = NO;
    self.transaction = transaction;
    self.transactionIdentifier = transaction.identifier;
    [self performSegueWithIdentifier:MPUSegueIdentifierTransaction_Summary sender:nil];
}

- (void)transactionRefunded:(MPTransaction *)transaction {
    self.transactionInProgress = NO;
    self.refundedTransaction = transaction;
    self.transactionIdentifier = transaction.referencedTransactionIdentifier;
    [self performSegueWithIdentifier:MPUSegueIdentifierTransaction_LoadTransaction sender:nil];
}

- (void)transactionStatusChanged:(MPTransaction *)transaction {
    
    NSString *title = [MPUUIHelper defaultControllerTitleBasedOnParameters:self.parameters
                                                               transaction:transaction
                                                                   toolbox:self.mposUi.transactionProvider.localizationToolbox];
    [self.delegate titleChanged:title];
}

#pragma mark - MPULoginDelegate

- (void)loginSuccess:(NSString *)username merchantIdentifier:(NSString *)merchantIdentifier merchantSecret:(NSString *)merchantSecret {
    //We proceed with the transaction yes? :D
    [self.delegate hideCloseButton:YES];
    [self performSegueWithIdentifier:MPUSegueIdentifierTransaction_Transaction sender:nil];
}

#pragma mark - MPUApplicationSelectionDelegate

- (void)applicationSelected:(id)application {
    [self.transactionViewController continueWithSelectedApplication:application];
    [self performSegueWithIdentifier:MPUSegueIdentifierTransaction_Transaction sender:nil];
}

- (void)applicationSelectionAbortClicked {
    [self.transactionViewController requestAbort];
    [self performSegueWithIdentifier:MPUSegueIdentifierTransaction_Transaction sender:nil];
}

#pragma mark - MPUErrorDelegate

- (void)errorRetryClicked {
    if ([self.previousSegueIdentifier isEqualToString:MPUSegueIdentifierTransaction_Transaction]) {
        [self performSegueWithIdentifier:MPUSegueIdentifierTransaction_Transaction sender:nil];
    }
    else if ([self.previousSegueIdentifier isEqualToString:MPUSegueIdentifierTransaction_PrintReceipt]) {
        [self performSegueWithIdentifier:MPUSegueIdentifierTransaction_PrintReceipt sender:nil];
    }
}

- (void)errorCancelClicked:(BOOL)authenticationFailed {
    if (self.mposUi.mposUiMode == MPUMposUiModeApplication && authenticationFailed) {
        [self performSegueWithIdentifier:MPUSegueIdentifierTransaction_Login sender:nil];
    } else {
        if ([self.previousSegueIdentifier isEqualToString:MPUSegueIdentifierTransaction_Transaction]) {
            self.completed(self, MPUTransactionResultFailed, self.mposUi.transaction);
        }
        else if ([self.previousSegueIdentifier isEqualToString:MPUSegueIdentifierTransaction_PrintReceipt]) {
            [self performSegueWithIdentifier:MPUSegueIdentifierTransaction_Summary sender:nil];
        }
    }
}

#pragma mark - MPUSummaryDelegate

- (void)summaryRefundClicked:(NSString *)transactionIdentifier {
    //This is an illegal state. Should never happen!
}

- (void)summaryCaptureClicked:(NSString *)transactionIdentifier {
    //This is an illegal state. Should never happen!
}

- (void)summarySendReceiptClicked:(NSString *)transactionIdentifier {
    self.sendPrintTransactionIdentifier = transactionIdentifier;
    [self performSegueWithIdentifier:MPUSegueIdentifierTransaction_SendReceipt sender:nil];
}

- (void)summaryPrintReceiptClicked:(NSString *)transactionIdentifier {
    self.sendPrintTransactionIdentifier = transactionIdentifier;
    [self performSegueWithIdentifier:MPUSegueIdentifierTransaction_PrintReceipt sender:nil];
}

- (void)summaryRetryClicked {
    self.summaryShown = NO;
    [self performSegueWithIdentifier:MPUSegueIdentifierTransaction_Transaction sender:nil];
}

- (void)summaryCloseClicked {
    if (self.transaction && self.transaction.status == MPTransactionStatusApproved) {
        self.completed(self, MPUTransactionResultApproved, self.mposUi.transaction);
    } else {
        self.completed(self, MPUTransactionResultFailed, self.mposUi.transaction);
    }
}

#pragma mark - MPUSendReceiptDelegate

- (void) sendReciptSuccess {
    [self.delegate hideBackButton:YES];
    if (self.summaryViewController) {
        [self.summaryViewController updateSendReceiptButtonText];
    }
    [self performSegueWithIdentifier:MPUSegueIdentifierTransaction_Summary sender:nil];
}

#pragma mark - MPUPrintReceiptDelegate

- (void)printReceiptSuccess {
    if (self.summaryViewController) {
        [self.summaryViewController updatePrintReceiptButtonText];
    }
    [self performSegueWithIdentifier:MPUSegueIdentifierTransaction_Summary sender:nil];
}

- (void)printReceiptFailed:(NSError *)error {
    self.lastError = error;
    [self performSegueWithIdentifier:MPUSegueIdentifierTransaction_Error sender:nil];
}

- (void)printReceiptAborted {
    [self performSegueWithIdentifier:MPUSegueIdentifierTransaction_Summary sender:nil];
}

#pragma mark - MPULoadTransactionDelegate

- (void)loadTransactionSuccess:(MPTransaction *)transaction {
    // We show the loaded original transaction that was refunded.
    // Only applies for Refunds.
    self.transaction = transaction;
    [self performSegueWithIdentifier:MPUSegueIdentifierTransaction_Summary sender:nil];
}

- (void)loadTransactionFailed:(NSError *)error {
    // Loading the original transaciton failed. We show the refund receipt and not the original.
    // This should theoretically never happen. 
    self.transaction = self.refundedTransaction;
    [self performSegueWithIdentifier:MPUSegueIdentifierTransaction_Summary sender:nil];
}

@end

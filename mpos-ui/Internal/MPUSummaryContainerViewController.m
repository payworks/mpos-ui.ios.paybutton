/*
 * mpos-ui : http://www.payworksmobile.com
 *
 * Copyright (c) 2015 payworks GmbH
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

#import "MPUSummaryContainerViewController.h"
#import "MPUTransactionParameters.h"
#import "MPUUIHelper.h"

NSString* const MPUSegueIdentifierSummary_LoadTransaction = @"smPushLoad";
NSString* const MPUSegueIdentifierSummary_Summary = @"smPushSummary";
NSString* const MPUSegueIdentifierSummary_SendReceipt = @"smPushSend";
NSString* const MPUSegueIdentifierSummary_PrintReceipt = @"smPushPrint";
NSString* const MPUSegueIdentifierSummary_Error = @"smPushError";

@interface MPUSummaryContainerViewController ()

//The view controllers
@property (nonatomic, strong) MPUSummaryController *summaryViewController;  // We reuse this. So we keep this strong
@property (nonatomic, weak) MPULoadTransactionController *loadTransactionViewController;
@property (nonatomic, weak) MPUSendReceiptController *sendReceiptViewController;
@property (nonatomic, weak) MPUPrintReceiptController *printReceiptViewController;
@property (nonatomic, weak) MPUErrorController *errorViewController;

@property (nonatomic, strong) MPTransaction *transaction;
@property (nonatomic, strong) MPTransaction *refundTransaction;
@property (nonatomic, strong) NSError *lastError;
@property (nonatomic, strong) UIImage *customerSignature;
@property (nonatomic, assign) BOOL modified;
@property (nonatomic, assign) BOOL refundingInProgress;
@property (nonatomic, assign) BOOL summaryShown;


@end

@implementation MPUSummaryContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.modified = false;
    self.viewTransitionInProgress = NO;
    self.previousSegueIdentifier = MPUSegueIdentifierSummary_LoadTransaction;
    
    // First we always load the transaction from the server.
    [self performSegueWithIdentifier:MPUSegueIdentifierSummary_LoadTransaction sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    self.previousSegueIdentifier = self.currentSegueIdentifier;
    self.currentSegueIdentifier = segue.identifier;
    
    if ([segue.identifier isEqualToString:MPUSegueIdentifierSummary_LoadTransaction]) {
        DDLogDebug(@"Load");
        self.loadTransactionViewController = segue.destinationViewController;
        [self showLoadTransaction:self.transactionIdentifer];
        [self swapToViewController:self.loadTransactionViewController];
    }
    
    if ([segue.identifier isEqualToString:MPUSegueIdentifierSummary_Summary]) {
        DDLogDebug(@"Summary");
        if(self.summaryShown) {
            // We've already created the screen before. No need to create it again.
            [self.delegate titleChanged:[MPUUIHelper localizedString:@"MPUSummary"]];
            [self swapToViewController:self.summaryViewController];
            return;
        }
        self.summaryShown = YES;
        self.summaryViewController = segue.destinationViewController;
        [self showSummary:self.transaction];
        [self swapToViewController:self.summaryViewController];
    }
    
    if ([segue.identifier isEqualToString:MPUSegueIdentifierSummary_SendReceipt]) {
        DDLogDebug(@"Send Receip[t");
        self.sendReceiptViewController = segue.destinationViewController;
        [self showSendReceipt:self.transactionIdentifer];
        [self swapToViewController:self.sendReceiptViewController];
    }
    
    if ([segue.identifier isEqualToString:MPUSegueIdentifierSummary_PrintReceipt]) {
        DDLogDebug(@"Print Receipt");
        self.printReceiptViewController = segue.destinationViewController;
        [self showPrintReceipt:self.transactionIdentifer];
        [self swapToViewController:self.printReceiptViewController];
    }
    
    if ([segue.identifier isEqualToString:MPUSegueIdentifierSummary_Error]) {
        DDLogDebug(@"Error");
        self.errorViewController = segue.destinationViewController;
        [self showError:self.lastError];
        [self swapToViewController:self.errorViewController];
    }
}

- (void)showLoadTransaction:(NSString *)transactionIdentifier {
    [self.delegate titleChanged:[MPUUIHelper localizedString:@"MPULoading"]];
    self.loadTransactionViewController.transactionIdentifer = transactionIdentifier;
    self.loadTransactionViewController.delegate = self;
}

- (void)showSummary:(MPTransaction *)transaction {
    [self.delegate titleChanged:[MPUUIHelper localizedString:@"MPUSummary"]];
    self.summaryViewController.transaction = transaction;
    self.summaryViewController.refundEnabled = YES;
    self.summaryViewController.retryEnabled = NO;
    self.summaryViewController.delegate = self;
}

- (void)showError:(NSError *)error{
    [self.delegate titleChanged:[MPUUIHelper localizedString:@"MPUError"]];
    self.errorViewController.error = error;
    self.errorViewController.delegate = self;
    if ([self.previousSegueIdentifier isEqualToString:MPUSegueIdentifierSummary_LoadTransaction] ||
       [self.previousSegueIdentifier isEqualToString:MPUSegueIdentifierSummary_PrintReceipt]) {
        self.errorViewController.retryEnabled = YES;
    }
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

- (void)showRefundTransaction:(NSString *)transactionIdentifier {
    UIViewController *viewController = [self.mposUi createRefundTransactionViewControllerWithTransactionIdentifer:transactionIdentifier subject:nil customIdentifier:nil completed:^(UIViewController *controller, MPUTransactionResult result, MPTransaction *transaction) {
        self.completed(self);
    }];
    
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - Public

- (void)backButtonPressed {
    if ([self.currentSegueIdentifier isEqualToString:MPUSegueIdentifierSummary_SendReceipt]) {
        [self performSegueWithIdentifier:MPUSegueIdentifierSummary_Summary sender:nil];
    }
    [self.delegate hideBackButton:YES];
}

#pragma mark - MPULoadTransactionDelegate

- (void)loadTransactionSuccess:(MPTransaction *)transaction {
    self.transaction = transaction;
    [self performSegueWithIdentifier:MPUSegueIdentifierSummary_Summary sender:nil];
}

- (void)loadTransactionFailed:(NSError *)error {
    self.lastError = error;
    [self performSegueWithIdentifier:MPUSegueIdentifierSummary_Error sender:nil];
}

#pragma mark - MPUSummaryDelegate

- (void) summaryRefundClicked:(NSString *)transactionIdentifier {
    self.refundingInProgress = YES;
    //We push a viewcontroller for refund. Makes the lifecycle easier IMO.
    [self showRefundTransaction:self.transactionIdentifer];
}

- (void) summaryRetryClicked {
    // NO-OP
    // This is an illegal state.
}

- (void) summarySendReceiptClicked:(NSString *)transactionIdentifier {
    [self performSegueWithIdentifier:MPUSegueIdentifierSummary_SendReceipt sender:nil];
}

- (void) summaryPrintReceiptClicked:(NSString *)transactionIdentifier {
    [self performSegueWithIdentifier:MPUSegueIdentifierSummary_PrintReceipt sender:nil];
}

- (void) summaryCloseClicked {
    self.completed(self);
}

#pragma mark - MPUErrorDelegate

- (void)errorRetryClicked {
    if ([self.previousSegueIdentifier isEqualToString:MPUSegueIdentifierSummary_LoadTransaction]) {
        [self performSegueWithIdentifier:MPUSegueIdentifierSummary_LoadTransaction sender:nil];
    }
    else if ([self.previousSegueIdentifier isEqualToString:MPUSegueIdentifierSummary_PrintReceipt]) {
        [self performSegueWithIdentifier:MPUSegueIdentifierSummary_PrintReceipt sender:nil];
    }
}

- (void)errorCancelClicked {
    if ([self.previousSegueIdentifier isEqualToString:MPUSegueIdentifierSummary_LoadTransaction]) {
        self.completed(self);
    }
    else if ([self.previousSegueIdentifier isEqualToString:MPUSegueIdentifierSummary_PrintReceipt]) {
        [self performSegueWithIdentifier:MPUSegueIdentifierSummary_Summary sender:nil];
    }
}

#pragma mark - MPUSendReceiptDelegate

- (void)sendReciptSuccess {
    [self.delegate hideBackButton:YES];
    if (self.summaryViewController) {
        [self.summaryViewController updateSendReceiptButtonText];
    }
    [self performSegueWithIdentifier:MPUSegueIdentifierSummary_Summary sender:nil];
}

#pragma mark - MPUPrintReceiptDelegate

- (void)printReceiptSuccess {
    if (self.summaryViewController) {
        [self.summaryViewController updatePrintReceiptButtonText];
    }
    [self performSegueWithIdentifier:MPUSegueIdentifierSummary_Summary sender:nil];
}

- (void)printReceiptFailed:(NSError *)error {
    self.lastError = error;
    [self performSegueWithIdentifier:MPUSegueIdentifierSummary_Error sender:nil];
}

- (void)printReceiptAborted {
    [self performSegueWithIdentifier:MPUSegueIdentifierSummary_Summary sender:nil];
}
@end

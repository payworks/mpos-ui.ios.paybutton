/*
 * mpos-ui : http://www.payworksmobile.com
 *
 * The MIT License (MIT)
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

#import "MPUSummaryController.h"
#import "MPUMposUi_Internal.h"
#import "MPUUIHelper.h"
#import "MPUMposUiConfiguration.h"
#import "MPUSendReceiptController.h"
#import "MPUPrintReceiptController.h"

@interface MPUSummaryController ()


@property (nonatomic, weak) IBOutlet UIView* containerView;
@property (nonatomic, weak) IBOutlet UILabel* transactionStatusView;
@property (nonatomic, weak) IBOutlet UILabel* amountView;
@property (nonatomic, weak) IBOutlet UILabel* subjectView;
@property (nonatomic, weak) IBOutlet UIView* subjectViewSeparator;
@property (nonatomic, weak) IBOutlet UIImageView* paymentSchemeView;
@property (nonatomic, weak) IBOutlet UILabel *paymentSchemeViewFallback;
@property (nonatomic, weak) IBOutlet UILabel* maskedAccountNumberView;
@property (nonatomic, weak) IBOutlet UIView* paymentSchemeViewSeparator;
@property (nonatomic, weak) IBOutlet UILabel* dateView;
@property (nonatomic, weak) IBOutlet UIButton* retryButton;
@property (nonatomic, weak) IBOutlet UIButton* refundButton;
@property (nonatomic, weak) IBOutlet UIButton* sendReceiptButton;
@property (nonatomic, weak) IBOutlet UIButton *closeButton;
@property (nonatomic, weak) IBOutlet UIButton *printReceiptButton;
@property (nonatomic, weak) IBOutlet UILabel *transactionTypeView;

@end


@implementation MPUSummaryController

#pragma mark - UIView lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateViews];
    [self l10n];
}


- (void) l10n {
    [self.refundButton setTitle:[MPUUIHelper localizedString:@"MPURefund"] forState:UIControlStateNormal];
    [self.retryButton setTitle:[MPUUIHelper localizedString:@"MPURetry"] forState:UIControlStateNormal];
    [self.sendReceiptButton setTitle:[MPUUIHelper localizedString:@"MPUSendReceipt"] forState:UIControlStateNormal];
    [self.closeButton setTitle:[MPUUIHelper localizedString:@"MPUClose"] forState:UIControlStateNormal];
    [self.printReceiptButton setTitle:[MPUUIHelper localizedString:@"MPUPrintReceipt"] forState:UIControlStateNormal];
}


#pragma mark - IBActions

- (IBAction)didClose:(id)sender {
    [self.delegate summaryCloseClicked];
}

- (IBAction)didTapRetryButton:(id)sender {
    [self.delegate summaryRetryClicked];
}

- (IBAction)didTapSendReceipt:(id)sender {
    [self.delegate summarySendReceiptClicked:[self transactionIdentifierForSendingAndPrintingReceipt]];
}

- (IBAction)didTapRefundButton:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[MPUUIHelper localizedString:@"MPURefundPayment"]
                                                   message:[MPUUIHelper localizedString:@"MPURefundPrompt"]
                                                  delegate:self
                                         cancelButtonTitle:[MPUUIHelper localizedString:@"MPUAbort"] otherButtonTitles:nil];
    
    [alert addButtonWithTitle:[MPUUIHelper localizedString:@"MPURefund"]];
    [alert show];
};

- (IBAction)didTapPrintReceiptButton:(id)sender{
    [self.delegate summaryPrintReceiptClicked:[self transactionIdentifierForSendingAndPrintingReceipt]];
}

#pragma mark - Public 
- (void)updatePrintReceiptButtonText {
    [self.printReceiptButton setTitle:[MPUUIHelper localizedString:@"MPUReprintReceipt"] forState:UIControlStateNormal];
}

- (void)updateSendReceiptButtonText {
    [self.sendReceiptButton setTitle:[MPUUIHelper localizedString:@"MPUResendReceipt"] forState:UIControlStateNormal];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0){ //Abort was clicked
        //let it dismiss...do nothing
    } else if (buttonIndex == 1) { // Refund was clicked
        [self.delegate summaryRefundClicked:self.transaction.identifier];
    }
}

#pragma mark - Private

- (NSString *)transactionIdentifierForSendingAndPrintingReceipt {
    // If this is a refund, we look for the transaction identifier from the refundTransactions list.
    if (self.transaction.refundDetails.status == MPRefundDetailsStatusRefunded
        && self.transaction.refundDetails.refundTransactions != nil
        && self.transaction.refundDetails.refundTransactions.count > 0) {
        MPRefundTransaction *refundTransaction = self.transaction.refundDetails.refundTransactions[0];
        return refundTransaction.identifier;
    }
    
    return self.transaction.identifier;
}

- (void)updateViews {
    [self initContainerView];
    [self updateTransactionStatusView];
    [self updateAmountView];
    [self updateSchemeView];
    [self updateMaskedAccountNumberView];
    [self updateSubjectView];
    [self updateDateView];
    [self updateButtons];
    [self updateTransactionTypeView];
}

- (void)updateTransactionTypeView {
    switch (self.transaction.type) {
        case MPTransactionTypePreauthorize:
        case MPTransactionTypeCharge:
            self.transactionTypeView.text = [MPUUIHelper localizedString:@"MPUSale"];
            break;
        case MPTransactionTypeCredit:
        case MPTransactionTypeRefund:
            self.transactionTypeView.text = [MPUUIHelper localizedString:@"MPURefund"];
            break;
        case MPTransactionTypeUnknown:
            self.transactionTypeView.text = @"";
            break;
    }
}

- (void)initContainerView {
    [self.containerView.layer setCornerRadius:2];
    [self.containerView.layer setShadowColor:[UIColor darkGrayColor].CGColor];
    [self.containerView.layer setShadowOpacity:0.4];
    [self.containerView.layer setShadowRadius:2.0];
    [self.containerView.layer setShadowOffset:CGSizeMake(-.2f, .2f)];
}

- (void)updateTransactionStatusView {
    
    if (self.transaction.type == MPTransactionTypeRefund) {
        [self updateTransactionStatusViewForRefundTransaction];
    }
    else{
        [self updateTransactionStatusViewForChargeTransaction];
    }
}


- (void)updateTransactionStatusViewForChargeTransaction {
    switch (self.transaction.status) {
        case MPTransactionStatusApproved:
            
            if (self.transaction.refundDetails.status == MPRefundDetailsStatusRefunded){
                self.transactionStatusView.text = [MPUUIHelper localizedString:@"MPUPaymentRefunded"];
                self.transactionStatusView.textColor = [MPUUIHelper colorFromHexString:@"#4caf50"];
            }
            else {
                self.transactionStatusView.text = [MPUUIHelper localizedString:@"MPUPaymentSuccessful"];
                self.transactionStatusView.textColor = [MPUUIHelper colorFromHexString:@"#4caf50"];
            }
            break;
            
        case MPTransactionStatusDeclined:
            self.transactionStatusView.text = [MPUUIHelper localizedString:@"MPUPaymentDeclined"];
            self.transactionStatusView.textColor = [MPUUIHelper colorFromHexString:@"#f44336"];
            break;
            
        case MPTransactionStatusAborted:
            self.transactionStatusView.text = [MPUUIHelper localizedString:@"MPUPaymentAborted"];
            self.transactionStatusView.textColor = [MPUUIHelper colorFromHexString:@"#f44336"];
            break;
            
        case MPTransactionStatusError:
            self.transactionStatusView.text = [MPUUIHelper localizedString:@"MPUError"];
            self.transactionStatusView.textColor = [MPUUIHelper colorFromHexString:@"#f44336"];
            break;
            
        case MPTransactionStatusInitialized:
        case MPTransactionStatusPending:
        case MPTransactionStatusUnknown:
            self.transactionStatusView.text = [MPUUIHelper localizedString:@"MPUError"];
            self.transactionStatusView.textColor = [MPUUIHelper colorFromHexString:@"#f44336"];
            break;
    }
}

- (void)updateTransactionStatusViewForRefundTransaction {
    switch (self.transaction.status) {
        case MPTransactionStatusApproved:
            self.transactionStatusView.text = [MPUUIHelper localizedString:@"MPURefundApproved"];
            self.transactionStatusView.textColor = [MPUUIHelper colorFromHexString:@"#4caf50"];
            break;
            
        case MPTransactionStatusDeclined:
            self.transactionStatusView.text = [MPUUIHelper localizedString:@"MPURefundDeclined"];
            self.transactionStatusView.textColor = [MPUUIHelper colorFromHexString:@"#f44336"];
            break;
            
        case MPTransactionStatusAborted:
            self.transactionStatusView.text = [MPUUIHelper localizedString:@"MPURefundAborted"];
            self.transactionStatusView.textColor = [MPUUIHelper colorFromHexString:@"#f44336"];
            break;
            
        case MPTransactionStatusError:
            self.transactionStatusView.text = [MPUUIHelper localizedString:@"MPUError"];
            self.transactionStatusView.textColor = [MPUUIHelper colorFromHexString:@"#f44336"];
            break;
            
        case MPTransactionStatusInitialized:
        case MPTransactionStatusPending:
        case MPTransactionStatusUnknown:
            self.transactionStatusView.text = [MPUUIHelper localizedString:@"MPUError"];
            self.transactionStatusView.textColor = [MPUUIHelper colorFromHexString:@"#f44336"];
            break;
    }
    
}

- (void)updateAmountView {
    self.amountView.text = [self.mposUi.transactionProvider.localizationToolbox textFormattedForAmount:self.transaction.amount currency:self.transaction.currency];
}

- (void)useSchemeViewFallback:(MPPaymentDetailsScheme)scheme {
    self.paymentSchemeView.hidden = YES;
    self.paymentSchemeViewFallback.hidden = NO;
    
    switch (scheme) {
        case MPPaymentDetailsSchemeVISA:
            self.paymentSchemeViewFallback.text = @"VISA";
            break;
            
        case MPPaymentDetailsSchemeVISAElectron:
            self.paymentSchemeViewFallback.text = @"VISA Electron";
            break;
            
        case MPPaymentDetailsSchemeMaestro:
            self.paymentSchemeViewFallback.text = @"Maestro";
            break;
            
        case MPPaymentDetailsSchemeMasterCard:
            self.paymentSchemeViewFallback.text = @"MasterCard";
            break;
            
        case MPPaymentDetailsSchemeAmericanExpress:
            self.paymentSchemeViewFallback.text = @"American Express";
            break;
            
        default:
            [self.paymentSchemeView removeFromSuperview];
            [self.paymentSchemeViewFallback removeFromSuperview];
            [self.paymentSchemeViewSeparator removeFromSuperview];
            return;
    }
    
}

- (void)updateSchemeView {
    MPPaymentDetailsScheme scheme = self.transaction.paymentDetails.scheme;
    if (scheme == MPPaymentDetailsSchemeUnknown) {
        [self.paymentSchemeView removeFromSuperview];
        [self.paymentSchemeViewFallback removeFromSuperview];
        [self.paymentSchemeViewSeparator removeFromSuperview];
        return;
    }
    if (!IS_OS_8_OR_LATER) {
        // on iOS 7, the method to load an image in a bundle does not exist.
        DDLogDebug(@"Scheme Falling Back!Not iOS8");
        [self useSchemeViewFallback:scheme];
        return;
    }
    
    switch (scheme) {
        case MPPaymentDetailsSchemeVISA:
        case MPPaymentDetailsSchemeVISAElectron:
            self.paymentSchemeView.image = [UIImage imageNamed:@"VISA" inBundle:[MPUUIHelper frameworkBundle] compatibleWithTraitCollection:nil];
            break;
        
        case MPPaymentDetailsSchemeMaestro:
            self.paymentSchemeView.image = [UIImage imageNamed:@"Maestro" inBundle:[MPUUIHelper frameworkBundle] compatibleWithTraitCollection:nil];
            break;
            
        case MPPaymentDetailsSchemeMasterCard:
            self.paymentSchemeView.image = [UIImage imageNamed:@"MasterCard" inBundle:[MPUUIHelper frameworkBundle] compatibleWithTraitCollection:nil];
            break;
            
        case MPPaymentDetailsSchemeAmericanExpress:
            self.paymentSchemeView.image = [UIImage imageNamed:@"AmericanExpress" inBundle:[MPUUIHelper frameworkBundle] compatibleWithTraitCollection:nil];
            break;
            
        default:
            [self useSchemeViewFallback: scheme];
            break;
    }
}

- (void)updateMaskedAccountNumberView {
    NSString *maskedAccountNumber = self.transaction.paymentDetails.accountNumber;
    maskedAccountNumber = [maskedAccountNumber stringByReplacingOccurrencesOfString:@"[^0-9]"
                                                                         withString:@"*"
                                                                            options:NSRegularExpressionSearch
                                                                              range:NSMakeRange(0, [maskedAccountNumber length])];
    if ((!maskedAccountNumber || [maskedAccountNumber length] == 0) && self.paymentSchemeView.superview == nil) {
        [self.maskedAccountNumberView removeFromSuperview];
    } else {
        self.maskedAccountNumberView.text = maskedAccountNumber;   
    }
}

- (void)updateSubjectView {
    if ([MPUUIHelper isStringEmpty:self.transaction.subject]) {
        [self.subjectView removeFromSuperview];
        [self.subjectViewSeparator removeFromSuperview];
    } else {
        self.subjectView.text = self.transaction.subject;
    }
}

- (void)updateDateView {
    self.dateView.text = [self.mposUi.transactionProvider.localizationToolbox textFormattedForTimeAndDate:self.transaction.created];
}

- (void)updateButtons {
    // if send receipt via email feature not enabled, remove sendReceiptButton.
    if (![self isSendReceiptFeatureEnabled]) {
        [self.sendReceiptButton removeFromSuperview];
    }
    
    // if print receipt feature not enabled, remove printReceiptButton.
    if (![self isPrintReceiptFeatureEnabled]) {
        [self.printReceiptButton removeFromSuperview];
    }
    
    // if refund receipt feature not enabled and other factors fail to satisfy refund button, remove refundButton.
    if (self.refundEnabled == NO || ![self isRefundFeatureEnabled] || ![self isTransactionApproved] || [self isTransactionTypeRefund] || [self isTransactionRefunded]) {
        [self.refundButton removeFromSuperview];
    }

    if (self.retryEnabled == NO || self.transaction.status == MPTransactionStatusApproved || self.sessionIdentifier) {
        [self.retryButton removeFromSuperview];
    }
}

- (BOOL)isTransactionApproved {
    return (self.transaction.status == MPTransactionStatusApproved);
}

- (BOOL)isTransactionRefunded {
    return (self.transaction.refundDetails.status == MPRefundDetailsStatusRefunded);
}

- (BOOL)isTransactionTypeRefund {
    return (self.transaction.type == MPTransactionTypeRefund);
}

-(BOOL)isRefundFeatureEnabled {
    return ((self.mposUi.configuration.summaryFeatures & MPUMposUiConfigurationSummaryFeatureRefundTransaction) == MPUMposUiConfigurationSummaryFeatureRefundTransaction);
}

-(BOOL)isPrintReceiptFeatureEnabled {
    return ((self.mposUi.configuration.summaryFeatures & MPUMposUiConfigurationSummaryFeaturePrintReceipt) == MPUMposUiConfigurationSummaryFeaturePrintReceipt);
}

-(BOOL)isSendReceiptFeatureEnabled {
    return ((self.mposUi.configuration.summaryFeatures & MPUMposUiConfigurationSummaryFeatureSendReceiptViaEmail) == MPUMposUiConfigurationSummaryFeatureSendReceiptViaEmail);
}

@end

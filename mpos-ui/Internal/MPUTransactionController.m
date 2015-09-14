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

#import "MPUTransactionController.h"
#import "MPUUIHelper.h"
#import "MPUSummaryController.h"
#import "MPUErrorController.h"
#import "MPUMposUi_Internal.h"
#import "MPUTransactionParameters.h"
#import "MPUMposUiConfiguration.h"
#import "MPUMposUiAppearance.h"
#import "MPUApplicationSelectionController.h"
#import "MPUProgressView.h"
#import <MPBSignatureViewController/MPBSignatureViewController.h>

@interface MPUTransactionController ()

@property(nonatomic, strong) MPTransaction *transaction;
@property(nonatomic, strong) MPTransactionProcess *transactionProcess;

@property (nonatomic, weak) IBOutlet UILabel *transactionStatusInfo;
@property (nonatomic, weak) IBOutlet UILabel *transactionStatusIcon;
@property (nonatomic, weak) IBOutlet MPUProgressView *progressView;
@property (nonatomic, weak) IBOutlet UIButton *abortButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *progressViewMarginTopConstraint;
@property (nonatomic, assign) BOOL isRefund;

@end

@implementation MPUTransactionController

- (void)viewDidLoad {
    [super viewDidLoad];

    MPUMposUiConfiguration *configuration = self.mposUi.configuration;
    self.transactionStatusIcon.textColor = configuration.appearance.navigationBarTint;

    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        self.progressViewMarginTopConstraint.constant = 60;
    }

    [self l10n];
    [self startTransaction];
}

#pragma mark - Public
- (void)continueWithCustomerSignature:(UIImage *)signature verified:(BOOL)verified {
    [self.transactionProcess continueWithCustomerSignature:signature verified:verified];
}

- (void)continueWithSelectedApplication:(id)application {
    [self.transactionProcess continueWithSelectedApplication:application];
}


#pragma mark - Private

- (void) l10n {
    [self.abortButton setTitle:[MPUUIHelper localizedString:@"MPUAbort"] forState:UIControlStateNormal];
}

- (void)startTransaction {

    self.transaction = nil;
    self.mposUi.transaction = nil;
    self.mposUi.transactionProcessDetails = nil;
    
    MPTransactionProcessRegistered  registered = ^(MPTransactionProcess *transactionProcess, MPTransaction *transaction) {
        DDLogDebug(@"transaction registered");
        self.transaction = transaction;
        self.mposUi.transaction = transaction;
    };

    MPTransactionProcessStatusChanged statusChanged = ^(MPTransactionProcess *transactionProcess, MPTransaction *transaction, MPTransactionProcessDetails *details) {
        DDLogDebug(@"transaction status changed");
        self.mposUi.transaction = transaction;
        self.mposUi.transactionProcessDetails = details;
        [self updateTransactionStatus:details withTransaction:transaction];

    };
    
    MPTransactionProcessActionRequired actionRequired = ^(MPTransactionProcess *transactionProcess, MPTransaction *transaction, MPTransactionAction action, MPTransactionActionSupport *support) {
        DDLogDebug(@"transaction action required");
        if (action == MPTransactionActionApplicationSelection) {
            MPTransactionActionApplicationSelectionSupportWrapper *wrapper = [MPTransactionActionApplicationSelectionSupportWrapper wrapAround:support];
            NSArray *applications = wrapper.applications;
            [self displayApplicationSelection:applications];
        } else if (action == MPTransactionActionCustomerSignature) {
            [self displayCustomerSignature:transaction.paymentDetails.scheme];
        } else if (action == MPTransactionActionCustomerIdentification) {
            [self.transactionProcess continueWithCustomerIdentityVerified:false];
        }
    };

    MPTransactionProcessCompleted completed = ^(MPTransactionProcess *transactionProcess, MPTransaction *transaction, MPTransactionProcessDetails *details) {
        DDLogDebug(@"transaction completed, error %@", details.error);
        switch (transaction.status) {
            case MPTransactionStatusApproved:
            case MPTransactionStatusDeclined:
                if (self.isRefund) {
                    [self.delegate transactionRefunded:transaction];
                    return;
                }
                [self.delegate transactionSummary:transaction];
                break;
                
            case MPTransactionStatusAborted:
                self.mposUi.error = details.error;
                if (self.transaction){
                    [self.delegate transactionSummary:transaction];
                }
                break;
            case MPTransactionStatusError:
            case MPTransactionStatusInitialized:
            case MPTransactionStatusPending:
            case MPTransactionStatusUnknown:
                self.mposUi.error = details.error;
                [self.delegate transactionError:details.error];
                break;
        }
    };


    if (self.parameters.sessionIdentifier) {
        self.transactionProcess = [self.mposUi.transactionProvider startTransactionWithSessionIdentifier:self.parameters.sessionIdentifier
                                                                                          usingAccessory:self.mposUi.configuration.terminalFamily
                                                                                           statusChanged:statusChanged
                                                                                          actionRequired:actionRequired
                                                                                               completed:completed];

    } else if (self.parameters.transactionIdentifier){ //This is a refund
        self.isRefund = YES;
        MPTransactionTemplate* template = [self.mposUi.transactionProvider refundTransactionTemplateWithReferenceToPreviousTransaction:self.parameters.transactionIdentifier
                                                                                                                               subject:self.parameters.subject
                                                                                                                      customIdentifier:self.parameters.customIdentifier];
        self.transactionProcess = [self.mposUi.transactionProvider startTransactionWithTemplate:template
                                                                                 usingAccessory:self.mposUi.configuration.terminalFamily
                                                                                     registered:registered
                                                                                  statusChanged:statusChanged
                                                                                 actionRequired:actionRequired
                                                                                      completed:completed];
    } else {
        MPTransactionTemplate* template = [self.mposUi.transactionProvider chargeTransactionTemplateWithAmount:self.parameters.amount
                                                                                                      currency:self.parameters.currency
                                                                                                       subject:self.parameters.subject
                                                                                              customIdentifier:self.parameters.customIdentifier];
        self.transactionProcess = [self.mposUi.transactionProvider startTransactionWithTemplate:template
                                                                                 usingAccessory:self.mposUi.configuration.terminalFamily
                                                                                     registered:registered
                                                                                  statusChanged:statusChanged
                                                                                 actionRequired:actionRequired
                                                                                      completed:completed];

    }
}


- (void)updateTransactionStatus:(MPTransactionProcessDetails *)details withTransaction:(MPTransaction *)transaction {
    self.transactionStatusInfo.text = [details.information componentsJoinedByString:@"\n"];
    self.transactionStatusIcon.text = [self iconForTransactionState:details];
    self.abortButton.hidden = ![self.transactionProcess canBeAborted];
    [self updateProgressView:details];
}

- (NSString *)iconForTransactionState:(MPTransactionProcessDetails*) details {
    switch(details.stateDetails) {
        case MPTransactionProcessDetailsStateDetailsConnectingToAccessoryWaitingForReader:
            return @"\uf002"; //fa-search
        case MPTransactionProcessDetailsStateDetailsConnectingToAccessory:
        case MPTransactionProcessDetailsStateDetailsConnectingToAccessoryCheckingForUpdate:
        case MPTransactionProcessDetailsStateDetailsConnectingToAccessoryUpdating:
            return @"\uf023"; //fa-lock
        case MPTransactionProcessDetailsStateDetailsProcessingWaitingForPIN:
            return @"\uf00a"; //fa-th
        case MPTransactionProcessDetailsStateDetailsCreated:
        case MPTransactionProcessDetailsStateDetailsWaitingForCardRemoval:
        case MPTransactionProcessDetailsStateDetailsInitializingTransactionQuerying:
        case MPTransactionProcessDetailsStateDetailsFailed:
        case MPTransactionProcessDetailsStateDetailsDeclined:
        case MPTransactionProcessDetailsStateDetailsApproved:
        case MPTransactionProcessDetailsStateDetailsAborted:
        case MPTransactionProcessDetailsStateDetailsInitializingTransactionRegistering:
        case MPTransactionProcessDetailsStateDetailsNotRefundable:
        case MPTransactionProcessDetailsStateDetailsProcessing:
        case MPTransactionProcessDetailsStateDetailsProcessingActionRequired:
        case MPTransactionProcessDetailsStateDetailsProcessingCompleted:
        case MPTransactionProcessDetailsStateDetailsWaitingForCardPresentation:
            break; // We do nothing here.
    };

    switch (details.state) {
        case MPTransactionProcessDetailsStateCreated:
        case MPTransactionProcessDetailsStateConnectingToAccessory:
        case MPTransactionProcessDetailsStateInitializingTransaction:
            return @"\uf023"; //fa-lock
        case MPTransactionProcessDetailsStateProcessing:
            return @"\u202F\uf19c"; //fa-bank - mind the gap
        case MPTransactionProcessDetailsStateWaitingForCardPresentation:
        case MPTransactionProcessDetailsStateWaitingForCardRemoval:
            return @"\uf09d"; //fa-creditcard
        case MPTransactionProcessDetailsStateApproved:
        case MPTransactionProcessDetailsStateAborted:
        case MPTransactionProcessDetailsStateDeclined:
            return @"\u202F\uf19c"; //fa-bank - mind the gap
        case MPTransactionProcessDetailsStateFailed:
            return @"\uf057"; //fa-circle
        case MPTransactionProcessDetailsStateNotRefundable:
            break; //We do nothing!
    }
    return @"";
}

- (void)updateProgressView:(MPTransactionProcessDetails *)details {
    BOOL visible = YES;
    switch(details.stateDetails) {
        case MPTransactionProcessDetailsStateDetailsProcessingWaitingForPIN:
        case MPTransactionProcessDetailsStateDetailsWaitingForCardPresentation:
        case MPTransactionProcessDetailsStateDetailsWaitingForCardRemoval:
        case MPTransactionProcessDetailsStateDetailsAborted:
        case MPTransactionProcessDetailsStateDetailsApproved:
        case MPTransactionProcessDetailsStateDetailsDeclined:
        case MPTransactionProcessDetailsStateDetailsFailed:
            visible = NO;
            break;
            
        default:
            visible = YES;
            break;
    }

    if (visible) {
        self.progressView.hidden = NO;
        self.progressView.animating = YES;
    } else {
        self.progressView.hidden = YES;
        self.progressView.animating = NO;
    }
}

- (void)displayCustomerSignature:(MPPaymentDetailsScheme)scheme {
    if (self.mposUi.configuration.signatureCapture == MPUMposUiConfigurationSignatureCaptureOnScreen) {
        NSString *formattedAmount = [self.mposUi.transactionProvider.localizationToolbox textFormattedForAmount:self.transaction.amount currency:self.transaction.currency];
        [self.delegate transactionSignatureRequired:scheme amount:formattedAmount];
    } else {
        [self.transactionProcess continueWithCustomerSignatureOnReceipt];
    }

}

- (void)displayApplicationSelection:(NSArray *)applications {
    [self.delegate transactionApplicationSelectionRequired:applications];
}

#pragma mark - IBActions

- (IBAction)didTapAbortButton:(id)sender {
    [self requestAbort];
}

- (void)requestAbort {
    bool result = [self.transactionProcess requestAbort];
    DDLogDebug(@"Requesting abort %d", result);
}

#pragma mark - UI-Lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:)    name:UIDeviceOrientationDidChangeNotification  object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)orientationChanged:(NSNotification *)notification{
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        self.progressViewMarginTopConstraint.constant = 60;
    } else if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation) && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        self.progressViewMarginTopConstraint.constant = 100;
    }
}

@end

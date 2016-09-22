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

#import "MPUPrintReceiptController.h"
#import "MPUProgressView.h"
#import "MPUUIHelper.h"
#import "MPUMposUi_Internal.h"
#import "MPUMposUiConfiguration.h"
#import "MPUMposUiAppearance.h"
#import "MPUErrorController.h"

@interface MPUPrintReceiptController ()

@property (nonatomic, weak) IBOutlet UILabel *printingStatusInfo;
@property (nonatomic, weak) IBOutlet UILabel *printingStatusIcon;
@property (nonatomic, weak) IBOutlet MPUProgressView *progressView;
@property (nonatomic, weak) IBOutlet UIButton *abortButton;
@property (weak, nonatomic) IBOutlet UIView *cancelViewContainer;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *progressViewMarginTopConstraint;

@property (nonatomic, strong) MPPrintingProcess *printingProcess;

@end

@implementation MPUPrintReceiptController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.progressView.animating = YES;
    [self.printingStatusIcon setText:@"\uf02f"]; //fa-print
    [self.printingStatusInfo setText:@""];
    
    MPUMposUiConfiguration *configuration = [MPUMposUi sharedInitializedInstance].configuration;
    self.printingStatusIcon.textColor = configuration.appearance.navigationBarTint;
    
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        self.progressViewMarginTopConstraint.constant = 60;
    }
    [self l10n];
    [self startPrinting];
}

#pragma mark - Private methods

- (void) l10n {
    
    NSAttributedString *retryAttString = [[NSAttributedString alloc] initWithString:[MPUUIHelper localizedString:@"MPUAbort"] attributes:[MPUUIHelper actionButtonTitleAttributesBold:YES]];
    [self.abortButton setAttributedTitle:retryAttString forState:UIControlStateNormal];
    self.abortButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
}

- (void)startPrinting {
    DDLogDebug(@"TransactionID:%@",self.transactionIdentifer);
    
    MPAccessoryParameters *printerParameters = self.mposUi.configuration.printerParameters;
    self.printingProcess = [self.mposUi.transactionProvider printCustomerReceiptForTransactionIdentifier:self.transactionIdentifer accessoryParameters:printerParameters statusChanged:^(MPPrintingProcess *printingProcess, MPTransaction *transaction, MPPrintingProcessDetails *details) {
        
            [self updatePrintStatus:details];
        
    } completed:^(MPPrintingProcess *printingProcess, MPTransaction *transaction, MPPrintingProcessDetails *details) {
            
        if (details.error) {
            self.mposUi.error = details.error;
            [self.delegate printReceiptFailed:details.error];
        } else if (details.state == MPPrintingProcessDetailsStateAborted){
            [self.delegate printReceiptAborted];
        } else {
            [self.delegate printReceiptSuccess];
        }
    }];
}

- (void)updatePrintStatus:(MPPrintingProcessDetails *) details {
    self.printingStatusInfo.text = [details.information componentsJoinedByString:@"\n"];
    self.cancelViewContainer.hidden = ![self.printingProcess canBeAborted];
    [self updateProgressView:details];
}

- (void)updateProgressView:(MPPrintingProcessDetails *) details {
    BOOL visible = YES;
    switch (details.stateDetails) {
        case MPPrintingProcessDetailsStateDetailsCreated:
        case MPPrintingProcessDetailsStateDetailsFetchingTransaction:
        case MPPrintingProcessDetailsStateDetailsConnectingToAccessory:
        case MPPrintingProcessDetailsStateDetailsConnectingToAccessoryWaitingForPrinter:
        case MPPrintingProcessDetailsStateDetailsSendingToPrinterCheckingState:
        case MPPrintingProcessDetailsStateDetailsSendingToPrinter:
            visible = YES;
            break;
        case MPPrintingProcessDetailsStateDetailsSentToPrinter:
        case MPPrintingProcessDetailsStateDetailsAborted:
        case MPPrintingProcessDetailsStateDetailsFailedPaperEmpty:
        case MPPrintingProcessDetailsStateDetailsFailedCoverOpen:
        case MPPrintingProcessDetailsStateDetailsFailed:
            visible = NO;
            break;
    }
    
    if (visible) {
        self.progressView.hidden = NO;
        self.progressView.animating = YES;;
    } else {
        self.progressView.hidden = YES;
        self.progressView.animating = NO;;
    }
}

#pragma mark - IBActions

- (IBAction)didTapAbortButton:(id)sender {
    bool result = [self.printingProcess requestAbort];
    DDLogDebug(@"Requesting print abort %d", result);
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

- (void)orientationChanged:(NSNotification *)notification {
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        self.progressViewMarginTopConstraint.constant = 60;
    } else if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation) && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        self.progressViewMarginTopConstraint.constant = 100;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

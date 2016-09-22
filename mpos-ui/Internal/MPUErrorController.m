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

#import <Foundation/Foundation.h>
#import <mpos.core/mpos-extended.h>
#import "MPUErrorController.h"
#import "MPUMposUi_Internal.h"
#import "MPUMposUiConfiguration.h"
#import "MPUMposUiAppearance.h"
#import "MPUUIHelper.h"

@interface MPUErrorController ()

@property (nonatomic, weak) IBOutlet UILabel* transactionStatusInfo;
@property (nonatomic, weak) IBOutlet UILabel* transactionStatusIcon;
@property (nonatomic, weak) IBOutlet UIButton* retryButton;
@property (nonatomic, weak) IBOutlet UIButton* cancelButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint* transactionStatusIconTopMargin;
@property (nonatomic, assign) BOOL authFailed;

@property (assign, nonatomic) NSTimer *autoCloseTimer;

@end

@implementation MPUErrorController

#pragma mark - UI-Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.transactionStatusIcon.textColor = self.mposUi.configuration.appearance.navigationBarTint;

    if (self.details != nil && self.details.information != nil && self.details.information.count == 2) {
        NSString *text = [NSString stringWithFormat:@"%@\n%@", self.details.information[0], self.details.information[1]];
        self.transactionStatusInfo.text = text;
    }
    else {
        self.transactionStatusInfo.text = self.error.localizedDescription;
    }

    if (self.retryEnabled == NO) {
        self.retryButton.hidden = YES;
    }
    
    self.authFailed = NO;
    if (self.error.type == MPErrorTypeServerAuthenticationFailed) {
        self.retryButton.hidden = YES;
        self.authFailed = YES;
        if (self.mposUi.mposUiMode == MPUMposUiModeApplication) {
            [self.mposUi clearMerchantCredentialsIncludingUsername:NO];
        }
    } else if(self.error.type == MPErrorTypeAccessoryBusy) {
        self.retryButton.hidden = NO;
    }
    [self l10n];
    
    if (self.mposUi.configuration.resultDisplayBehavior == MPUMposUiConfigurationResultDisplayBehaviorCloseAfterTimeout) {
        
        self.autoCloseTimer = [NSTimer scheduledTimerWithTimeInterval:MPUMposUiConfigurationResultDisplayCloseTimeout target:self selector:@selector(autoCloseTimerFired:) userInfo:nil repeats:NO];
    }

}

- (void)l10n {
    
    NSAttributedString *retryAttString = [[NSAttributedString alloc] initWithString:[MPUUIHelper localizedString:@"MPURetry"] attributes:[MPUUIHelper actionButtonTitleAttributesBold:NO]];
    [self.retryButton setAttributedTitle:retryAttString forState:UIControlStateNormal];
    self.retryButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    
    NSAttributedString *cancelAttString = [[NSAttributedString alloc] initWithString:[MPUUIHelper localizedString:@"MPUClose"] attributes:[MPUUIHelper actionButtonTitleAttributesBold:YES]];
    [self.cancelButton setAttributedTitle:cancelAttString forState:UIControlStateNormal];
    self.cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [self disableAutoCloseTimer];
}



#pragma mark - Autoclose timer

- (void)autoCloseTimerFired:(NSTimer*)timer {
    
    self.autoCloseTimer = nil;
    [self.delegate errorCancelClicked:self.authFailed];
}


- (void)disableAutoCloseTimer {
    
    [self.autoCloseTimer invalidate];
    self.autoCloseTimer = nil;
}


#pragma  mark - Private

- (void)orientationChanged:(NSNotification *)notification {
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        self.transactionStatusIconTopMargin.constant = 60;
    } else if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation) && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        self.transactionStatusIconTopMargin.constant = 100;
    }
}


#pragma mark - IBActions


- (IBAction)didTapCancelButton:(id)sender {
    
    [self disableAutoCloseTimer];
    [self.delegate errorCancelClicked:self.authFailed];
}

- (IBAction)didTapRetryButton:(id)sender {
    
    [self disableAutoCloseTimer];
    [self.delegate errorRetryClicked];
}

@end

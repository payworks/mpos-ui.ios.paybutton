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

#import <Foundation/Foundation.h>
#import <mpos.core/mpos-extended.h>
#import "MPUErrorController.h"
#import "MPUMposUi_Internal.h"
#import "MPUMposUiConfiguration.h"
#import "MPUMposUiAppearance.h"
#import "MPUTransactionParameters.h"
#import "MPUUIHelper.h"

@interface MPUErrorController ()

@property (nonatomic, weak) IBOutlet UILabel* transactionStatusInfo;
@property (nonatomic, weak) IBOutlet UILabel* transactionStatusIcon;
@property (nonatomic, weak) IBOutlet UIButton* retryButton;
@property (nonatomic, weak) IBOutlet UIButton* cancelButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint* transactionStatusIconTopMargin;

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
    
    if (self.error.type == MPErrorTypeServerAuthenticationFailed) {
        self.retryButton.hidden = YES;
    }
    
    [self.retryButton setTitle:[MPUUIHelper localizedString:@"MPURetry"] forState:UIControlStateNormal];
    [self.cancelButton setTitle:[MPUUIHelper localizedString:@"MPUClose"] forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
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
    [self.delegate errorCancelClicked];
}

- (IBAction)didTapRetryButton:(id)sender {
    [self.delegate errorRetryClicked];
}

@end

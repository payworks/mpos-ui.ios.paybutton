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

#import "MPULoadTransactionController.h"
#import "MPULoadTransactionController.h"
#import "MPUMposUiAppearance.h"
#import "MPUMposUiConfiguration.h"
#import "MPUErrorController.h"
#import "MPUMposUi_Internal.h"
#import "MPUProgressView.h"
#import "MPUUIHelper.h"

@interface MPULoadTransactionController ()

@property (nonatomic, weak) IBOutlet UILabel* transactionStatusIcon;
@property (nonatomic, weak) IBOutlet UILabel* transactionStatusInfo;
@property (nonatomic, weak) IBOutlet MPUProgressView* progressView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint* progressViewMarginTopConstraint;

@end

@implementation MPULoadTransactionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.progressView.animating = YES;
    [self.transactionStatusIcon setText:@"\uf1da"];
    self.transactionStatusIcon.textColor = self.mposUi.configuration.appearance.navigationBarTint;
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        self.progressViewMarginTopConstraint.constant = 60;
    }
    
    [self l10n];
    [self fetchTransactionForId];
}

#pragma mark - Private

- (void)l10n {
    self.transactionStatusInfo.text = [MPUUIHelper localizedString:@"MPUFetching"];
}

- (void)fetchTransactionForId {
    [self.mposUi.transactionProvider.transactionModule lookupTransactionWithTransactionIdentifier:self.transactionIdentifer completed:^(MPTransaction *transaction, NSError *error) {
        if (error != nil) {
            self.mposUi.error = error;
            [self.delegate loadTransactionFailed:error];
        } else {
            self.mposUi.transaction = transaction;
            [self.delegate loadTransactionSuccess:transaction];
        }
    }];
}

#pragma mark - UI-Lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)orientationChanged:(NSNotification *)notification{
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

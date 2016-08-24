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

#import "MPUSummaryMainController.h"
#import "MPUSummaryContainerViewController.h"
#import "MPUMposUiConfiguration.h"
#import "MPUMposUiAppearance.h"

NSString* const MPUSegueIdentifierSummaryContainer = @"embedSummaryContainer";

@interface MPUSummaryMainController ()

@property (nonatomic, strong) MPUSummaryContainerViewController *summaryContainer;

@end

@implementation MPUSummaryMainController

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:MPUSegueIdentifierSummaryContainer]) {
        self.summaryContainer = segue.destinationViewController;
        self.summaryContainer.transactionIdentifer = self.transactionIdentifer;
        self.summaryContainer.completed = self.completed;
        self.summaryContainer.delegate = self;
    }
}

#pragma mark - Navigation buttons handling

- (void)backButtonPressed {
    [self.summaryContainer backButtonPressed];
}

- (void)closeButtonPressed {
    [self.summaryContainer closeButtonPressed];
}

@end

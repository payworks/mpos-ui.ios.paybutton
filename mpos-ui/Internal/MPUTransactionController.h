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

#import <UIKit/UIKit.h>
#import "MPUAbstractController.h"

@protocol MPUTransactionDelegate

@required
- (void)transactionApplicationSelectionRequired:(NSArray *)applicaitons;
- (void)transactionSignatureRequired:(MPPaymentDetailsScheme)scheme amount:(NSString *)amount;
- (void)transactionError:(NSError *)error;
- (void)transactionRefunded:(MPTransaction *)transaction;
- (void)transactionSummary:(MPTransaction *)transaction;
- (void)transactionStatusChanged:(MPTransaction *)transaction;

@end

@interface MPUTransactionController : MPUAbstractController

@property (nonatomic, strong) MPTransactionParameters *parameters;
@property (nonatomic, strong) MPTransactionProcessParameters *processParameters;
@property (nonatomic, copy) NSString *sessionIdentifier;
@property (nonatomic, weak) id<MPUTransactionDelegate> delegate;

- (void)continueWithSelectedApplication:(id)application;
- (void)continueWithCustomerSignature:(UIImage *)signature verified:(BOOL)verified;
- (void)requestAbort;

@end

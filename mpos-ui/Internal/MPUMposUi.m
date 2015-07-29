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

#import "MPUMposUi_Internal.h"
#import "MPUUIHelper.h"
#import "MPUTransactionParameters.h"
#import "MPUMposUiConfiguration.h"
#import "MPUSummaryMainController.h"
#import "MPUTransactionMainController.h"
#import "MPUPrintReceiptmainController.h"

NSString *const MPMposUiSDKVersion = @"2.4.1";

static MPUMposUi *theInstance;

@implementation MPUMposUi


+ (NSString *)version
{
    return MPMposUiSDKVersion;
}

+ (id)initializeWithProviderMode:(MPProviderMode)providerMode merchantIdentifier:(NSString *)merchantIdentifier merchantSecret:(NSString *)merchantSecret {
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        [MPUUIHelper loadMyCustomFont];
    });

    theInstance = [[MPUMposUi alloc] initWith:providerMode identifier:merchantIdentifier secret:merchantSecret];
    return theInstance;
}

+ (MPUMposUi *)sharedInitializedInstance {
    return theInstance;
}

- (id)initWith:(MPProviderMode)providerMode identifier:(NSString *)merchantIdentifier secret:(NSString *)merchantSecret {
    
    self = [super init];
    if (self == nil)
    {
        return nil;
    }
    
    self.providerMode = providerMode;
    self.merchantIdentifier = merchantIdentifier;
    self.merchantSecret = merchantSecret;
    self.configuration = [[MPUMposUiConfiguration alloc] init];
    self.transactionProvider = [MPMpos transactionProviderForMode:self.providerMode merchantIdentifier:self.merchantIdentifier merchantSecretKey:self.merchantSecret];

    return self;
}

- (UIViewController *)createTransactionViewControllerWithSessionIdentifier:(NSString *)sessionIdentifier completed:(MPUTransactionCompleted)completed {
    
    MPUTransactionParameters *parameters = [[MPUTransactionParameters alloc] initWithSessionIdentifier:sessionIdentifier];
    return [self createTransactionViewControllerWithParameters:parameters completed:completed];
}

- (UIViewController *)createChargeTransactionViewControllerWithAmount:(NSDecimalNumber *)amount currency:(MPCurrency)currency subject:(NSString *)subject customIdentifier:(NSString *)customIdentifier completed:(MPUTransactionCompleted)completed {
    
    MPUTransactionParameters *parameters = [[MPUTransactionParameters alloc] initWithAmount:amount currency:currency subject:subject customIdentifier:customIdentifier];
    return [self createTransactionViewControllerWithParameters:parameters completed:completed];
}

- (UIViewController *)createRefundTransactionViewControllerWithTransactionIdentifer:(NSString *)transactionIndentifier subject:(NSString *)subject customIdentifier:(NSString *)customIdentifier completed:(MPUTransactionCompleted)completed {
    MPUTransactionParameters *parameters = [[MPUTransactionParameters alloc]initWithTransactionIdentifier:transactionIndentifier subject:subject customIdentifier:customIdentifier];
    return [self createTransactionViewControllerWithParameters:parameters completed:completed];
}


- (UIViewController *)createSummaryViewControllerWithTransactionIdentifier:(NSString *)transacitonIdentifier completed:(MPUSummaryCompleted)completed {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"mpos-ui" bundle:[MPUUIHelper frameworkBundle]];
    MPUSummaryMainController* viewController = [storyboard instantiateViewControllerWithIdentifier:@"MPUSummaryMainController"];
    viewController.transactionIdentifer = transacitonIdentifier;
    viewController.completed = completed;
    return viewController;
}

- (UIViewController *)createTransactionViewControllerWithParameters:(MPUTransactionParameters *)parameters completed:(MPUTransactionCompleted)completed {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"mpos-ui" bundle:[MPUUIHelper frameworkBundle]];
    MPUTransactionMainController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"MPUTransactionMainController"];
    viewController.parameters = parameters;
    viewController.completed = completed;
    return viewController;
}


- (UIViewController *)createPrintTransactionViewControllerWithTransactionIdentifier:(NSString *)transactionIdentifier completed:(MPUPrintReceiptCompleted)completed {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"mpos-ui" bundle:[MPUUIHelper frameworkBundle]];
    MPUPrintReceiptMainController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"MPUPrintReceiptMainController"];
    viewController.transactionIdentifer = transactionIdentifier;
    viewController.completed = completed;
    return viewController;
}

@end

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
#import <UIKit/UIKit.h>
#import <mpos.core/mpos-extended.h>

@class MPTransaction;
@class MPUMposUiConfiguration;
@class MPUTransactionParameters;

/**
 * Enum describing the result of the transaction.
 */
typedef NS_ENUM(NSUInteger, MPUTransactionResult) {
    /**
     * The transaction was approved.
     */
    MPUTransactionResultApproved = 0,
    
    /**
     * The transaction failed. This might be due an error or the transaction was declined / aborted.
     */
    MPUTransactionResultFailed
};

typedef void (^MPUTransactionCompleted)(UIViewController *controller, MPUTransactionResult result, MPTransaction *transaction);

/**
 * Enum describing the result of the receipt printing process.
 */
typedef NS_ENUM(NSUInteger, MPUPrintReceiptResult) {
    /**
     * The receipt printing was successful.
     */
    MPUPrintReceiptResultSuccessful = 0,
    
    /**
     * The receipt printing failed. This might be due an error.
     */
    MPUPrintReceiptResultFailed
};

typedef void (^MPUPrintReceiptCompleted)(UIViewController *controller, MPUPrintReceiptResult result);

typedef void (^MPUSummaryCompleted)(UIViewController *controller);

/**
 * Shared factory that creates different ViewController that guide you through a transaction.
 */
@interface MPUMposUi : NSObject

/**
 * The last transaction that has been processed.
 */
@property (nonatomic, strong) MPTransaction *transaction;

/**
 * The details about the last transaction that has been processed.
 */
@property (nonatomic, strong) MPTransactionProcessDetails *transactionProcessDetails;

/**
 * The last error encountered in the process.
 */
@property (nonatomic, strong) NSError *error;


/**
 * The configuration for creating new controllers.
 */
@property (nonatomic, strong) MPUMposUiConfiguration *configuration;


/**
 * Returns the version of the SDK.
 * @return The version of the SDK
 * @since 2.0.0
 */
+ (NSString *)version;

/**
 * Initializes the MposUi. The method *MUST* be called before any transaction can be started.
 * @param providerMode The mode to use
 * @param merchantIdentifier The merchant identifier to use
 * @param merchantSecret The merchant secret to use
 */
+ (id)initializeWithProviderMode:(MPProviderMode)providerMode merchantIdentifier:(NSString *)merchantIdentifier merchantSecret:(NSString *)merchantSecret;


/**
 * Creates an UIViewController that starts the transactions and updates its views accordingly.
 * @param sessionIdentifier The session reference for the transaction to process.
 * @param completed Completed callback notifying about the completion of a transaction. The ViewController can be dismissed afterwards.
 * @return The ViewController ready to be pushed for display
 */
- (UIViewController *)createTransactionViewControllerWithSessionIdentifier:(NSString *)sessionIdentifier completed:(MPUTransactionCompleted)completed;


/**
 * Creates an UIViewController that starts the transactions and updates its views accordingly.
 * @param amount The amount for the transaction.
 * @param currency The currency for the transaction.
 * @param subject The subject for the transaction.
 * @param customIdentifier The custom identifier for the transaction.
 * @param completed Completed callback notifying about the completion of a transaction. The ViewController can be dismissed afterwards.
 * @return The ViewController ready to be pushed for display
 */
- (UIViewController *)createChargeTransactionViewControllerWithAmount:(NSDecimalNumber *)amount currency:(MPCurrency)currency subject:(NSString *)subject customIdentifier:(NSString *)customIdentifier completed:(MPUTransactionCompleted)completed;


/**
 * Creates an UIViewController that starts the refund for a transaction with transactionIdentifier and updates its views accordingly.
 * @param transactionIdentiier The transaction identifer of the transaction to refund.
 * @param subject The subject for the transaction.
 * @param customIdentifier The custom identifier for the transaction.
 * @param completed Completed callback notifying about the completion of a transaction. The ViewController can be dismissed afterwards. 
 * @return The ViewController ready to be pushed for display
 */
- (UIViewController *)createRefundTransactionViewControllerWithTransactionIdentifer:(NSString *)transactionIndentifier subject:(NSString *)subject customIdentifier:(NSString *)customIdentifier completed:(MPUTransactionCompleted)completed;

/**
 * Creates an UIViewController that starts the summary view for the transaction.
 * @param transactionIdentiier The transaction identifer of the transaction.
 * @param completed Completed callback notifiying the completion of the summary. The ViewController can be dismissed afterwards.
 * @return The ViewControlller ready to be pushed for display
 */
- (UIViewController *)createSummaryViewControllerWithTransactionIdentifier:(NSString *)transacitonIdentifier completed:(MPUSummaryCompleted)completed;

/**
 * Creates an UIViewController that starts the receipt printing view for the transaction.
 * @param transactionIdentiier The transaction identifer of the transaction.
 * @param completed The completed callback notifying the completion of printing. The ViewController can be dismissed afterwards.
 * @return The ViewControlller ready to be pushed for display
 */
- (UIViewController *)createPrintTransactionViewControllerWithTransactionIdentifier:(NSString *)transactionIdentifier completed:(MPUPrintReceiptCompleted)completed;

/**
 * Returns an instance of the initialized MposUi.
 * @return The initialized instance or nil of none is initialized.
 */
+ (MPUMposUi *)sharedInitializedInstance;

@end

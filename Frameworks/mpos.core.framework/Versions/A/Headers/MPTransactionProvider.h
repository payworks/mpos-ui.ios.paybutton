//
// PAYWORKS GMBH ("COMPANY") CONFIDENTIAL
// Copyright (c) 2014 payworks GmbH, All Rights Reserved.
//
// NOTICE:  All information contained herein is, and remains the property of COMPANY. The intellectual and technical concepts contained
// herein are proprietary to COMPANY and may be covered by European or foreign Patents, patents in process, and are protected by trade secret or copyright law.
// Dissemination of this information or reproduction of this material is strictly forbidden unless prior written permission is obtained
// from COMPANY.  Access to the source code contained herein is hereby forbidden to anyone except current COMPANY employees, managers or contractors who have executed
// Confidentiality and Non-disclosure agreements explicitly covering such access.
//
// The copyright notice above does not evidence any actual or intended publication or disclosure of this source code, which includes
// information that is confidential and/or proprietary, and is a trade secret, of COMPANY.
// ANY REPRODUCTION, MODIFICATION, DISTRIBUTION, PUBLIC  PERFORMANCE,
// OR PUBLIC DISPLAY OF OR THROUGH USE  OF THIS  SOURCE CODE  WITHOUT  THE EXPRESS WRITTEN CONSENT OF COMPANY IS STRICTLY PROHIBITED, AND IN VIOLATION OF APPLICABLE
// LAWS AND INTERNATIONAL TREATIES.  THE RECEIPT OR POSSESSION OF  THIS SOURCE CODE AND/OR RELATED INFORMATION DOES NOT CONVEY OR IMPLY ANY RIGHTS
// TO REPRODUCE, DISCLOSE OR DISTRIBUTE ITS CONTENTS, OR TO MANUFACTURE, USE, OR SELL ANYTHING THAT IT  MAY DESCRIBE, IN WHOLE OR IN PART.

#import "MPTransactionProcess.h"
#import "MPPrintingProcess.h"
#import "MPTransaction.h"


@class MPReceiptFactory;
@class MPTransactionTemplate;
@class MPLocalizationToolbox;


/**
 * The range of models you can to connect to during a checkout.
 * @since 2.2.0
 */
typedef NS_ENUM(NSUInteger, MPAccessoryFamily){
    /** Use a mock */
    MPAccessoryFamilyMock,
    
    /** Use the Miura MPI devices  */
    MPAccessoryFamilyMiuraMPI,
    
    /** Use the Verifone e-Series (except e105) */
    MPAccessoryFamilyVerifoneESeries,
    /** Use the Verifone e105 */
    MPAccessoryFamilyVerifoneE105,
    
    /** Use the Sewoo printer */
    MPAccessoryFamilySewoo,
    
    /** Use the BBPOS WisePad or WisePOS */
    MPAccessoryFamilyBBPOS,
    /** Use the BBPOS Chipper */
    MPAccessoryFamilyBBPOSChipper
};

/**
 * Callback block for a transaction query with custom identifier.
 * @param transactions Array of MPTransaction objects with the provided customIdentifier
 * @param error The error that might have occured
 * @since 2.3.1
 */
typedef void (^MPTransactionProviderQueryByCustomIdentifierCompleted)(NSArray * _Nonnull transactions, NSError * _Nullable error);

/**
 * Callback block for a transaction query with session identifier.
 * @param transaction The transaction with the provided sessionIdentifier
 * @param error The error that might have occured
 * @since 2.3.0
 */
typedef void (^MPTransactionProviderQueryBySessionIdentifierCompleted)(MPTransaction * _Nonnull transaction, NSError * _Nullable error);

/**
 * Callback block for a transaction query with transaction identifier.
 * @param transaction The transaction with the provided transactionIdentifier
 * @param error The error that might have occured
 * @since 2.3.0
 */
typedef void (^MPTransactionProviderQueryByTransactionIdentifierCompleted)(MPTransaction * _Nonnull transaction, NSError * _Nullable error);

/**
 * Callback block for a sending a receipt for a transaction.
 * @param error The error that might have occured
 * @since 2.3.0
 */
typedef void (^MPTransactionProviderSendingCustomerReceiptCompleted)(NSString * _Nonnull transactionIdentifier, NSString * _Nonnull emailAddress, NSError * _Nullable error);


/**
 * Callback block for a transaction receipt query.
 * @param error The error that might have occured
 * @since 2.4.0
 */
typedef void (^MPTransactionProviderQueryTransactionReceiptCompleted)(NSString * _Nonnull transactionIdentifier, MPReceipt * _Nullable receipt, NSError * _Nullable error);

/**
 * Provider that simplifies the process of making a single transaction by encapsulating the necessary steps inbetween.
 * @since 2.2.0
 */
@interface MPTransactionProvider : NSObject

/**
 * Returns a factory that must be used to generate receipts.
 * @since 2.3.0
 */
@property (strong, readonly, nonatomic, nonnull) MPReceiptFactory *receiptFactory DEPRECATED_ATTRIBUTE;

/**
 * Returns a toolbox for formatting various kinds of strings and values
 * @since 2.3.0
 */
@property (strong, readonly, nonatomic, nonnull) MPLocalizationToolbox *localizationToolbox;

/**
 * Creates a new template for a new transaction.
 * @param amount The amount The amount of the transaction
 * @param currency The currency of the transaction
 * @param subject The subject of the transaction
 * @param customIdentifier The custom identifier of the transaction
 * @return A new transaction templated that can be used to start a transaction locally
 * @since 2.2.0
 */
- (nonnull MPTransactionTemplate *)chargeTransactionTemplateWithAmount:(nonnull NSDecimalNumber *)amount
                                                      currency:(MPCurrency)currency
                                                       subject:(nullable NSString *)subject
                                              customIdentifier:(nullable NSString *)customIdentifier;

/**
 * Creates a new template, linking to a previous transaction.
 * @param referencedTransactionIdentifier The transaction to reference
 * @param subject The subject of the transaction
 * @param customIdentifier The custom identifier of the transaction
 * @return A new transaction templated that can be used to start a transaction locally
 * @since 2.2.0
 */
- (nonnull MPTransactionTemplate *)refundTransactionTemplateWithReferenceToPreviousTransaction:(nonnull NSString *)referencedTransactionIdentifier
                                                                               subject:(nullable NSString *)subject
                                                                      customIdentifier:(nullable NSString *)customIdentifier;
/**
 * Creates a new template, linking to a previous transaction with the given customIdentifier
 * @param customIdentifier the transaction to reference
 * @param subject The subject of the transaction
 * @param refundCustomIdentifier the custom identifier of the transaction
 * @return A new transaction template that can be used to start a transaction locally
 * @since 2.3.1
 */
- (nonnull MPTransactionTemplate *)refundTransactionTemplateWithOriginalCustomIdentifier:(nonnull NSString *)customIdentifier
                                                                         subject:(nullable NSString *)subject
                                                          refundCustomIdentifier:(nullable NSString *)refundCustomIdentifier;

/**
 * Starts and returns a new transaction process which guide you through a complete transaction. This method is used if the session has already been created on the backend.
 * @param sessionIdentifier The sessionIdentifier of the transaction to start
 * @param accessoryFamily The kind of accessory you want to use for the transaction
 * @param statusChanged The status of the process changed and new information can be displayed to the user
 * @param actionRequired An explicit action by the merchant or customer is required
 * @param completed The transactionProcess ended and a new one can be started
 * @since 2.2.0
 */
- (nonnull MPTransactionProcess *)startTransactionWithSessionIdentifier:(nonnull NSString *)sessionIdentifier
                                                 usingAccessory:(MPAccessoryFamily)accessoryFamily
                                                  statusChanged:(nonnull MPTransactionProcessStatusChanged)statusChanged
                                                 actionRequired:(nonnull MPTransactionProcessActionRequired)actionRequired
                                                      completed:(nonnull MPTransactionProcessCompleted)completed;

/**
 * Starts and returns a new transaction process which guide you through a complete transaction. This method registers the transaction locally without requiring a backend for this.
 * @param template The template describing the general transaction parameters
 * @param accessoryFamily The kind of accessory you want to use for the transaction
 * @param registered Callback when the transaction has been registered with the backend. Use this information to save a reference to it.
 * @param statusChanged The status of the process changed and new information can be displayed to the user
 * @param actionRequired An explicit action by the merchant or customer is required
 * @param completed The transactionProcess ended and a new one can be started
 * @since 2.2.0
 */
- (nonnull MPTransactionProcess *)startTransactionWithTemplate:(nonnull MPTransactionTemplate *)template
                                        usingAccessory:(MPAccessoryFamily)accessoryFamily
                                            registered:(nonnull MPTransactionProcessRegistered)registered
                                         statusChanged:(nonnull MPTransactionProcessStatusChanged)statusChanged
                                        actionRequired:(nonnull MPTransactionProcessActionRequired)actionRequired
                                             completed:(nonnull MPTransactionProcessCompleted)completed;

/**
 * Queries a customer transaction receipt by its transaction identifier.
 * @param transactionIdentifier The identifier of the transaction for querying the receipt.
 * @param completed The query is finished
 * @since 2.4.0
 */
- (void)queryCustomerTransactionReceiptByTransactionIdentifier:(nonnull NSString *)transactionIdentifier
                                                     completed:(nonnull MPTransactionProviderQueryTransactionReceiptCompleted)completed;

/**
 * Queries a merchant transaction receipt by its transaction identifier.
 * @param transactionIdentifier The identifier of the transaction for querying the receipt.
 * @param completed The query is finished
 * @since 2.4.0
 */
- (void)queryMerchantTransactionReceiptByTransactionIdentifier:(nonnull NSString *)transactionIdentifier
                                                     completed:(nonnull MPTransactionProviderQueryTransactionReceiptCompleted)completed;

/**
 * Queries a transaction by its session identifier.
 * @param sessionIdentifier The session identifier of the transaction
 * @param completed The async completion callback
 * @since 2.2.0
 */
- (void)queryTransactionBySessionIdentifier:(nonnull NSString *)sessionIdentifier
                                  completed:(nonnull MPTransactionProviderQueryBySessionIdentifierCompleted)completed;

/**
 * Queries transactions by custom identifier. Returns only the first page.
 * @param customIdentifier the custom identifier of the transactions
 * @param completed the async completion callback
 * @since 2.3.1
 */
- (void)queryTransactionsByCustomIdentifier:(nonnull NSString*)customIdentifier
                                 completed: (nonnull MPTransactionProviderQueryByCustomIdentifierCompleted) completed;



/**
 * Queries a transaction by its identifier.
 * @param transactionIdentifier The identifier of the transaction
 * @param completed The async completion callback
 * @since 2.3.0
 */
- (void)queryTransactionByTransactionIdentifier:(nonnull NSString *)transactionIdentifier
                                      completed:(nonnull MPTransactionProviderQueryByTransactionIdentifierCompleted)completed;


/**
 * Sends a receipt for the given transaction.
 * @param transactionIdentifier The transaction identifier to generate the receipt for
 * @param emailAddress Email receiver of the receipt
 * @param completed The async completion block
 * @since 2.3.0
 */
- (void)sendCustomerReceiptForTransactionIdentifier:(nonnull NSString *)transactionIdentifier
                                       emailAddress:(nonnull NSString *)emailAddress
                                          completed:(nonnull MPTransactionProviderSendingCustomerReceiptCompleted)completed;


/**
 * Prints a customer receipt for the given transaction identifier.
 * A convenience method which first fetches the transaction.
 *
 * @param transactionIdentifier Transaction identifier of the transaction.
 * @param accessoryFamily The kind of accessory you want to use for the printing.
 * @param statusChanged The status of the process changed and new information can be displayed to the user
 * @param completed The printingProcess ended and a new one can be started
 * @since 2.4.0
 */
- (nonnull MPPrintingProcess *)printCustomerReceiptForTransactionIdentifier:(nonnull NSString *)transactionIdentifier
                                                     usingAccessory:(MPAccessoryFamily)accessoryFamily
                                                      statusChanged:(nonnull MPPrintingProcessStatusChanged)statusChanged
                                                          completed:(nonnull MPPrintingProcessCompleted)completed;



@end


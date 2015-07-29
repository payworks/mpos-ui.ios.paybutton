//
// PAYWORKS GMBH ("COMPANY") CONFIDENTIAL
// Copyright (c) 2013 payworks GmbH, All Rights Reserved.
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

#import "MPTransaction.h"
#import "MPAccessory.h"
#import "MPReceipt.h"

@protocol MPProviderComponentDelegate;
@protocol MPAccessoryComponentDelegate;

@class MPAccessoryUpdateRequirement;
@class MPTransactionActionSupport;
@class MPPaymentDetailsFactory;
@class MPAccessoryOptionsFactory;
@class MPAccessoryOptions;
@class MPTransactionActionResponse;
@class MPTransactionActionResponseFactory;
@class MPReceiptFactory;
@class MPTransactionTemplate;

/**
 * Success handler for connecting to an accessory (e.g. PED or a printer).
 * @param accessory The connected accessory
 * @since 2.0.0
 */
typedef void (^MPAccessoryConnectSuccess)(MPAccessory *accessory);
/**
 * Failure handler for connecting to an accessory (e.g. PED or a printer).
 * @param error Error describing what happened
 * @since 2.0.0
 */
typedef void (^MPAccessoryConnectFailure)(NSError *error);


/**
 * Success handler for checking if an accessory must be updated before it can be used.
 * @param accessory The accessory that was checked
 * @param updateRequirement Indicating the update requirement
 * @since 2.0.0
 */
typedef void (^MPAccessoryCheckUpdateSuccess)(MPAccessory *accessory, MPAccessoryUpdateRequirement *updateRequirement);
/**
 * Failure handler for checking if an accessory must be updated before it can be used.
 * @param accessory The accessory that failed to update
 * @param error Error describing why the update failed
 * @since 2.0.0
 */
typedef void (^MPAccessoryCheckUpdateFailure)(MPAccessory *accessory, NSError *error);


/**
 * Success handler for updating an accessory.
 * @param accessory The accessory that was updated
 * @since 2.0.0
 */
typedef void (^MPAccessoryUpdateSuccess)(MPAccessory *accessory);
/**
 * Failure handler for updating an accessory.
 * @param accessory The accessory that failed to update
 * @param error Error describing why the update failed
 * @since 2.0.0
 */
typedef void (^MPAccessoryUpdateFailure)(MPAccessory *accessory, NSError *error);


/**
 * Success handler for updating accessory state
 * @param accessory The accessory with updated state
 */
typedef void (^MPAccessoryUpdateStateSuccess)(MPAccessory *accesory);

/**
 * Failure handler for updating accessory state
 * @param accessory The accessory whose state failed to be updated
 * @param error Error describing why the update failed
 */
typedef void (^MPAccessoryUpdateStateFailure)(MPAccessory *accesory, NSError *error);

/**
 * Success handler for disconnection from an accessory.
 * @param accessory The accessory that was disconnected - the reference is no longer valid for interactions
 * @since 2.0.0
 */
typedef void (^MPAccessoryDisconnectSuccess)(MPAccessory *accessory);
/**
 * Failure handler for disconnection from an accessory.
 * @param accessory The accessory that should have been disconnected
 * @param error Error describing why the disconnect failed
 * @since 2.0.0
 */
typedef void (^MPAccessoryDisconnectFailure)(MPAccessory *accessory, NSError *error);


/**
 * Success handler for a transaction lookup with our gateway.
 * @param transaction The requested transaction
 * @since 2.0.0
 */
typedef void (^MPTransactionLookupSuccess)(MPTransaction *transaction);
/**
 * Failure handler for a transaction lookup with our gateway.
 * @param identifier The identifier used to lookup the transaction
 * @param error Error describing why the lookup failed
 * @since 2.0.0
 */
typedef void (^MPTransactionLookupFailure)(NSString *identifier, NSError *error);

/**
 * Success handler for a transactions lookup with our gateway.
 * @param transactions the requested transactions
 * @since 2.3.1
 */
typedef void (^MPTransactionsLookupSuccess)(NSArray *transactions);

/**
 * Failure handler for a transactions lookup with our gateway.
 * @param customIdentifier The customIdentifier used to lookup the transaction
 * @param error Error describing why the lookup failed
 * @since 2.3.1
 */
typedef void (^MPTransactionsLookupFailure)(NSString *customIdentifier, NSError *error);

/**
 * Approval handler for executing a tranaction. At this stage the transaction is approved (completed successfully, executed and approved by the host).
 * @param transaction The approved transaction
 * @since 2.0.0
 */
typedef void (^MPTransactionApproval)(MPTransaction *transaction);

/**
 * Decline handler for executing a tranaction. At this stage the transaction is declined (completed successfully, executed but declined by the host or terminal).
 * @param transaction The declined transaction
 * @since 2.0.0
 */
typedef void (^MPTransactionDecline)(MPTransaction *transaction);

/**
 * Abort handler for executing a tranaction. At this stage the transaction is aborted.
 * @param transaction The declined transaction
 * @since 2.0.0
 */
typedef void (^MPTransactionAbort)(MPTransaction *transaction);

/**
 * Failure handler for the execution of a transaction. There are different reasons why a transaction may fail: network errors, missing parameters, invalid payment details). Some of those errors are recoverable (e.g. by just starting the transaction again). The error will provide information about the recoverability. The error is also attached to the transaction as an error property, giving access to it at a later stage.
 * @param transaction The failed transaction
 * @param error Indicates what happened and how to proceed
 * @since 2.0.0
 */
typedef void (^MPTransactionFailure)(MPTransaction *transaction, NSError *error);
/**
 * Action handler for a transaction, used to request additional details when needed (e.g. some POS transaction needs a customer signature).
 * To only get requests for actions that you support, provide a bitmask of actions when initializing the provider.
 * @param transaction The transaction requesting the additional action/data
 * @param action The requested action/data
 * @param supportData Additional data that may be needed for certain types of actions (will require a downcast)
 * @since 2.0.0
 */
typedef void (^MPTransactionActionRequired)(MPTransaction *transaction, MPTransactionAction action, MPTransactionActionSupport *supportData);


/**
 * Handler indicating a successful abort of a transaction.
 * @param transaction The aborted transaction
 * @since 2.0.0
 */
typedef void (^MPTransactionAbortSuccess)(MPTransaction *transaction);

/**
 * Handler indicating an error during an attempted abort of a transaction. If this is called, the transaction was NOT aborted.
 * @param transaction The transaction that should have been aborted
 * @param error The error that occured while aborting the transaction
 * @since 2.0.0
 */
typedef void (^MPTransactionAbortFailure)(MPTransaction *transaction, NSError *error);

/**
 * Handler indicating an approved refund of a transaction.
 * @param transaction The refunded transaction
 * @since 2.3.0
 */
typedef void (^MPRefundTransactionWithoutCardApproved)(MPTransaction *transaction);

/**
 * Handler indicating a declined refund of a transaction.
 * @param transaction The refunded transaction
 * @since 2.3.0
 */
typedef void (^MPRefundTransactionWithoutCardDeclined)(MPTransaction *transaction);

/**
 * Handler indicating an error during an attempted refund without card. If this is called, the transaction was NOT refunded:
 * @param transactionTemplate The transaction template that should have been refunded
 * @param error The error that occured while refunding the transaction
 * @since 2.3.0
 */
typedef void (^MPRefundTransactionWithoutCardFailure)(MPTransactionTemplate *transactionTemplate, NSError *error);

/**
 * Success handler for sending a receipt via email.
 * @since 2.3.0
 */
typedef void (^MPCustomerReceiptSendingSuccess)(NSString *transactionIdentifier, NSString *emailAddress);

/**
 * Failure handler for sending a receipt via email.
 * @param error Error describing why the mail sending failed
 * @since 2.3.0
 */
typedef void (^MPCustomerReceiptSendingFailure)(NSString *transactionIdentifier, NSString *emailAddress, NSError *);

/**
 * Success handler for querying a transaction receipt.
 * @since 2.4.0
 */
typedef void (^MPTransactionReceiptQuerySuccess)(NSString *transactionIdentifier, MPReceipt *receipt);

/**
 * Failure handler for querying a transaction receipt.
 * @param error Error describing why the query failed
 * @since 2.4.0
 */
typedef void (^MPTransactionReceiptQueryFailure)(NSString *transactionIdentifier, NSError *error);


/**
 * Indicating the mode the provider will run in.
 * @since 2.0.0
 */

typedef NS_ENUM(NSUInteger, MPProviderMode){
    /** Unkndown or not available */    
    MPProviderModeUnknown  = 0,
    /** Live transactions */
    MPProviderModeLIVE,
    /** Test transactions */
    MPProviderModeTEST,
    /**< Mocked transactions */
    MPProviderModeMOCK,
};

/**
 * The payment provider is the main instance responsible for handling, creating and managing transactions and the connection to external accessories.
 * @since 2.0.0
 */
@interface MPProvider : NSObject

/**
 * Supported actions as provided via provider options.
 * @since 2.0.0
 */
@property (assign, readonly, nonatomic) MPTransactionAction supportedActions;

/**
 * The mode the provider is running in.
 * @since 2.0.0
 */
@property (assign, readonly, nonatomic) MPProviderMode providerMode;

#pragma mark -
#pragma mark Factories
/** @name Factories */

/**
 * Returns a factory that must be used to generate the payment params when making a transaction.
 * @since 2.0.0
 */
@property (strong, readonly, nonatomic) MPPaymentDetailsFactory *paymentDetailsFactory;

/**
 * Returns a factory that must be used to generate the accessory options.
 * @since 2.0.0
 */

@property (strong, readonly, nonatomic) MPAccessoryOptionsFactory *accessoryOptionsFactory;

/**
 * Returns a factory that must be used to generate action responses during transactions.
 * @since 2.0.0
 */
@property (strong, readonly, nonatomic) MPTransactionActionResponseFactory *transactionActionResponseFactory;

/**
 * Returns a factory that must be used to generate receipts.
 * @since 2.0.0
 */
@property (strong, readonly, nonatomic) MPReceiptFactory *receiptFactory DEPRECATED_ATTRIBUTE;

/**
 * Returns a set containing all accessories that are currently handled by the provider (either connected/disconnected/not in range).
 * @since 2.0.0
 */
@property (strong, readonly, nonatomic) NSSet *accessories;

#pragma mark -
#pragma mark Callback queue
/**
 * Dispatch queue used for block callbacks. If not set (NULL), dispatch_get_main_queue() will be used.
 * @since 2.0.0
 */
@property (strong, nonatomic) dispatch_queue_t callbackQueue;

#pragma mark -
#pragma mark Handle Accessories
/** @name Handle Accessories */

/**
 * Connects to an accessory with the given options.
 * @param options The options to be used for the connection effort
 * @param success The success handler called when the connection is made
 * @param failure The failure handler called when no connection is possible
 * @throws NSException If the options are invalid
 * @since 2.0.0
 */
- (void)connectToAccessory:(MPAccessoryOptions *)options success:(MPAccessoryConnectSuccess)success failure:(MPAccessoryConnectFailure)failure;

/**
 * Checks if an update for the given accessory is available and must be installed before a transaction can take place.
 * @param accessory The accessory to check
 * @param success The success handler called when the connection is made
 * @param failure The failure handler called when no connection is possible
 * @throws NSException if the accessory is invalid
 * @since 2.0.0
 */
- (void)checkUpdateRequirementForAccessory:(MPAccessory *)accessory success:(MPAccessoryCheckUpdateSuccess)success failure:(MPAccessoryCheckUpdateFailure)failure;


/**
 * Updates the accessory to the configuration/software.
 * @param accessory The accessory to update
 * @param success The success handler called when the accessory was successfully updated or no update was necessary
 * @param failure The failure handler called when the update failed
 * @throws NSException If the accessory is invalid
 * @since 2.0.0
 */
- (void)updateAccessory:(MPAccessory *)accessory success:(MPAccessoryUpdateSuccess)success failure:(MPAccessoryUpdateFailure)failure;


/**
 * Updates the accessory state. The accessory will have its details updated as well as battery state and battery level properties updated 
 * and all MPAccessoryComoponentDelegate added for this accessory will receive an accessory:didChangeBatteryState:level: notification
 * @param accessory The accessory to querry for battery state
 * @param success The success handler called when accessory battery state was updated
 * @param failure The failure handler called when accessory battery state failed to update
 * @since 2.0.1
 */
- (void)updateAccessoryState:(MPAccessory*)accessory success:(MPAccessoryUpdateStateSuccess)success failure:(MPAccessoryUpdateStateFailure)failure;

/**
 * Disconnects a given accessory. This is normally required if more than once accessory using the Bluetooth connection consecutively (e.g. fist a PED and then a printer).
 * Also note that the accessory reference is no longer valid for interactions and transactions, but rather only given back as a reference.
 * @param accessory The accessory to disconnect from
 * @param success The success handler called when the accessory was disconnected
 * @param failure The failure handler called when the disconnect was not possible (e.g. invalid reference, ongoing transaction)
 * @throws NSException If the accessory is invalid
 * @since 2.0.0
 */
- (void)disconnectFromAccessory:(MPAccessory *)accessory success:(MPAccessoryDisconnectSuccess)success failure:(MPAccessoryDisconnectFailure)failure;


#pragma mark -
#pragma mark Manage Transactions
/** @name Manage Transactions */

/**
 * Queries a previous transaction (including state), typically when the transaction failed due to network errors.
 * @param identifier The reference to the transaction session
 * @param success The success handler called when the transaction lookup was successful
 * @param failure The failure handler called when the lookup failed
 * @throws NSException If the identifier is invalid
 * @since 2.0.0
 */
- (void)lookupTransactionWithSessionIdentifier:(NSString *)identifier success:(MPTransactionLookupSuccess)success failure:(MPTransactionLookupFailure)failure;

/**
 * Queries a previous transaction (including state), typically when the transaction failed due to network errors.
 * @param identifier The identifier of the transaction
 * @param success The success handler called when the transaction lookup was successful
 * @param failure The failure handler called when the lookup failed
 * @throws NSException If the identifier is invalid
 * @since 2.3.0
 */
- (void)lookupTransactionWithTransactionIdentifier:(NSString *)identifier success:(MPTransactionLookupSuccess)success failure:(MPTransactionLookupFailure)failure;

/**
 * Queries previous transactions (including state).
 * @param customIdentifier
 * @param success The success handler called when the transaction lookup was successful
 * @param failure The failure handler called when the lookup failed
 * @throws NSException If the identifier is invalid
 * @since 2.3.1
 */
- (void)lookupTransactionsWithCustomIdentifier:(NSString *)customIdentifier success:(MPTransactionsLookupSuccess)success failure:(MPTransactionsLookupFailure)failure;


#pragma mark -
#pragma mark Execute Transactions
/** @name Execute Transactions */

/**
 * Starts registering and executing a given transaction with the help of the given accessory. From there on action callbacks will request additional parameters if necessary.
 * This request typically starts a mPOS transaction.
 * @param transaction The transaction to be excecuted
 * @param accessory The accessory to use for the transaction
 * @param approval The approved handler called when the transaction was approved.
 * @param decline The declined handler called when the transaction was declined during the execution.
 * @param abort The abort handler called when the transaction was aborted during the execution.
 * @param failure The failure handler called when the transaction failed, have a look at the error for more details
 * @param actionRequired The action required handler called when additional details are necessary (e.g. a customer signature)
 * @throws NSException If the transaction is invalid
 * @since 2.2.0
 */
- (void)startTransaction:(MPTransaction *)transaction usingAccessory:(MPAccessory *)accessory approval:(MPTransactionApproval)approval decline:(MPTransactionDecline)decline abort:(MPTransactionAbort)abort failure:(MPTransactionFailure)failure actionRequired:(MPTransactionActionRequired)actionRequired;


/**
 * Continues a transaction for a given action request, providing additional data if needed. Note that callbacks are still handled by the failure block you handed to startTransaction
 * @param transaction The transaction to continue
 * @param action The action you respond to
 * @param response Response data provided for the specific action (e.g. containing a signature)
 * @throws NSException If the transaction is invalid
 * @since 2.0.0
 */
- (void)continueTransaction:(MPTransaction *)transaction withAction:(MPTransactionAction)action response:(MPTransactionActionResponse *)response;

/**
 * Attempts to abort a transactions. This is only possible until a certain point of the transaction.
 * If the abort is successful, then the abort block of the startTransaction method will be executed before the success block from this method
 * @param transaction The transaction to abort
 * @param success The success handler called when the transaction was successfully aborted
 * @param failure The failure handler called when aborting the transaction failed.
 * @throws NSException If the transaction is invalid
 * @since 2.0.0
 */
- (void)abortTransaction:(MPTransaction *)transaction success:(MPTransactionAbortSuccess)success failure:(MPTransactionAbortFailure)failure;

#pragma mark -
#pragma mark Send Receipts

/**
 * Sends out an email receipt for a given transaction.
 * @param transactionIdentifier A reference to the transaction
 * @param emailAddress Email receiver of the receipt
 * @param success The success handler called when the sending was successful
 * @param failure The failure handler called when the sending failed
 * @throws NSException If the transation is invalid
 * @since 2.3.0
 */
- (void)sendCustomerReceiptForTransactionIdentifier:(NSString *)transactionIdentifier emailAddress:(NSString *)emailAddress success:(MPCustomerReceiptSendingSuccess)success failure:(MPCustomerReceiptSendingFailure)failure;

#pragma mark -
#pragma mark Refund Transation without card


/**
 * Refunds a transaction with the given template
 * @param transactionTemplate The transaction template for refunding
 * @param approved The approved handler called when the refund was approved
 * @param declined The declined handler called when the refund was declined
 * @param failure The failure handler called when the refund failed
 * @throws NSException If the transation is invalid
 * @since 2.3.0
 */
- (void)refundTransactionWithoutCardForTemplate:(MPTransactionTemplate *)transactionTemplate approved:(MPRefundTransactionWithoutCardApproved)approved declined:(MPRefundTransactionWithoutCardDeclined)declined failure:(MPRefundTransactionWithoutCardFailure)failure;

/**
 * Queries a receipt for a given transaction.
 * @param transactionIdentifier A reference to the transaction
 * @param receiptType The type of receipt to query
 * @param success The success handler called when the query was successful
 * @param failure The failure handler called when the query failed
 * @throws NSException If the transation is invalid
 * @since 2.4.0
 */
- (void)queryTransactionReceiptByTransactionIdentifier:(NSString *)transactionIdentifier receiptType:(MPReceiptType)receiptType success:(MPTransactionReceiptQuerySuccess)success failure:(MPTransactionReceiptQueryFailure)failure;

#pragma mark -
#pragma mark Register Callbacks
/** @name Register Callbacks */

/**
 * Adds an additional provider delegate.
 * @param delegate The delegate to add
 * @since 2.0.0
 */
- (void)addProviderComponentDelegate:(id<MPProviderComponentDelegate>)delegate;
/**
 * Removes an existing provider delegate.
 * @param delegate The delegate to remove
 * @since 2.0.0
 */
- (void)removeProviderComponentDelegate:(id<MPProviderComponentDelegate>)delegate;

/**
 * Adds an additional accessory delegate.
 * @param delegate The delegate to add
 * @since 2.0.0
 */
- (void)addAccessoryComponentCallback:(id<MPAccessoryComponentDelegate>)delegate;
/**
 * Removes an existing accessory delegate.
 * @param delegate The delegate to remove
 * @since 2.0.0
 */
- (void)removeAccessoryComponentCallback:(id<MPAccessoryComponentDelegate>)delegate;

@end

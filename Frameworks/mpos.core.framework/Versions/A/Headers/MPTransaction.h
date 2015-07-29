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

@class MPLocationDetails;
@class MPPaymentDetails;
@class MPProcessingDetails;
@class MPStatusDetails;
@class MPRefundDetails;

/**
 * Actions requested during a transaction. Bitwise OR to stack, AND to split.
 * @since 2.0.0
 */
typedef NS_OPTIONS(NSUInteger, MPTransactionAction){
    /** No actions supported, NOP action */
    MPTransactionActionNone                                = 0,
    /** A customer signature must be provided to complete the transaction */
    MPTransactionActionCustomerSignature                   = 1 << 0,
    /** The customer must be identified by means of ID check with an official document */
    MPTransactionActionCustomerIdentification              = 1 << 1,
    /** Used to indicate a text that must be displayed in order to continue */
    MPTransactionActionApplicationSelection                = 1 << 2,
};
static MPTransactionAction MPTransactionActionAll = MPTransactionActionCustomerSignature | MPTransactionActionCustomerIdentification | MPTransactionActionApplicationSelection;


/**
 * The type of transaction that will be executed.
 * @since 2.0.0
 */
typedef NS_ENUM(NSUInteger, MPTransactionType){
    /** Unknown or not available */
    MPTransactionTypeUnknown = 0,
    /** Debit transaction, where the funds are directly removed from debited from the account */
    MPTransactionTypeCharge,
    /** Refund transaction, where the funds are directly posted to the account */
    MPTransactionTypeRefund,
    /** Preauthorize transaction, where the funds are reserved on the account. Note: just available for mapping purposes and cannot be initiated by the SDK.  */
    MPTransactionTypePreauthorize,
    /** Credit transaction, where the funds are credited to an account. Note: just available for mapping purposes and cannot be initiated by the SDK. */
    MPTransactionTypeCredit
};

/**
 * @since 2.0.0
 * The final result of the transaction.
 */
typedef NS_ENUM(NSUInteger, MPTransactionStatus){
    /** Unknown or not available */
    MPTransactionStatusUnknown = 0,
    /** Transaction is initialized and can be started */
    MPTransactionStatusInitialized,
    /** Transaction result is still pending (e.g. not finished or waiting for async workflow) */
    MPTransactionStatusPending,
    /** Transaction was approved */
    MPTransactionStatusApproved,
    /** Transaction was declined */
    MPTransactionStatusDeclined,
    /** Transaction was aborted (by merchant or shopper) */
    MPTransactionStatusAborted,
    /** An error occured, see [MPTransaction.error] for more details */
    MPTransactionStatusError,
};

/**
 * The currency used for a transaction.
 * @since 2.0.0
 */
typedef NS_ENUM(NSUInteger, MPCurrency){
    /** Unknown or not available */
    MPCurrencyUnknown = 0,
    /** United Arab Emirates Dirham */
    MPCurrencyAED,
    /** Australian Dollar */
    MPCurrencyAUD,
    /** Bulgarian Lev */
    MPCurrencyBGN,
    /** Brazilian Real */
    MPCurrencyBRL,
    /** Swiss Franc */
    MPCurrencyCHF,
    /** Czech Koruna */
    MPCurrencyCZK,
    /** Danish Krone  */
    MPCurrencyDKK,
    /** Euro */
    MPCurrencyEUR,
    /** Pound Sterling */
    MPCurrencyGBP,
    /** Hong Kong Dollars */
    MPCurrencyHKD,
    /** Croatian Kuna */
    MPCurrencyHRK,
    /** Hungarian Forint */
    MPCurrencyHUF,
    /** Indian Rupee */
    MPCurrencyINR,
    /** Lithuanian Litas */
    MPCurrencyLTL,
    /** Latvian Lats */
    MPCurrencyLVL,
    /** Norwegian Krone */
    MPCurrencyNOK,
    /** Polish Zloty */
    MPCurrencyPLN,
    /** Romanian Leu */
    MPCurrencyRON,
    /** Swedish Krona */
    MPCurrencySEK,
    /** Singapore Dollar */
    MPCurrencySGD,
    /** US Dollar */
    MPCurrencyUSD,
    /** South African Rand */
    MPCurrencyZAR
};

/**
 * The state the transaction is currently in. Not all transactions run through all of the steps.
 * @since 2.0.0
 */
typedef NS_ENUM(NSUInteger, MPTransactionState)
{
    /** Unkndown or not available */    
    MPTransactionStateUnknown = 0,
    /** The transaction is waiting to be executed */
    MPTransactionStateIdle,
    /** The transaction is waiting for the card to be inserted */
    MPTransactionStateAwaitingCardPresentation,
    /** The card is currently being analyzed */
    MPTransactionStateAwaitingCardIdentification,
    /** The card requires an application selection by the cardholder */
    MPTransactionStateAwaitingApplicationSelection,
    /** The transaction requires an amount confirmation by the cardholder */
    MPTransactionStateAwaitingAmountConfirmation,
    /** The transaction requires a PIN to be inserted */
    MPTransactionStateAwaitingPIN,
    /** The transaction is a being executed with the remote system */
    MPTransactionStateAwaitingExecution,
    /** The transaction is waiting for the card to be removed */
    MPTransactionStateAwaitingCardRemoval,
    /** The transaction requires a signature by the cardholder */
    MPTransactionStateAwaitingSignature,
    /** The transaction requires an identificatio by the cardholder */
    MPTransactionStateAwaitingIdentification,
    /** The transaction is being finalized with the remote host */
    MPTransactionStateAwaitingCompletion,
    /** The transaction is in a final state and no changes can be made to it anymore */
    MPTransactionStateEnded
};


/**
 * A transaction contains all information required to make a transaction. It goes through specifically defined states and offers additional details after successful execution.
 * @since 2.0.0
 */
@interface MPTransaction : NSObject

#pragma mark -
#pragma mark General Information
/** @name General Information */

/**
 * The amount of the transaction.
 * @since 2.0.0
 */
@property (strong, readonly, nonatomic) NSDecimalNumber *amount;

/**
 * The currency used for the transaction.
 * @since 2.0.0
 */
@property (assign, readonly, nonatomic) MPCurrency currency;

/**
 * The subject line for the transaction.
 * @since 2.0.0
 */
@property (strong, readonly, nonatomic) NSString *subject;


#pragma mark -
#pragma mark Transaction Setup (must be set manually)
/** @name Transaction Setup (must be set manually) */

/**
 * The type of transaction to be executed.
 * @since 2.0.0
 */
@property (assign, readonly, nonatomic) MPTransactionType type;

#pragma mark -
#pragma mark Payment Details
/** @name Payment Details */

/**
 * The payment params used for the transaction.
 * @since 2.0.0
 */
@property (strong, readonly, nonatomic) MPPaymentDetails *paymentDetails;

/**
 * The refund params associated with the transaction.
 * @since 2.0.0
 */
@property (strong, readonly, nonatomic) MPRefundDetails *refundDetails;


#pragma mark -
#pragma mark Transaction Result

/**
 * Current state of the transaction. Approved, Declined and Error are the final states.
 * @since 2.0.0
 */
@property (assign, readonly, nonatomic) MPTransactionStatus status;

/**
 * Additional details associated with the current status, providing more detailed information for the current status and debug information.
 * @since 2.0.0
 */
@property (strong, readonly, nonatomic) MPStatusDetails *statusDetails;


/**
 * The current workflow state the transaction is in.
 * @since 2.0.0
 */
@property (assign, readonly, nonatomic) MPTransactionState state;

/**
 * If the transaction execution fails for any reason, this will contain the last error message. Otherwise nil.
 * @since 2.0.0
 */
@property (strong, readonly, nonatomic) NSError *error;

#pragma mark -
#pragma mark Global References
/** @name Global Refrences */

/**
 * The (temporary) session that references the transaction.
 * @since 2.0.0
 */
@property (strong, readonly, nonatomic) NSString *sessionIdentifier;


/**
 * The reference within our infrastructure to identify the transaction (payworks identifier).
 * @since 2.0.0
 */
@property (strong, readonly, nonatomic) NSString *identifier;


/**
 * A reference to a group of transactions that logically belong together.
 * @since 2.0.0
 */
@property (strong, readonly, nonatomic) NSString *groupIdentifier;

/**
 * A reference to a transaction that the current transaction is building up on.
 * @since 2.0.0
 */

@property (strong, readonly, nonatomic) NSString *referencedTransactionIdentifier;

/**
 * An identifier that can be set by the developer/user. Must be in the range [0-9a-zA-Z]. This will normally be a reference to a order in your system.
 * @since 2.0.0
 */
@property (strong, readonly, nonatomic) NSString *customIdentifier;

/**
 * Timestamp when the transaction was created. This timestamp will always be UTC.
 * @since 2.0.0
 */
@property (strong, readonly, nonatomic) NSDate *created;


/**
 * Indicates if the transaction can still be aborted.
 * @return YES if the transaction can be aborted, NO otherwise
 * @since 2.0.0
 */
- (BOOL)canBeAborted;

#pragma mark -
#pragma mark Customer and Receipt Information
/** @name Customer and Receipt Information */

/**
 * Location information on the current transaction
 * @since 2.0.0
 */
@property (strong, nonatomic) MPLocationDetails *locationDetails;


/**
 * Information and identifiers returned by the processor.
 * @since 2.0.0
 */
@property (strong, readonly, nonatomic) MPProcessingDetails *processingDetails;


@end


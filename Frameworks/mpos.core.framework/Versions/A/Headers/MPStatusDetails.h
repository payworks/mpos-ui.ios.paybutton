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

/**
 * Enum incicating a more detailed status on the transaction.
 * @since 2.0.0
 */
typedef NS_ENUM(NSUInteger, MPTransactionStatusDetailsCode){
    /** Transaction needs to be initialized */
    MPTransactionStatusDetailsCodeUnknown = 0,
    
    /** Transaction is initialized and can be started */
    MPTransactionStatusDetailsCodeInitializedAtServer,
    /** Transaction is initialized and can be started */
    MPTransactionStatusDetailsCodeInitializedAtProcessor,
    /** Transaction has been re-initialized at the server and should be processed again */
    MPTransactionStatusDetailsCodeInitializedWithReplacement,
    
    /** The transaction was send to the processor and is awaiting approval */
    MPTransactionStatusDetailsCodePendingWaitungForProcessor,
    /** The transaction was received by the processor and needs to be finalized */
    MPTransactionStatusDetailsCodePendingAwaitingFinalization,
    
    /** The transaction was approved */
    MPTransactionStatusDetailsCodeApproved,
    
    /** The transaction was aborted by the customer */
    MPTransactionStatusDetailsCodeDeclinedCardOrTerminalDeclined,
    /** The transaction was declined by the processor */
    MPTransactionStatusDetailsCodeDeclinedProcessor,
    /** The software on the device is no longer valid */
    MPTransactionStatusDetailsCodeDeclinedInvalidTerminalSoftware,
    /** The configuration on the device is no longer valid */
    MPTransactionStatusDetailsCodeDeclinedInvalidTerminalConfiguration,
    /** The terminal is not supported for this merchant */
    MPTransactionStatusDetailsCodeDeclinedInvalidTerminal,
    /** The session created for the transaction has expired */
    MPTransactionStatusDetailsCodeDeclinedSessionExpired,
    /** The entered PIN is wrong */
    MPTransactionStatusDetailsCodeDeclinedPinWrong,
    /** The PIN was entered wrong too often*/
    MPTransactionStatusDetailsCodeDeclinedPinWrongTooOften,
    /** The used card is expired */
    MPTransactionStatusDetailsCodeDeclinedCardExpired,
    /** The scheme presented by the card is invalid */
    MPTransactionStatusDetailsCodeDeclinedCardInvalidScheme,
    /** The PAN on the card is invalid*/
    MPTransactionStatusDetailsCodeDeclinedCardInvalidPan,
    /** The card was reported stolen */
    MPTransactionStatusDetailsCodeDeclinedCardStolen,
    /** A different card has to be used for this transaction */
    MPTransactionStatusDetailsCodeDeclinedCardUseOriginal,
    /** The transaction was declined by the processor with a special error case */
    MPTransactionStatusDetailsCodeDeclinedProcessorExceedsWithdrawalCountLimit,
    /** Processor error */
    MPTransactionStatusDetailsCodeDeclinedProcessorInconsistentState,
    /** The transaction was declined due to a malformed request */
    MPTransactionStatusDetailsCodeDeclinedMalformedRequest,
    /** Transaction not possible, because the card might have been manipulated */
    MPTransactionStatusDetailsCodeDeclinedManipulationSuspected,
    /** Card is not allowed */
    MPTransactionStatusDetailsCodeDeclinedCardBlocked,
    /** Card has insufficient funds */
    MPTransactionStatusDetailsCodeDeclinedInsufficientFunds,
    /** Merchant did too many transactions within a certain timeframe */
    MPTransactionStatusDetailsCodeDeclinedTransactionFrequencyExceeded,
    /** Card has been reported as lost and cannot be used anymore */
    MPTransactionStatusDetailsCodeDeclinedCardLost,
    /** Card scheme not allowed */
    MPTransactionStatusDetailsCodeDeclinedInvalidScheme,
    /** Transaction amount is not allowed (too high or too low) */
    MPTransactionStatusDetailsCodeDeclinedInvalidAmount,
    /** The configuration data in the merchant's processing path is wrong */
    MPTransactionStatusDetailsCodeDeclinedInvalidConfiguration,
    /** Same transcation is already being processed */
    MPTransactionStatusDetailsCodeDeclinedDuplicateTransaction,
    /** The transaction was declined due to an invalid workflow */
    MPTransactionStatusDetailsCodeDeclinedInvalidWorkflow,
    /** Card expired */
    MPTransactionStatusDetailsCodeDeclinedProcessorCardExpired,
    /** Refund not possible (e.g. not allowed by bank or transaction already refunded) */
    MPTransactionStatusDetailsCodeDeclinedProcessorRefundNotPossible,
    /** Transaction with this card temporarily not possible, due to too many tries */
    MPTransactionStatusDetailsCodeDeclinedProcessorTemporarilyBlacklisted,
    /** Transaction amount exceeds card limit */
    MPTransactionStatusDetailsCodeDeclinedAmountExceedsLimit,
    
    /** The transaction was aborted by the customer by removing the card */
    MPTransactionStatusDetailsCodeAbortedShopperRemovedCard,
    /** The transaction was aborted by the customer */
    MPTransactionStatusDetailsCodeAbortedShopperAborted,
    /** The transaction was aborted by the merchant */
    MPTransactionStatusDetailsCodeAbortedMerchantAborted,
    /** The transaction timed out waiting for a card */
    MPTransactionStatusDetailsCodeAbortedWaitingForCardTimeout,
    
    /** Processor error */
    MPTransactionStatusDetailsCodeErrorInvalidProcessorFormat,
    /** Processor error */
    MPTransactionStatusDetailsCodeErrorInvalidProcessorStatus,
    /** Processor error */
    MPTransactionStatusDetailsCodeErrorMissingProcessorSession,
    /** Processor error */
    MPTransactionStatusDetailsCodeErrorInvalidProcessorSession,
    /** Processor error */
    MPTransactionStatusDetailsCodeErrorInvalidProcessorNonce,
    /** Processor error */
    MPTransactionStatusDetailsCodeErrorProcessorConnectionError,
    /** Processor error */
    MPTransactionStatusDetailsCodeErrorProcessorFailedInconsistentStateUnresolved,
    /** Processor error */
    MPTransactionStatusDetailsCodeErrorProcessorFailedInconsistentStateResolved,
    /** Configuration error at payment processor */
    MPTransactionStatusDetailsCodeErrorProcessorPaymentDetailsExtractionFailed,
    /** Configuration error at payment processor */
    MPTransactionStatusDetailsCodeErrorProcessorInvalidPaymentDetails,
    /** Configuration error at payment processor */
    MPTransactionStatusDetailsCodeErrorProcessorInvalidConfiguration,
    /** Configuration error at payment processor */
    MPTransactionStatusDetailsCodeErrorProcessorMalformedRequest,
    /** Same transcation is already being processed */
    MPTransactionStatusDetailsCodeErrorProcessorTransactionAlreadyInProgress,
    /** No response from acquiring bank received */
    MPTransactionStatusDetailsCodeErrorProcessorConnectionNoResponse,
    /** The terminal processing the transaction encountered an error */
    MPTransactionStatusDetailsCodeErrorTerminalError,
    /** The terminal processing the transaction encountered an error */
    MPTransactionStatusDetailsCodeErrorTerminalTimeout,
    
    /** The server returned an invalid response */
    MPTransactionStatusDetailsCodeErrorServerInvalidResponse,
    /** The server is unavailable */
    MPTransactionStatusDetailsCodeErrorServerUnavailable,
    /** Authentication with the server failed, credential missmatch */
    MPTransactionStatusDetailsCodeErrorServerAuthenticationFailed,
    /** SSL pinning failed, had to cancel authentication*/
    MPTransactionStatusDetailsCodeErrorServerPinningWithRemoteFailed,
    /** Timout from the server received */
    MPTransactionStatusDetailsCodeErrorServerTimeout,
    /** The server timed out */
    
    MPTransactionStatusDetailsCodeErrorServerSessionTimeout,
    /** The transaction was (falsely) approved offline */
    MPTransactionStatusDetailsCodeErrorApprovedOffline

};


/**
 * Object encapulating details about the current transaction state. Should be used in conjunction with [MPTransactionStatus].
 * @since 2.0.0
 */
@interface MPStatusDetails : NSObject

/**
 * The transaction status details.
 * @since 2.0.0
 */
@property (assign, readonly, nonatomic) MPTransactionStatusDetailsCode code;

/**
 * A humand readable description of the current status.
 * @since 2.0.0
 */
@property (strong, readonly, nonatomic) NSString *detailedDescription;

/**
 * A developer facing message/description about the current status. Might containg tips on how to resolve an issue.
 * @since 2.0.0
 */
@property (strong, readonly, nonatomic) NSString *developerDescription;

@end

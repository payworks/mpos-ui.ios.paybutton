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

/**
 * Detailing the current state of the transaction process.
 * @since 2.2.0
 */
typedef NS_ENUM(NSUInteger, MPTransactionProcessDetailsState){
    /** The process has been initialized and awaits execution */
    MPTransactionProcessDetailsStateCreated,
    /** The process just started and the transaction is either registered or queried */
    MPTransactionProcessDetailsStateConnectingToAccessory,
    /** The transaction processing is ongoing and a card must be presented */
    MPTransactionProcessDetailsStateInitializingTransaction,
    /** The process is establishing a connection to an accessory */
    MPTransactionProcessDetailsStateWaitingForCardPresentation,
    /** The transaction processing is ongoing and a card must be removed */
    MPTransactionProcessDetailsStateWaitingForCardRemoval,
    /** The process is processing a transaction */
    MPTransactionProcessDetailsStateProcessing,
    /** The transaction was approved */
    MPTransactionProcessDetailsStateApproved,
    /** The transaction was declined */
    MPTransactionProcessDetailsStateDeclined,
    /** The transaction was aborted */
    MPTransactionProcessDetailsStateAborted,
    /** The process failed during one of its stages */
    MPTransactionProcessDetailsStateFailed,
    /** The transacion is not refundable */
    MPTransactionProcessDetailsStateNotRefundable
};

/**
 * More detailed information on the current state of the process.
 * @since 2.2.0
 */
typedef NS_ENUM(NSUInteger, MPTransactionProcessDetailsStateDetails){
    /** The process is initialized, nothing has happened yet */
    MPTransactionProcessDetailsStateDetailsCreated,
    
    /** A connection attempt with an accessory is ongoing */
    MPTransactionProcessDetailsStateDetailsConnectingToAccessory,
    /** An update check for the accessory is ongoing */
    MPTransactionProcessDetailsStateDetailsConnectingToAccessoryCheckingForUpdate,
    /** An update of the accessory is ongoing */
    MPTransactionProcessDetailsStateDetailsConnectingToAccessoryUpdating,
    /** Wait until user connects a reader */
    MPTransactionProcessDetailsStateDetailsConnectingToAccessoryWaitingForReader,

    /** The transaction template is registered with the server */
    MPTransactionProcessDetailsStateDetailsInitializingTransactionRegistering,
    /** The transaction details are queried from the server */
    MPTransactionProcessDetailsStateDetailsInitializingTransactionQuerying,

    /** The transaction processing is waiting for a card to be presented */
    MPTransactionProcessDetailsStateDetailsWaitingForCardPresentation,
    /** The transaction processing is waiting for a card removal */
    MPTransactionProcessDetailsStateDetailsWaitingForCardRemoval,
    
    /** The transaction processing is ongoing */
    MPTransactionProcessDetailsStateDetailsProcessing,
    /** The transaction requires an interactio before it can complete */
    MPTransactionProcessDetailsStateDetailsProcessingActionRequired,
    /** The transaction processing is waiting for a PIN entry */
    MPTransactionProcessDetailsStateDetailsProcessingWaitingForPIN,
    /** The transaction was completed */
    MPTransactionProcessDetailsStateDetailsProcessingCompleted,
    
    /** The transaction was approved */
    MPTransactionProcessDetailsStateDetailsApproved,
    /** The transaction was declined */
    MPTransactionProcessDetailsStateDetailsDeclined,
    /** The transaction was aborted */
    MPTransactionProcessDetailsStateDetailsAborted,
    /** The transaction processing failed at some point */
    MPTransactionProcessDetailsStateDetailsFailed,
    
    /** The transaction is not refundable */
    MPTransactionProcessDetailsStateDetailsNotRefundable
};


/**
 * Object holding representing the current status of the transaction process.
 * @since 2.2.0
 */
@interface MPTransactionProcessDetails : NSObject

/**
 * Provides a high level status of the current state of the process
 * @since 2.2.0
 */
@property (assign, readonly, nonatomic) MPTransactionProcessDetailsState state;

/**
 * Provides more details information on the current state of the process
 * @since 2.2.0
 */
@property (assign, readonly, nonatomic) MPTransactionProcessDetailsStateDetails stateDetails;

/**
 * Provides two localized lines of text (each with max 40 characters) that can be displayed on screen suitable for the current status
 * @since 2.2.0
 */
@property (strong, readonly, nonatomic) NSArray *information;

/**
 * Holds the error thrown by the underlying components in case of a failure. Only populated in case of state == MPTransactionProcessDetailsStateFailed
 * @since 2.2.0
 */
@property (strong, readonly, nonatomic) NSError *error;

@end

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

#import "MPTransaction.h"
#import "MPProvider.h"


@class UIImage;
@class MPTransactionActionSupport;
@class MPApplicationInformation;
@class MPTransaction;
@class MPTransactionProcess;
@class MPTransactionProvider;
@class MPAccessory;
@class MPTransactionProcessDetails;

/**
 * Callback indicating a successful registration of the transaction and provides access it. Save the .sessionIdentifier or .identifier to query the status in case of an error or application termination.
 * @param transactionProcess The instance that called the block
 * @param transaction The transaction reference that was created (same as transactionProcess.transaction)
 * @since 2.2.0
 */
typedef void (^MPTransactionProcessRegistered)(MPTransactionProcess * _Nonnull transactionProcess, MPTransaction * _Nonnull transaction);

/**
 * Indicates a status change of the overall process and provides information about whats happening with process.
 * @param transactionProcess The instance that called the block
 * @param transaction The transaction that is currently being processed (same as transactionProcess.transaction)
 * @since 2.2.0
 */
typedef void (^MPTransactionProcessStatusChanged)(MPTransactionProcess * _Nonnull transactionProcess, MPTransaction * _Nonnull transaction, MPTransactionProcessDetails * _Nonnull details);

/**
 * Indicates that an explicit user interaction is required. The SDK blocks until a call to paymentProcess continueWith... is called.
 * @param transactionProcess The instance that called the block
 * @param transaction The transaction that is currently being processed (same as transactionProcess.transaction)
 * @param action The action that is required
 * @param support Additional data that might be necessary to complete the action
 * @since 2.2.0
 */
typedef void (^MPTransactionProcessActionRequired)(MPTransactionProcess * _Nonnull transactionProcess, MPTransaction * _Nonnull transaction, MPTransactionAction action, MPTransactionActionSupport * _Nullable support);

/**
 * Indicates that the process has been completed. The paymentProcess.details provide additional information on the result of the process.
 * @param transactionProcess The instance that called the block
 * @param transaction The transaction that has been processed (same as paymentProcess.transaction)
 * @param details The latest details object for providing access to the overall processing status (same as transactionProcess.details)
 * @since 2.2.5
 */
typedef void (^MPTransactionProcessCompleted)(MPTransactionProcess * _Nonnull transactionProcess, MPTransaction * _Nonnull transaction, MPTransactionProcessDetails * _Nonnull details);


/**
 * Automated workflow that encapsulates all steps required for making a transaction.
 * @since 2.2.0
 */
@interface MPTransactionProcess : NSObject

/**
 * The provider instance that is used by the process.
 * @since 2.2.0
 */
@property (strong, readonly, nonatomic, nullable) MPTransactionProvider *provider;

/**
 * The transaction object used by the process.
 * @since 2.2.0
 */
@property (strong, readonly, nonatomic, nonnull) MPTransaction *transaction;

/**
 * The accessory object used by the process.
 * @since 2.2.0
 */
@property (strong, readonly, nonatomic, nullable) MPAccessory *accessory;

/**
 * The process details providing access to the current status.
 * @since 2.2.0
 */
@property (strong, readonly, nonatomic, nonnull) MPTransactionProcessDetails *details;


/**
 * Continues a transaction with a signature after a respective actionRequired callback was called.
 * @param signature The digital signature of the cusomter
 * @param verified Indicates if the signature matches the one on the card
 * @since 2.2.0
 */
- (void)continueWithCustomerSignature:(nonnull UIImage *)signature
                             verified:(BOOL)verified;

/**
 * Continues a transaction indicating that the signature will be captured on the receipt after the transaction. Continues after a respective actionRequired callback was called.
 * @since 2.2.5
 */
- (void)continueWithCustomerSignatureOnReceipt;

/**
 * Continues a transaction with with a identity verification a respective actionRequired callback was called.
 * @param verified Indicates if the identity was verified
 * @since 2.2.0
 */
- (void)continueWithCustomerIdentityVerified:(BOOL)verified;

/**
 * Continue a transaction after an application selection actionRequired callback was called.
 * @param application The application to use for the transaction
 * @since 2.2.0
 */
- (void)continueWithSelectedApplication:(nonnull MPApplicationInformation *)application;

/**
 * Requests an abort at the next possible moment. Repeated calls are ignored.
 * Once the abort was successful, the process completes and has state == MPTransactionProcessDetailsStateAborted.
 * @returns Returns NO if the transaction can not be aborted, and YES if the abort has been queued but is not guaranteed to happen
 * @since 2.0.0
 */
- (BOOL)requestAbort;

/**
 * Indicates whether the process can be aborted.
 * @return YES if it can be aborted, NO otherwise
 * @since 2.3.0
 */
- (BOOL)canBeAborted;

@end


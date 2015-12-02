//
// PAYWORKS GMBH ("COMPANY") CONFIDENTIAL
// Copyright (c) 2015 payworks GmbH, All Rights Reserved.
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

@class MPTransaction;
@class MPTransactionProvider;
@class MPPrintingProcess;
@class MPPrintingProcessDetails;
@class MPAccessory;

/**
 * Indicates a status change of the overall process and provides information about whats happening with process.
 * @param printingProcess The instance that called the block
 * @param transaction The transaction that is currently being processed (same as printingProcess.transaction)
 * @since 2.4.0
 */
typedef void (^MPPrintingProcessStatusChanged)(MPPrintingProcess * _Nonnull printingProcess, MPTransaction * _Nullable transaction, MPPrintingProcessDetails * _Nonnull details);

/**
 * Indicates that the process has been completed. The printingProcess.details provide additional information on the result of the process.
 * @param printingProcess The instance that called the block
 * @param transaction The transaction that has been processed (same as printingProcess.transaction)
 * @param details The latest details object for providing access to the overall processing status (same as printingProcess.details)
 * @since 2.4.0
 */
typedef void (^MPPrintingProcessCompleted)(MPPrintingProcess * _Nonnull printingProcess, MPTransaction * _Nullable transaction, MPPrintingProcessDetails * _Nonnull details);

/**
 * Automated workflow that encapsulates all steps required for making a transaction.
 * @since 2.4.0
 */
@interface MPPrintingProcess : NSObject

/**
 * The provider instance that is used by the process.
 * @since 2.4.0
 */
@property (strong, readonly, nonatomic, nullable) MPTransactionProvider *provider;

/**
 * The accessory object used by the process.
 * @since 2.4.0
 */
@property (strong, readonly, nonatomic, nullable) MPAccessory *accessory;

/**
 * The process details providing access to the current status.
 * @since 2.4.0
 */
@property (strong, readonly, nonatomic, nonnull) MPPrintingProcessDetails *details;

/**
 * Requests an abort at the next possible moment. Repeated calls are ignored.
 * Once the abort was successful, the process completes and has state == MPPrintingProcessDetailsStateAborted.
 * @returns Returns NO if the transaction can not be aborted, and YES if the abort has been queued but is not guaranteed to happen
 * @since 2.4.0
 */
- (BOOL)requestAbort;

/**
 * Indicates whether the process can be aborted.
 * @return YES if it can be aborted, NO otherwise
 * @since 2.4.0
 */
- (BOOL)canBeAborted;

@end


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


/**
 * Detailing the current state of a printing process.
 * @since 2.4.0
 */
typedef NS_ENUM(NSUInteger, MPPrintingProcessDetailsState) {
    /** The process has been initialized and awaits execution. */
    MPPrintingProcessDetailsStateCreated,
    /** The transaction is being fetched from the server.
     * Only happens if process started with a transaction identifier. */
    MPPrintingProcessDetailsStateFetchingTransaction,
    /** The process is establishing a connection to an accessory with a printer component. */
    MPPrintingProcessDetailsStateConnectingToAccessory,
    /** The transaction data is being sent to the printer component. */
    MPPrintingProcessDetailsStateSendingToPrinter,
    /** The transaction data was successfully sent to the printer component. */
    MPPrintingProcessDetailsStateSentToPrinter,
    /** The printing was aborted. */
    MPPrintingProcessDetailsStateAborted,
    /** The printing process failed during one of its stages. */
    MPPrintingProcessDetailsStateFailed

};

/**
 * More detailed information on the current state of the process.
 * @since 2.4.0
 */
typedef NS_ENUM(NSUInteger, MPPrintingProcessDetailsStateDetails){
    /** The process is initialized, nothing has happened yet */
    MPPrintingProcessDetailsStateDetailsCreated,
    
    /** The transaction is being fetched from the server.
     * Only happens if process started with a transaction identifier. */
    MPPrintingProcessDetailsStateDetailsFetchingTransaction,
    
    /** A connection attempt with an accessory is ongoing */
    MPPrintingProcessDetailsStateDetailsConnectingToAccessory,
    /** Wait until user connects a printer */
    MPPrintingProcessDetailsStateDetailsConnectingToAccessoryWaitingForPrinter,
    
    /** The printer component is being checked for its state. */
    MPPrintingProcessDetailsStateDetailsSendingToPrinterCheckingState,
    /** The transaction data is being sent to the printer component. */
    MPPrintingProcessDetailsStateDetailsSendingToPrinter,
    
    /** The transaction data was successfully sent to the printer component. */
    MPPrintingProcessDetailsStateDetailsSentToPrinter,
    
    /** The printing was aborted. */
    MPPrintingProcessDetailsStateDetailsAborted,
    
    /** The printing process failed due to printer error -- no paper in tray. */
    MPPrintingProcessDetailsStateDetailsFailedPaperEmpty,
    
    /** The printing process failed due to printer error -- its cover is open. */
    MPPrintingProcessDetailsStateDetailsFailedCoverOpen,
    
    /** The printing process failed during one of its stages for other reason. */
    MPPrintingProcessDetailsStateDetailsFailed
};

/**
 * Object providing information for an ongoing printing process.
 * @since 2.4.0
 */
@interface MPPrintingProcessDetails : NSObject

/**
 * Provides a high level status of the current state of the process
 * @since 2.4.0
 */
@property (assign, readonly, nonatomic) MPPrintingProcessDetailsState state;

/**
 * Provides more details information on the current state of the process
 * @since 2.4.0
 */
@property (assign, readonly, nonatomic) MPPrintingProcessDetailsStateDetails stateDetails;

/**
 * Provides two localized lines of text (each with max 40 characters) that can be displayed on screen suitable for the current status
 * @since 2.4.0
 */
@property (strong, readonly, nonatomic, nonnull) NSArray *information;

/**
 * Holds the error thrown by the underlying components in case of a failure. Only populated in case of state == MPPrintingProcessDetailsStateFailed
 * @since 2.4.0
 */
@property (strong, readonly, nonatomic, nullable) NSError *error;

@end


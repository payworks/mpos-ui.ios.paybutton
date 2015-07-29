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

#import "MPAccessoryComponent.h"
#import "MPReceipt.h"

@class MPAccessoryComponentPrinter;

typedef void (^MPAccessoryComponentPrinterPrintSuccess)(MPAccessoryComponentPrinter *component, MPReceipt *receipt);
typedef void (^MPAccessoryComponentPrinterPrintFailure)(MPAccessoryComponentPrinter *component, MPReceipt *receipt, NSError *error);

/**
 * State of printer accessory component.
 * @since 2.4.0
 */
typedef NS_ENUM(NSUInteger, MPAccessoryComponentPrinterState){
    /** Unkndown or not available */
    MPAccessoryComponentPrinterStateUnknown = 0,
    /** The printer is ready */
    MPAccessoryComponentPrinterStateNormal,
    /** The printer is busy */
    MPAccessoryComponentPrinterStateBusy,
    /** The printer's paper is low or empty */
    MPAccessoryComponentPrinterStatePaperLowOrEmpty,
    /** The printer's cover is open */
    MPAccessoryComponentPrinterStateCoverOpen
};


/**
 * Component providing access to printing features of the accessory.
 * @since 2.4.0
 */
@interface MPAccessoryComponentPrinter : MPAccessoryComponent

/**
 * Current state of the printer.
 * @since 2.4.0
 */
@property (assign, readonly, nonatomic) MPAccessoryComponentPrinterState state;

/**
 * Returns if the component is ready for printing.
 * @since 2.4.0
 */
- (BOOL)canPrint;

/**
 * Prints the given receipt.
 * @param receipt The receipt to be printed
 * @param success Data successfully sent to printer, the receipt is being printed
 * @param failure Printing receipt not successful
 * @since 2.4.0
 */
- (void)printReceipt:(MPReceipt *)receipt
             success:(MPAccessoryComponentPrinterPrintSuccess)success
             failure:(MPAccessoryComponentPrinterPrintFailure)failure;



@end

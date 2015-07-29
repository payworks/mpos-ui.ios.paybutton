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

#import <Foundation/Foundation.h>

/**
 * Enum specifiying the refund status of a transaction.
 * @since 2.1.0
 */
typedef NS_ENUM(NSUInteger, MPRefundDetailsStatus) {
    /** Unknown status */
    MPRefundDetailsStatusUnknown = 0,
    /** The transaction cannot be refunded */
    MPRefundDetailsStatusNonRefundable,
    /** The transaction can be refunded partially and fully */
    MPRefundDetailsStatusRefundablePartialAndFull,
    /** The transaction can be refunded fully */
    MPRefundDetailsStatusRefundableFullOnly,
    /** The transaction was already refunded */
    MPRefundDetailsStatusRefunded
};

/**
 * Option flags indicating the process for a refund.
 * @since 2.1.0
 */
typedef NS_OPTIONS(NSUInteger, MPRefundDetailsProcess) {
    /** Unknown process */
    MPRefundDetailsProcessUnknown       = 0,
    /** The refund can be triggered with any card */
    MPRefundDetailsProcessAnyCard       = 1 << 0,
    /** The refund can be triggered without any card (card not present) */
    MPRefundDetailsProcessWithoutCard   = 1 << 1,
    /** The refund can only be triggered with the same card the transaction was processed with */
    MPRefundDetailsProcessSameCard      = 1 << 2
};


/**
 * Object indicting the current refund capabilities of the transaction.
 * @since 2.1.0
 */
@interface MPRefundDetails : NSObject

/**
 * Indicates the status of a possible refund option.
 * @since 2.1.0
 */
@property (assign, readonly, nonatomic) MPRefundDetailsStatus status;

/**
 * Indicates the process to be applied for a refund. Is an options flag and might indicate multiple possibilities.
 * @since 2.1.0
 */
@property (assign, readonly, nonatomic) MPRefundDetailsProcess process;

@end

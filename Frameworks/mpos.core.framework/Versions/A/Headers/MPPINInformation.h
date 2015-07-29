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
 * The reason for the status update.
 * @since 2.0.0
 */
typedef NS_ENUM(NSUInteger, MPPINInformationStatus){
    /** PIN entry started */
    MPPINInformationStatusStarted,
    /** PIN entry update */
    MPPINInformationStatusUpdate,
    /** The entered PIN is correct */
    MPPINInformationStatusCompleted,
    /** The entered PIN is incorrect */
    MPPINInformationStatusIncorrect,
    /** The entered PIN is incorrect and last try is coming up */
    MPPINInformationStatusLastTry
};

/**
 * PIN information providing information about the current entry process.
 * @since 2.0.0
 */
@interface MPPINInformation : NSObject

/**
 * The status of the entry process.
 * @since 2.0.0
 */
@property (assign, readonly, nonatomic) MPPINInformationStatus status;

/**
 * The number of digits entered.
 * @since 2.0.0
 */
@property (assign, readonly, nonatomic) NSInteger digits;

@end

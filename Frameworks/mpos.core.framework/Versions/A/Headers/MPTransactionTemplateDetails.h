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

#import <Foundation/Foundation.h>


/**
 * Details for a transaction template which can be required by different aquirers.
 * Please check the documentation related to the aquirers you are working with.
 * @since 2.4.9
 * @deprecated 2.5.0
 */
DEPRECATED_MSG_ATTRIBUTE("Use MPTransactionParameters instead")
@interface MPTransactionTemplateDetails : NSObject

/**
 * The amount of money which will be transferred to application's owner account
 * @throws NSException if NaN
 * @since 2.4.9
 */
@property (strong, nonatomic, nullable) NSDecimalNumber *applicationFee;

/**
 * A set of key/value pairs that you can attach to a charge object.
 * The keys and values must be NSString objects.
 * @note Size limits may apply! Please check the documentation related to aquirers you work with
 * @since 2.4.9
 */
@property (strong, nonatomic, nullable) NSDictionary *metadata;


@end

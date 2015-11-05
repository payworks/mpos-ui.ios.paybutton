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


/**
 * Helper toolbox to format amounts, currencies and dates
 * @since 2.3.0
 */
@interface MPLocalizationToolbox : NSObject

/**
 * Formats an amount and currency based on the system region and locale.
 * @param amount The amount to format
 * @param currency The currency to format
 * @return A formatted amound and currency
 * @since 2.3.0
 */
- (nullable NSString *)textFormattedForAmount:(nullable NSDecimalNumber *)amount currency:(MPCurrency)currency;

/**
 * Formats a date based on the system region and locale.
 * @param date The date to format
 * @return A formatted date
 * @since 2.3.0
 */
- (nullable NSString *)textFormattedForDate:(nullable NSDate *)date;

/**
 * Formats a time based on the system region and locale.
 * @param time The time to format
 * @return A formatted time
 * @since 2.3.0
 */
- (nullable NSString *)textFormattedForTime:(nullable NSDate *)time;

/**
 * Formats a date and time based on the system region and locale.
 * @param datetime The date and time to format
 * @return A formatted date and time
 * @since 2.3.0
 */
- (nullable NSString *)textFormattedForTimeAndDate:(nullable NSDate *)datetime;

@end


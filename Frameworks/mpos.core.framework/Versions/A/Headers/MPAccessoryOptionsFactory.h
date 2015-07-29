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

#import "MPAccessory.h"
@class MPAccessoryOptions;


/**
 * Factory able to create new accessory options. Those options are used to connect to a new accessory.
 * @since 2.0.0
 */
@interface MPAccessoryOptionsFactory : NSObject

/**
 * Creates new accessory options for a device connected via as an External Accessory.
 * @param type The type of device you want to connect to
 * @param protocol The protocol used by the device (e.g. com.miura.shuttle)
 * @param prefix A prefix for selecting the appropriate device if multiple are available
 * @return A new set of accessory options that can be used to connect to an accessory
 * @throws NSException if the parameters are invalid
 * @since 2.0.0
 */
- (MPAccessoryOptions *)externalAccessoryOptionsWithType:(MPAccessoryType)type protocol:(NSString *)protocol namePrefix:(NSString *)prefix;

/**
 * Creates new accessory options for a device connected via th audio jack.
 * @param type The type of decice you want to connect to
 * @return A new set of accessory options that can be used to connect to an accessory
 * @throws NSException if the parameters are invalid
 * @since 2.0.0
 */
- (MPAccessoryOptions *)audioJackAccessoryOptionsWithType:(MPAccessoryType)type;


/**
 * Creates new accessory options for mocked device.
 * @returns A new set mock acccessory options
 * @since 2.0.0
 */
- (MPAccessoryOptions *)mockAccessoryOptions;
@end

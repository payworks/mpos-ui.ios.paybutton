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

/**
 * Options that will be provided for opening a connection.
 * @since 2.0.0
 */
@interface MPAccessoryOptions : NSObject

/**
 * The type of accessory used.
 * @since 2.0.0
 */
@property (assign, readonly, nonatomic) MPAccessoryType type;

/**
 * The connection used to connect to the accessory.
 * @since 2.0.0
 */
@property (assign, readonly, nonatomic) MPAccessoryConnectionType connectionType;

/**
 * Additional information used during a connect attempt, the values are dependent on the connection type.
 * @since 2.0.0
 */
@property (strong, readonly, nonatomic) NSArray *filters;


/**
 * The text displayed as an idle screen.
 * @since 2.0.0
 */
@property (strong, nonatomic) NSArray *idleScreenText;

/**
 * The language to use for displaying information and prompts on the display.
 * @since 2.0.0
 */
@property (assign, nonatomic) MPLocale locale;

@end

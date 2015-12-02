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
 * Protocol implemented by the optionals object, on which additional parameters for an accessory can be set
 * @since 2.5.0
 */
@protocol MPAccessoryOptionals <NSObject>

/**
 * The text displayed as an idle screen.
 * @since 2.5.0
 */
@property (nonatomic, nullable) NSArray *idleText;

/**
 * The language to use for displaying information and prompts on the display.
 * @since 2.5.0
 */
@property (nonatomic) MPLocale locale;

@end


/**
 * Protocol implemented by the optionals object for an accessory that connects via Bluetooth or lightning. Additional parameters specific for this type of connection can be set on it.
 * @since 2.5.0
 */
@protocol MPExternalAccessoryOptionals <MPAccessoryOptionals>

/**
 * A prefix for selecting the appropriate device if multiple are available
 * @since 2.5.0
 */
@property (nonatomic, nullable) NSString *namePrefix;

@end


/**
 * Block that provides an optionals object, on which additional parameters for an accessory can be set
 * @since 2.5.0
 */
typedef void (^MPAccessoryOptionalsBlock)(id<MPAccessoryOptionals> _Nonnull optionals);

/**
 * Block that provides an optionals object, on which additional parameters for an accessory connected via Bluetooth or lightning connector can be set
 * @since 2.5.0
 */
typedef void (^MPExternalAccessoryOptionalsBlock)(id<MPExternalAccessoryOptionals> _Nonnull optionals);



// Keys used for connection additional values stored in filters
//
// MPAccessoryOptionalsProtocolKey      - Key for Bluetooth or Lightning connection protocol
// MPAccessoryOptionalsNamePrefixKey    - Key for Bluetooth or Lightning name prefix
// MPAccessoryOptionalsRemoteKey        - Key for TCP connection remote address. Can be an IP or a domain name
// MPAccessoryOptionalsPortKey          - Key for TCP connection port

extern NSString * _Nonnull const MPAccessoryOptionalsProtocolKey;
extern NSString * _Nonnull const MPAccessoryOptionalsNamePrefixKey;
extern NSString * _Nonnull const MPAccessoryOptionalsRemoteKey;
extern NSString * _Nonnull const MPAccessoryOptionalsPortKey;


/**
 * Parameters used to describe an accessory
 * @since 2.5.0
 */

@interface MPAccessoryParameters : NSObject

/**
 * The type of accessory used.
 * @since 2.5.0
 */
@property (assign, readonly, nonatomic) MPAccessoryFamily accessoryFamily;

/**
 * The connection used to connect to the accessory.
 * @since 2.5.0
 */
@property (assign, readonly, nonatomic) MPAccessoryConnectionType connectionType;

/**
 * Additional information used during a connect attempt, the values are dependent on the connection type.
 * @since 2.5.0
 */
@property (strong, readonly, nonatomic, nullable) NSDictionary *filters;

/**
 * The text displayed as an idle screen.
 * @since 2.5.0
 */
@property (strong, readonly, nonatomic, nullable) NSArray *idleText;

/**
 * The language to use for displaying information and prompts on the display.
 * @since 2.5.0
 */
@property (assign, readonly, nonatomic) MPLocale locale;

/**
 * Creates a parameters object used to connect to an accessory via bluetooth or via lightning connector.
 * @param family The family of the accessory.
 * @param protocol The protocol used by the device (e.g. com.miura.shuttle)
 * @param optionalsBlock A block that has one argument - an object on which optional parameters can be set.
 * @return A new parameters object that can be used to start transactions on a specific accessory.
 * @throws NSException if the protocol is nil or empty
 * @since 2.5.0
 */
+ (nonnull instancetype)externalAccessoryParametersWithFamily:(MPAccessoryFamily)family protocol:(nonnull NSString *)protocol optionals:(nullable MPExternalAccessoryOptionalsBlock)optionalsBlock;


/**
 * Creates a parameters object used to connect to an accessory via audio jack
 * @param family The family of the accessory.
 * @param optionalsBlock A block that has one argument - an object on which optional parameters can be set. Can be null.
 * @return A new parameters object that can be used to start transactions on a specific accessory
 * @since 2.5.0
 */
+ (nonnull instancetype)audioJackAccessoryParametersWithFamily:(MPAccessoryFamily)family optionals:(nullable MPAccessoryOptionalsBlock)optionalsBlock;

/**
 * Creates a parameters object for a mocked device
 * @return A new parameters object that can be used to start a mock transactions on a mock accessory
 * @since 2.5.0
 */
+ (nonnull instancetype)mockAccessoryParameters;


@end
 
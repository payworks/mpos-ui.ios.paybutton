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
 * The version of the SDK.
 * @since 2.0.0
 */
extern NSString *const MPConnectSDKVersion;

#import "MPProvider.h"
@class MPProviderOptions;
@class MPProviderOptionsFactory;
@class MPTransactionProvider;

/**
 * Main entry point for the SDK, offering the ability to create payment provider handling transactions and accessory interaction.
 * @since 2.0.0
 */
@interface MPMpos : NSObject

/**
 * Returns an options factory to create the respective provider options used to instantiate a new provider.
 * @return An options factory to build provider options
 * @since 2.0.0
 */
+ (MPProviderOptionsFactory *)providerOptionsFactory;

/**
 * Returns a new payment provider to be used for consecutive payments.
 * @param options The options for the provider to be returned, including credentials and provider identifications
 * @return A new instance of the payment provider ready to be used
 * @throws NSException if the options are invalid
 * @since 2.0.0
 */
+ (MPProvider *)providerWithOptions:(MPProviderOptions *)options;

/**
 * Returns the version of the connect SDK.
 * @return The version of the SDK
 * @since 2.0.0
 */
+ (NSString *)version;

/**
 * Returns a new transaction provider that is taylord for simple transaction processing.
 * @param mode The mode the provider should run in
 * @param merchantIdentifier The merchant credentials to use for the transactions
 * @param merchantSecretKey The merchant credentials to use for the transactions
 * @since 2.2.0
 */
+ (MPTransactionProvider *)transactionProviderForMode:(MPProviderMode)mode merchantIdentifier:(NSString *)merchantIdentifier merchantSecretKey:(NSString *)merchantSecretKey;


@end

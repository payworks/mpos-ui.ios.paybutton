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

#import "MPProvider.h"

@class MPProviderOptions;

/**
 * The provider options factory is used to create provider options for instantiating a new payment provider.
 * @since 2.0.0
 */
@interface MPProviderOptionsFactory : NSObject

/**
 * Returns new payment provider options that can be used to initialize a provider with the framework.
 * @param mode The mode the provider should operate in
 * @param merchantIdentifier Merchant credentials
 * @param merchantSecretKey Merchant credentials
 * @param supportedActions The actions you support during a transaction workflow
 * @return new provider options
 * @throws NSException If the parameters are not valid
 * @since 2.0.0
 */
- (MPProviderOptions *)providerOptionsWithMode:(MPProviderMode)mode merchantIdentifer:(NSString *)merchantIdentifier merchantSecretKey:(NSString *)merchantSecretKey supportedActions:(MPTransactionAction)supportedActions;

/**
 * Returns new payment provider options that can be used to initialize a provider with mock options.
 * @param supportedActions The actions you support during a transaction workflow
 * @since 2.0.0
 */
- (MPProviderOptions *)mockOptionsWithSupportedActions:(MPTransactionAction)supportedActions;

@end

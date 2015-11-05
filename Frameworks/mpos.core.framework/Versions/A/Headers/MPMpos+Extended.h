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

#import "MPMpos.h"


@class MPMockConfiguration;


typedef void (^MPMposLoginSuccess)(NSString * _Nonnull username, NSString * _Nonnull merchantIdentifier, NSString * _Nonnull merchantSecretKey);
typedef void (^MPMposLoginFailure)(NSString * _Nonnull username, NSError * _Nonnull error);

typedef void (^MPMposPasswordResetRequestSuccess)(NSString * _Nonnull username);
typedef void (^MPMposPasswordResetRequestFailure)(NSString * _Nonnull username, NSError * _Nonnull error);

/**
 * Extension to the base SDK, offering additional functionalities for logging and mocking.
 * @since 2.0.0
 */
@interface MPMpos (Extended)

/**
 * Configuration to manage the mocking behavior of the SDK.
 * @return The current mocking configuration.
 * @since 2.0.0
 */
+ (nonnull MPMockConfiguration *) mockConfiguration;

/**
 * Enables logging within the SDK.
 * @param logLevel The log level to use from now on
 * @since 2.0.0
 */
+ (void)setLogLevel:(NSUInteger)logLevel;

/**
 * Login for whitelabel applications with the given credentials
 * @param mode
 * @param applicationIdentifier
 * @param username
 * @param password
 * @param success
 * @param failure
 */
+ (void)loginWithMode:(MPProviderMode)mode
 applicationIdentifier:(nonnull NSString *)applicationIdentifier
              username:(nonnull NSString *)username
              password:(nonnull NSString *)password
               success:(nonnull MPMposLoginSuccess)success
               failure:(nonnull MPMposLoginFailure)failure;


/**
 * Password reset for whitelabel applications with the given credentials
 * @param mode
 * @param applicationIdentifier
 * @param username
 * @param success
 * @param failure
 */
+ (void)passwordResetRequest:(MPProviderMode)mode
        applicationIdentifier:(nonnull NSString *)applicationIdentifier
                     username:(nonnull NSString *)username
                      success:(nonnull MPMposPasswordResetRequestSuccess)success
                      failure:(nonnull MPMposPasswordResetRequestFailure)failure;

@end

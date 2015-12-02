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

/**
 * Success handler for loggin into your application.
 * @param username Your username.
 * @param merchantIdentifier The merchantIdentifier to use with the SDK.
 * @param merchantSecretKey The merchantSecretKey to use with the SDK.
 * @since 2.4.4
 */
typedef void (^MPMposLoginSuccess)(NSString * _Nonnull username, NSString * _Nonnull merchantIdentifier, NSString * _Nonnull merchantSecretKey);
/**
 * Failure handler for loggin into your application.
 * @param username Your username.
 * @param error The error that occured.
 * @since 2.4.4
 */typedef void (^MPMposLoginFailure)(NSString * _Nonnull username, NSError * _Nonnull error);

/**
 * Success handler for resetting your password.
 * @param username Your username.
 * @since 2.4.4
 */
typedef void (^MPMposPasswordResetRequestSuccess)(NSString * _Nonnull username);
/**
 * Failure handler for resetting your password.
 * @param username Your username.
 * @param error The error that occured.
 * @since 2.4.4
 */
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
 * @param mode The mode the provider should run in.
 * @param applicationIdentifier The identifier of the application to login to.
 * @param username Your username.
 * @param password Your password.
 * @param success Success block called when the login was successful.
 * @param failure Failure block called when the login failed.
 * @since 2.4.4
 */
+ (void)loginWithMode:(MPProviderMode)mode
applicationIdentifier:(nonnull NSString *)applicationIdentifier
             username:(nonnull NSString *)username
             password:(nonnull NSString *)password
              success:(nonnull MPMposLoginSuccess)success
              failure:(nonnull MPMposLoginFailure)failure;


/**
 * Password reset for whitelabel applications with the given credentials
 * @param mode The mode the provider should run in.
 * @param applicationIdentifier The identifier of the application to login to.
 * @param username Your username.
 * @param success Success block called when the reset was successful.
 * @param failure Failure block called when the reset failed.
 * @since 2.4.4 
 */
+ (void)passwordResetRequest:(MPProviderMode)mode
       applicationIdentifier:(nonnull NSString *)applicationIdentifier
                    username:(nonnull NSString *)username
                     success:(nonnull MPMposPasswordResetRequestSuccess)success
                     failure:(nonnull MPMposPasswordResetRequestFailure)failure;

@end

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
@class MPTransactionTemplate;
@class MPTransactionTemplateFactory;

/**
 * Success handler for creating a new transaction and registering it within our systems.
 * @param transaction The requested transaction
 * @since 2.0.0
 */
typedef void (^MPTransactionCreateSuccess)(MPTransaction *transaction);

/**
 * Failure handler for creating a new transaction and registering it within our systems.
 * @param error Error describing why it failed
 * @since 2.0.0
 */
typedef void (^MPTransactionCreateFailure)(NSError *error);

/**
 * Provider additions, exposing some functionalities that should normally be handled by a server.
 * Please note that this should typically only be used for testing (as this exposes additional credentials).
 * @since 2.0.0
 */
@interface MPProvider (Extended)

/**
 * Returns a factory that must be used to generate a new transaction template for creating a transaction.
 * @since 2.0.0
 */
@property (strong, readonly, nonatomic) MPTransactionTemplateFactory *transactionTemplateFactory;

/**
 * Registers a new transaction that can then be used to complete a transaction. This step is normally done via a direct server-to-server call but is exposed for testing and rapid prototyping applications. 
 * @param template The template to use to create the transaction
 * @param success The success handler called when the transaction was registered successfully
 * @param failure The failure handler called when an error occured during registration
 * @throws NSException If the parameters are invalid
 * @since 2.0.0
 */
- (void)registerTransactionWithTemplate:(MPTransactionTemplate *)template success:(MPTransactionCreateSuccess)success failure:(MPTransactionCreateFailure)failure;

@end

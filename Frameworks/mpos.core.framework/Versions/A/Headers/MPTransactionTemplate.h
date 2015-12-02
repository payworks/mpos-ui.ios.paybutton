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

#import "MPTransaction.h"


@class MPTransactionTemplateDetails;
/**
 * A template describing the initial parameters or a transaction.
 * The template is used to register a transaction via the MPServerSubsystem category.
 * @since 2.0.0
 * @deprecated 2.5.0
 */
DEPRECATED_MSG_ATTRIBUTE("Use MPTransactionParameters instead")
@interface MPTransactionTemplate : NSObject

/**
 * The amount of the transaction.
 * @since 2.0.0
 */
@property (strong, readonly, nonatomic, nullable) NSDecimalNumber *amount;

/**
 * The currency of the transaction.
 * @since 2.0.0
 */
@property (assign, readonly, nonatomic) MPCurrency currency;

/**
 * The type of the transaction.
 * @since 2.0.0
 */
@property (assign, readonly, readonly, nonatomic) MPTransactionType type;

/**
 * The subject of the transaction.
 * @since 2.0.0
 */
@property (strong, readonly, nonatomic, nullable) NSString *subject;

/**
 * An arbitrary string to be displayed on your customer's credit card statement.
 * @note Certain limitations may apply. Please check the documentation related to the aquirers you are working with.
 * @since 2.4.9
 */
@property (strong, nonatomic, nonnull) NSString *statementDescriptor;

/**
 * An (optional) custom identifier, that can be used to reference transaction to your internal system.
 * Valid range is ([A-Z][a-z][0-9])*{0,256}.
 * @since 2.0.0
 */
@property (strong, readonly, nonatomic, nullable) NSString *customIdentifier;

/**
 * A reference to a previous transaction.
 * Required for referencing transactions (e.g. refund).
 * @since 2.0.0
 */
@property (strong, readonly, nonatomic, nullable) NSString *referencedTransactionIdentifier;

/**
 * A reference to the custom Identifier of a previous transaction
 * @since 2.4.0
 */
@property (strong, readonly, nonatomic, nullable) NSString *referencedCustomIdentifier;

/**
 * Details for a transaction template which can be required by different aquirers.
 * Please check the documentation related to the aquirers you are working with.
 * @since 2.4.9
 */
@property (strong, readonly, nonatomic, nonnull) MPTransactionTemplateDetails *details;

@end

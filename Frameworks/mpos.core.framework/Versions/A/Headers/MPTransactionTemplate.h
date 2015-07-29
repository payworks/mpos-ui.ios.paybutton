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

/**
 * A template describing the initial parameters or a transaction.
 * The template is used to register a transaction via the MPServerSubsystem category.
 * @since 2.0.0
 */
@interface MPTransactionTemplate : NSObject

/**
 * The amount of the transaction.
 * @since 2.0.0
 */
@property (strong, readonly, nonatomic) NSDecimalNumber *amount;

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
@property (strong, readonly, readonly, nonatomic) NSString *subject;

/**
 * An (optional) custom identifier, that can be used to reference transaction to your internal system.
 * Valid range is ([A-Z][a-z][0-9])*{0,256}.
 * @since 2.0.0
 */
@property (strong, readonly, nonatomic) NSString *customIdentifier;

/**
 * A reference to a previous transaction.
 * Required for referencing transactions (e.g. refund).
 * @since 2.0.0
 */
@property (strong, readonly, nonatomic) NSString *referencedTransactionIdentifier;

/*
 * A reference to the custom Identifier of a previous transaction
 * @since 2.4.0
 */
@property (strong, readonly, nonatomic) NSString *referencedCustomIdentifier;

@end

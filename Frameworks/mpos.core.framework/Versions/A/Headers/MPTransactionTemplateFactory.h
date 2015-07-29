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

@class MPTransactionTemplate;
#import "MPTransaction.h"

/**
 * The transaction temnplate factory is used to create a new transaction template that can be used to create a new transaction via the MPServerSubsystem additions.
 * @since 2.0.0
 */
@interface MPTransactionTemplateFactory : NSObject

/**
 * Creates a new template for a new transaction.
 * @param amount The amount The amount of the transaction
 * @param currency The currency of the transaction
 * @param type The type of the transaction
 * @param subject The subject of the transaction
 * @param customIdentifier The custom identifier of the transaction
 * @return A new transaction templated that can be registered
 * @since 2.0.0
 */
- (MPTransactionTemplate *)transactionTemplateWithAmount:(NSDecimalNumber *)amount currency:(MPCurrency)currency type:(MPTransactionType)type subject:(NSString *)subject customIdentifier:(NSString *)customIdentifier;


/**
 * Creates a new refund template, linking to a previous transaction. This is for looking up the actual transaction which should get refunded.
 * @param referencedTransactionIdentifier The transaction to reference
 * @param subject The subject of the transaction
 * @param customIdentifier The custom identifier of the transaction
 * @return A new transaction templated that can be registered
 * @since 2.3.0
 */
- (MPTransactionTemplate *)refundTransactionTemplateWithReferenceToPreviousTransactionIdentifier:(NSString *)referencedTransactionIdentifier subject:(NSString *)subject customIdentifier:(NSString *)customIdentifier;


/**
 * Creates a new refund template, linking to a previous transaction and providing additional payment related properties.
 * @param referencedTransactionIdentifier The transaction to reference
 * @param amount The amount The amount of the transaction
 * @param currency The currency of the transaction
 * @param subject The subject of the transaction
 * @param customIdentifier The custom identifier of the transaction
 * @return A new transaction templated that can be registered
 * @since 2.0.0
 */
- (MPTransactionTemplate *)refundTransactionTemplateWithReferenceToPreviousTransactionIdentifier:(NSString *)referencedTransactionIdentifier amount:(NSDecimalNumber *)amount currency:(MPCurrency)currency subject:(NSString *)subject customIdentifier:(NSString *)customIdentifier;

/**
 * Creates a new refund template, linking to a transaction which was looked up.
 * @param transaction The transaction for linking
 * @param subject The subject of the transaction
 * @param customIdentifier The custom identifier of the transaction
 * @return A new transaction template that can be used for a refund without card present
 * @since 2.3.0
 */
- (MPTransactionTemplate *)refundTransactionTemplateWithReferenceToPreviousTransaction:(MPTransaction *)transaction subject:(NSString *)subject customIdentifier:(NSString *)customIdentifier;

/**
 * Creates a new refund template, linking to a transaction with the given custom identifier
 * @param customIdentifier the customIdentifier for linking
 * @param subject The subject of the transaction
 * @param refundCustomIdentifier the customIdentifier of the refund
 * @return A new transaction template that can be used for a refund without card present
 */
- (MPTransactionTemplate *)refundTransactionTemplateWithReferenceToCustomIdentifier:(NSString *)customIdentifier subject:(NSString *)subject refundCustomIdentifier:(NSString *)refundCustomIdentifier;

@end

//
// PAYWORKS GMBH ("COMPANY") CONFIDENTIAL
// Copyright (c) 2015 payworks GmbH, All Rights Reserved.
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
 * Protocol implemented by the optionals object, on which additional parameters for a transaction can be set
 * @see MPTransactionParameters for parameters description
 * @since 2.5.0
 */
@protocol MPTransactionParametersOptionals <NSObject>

/**
 * The subject of the transaction.
 * @since 2.5.0
 */
@property (nonatomic, nullable) NSString* subject;

/**
 * An custom identifier, that can be used to reference transaction to your internal system.
 * Valid range is ([A-Z][a-z][0-9])*{0,256}.
 * @since 2.5.0
 */
@property (nonatomic, nullable) NSString* customIdentifier;

/**
 * An arbitrary string to be displayed on your customer's credit card statement.
 * @note Certain limitations may apply. Please check the documentation related to the aquirers you are working with.
 * @since 2.5.0
 */
@property (nonatomic, nullable) NSString* statementDescriptor;

/**
 * The fee that will be added to the transaction costs.
 * @since 2.5.0
 */
@property (nonatomic, nullable) NSDecimalNumber* applicationFee;

/**
 * A set of key/value pairs that you can attach to a charge object.
 * @note Size limits may apply! Please check the documentation related to aquirers you work with
 * @since 2.5.0
 */
@property (nonatomic, nullable) NSDictionary* metadata;

@end


/**
 * Protocol implemented by the refund optionals object, on which additional parameters for a transaction can be set
 * @see MPTransactionParameters for parameters description
 * @since 2.5.0
 */
@protocol MPTransactionParametersRefundOptionals <NSObject>

/**
 * The subject of the transaction.
 * @since 2.5.0
 */

@property (nonatomic, nullable) NSString* subject;
/**
 * An custom identifier, that can be used to reference transaction to your internal system.
 * Valid range is ([A-Z][a-z][0-9])*{0,256}.
 * @since 2.5.0
 */
@property (nonatomic, nullable) NSString* customIdentifier;

/**
 * Sets the amount and currency.
 * @param amount The amount.
 * @param currency The currency.
 * @since 2.5.0
 */
- (void)setAmount:(nonnull NSDecimalNumber*)amount currency:(MPCurrency)currency;

@end


/**
 * Optionals callback definition, providing access to an object to set optional parameters for a transaction.
 * @param optionals Object to set optional parameters on.
 * @since 2.5.0
 */
typedef void (^MPTransactionParametersOptionalsBlock)(id<MPTransactionParametersOptionals>_Nonnull optionals);

/**
 * Optionals callback definition, providing access to an object to set optional parameters for a refund.
 * @param optionals Object to set optional parameters on.
 * @since 2.5.0
 */
typedef void (^MPTransactionParametersRefundOptionalsBlock)(id<MPTransactionParametersRefundOptionals>_Nonnull optionals);


/**
 * Transaction parameters that describe the initial parameters of a transaction.
 * The parameters are used to register a transaction via the MPServerSubsystem category.
 * @since 2.5.0
 */
@interface MPTransactionParameters : NSObject

/**
 * The type of the transaction.
 * @since 2.5.0
 */
@property (nonatomic, readonly, assign) MPTransactionType transactionType;

/**
 * The amount of the transaction.
 * @since 2.5.0
 */
@property (nonatomic, readonly, copy, nullable) NSDecimalNumber *amount;

/**
 * The currency of the transaction.
 * @since 2.5.0
 */
@property (nonatomic, readonly, assign) MPCurrency currency;

/**
 * A reference to a previous transaction.
 * Required for referencing transactions (e.g. refund).
 * @since 2.5.0
 */
@property (nonatomic, readonly, copy, nullable) NSString *referencedTransactionIdentifier;

/**
 * A reference to the custom identifier of a previous transaction
 * @since 2.5.0
 */
@property (nonatomic, readonly, copy, nullable) NSString *referencedCustomIdentifier;

/**
 * The subject of the transaction.
 * @since 2.5.0
 */
@property (nonatomic, readonly, copy, nullable) NSString *subject;

/**
 * An (optional) custom identifier, that can be used to reference transaction to your internal system.
 * Valid range is ([A-Z][a-z][0-9])*{0,256}.
 * @throws NSException if customerIdentifier is not in the valid range when set on the optionals object. Nil and Empty value is OK.
 * @since 2.5.0
 */
@property (nonatomic, readonly, copy, nullable) NSString *customIdentifier;

/**
 * An arbitrary string to be displayed on your customer's credit card statement.
 * @note Certain limitations may apply. Please check the documentation related to the aquirers you are working with.
 * @since 2.5.0
 */
@property (nonatomic, readonly, copy, nullable) NSString *statementDescriptor;

/**
 * The fee that will be added to the transaction costs.
 * @since 2.5.0
 */
@property (nonatomic, readonly, copy, nullable) NSDecimalNumber *applicationFee;

/**
 * A set of key/value pairs that you can attach to a charge object.
 * @note Size limits may apply! Please check the documentation related to aquirers you work with
 * @since 2.5.0
 */
@property (nonatomic, readonly, copy, nullable) NSDictionary *metadata;


/**
 * Creates parameters for a new charge transaction.
 * @param amount The amount The amount of the transaction
 * @param currency The currency of the transaction
 * @param optionalsBlock A block that has one argument - an object on which optional parameters can be set. Can be null.
 * @return A new transaction parameters object that can be used to start a transaction
 * @throws NSException if amount is nil or NaN
 * @since 2.5.0
 */
+ (nonnull instancetype)chargeWithAmount:(nonnull NSDecimalNumber*)amount currency:(MPCurrency)currency optionals:(nullable MPTransactionParametersOptionalsBlock)optionalsBlock;


/**
 * Creates parameters for a refund transaction, linking to a previous transaction. This is for looking up the actual transaction which should get refunded.
 * @param transactionIdentifier The transaction to reference
 * @param optionalsBlock A block that has one argument - an object on which optional parameters can be set. Can be null.
 * @return A new transaction parameters object that can be used to start a refund transaction
 * @since 2.5.0
 */
+ (nonnull instancetype)refundForTransactionIdentifier:(nonnull NSString*)transactionIdentifier optionals:(nullable MPTransactionParametersRefundOptionalsBlock)optionalsBlock;


/**
 * Creates parameters for a refund transaction, linking to a transaction with the given custom identifier. This is for looking up the actual transaction which should get refunded.
 * @param customIdentifier The customIdentifier of the linked transaction
 * @param optionalsBlock A block that has one argument - an object on which optional parameters can be set. Can be null.
 * @return A new transaction parameters object that can be used to start a refund transaction
 * @since 2.5.0
 */
+ (nonnull instancetype)refundForCustomIdentifier:(nonnull NSString*)customIdentifier optionals:(nullable MPTransactionParametersRefundOptionalsBlock)optionalsBlock;

@end

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
 * Features offered by the payment accessory.
 * @since 2.0.0
 */
typedef NS_OPTIONS(NSUInteger, MPPaymentAccessoryFeature){
    /** Unknown or not available */
    MPPaymentAccessoryFeatureNone                               = 0,
    
    /** Magnetic stripe reader */
    MPPaymentAccessoryFeatureMagneticStripe                     = 1 << 0,
    /** ICC/EMV chip reader */
    MPPaymentAccessoryFeatureICC                                = 1 << 1,
    /** NFC Connectivity */
    MPPaymentAccessoryFeatureNFC                                = 1 << 2,
    
    /** EMV transaction processing */
    MPPaymentAccessoryFeatureEMVKernel                          = 1 << 3,
    
    /** SRED encryption for sensitive card details */
    MPPaymentAccessoryFeatureSREDEncryption                     = 1 << 4,
    /** PIN encryption for online PIN verification */
    MPPaymentAccessoryFeaturePINEncryption                      = 1 << 5,
    
    /** Keypad on the accessory */
    MPPaymentAccessoryFeatureKeypad                             = 1 << 6,
    /** Display on the accessory */
    MPPaymentAccessoryFeatureDisplay                            = 1 << 7,
    
    /** Capable of online transaction */
    MPPaymentAccessoryFeatureOnlineTransactions                 = 1 << 8,
    /** Capable of offline transactions */
    MPPaymentAccessoryFeatureOfflineTransactions                = 1 << 9,

    /** Offline PIN verification */
    MPPaymentAccessoryFeatureOfflinePIN                         = 1 << 10,
    /** Supports abort with key on device*/
    MPPaymentAccessoryFeatureAbortWithKey                       = 1 << 11,
    /** Supports card present refunds */
    MPPaymentAccessoryFeatureRefund                             = 1 << 12
};


/**
 * Features that are required by the payment accessory
 * @since 2.0.1
 */
typedef NS_OPTIONS(NSUInteger, MPPaymentAccessoryRequirement) {
    
    /** No requirements*/
    MPPaymentAccessoryRequirementNone                           = 0,
    
    /** Ask user confirmation for amount*/
    MPPaymentAccessoryRequirementAmountConfirmation             = 1 << 0,
    
    /** Indicates if the accessory requires an authentication before any updates can be installed */
    MPPaymentAccessoryRequirementAuthenticationBeforeUpdate     = 1 << 1,
    
    /** Indicates that the accessory needs a manual interaction in order to enable NFC transaction (upgrade from ICC/Magstripe to NFC) */
    MPPaymentAccessoryRequirementManualNFCActivation            = 1 << 2,
    
    /** Indicates that the accessory requires special treatment due to contactless limitations */
    MPPaymentAccessoryRequirementContactlessOnlyWorkaround      = 1 << 3,
};


/**
 * Completion handler for displaying text on the accessory.
 * @since 2.0.0
 */
typedef void (^MPPaymentAccessoryDisplayTextSuccess)(MPAccessory * _Nonnull accessory, NSArray * _Nonnull text);
/**
 * Failure handler for displaying text on the accessory.
 * @param error Error that occurred during the process
 * @since 2.0.0
 */
typedef void (^MPPaymentAccessoryDisplayTextFailure)(MPAccessory * _Nonnull accessory, NSArray * _Nonnull text, NSError * _Nonnull error);


/**
 * Completion handler for displaying the idle screen on the accessory.
 * @since 2.0.0
 */
typedef void (^MPPaymentAccessoryDisplayIdleScreenSuccess)(MPAccessory * _Nonnull accessory);
/**
 * Failure handler for displaying the idle screen on the accessory.
 * @param error Error that occurred during the process
 * @since 2.0.0
 */
typedef void (^MPPaymentAccessoryDisplayIdleScreenFailure)(MPAccessory * _Nonnull accessory, NSError * _Nonnull error);


/**
 * Contains specific information related to a payment accessory.
 * @since 2.0.0
 */
@interface MPPaymentAccessory : MPAccessory

#pragma mark - General Information
/** @name Display and Locale Information */

/**
 * The language to use for displaying infos and prompts.
 * @since 2.0.0
 */
@property (assign, readonly, nonatomic) MPLocale locale;

/**
 * The text that should be displayed when the accessory is connected but in idle mode.
 * @since 2.0.0
 */
@property (strong, readonly, nonatomic, nonnull) NSArray *idleScreenText;



#pragma mark -
#pragma mark Payment Specific
/** @name PaymentSpecific */

/**
 * Features offered by the payment accessory (bitwise OR of available features).
 * @since 2.0.0
 */
@property (assign, readonly, nonatomic) MPPaymentAccessoryFeature features;

/**
 * Features that are required by the payment accessory (bitwise OR of available features).
 * @since 2.0.1
 */
@property (assign, readonly, nonatomic) MPPaymentAccessoryRequirement requirements;




#pragma mark -
#pragma mark Accessory Interaction
/** @name Accessory Interaction */

/**
 * Displays the idle screen on the accessory.
 * @param text The text to display on the accessory
 * @param success Success handler to be notified about the result
 * @param failure Failure handler to be notified
 * @throws NSException if the parameters are invalid
 * @since 2.0.0
 */
- (void)displayText:(nonnull NSArray *)text success:(nonnull MPPaymentAccessoryDisplayTextSuccess)success failure:(nonnull MPPaymentAccessoryDisplayTextFailure)failure;


/**
 * Displays the idle screen on the accessory.
 * @param success Success handler to be notified about the result
 * @param failure Failure handler to be notified
 * @throws NSException if the parameters are invalid
 * @since 2.0.0
 */
- (void)displayIdleScreenWithSuccess:(nonnull MPPaymentAccessoryDisplayIdleScreenSuccess)success failure:(nonnull MPPaymentAccessoryDisplayIdleScreenFailure)failure;

@end


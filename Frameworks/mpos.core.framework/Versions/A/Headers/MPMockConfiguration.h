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


#import "MPAccessoryUpdateRequirement.h"
#import "MPPaymentDetails.h"

/**
 * Defines the transaction outcome on the accessory.
 * @since 2.2.0
 */
typedef NS_ENUM(NSUInteger, MPMockConfigurationPaymentAccessoryBehavior){
    
    /** The payment is approved with no customer verification */
    MPMockConfigurationPaymentAccessoryBehaviorApprove = 0,
    /** The payment is declined offline */
    MPMockConfigurationPaymentAccessoryBehaviorDeclineOffline,
    /** The payment is declined after online authorization */
    MPMockConfigurationPaymentAccessoryBehaviorDeclineOnline,
    /** The payment is aborted by the customer. If PinAsk option is set then the last pin entry will be canceled by user, else it's a card removed. */
    MPMockConfigurationPaymentAccessoryBehaviorAbort,
    /** The payment fails due to an error */
    MPMockConfigurationPaymentAccessoryBehaviorError
};


/**
 * Defines the accessory behavior during an ongoing transaction.
 * @since 2.1.0
 */
typedef NS_OPTIONS(NSUInteger, MPMockConfigurationPaymentAccessoryOptions) {
    /** None*/
    MPMockConfigurationPaymentAccessoryOptionNone                               = 0,
    /** A mock pin will be entered with the respective notifications */
    MPMockConfigurationPaymentAccessoryOptionPINAskOK                           = 1 << 0,
    /** Wrong pin will be entered and the transaction will fail*/
    MPMockConfigurationPaymentAccessoryOptionPINWrong                           = 1 << 1,
    /** First insertion of pin will be wrong and a retry will be notified. Is Ignored if PinAskOk or PinWrong is not set.*/
    MPMockConfigurationPaymentAccessoryOptionPINRetry                           = 1 << 2,
    /** Pin will be inserted wrong twice, after the fail a "last try" notification will be sent. Ignores the PINRetry option.
     Is Ignored if PinAskOk or PinWrong is not set.*/
    MPMockConfigurationPaymentAccessoryOptionPINLastTry                         = 1 << 3,
    /** Signature will be asked, if the result of the callback is NO then the transaction will fail regardless of accessory's and gateway's set behavior*/
    MPMockConfigurationPaymentAccessoryOptionAskSignature                       = 1 << 4
};


/**
 * Defines the payment source that is used during a transaction.
 * @since 2.2.0
 */

typedef NS_ENUM(NSUInteger, MPMockConfigurationPaymentAccessorySource){
    
    /** The payment is done with an EMV card */
    MPMockConfigurationPaymentAccessorySourceICC = 0,
    /** The payment is done witn an EMV card with multiple applications, thus the app selection callback will be executed*/
    MPMockConfigurationPaymentAccessorySourceICCWithMultipleApps,
    /** The payment is done with a magstripe card */
    MPMockConfigurationPaymentAccessorySourceMagstripe
};


/**
 * Defines the server outcome for a transaction.
 * @since 2.2.0
 */
typedef NS_ENUM(NSUInteger, MPMockConfigurationGatewayBehavior){
    /** The payment is approved by the bank */
    MPMockConfigurationGatewayBehaviorApprove = 0,
    /** The payment is declined by the bank */
    MPMockConfigurationGatewayBehaviorDecline,
    /** The payment encounters an error in the register phase */
    MPMockConfigurationGatewayBehaviorErrorDuringRegister,
    /** The payment encounters an error in the lookup phase */
    MPMockConfigurationGatewayBehaviorErrorDuringLookup,
    /** The payment encounters an error in the execute phase */
    MPMockConfigurationGatewayBehaviorErrorDuringExecute,
    /** The payment encounters an error in the finalize phase */
    MPMockConfigurationGatewayBehaviorErrorDuringFinalizeOrVoid,
    /** The refund encounters an error in the finalize phase */
    MPMockConfigurationGatewayBehaviorErrorDuringRefundWithoutCard
};

/**
 * Defines the payment source that is used during a transaction.
 * @since 2.2.0
 */

typedef NS_ENUM(NSUInteger, MPMockConfigurationPrinterAccessoryBehaviour){
    
    /** Printer works normally */
    MPMockConfigurationPrinterAccessoryBehaviourNormal = 0,
    /** Printer is busy */
    MPMockConfigurationPrinterAccessoryBehaviourBusy,
    /** Printer is low or out of paper */
    MPMockConfigurationPrinterAccessoryBehaviourPaperEmpty,
    /** The printer's cover is open */
    MPMockConfigurationPrinterAccessoryBehaviourCoverOpen
};

/**
 * The gateway behavior for an ongoing transaction.
 * @since 2.2.0
 */

typedef NS_OPTIONS(NSUInteger, MPMockConfigurationGatewayOptions){
    
    /** None*/
    MPMockConfigurationGatewayOptionNone = 0,
    /** Customers id check will be required. If the returned result is NO then the transaction will fail */
    MPMockConfigurationGatewayOptionRequireIdentification
};


/**
 * Defines the behavior an update check should mimic.
 * @since 2.2.0
 */
typedef NS_ENUM(NSUInteger, MPMockConfigurationMockUpdateBehavior) {
    
	/** No updates are available */
	MPMockConfigurationMockUpdateBehaviorNoUpdate = 0,
	/** Update is available */
	MPMockConfigurationMockUpdateBehaviorUpdateAvailableAndRequired,
	/** Will fail when checking for update requirements */
	MPMockConfigurationMockUpdateBehaviorErrorDuringCheckRequirements,
	/** Will fail when trying to update the accessory */
	MPMockConfigurationMockUpdateBehaviorErrorDuringUpdate
};


/**
 * Configuration describing the mocking behavior of the SDK.
 * @since 2.0.0
 */
@interface MPMockConfiguration : NSObject


/**
 * The behavior of the payment workflow.
 * @since 2.0.0
 */
@property (assign, nonatomic) MPMockConfigurationPaymentAccessoryBehavior paymentAccessoryBehavior;

/**
 * The options of the payment workflow.
 * @since 2.2.0
 */
@property (assign, nonatomic) MPMockConfigurationPaymentAccessoryOptions paymentAccessoryOptions;

/**
 * The payment source to use, e.g. a EMV card.
 * @since 2.0.0
 */
@property (assign, nonatomic) MPMockConfigurationPaymentAccessorySource paymentAccessorySource;

/**
 * Scheme that will be used for the mock card.
 * Currently only MPPaymentDetailsSchemeMasterCard and MPPaymentDetailsSchemeVISA are supported. If the mock is
 * provided with other value then it will default to MPPaymentDetailsSchemeVISA
 * @since 2.2.0
 */
@property (assign, nonatomic) MPPaymentDetailsScheme paymentAccessoryCardScheme;

/**
 * The behavior of the printing workflow.
 * @since 2.4.0
 */
@property (assign, nonatomic) MPMockConfigurationPrinterAccessoryBehaviour printerAccessoryBehavior;

/**
 * The behavior of the processor.
 * @since 2.0.0
 */
@property (assign, nonatomic) MPMockConfigurationGatewayBehavior gatewayBehavior;

/**
 * The options of the processor.
 * @since 2.0.0
 */
@property (assign, nonatomic) MPMockConfigurationGatewayOptions gatewayOptions;


/**
 * The behavior of the update workflow
 * @since 2.2.0
 */
@property (assign, nonatomic) MPMockConfigurationMockUpdateBehavior updateBehavior;


/**
 * Update requirement that will be used for the chekUpdateRequirements response
 * @since 2.2.0
 */
@property (assign, nonatomic) MPAccessoryUpdateRequirementComponent updateRequirementComponent;

/**
 * Adds a random delay interval to the response callbacks, simulating user behavior and network delay.
 * @param minimumDelay The minimum delay to use, defaults to 1s
 * @param maximumDelay The maximum delay to use, defaults to 2s
 * @since 2.0.0
 */
- (void)setRandomDelayIntervalInSecondsFrom:(double)minimumDelay to:(double)maximumDelay;



@end

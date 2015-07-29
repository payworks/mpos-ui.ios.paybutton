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

/**
 * Constant describing the error domain produces by the SDK
 * @since 2.0.0
 */
extern NSString *const MPErrorDomainKey;


/**
 * Constant describing the key for the error source
 * @since 2.0.0
 */
extern NSString *const MPErrorSourceKey;
/**
 * Constant describing the key for the error type
 * @since 2.0.0
 */
extern NSString *const MPErrorTypeKey;

/**
 * Constant describing the key for the error description
 * @since 2.0.0
 */
extern NSString *const MPErrorInfoKey;
/**
 * Constant describing the key for the error developer description
 * @since 2.0.0
 */
extern NSString *const MPErrorDeveloperInfoKey;
/**
 * Constant describing the key for the error localized description, also available for NSLocalizedDescriptionKey
 * @since 2.0.0
 */
extern NSString *const MPErrorLocalizedDescriptionKey;

/**
 * Enum describing the class of the error.
 * @since 2.0.0
 */
typedef NS_ENUM(NSUInteger, MPErrorSource) {
    /** Unknown class, not a MP error */
    MPErrorSourceUnknown = 0,
    /** Parameters provided for a method are invalid */
    MPErrorSourceParameter,
    /** The accessory params are invalid or the accessory caused an error */
    MPErrorSourceAccessory,
    /** The transaction parameters are invalid or the transaction caused an error */
    MPErrorSourceTransaction,
    /** The network connection caused an error for the transaction */
    MPErrorSourceServer,
    /** The system integrity check caused an error */
    MPErrorSourceSDK,
    /** An internal error occured */
    MPErrorSourceInternal
};


/**
 * Enum describing the various errors that are produced by the framework.
 * @since 2.0.0
 */
typedef NS_ENUM(NSUInteger, MPErrorType){
    /** Unknown error */
    MPErrorTypeUnknown = 0,
    //1
    /** A parameter is missing (e.g. nil) */
    MPErrorTypeParameterMissing,
    /** A parameter has an invalid format (e.g. empty) */
    MPErrorTypeParameterInvalid,
    //3
    /** The accessory was not found */
    MPErrorTypeAccessoryNotFound,
    /** The accessory is currently not connected or unavailable */
    MPErrorTypeAccessoryNotConnected,
    /** The accessory is already connected */
    MPErrorTypeAccessoryAlreadyConnected,
    /** The accessory is no longer connected */
    MPErrorTypeAccessoryAlreadyDisconnected,
    /** The accessory is busy with another task */
    MPErrorTypeAccessoryBusy,
    /** The accessory is not whitelisted and cannot be used */
    MPErrorTypeAccessoryNotWhitelisted,
    /** The accessory has been deactivated */
    MPErrorTypeAccessoryDeactivated,
    /** The accessory requires an update in order to continue */
    MPErrorTypeAccessoryRequiresUpdate,
    /** The battery level of the accessory is low and must be rechared in order to continue */
    MPErrorTypeAccessoryBatteryLow,
    /** The accessory has been tampered with and is no longer usable */
    MPErrorTypeAccessoryTampered,
    /** An error occured while communicating with the device */
    MPErrorTypeAccessoryError, //invalid response
    /** Accessory component not found */
    MPErrorTypeAccessoryComponentNotFound,
    /** The printer is currently busy */
    MPErrorTypeAccessoryComponentPrinterBusy,
    /** The printer ran out of paper */
    MPErrorTypeAccessoryComponentPrinterPaperLowOrOut,
    /** The cover of the printer is open */
    MPErrorTypeAccessoryComponentPrinterCoverOpen,
    
    //17
    /** The provided session was not found */
    MPErrorTypeTransactionSessionNotFound,
    /** The provided reference was not found */
    MPErrorTypeTransactionReferenceNotFound,
    /** The transaction is invalid */
    MPErrorTypeTransactionInvalid,
    /** The transaction is already being used in another context */
    MPErrorTypeTransactionBusy,
    /** The transaction is no longer abortable */
    MPErrorTypeTransactionNoLongerAbortable,
    /** The transaction was declined */
    MPErrorTypeTransactionDeclined,
    /** The transaction was aborted */
    MPErrorTypeTransactionAborted,
    /** An error occured while processing the transaction */
    MPErrorTypeTransactionError,
    /** The action was handled using an incorrect response */
    MPErrorTypeTransactionActionError,
    //26
    /** The server is unavailable */
    MPErrorTypeServerUnavailable,
    /** Authentication with the server failed, credential missmatch */
    MPErrorTypeServerAuthenticationFailed,
    /** Missing / malformed username */
    MPErrorTypeServerUnknownUsername,
    /** SSL pinning failed, had to cancel authentication*/
    MPErrorTypeServerPinningWithRemoteFailed,
    /** Timout from the server received */
    MPErrorTypeServerTimeout,
    /** The server returned an error */
    MPErrorTypeServerError, //invalid response
    //31
    /** Required resources were not found */
    MPErrorTypeSDKResourcesNotFound,
    /** Required resources were modified and are invalid */
    MPErrorTypeSDKResourcesModified,
    /** Configuration data is missng */
    MPErrorTypeSDKConfigurationMissing,
    //34
    /** The SDK reached an inconsistent state */
    MPErrorTypeInternalInconsistency
};

/**
 * Additions to NSError, offering specific error descriptions and recovery information.
 * @since 2.0.0
 */
@interface NSError (MPAdditions)

/**
 * Class of the error, provides the general source of the error.
 * @since 2.0.0
 */
@property (assign, readonly, nonatomic) MPErrorSource source;

/**
 * Unique code of the error, providing a general error reason.
 * @since 2.0.0
 */
@property (assign, readonly, nonatomic) MPErrorType type;

/**
 * A human readable description of the error.
 * @since 2.0.0
 */
@property (strong, readonly, nonatomic) NSString *info;

/**
 * A more specific description of the error, also gives hints on how to resolve it.
 * @since 2.0.0
 */
@property (strong, readonly, nonatomic) NSString *developerInfo;

/**
 * Checks if the NSError resulted from the framework domain.
 * @return YES if the domain is MPErrorDomainKey, NO otherwise
 * @since 2.0.0
 */
- (BOOL)isMPError;

@end

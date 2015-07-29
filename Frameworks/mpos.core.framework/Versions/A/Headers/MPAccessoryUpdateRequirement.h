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
 * The status and priority of an update.
 * @since 2.0.0
 */
typedef NS_ENUM(NSUInteger, MPAccessoryUpdateRequirementStatus){
    /** No update is available, proceed as planned  */
    MPAccessoryUpdateRequirementStatusNoUpdateAvailable = 0,
    /** Update is available and must be installed before the next transaction */
    MPAccessoryUpdateRequirementStatusUpdateAvailableAndRequired,
    /** Update is available, but the current config ist still supported for a limited amount of time (max. 24h) */
    MPAccessoryUpdateRequirementStatusUpdateAvailableButInGracePeriod
};

/**
 * The components that might require an update.
 * @since 2.0.0
 */
typedef NS_OPTIONS(NSUInteger, MPAccessoryUpdateRequirementComponent){
    /** No component is required */
    MPAccessoryUpdateRequirementComponentNone           = 0,
    /** The software must be updated */
    MPAccessoryUpdateRequirementComponentSoftware       = 1 << 0,
    /** A new configuration needs to be placed on the accessory, */
    MPAccessoryUpdateRequirementComponentConfiguration  = 1 << 1,
    /** The accessory needs new encryption keys or other security related settings */
    MPAccessoryUpdateRequirementComponentSecurity       = 1 << 2,
    /** The OS or firmware of the accessory must be updated */
    MPAccessoryUpdateRequirementComponentFirmware       = 1 << 3
};


/**
 * The result of an update check for the acessory.
 * @since 2.0.0
 */
@interface MPAccessoryUpdateRequirement : NSObject

/**
 * The priority indicating if and when an update needs to be executed.
 * @since 2.0.0
 */
@property (assign, readonly, nonatomic) MPAccessoryUpdateRequirementStatus status;

/**
 * The components that will be updated during the next update cycle.
 * @since 2.0.0
 */
@property (assign, readonly, nonatomic) MPAccessoryUpdateRequirementComponent affectedComponents;

@end

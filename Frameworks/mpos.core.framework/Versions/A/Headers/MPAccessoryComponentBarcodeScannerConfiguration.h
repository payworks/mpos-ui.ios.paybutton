//
// PAYWORKS GMBH ("COMPANY") CONFIDENTIAL
// Copyright (c) 2014 payworks GmbH, All Rights Reserved.
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
 * The available trigger modes.
 * @since 2.2.0
 */
typedef NS_ENUM(int, MPBarcodeTriggerMode) {
    /** Edge trigger */
    MPBarcodeTriggerModeEdge = 0,
    /** Level trigger */
    MPBarcodeTriggerModeLevel,
    /** Soft trigger */
    MPBarcodeTriggerModeSoft,
    /** Passive trigger */
    MPBarcodeTriggerModePassive
};

/**
 * The available scan modes.
 * @since 2.2.0
 */
typedef NS_ENUM(int, MPBarcodeScanMode) {
    /** 1d only mode */
    MPBarcodeScanMode1D = 0,
    /** 1D and 2D modes */
    MPBarcodeScanMode1D2D
};

/**
 * The available continuous modes.
 * @since 2.2.0
 */
typedef NS_ENUM(int, MPBarcodeContinuousMode) {
    /** Continuous mode disabled */
    MPBarcodeContinuousModeDisabled = 0,
    /** Continuous mode enabled */
    MPBarcodeContinuousModeEnabled
};


/**
 * Configuration for the barcode component.
 * @since 2.2.0
 */
@interface MPAccessoryComponentBarcodeScannerConfiguration : NSObject

/**
 * The triger mode when detecing barcodes and how
 * @since 2.2.0
 */
@property (assign, nonatomic) MPBarcodeTriggerMode triggerMode;

/**
 * The types of barcodes to detect.
 * @since 2.2.0
 */
@property (assign, nonatomic) MPBarcodeScanMode scanMode;

/**
 * Sets the continuous mode on the scanner.
 * @since 2.2.0
 */
@property (assign, nonatomic) MPBarcodeContinuousMode continuousMode;

@end

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
 * The available trigger modes that control the behavior of the scanner itself.
 * @since 2.2.0
 */
typedef NS_ENUM(int, MPAccessoryComponentBarcodeScannerConfigurationTriggerMode) {
    /** Edge trigger. Scanning starts with pressing a button and stops when its pressed again. */
    MPAccessoryComponentBarcodeScannerConfigurationTriggerModeEdge = 0,
    /** Level trigger. Scanning starts with pressing a button, continues while holding the button and then stops when its released again. */
    MPAccessoryComponentBarcodeScannerConfigurationTriggerModeLevel,
    /** Soft trigger. Scanning is on all the time and the buttons do not have any effect on the scan. */
    MPAccessoryComponentBarcodeScannerConfigurationTriggerModeSoft,
    /** Passive trigger. Scanning is on all the time and no button press is reported back. */
    MPAccessoryComponentBarcodeScannerConfigurationTriggerModePassive
};

/**
 * The available scan modes.
 * @since 2.2.0
 */
typedef NS_ENUM(int, MPAccessoryComponentBarcodeScannerConfigurationScanMode) {
    /** 1D only mode. Detects only 1D barcodes. */
    MPAccessoryComponentBarcodeScannerConfigurationScanMode1D = 0,
    /** 1D and 2D modes. Detects 1D and 2D barcodes. */
    MPAccessoryComponentBarcodeScannerConfigurationScanMode1D2D
};

/**
 * The available continuous modes.
 * @since 2.2.0
 */
typedef NS_ENUM(int, MPAccessoryComponentBarcodeScannerConfigurationContinuousMode) {
    /** Continuous mode disabled. */
    MPAccessoryComponentBarcodeScannerConfigurationContinuousModeDisabled = 0,
    /** Continuous mode enabled. */
    MPAccessoryComponentBarcodeScannerConfigurationContinuousModeEnabled
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
@property (assign, nonatomic) MPAccessoryComponentBarcodeScannerConfigurationTriggerMode triggerMode;

/**
 * The types of barcodes to detect.
 * @since 2.2.0
 */
@property (assign, nonatomic) MPAccessoryComponentBarcodeScannerConfigurationScanMode scanMode;

/**
 * Sets the continuous mode on the scanner.
 * @since 2.2.0
 */
@property (assign, nonatomic) MPAccessoryComponentBarcodeScannerConfigurationContinuousMode continuousMode;

@end


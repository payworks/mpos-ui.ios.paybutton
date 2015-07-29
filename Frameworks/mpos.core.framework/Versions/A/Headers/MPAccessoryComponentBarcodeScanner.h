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


#import "MPAccessoryComponent.h"
#import "MPBarcodeScanData.h"

@class MPAccessoryComponentBarcodeScannerConfiguration;
@class MPAccessoryComponentBarcodeScanner;

typedef void (^MPBarcodeComponentStartScanSuccess)(MPAccessoryComponentBarcodeScanner *component);
typedef void (^MPBarcodeComponentScan)(MPAccessoryComponentBarcodeScanner *component, MPBarcodeScanData *data);
typedef void (^MPBarcodeComponentButton)(MPAccessoryComponentBarcodeScanner *component, NSUInteger buttonStatus);
typedef void (^MPBarcodeComponentStartScanFailure)(MPAccessoryComponentBarcodeScanner *component, NSError *error) ;


typedef void (^MPBarcodeComponentStopScanSuccess)(MPAccessoryComponentBarcodeScanner *component);
typedef void (^MPBarcodeComponentStopScanFailure)(MPAccessoryComponentBarcodeScanner *component, NSError *error);


/**
 * Component providing access to barcode scanning features of the accessory.
 * @since 2.4.0
 */
@interface MPAccessoryComponentBarcodeScanner : MPAccessoryComponent

/**
 * Starts a new scan and appls an updated configuration before starting.
 * @param configuration The configuration to apply to the barcode scanner
 * @param success The success handler called when the scan was successfully started
 * @param scan Callback for scanned barcodes during the scan process
 * @param button Callback for pressed buttons during the scan proces
 * @param failure The failure handler called when the scan failed
 * @since 2.2.0
 */
- (void)startScanWithConfiguration:(MPAccessoryComponentBarcodeScannerConfiguration *)configuration
          success:(MPBarcodeComponentStartScanSuccess)success
             scan:(MPBarcodeComponentScan)scan
           button:(MPBarcodeComponentButton)button
          failure:(MPBarcodeComponentStartScanFailure)failure;


/**
 * Starts a new scan without applying an updated configuration first.
 * @param success The success handler called when the scan was successfully started
 * @param scan Callback for scanned barcodes during the scan process
 * @param button Callback for pressed buttons during the scan proces
 * @param failure The failure handler called when the scan failed
 * @since 2.2.0
 */
- (void)startScanWithSuccess:(MPBarcodeComponentStartScanSuccess)success
             scan:(MPBarcodeComponentScan)scan
           button:(MPBarcodeComponentButton)button
          failure:(MPBarcodeComponentStartScanFailure)failure;


/**
 * Stops an ongoing scan.
 * @param success The success handler called when the abort was successful
 * @param failure The failure handler called when the abort failed
 * @since 2.2.0
 */
- (void)stopScan:(MPBarcodeComponentStopScanSuccess)success
         failure:(MPBarcodeComponentStopScanFailure)failure;
@end
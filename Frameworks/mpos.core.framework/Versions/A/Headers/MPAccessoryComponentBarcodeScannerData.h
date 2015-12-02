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
 *
 * Object containting information about the scanned barcode. If available, the type and actual barcode are extracted.
 * Otherwise the raw responses and the raw barcode are available for access
 * @since 2.3.0
 */
typedef NS_ENUM(NSUInteger, MPAccessoryComponentBarcodeScannerConfigurationBarcodeType) {
    /** An unknown barcode */
    MPAccessoryComponentBarcodeScannerConfigurationBarcodeTypeUnknown = 0,
    /** EAN barcode */
    MPAccessoryComponentBarcodeScannerConfigurationBarcodeTypeUpcEan,
    /** Code39 barcode */
    MPAccessoryComponentBarcodeScannerConfigurationBarcodeTypeCode39,
    /** Code 128 barcode */
    MPAccessoryComponentBarcodeScannerConfigurationBarcodeTypeCode128,
    /** PDF417 barcode */
    MPAccessoryComponentBarcodeScannerConfigurationBarcodeTypePdf417,
    /** QR code */
    MPAccessoryComponentBarcodeScannerConfigurationBarcodeTypeQr,
    /** Invalid barcode scanned */
    MPAccessoryComponentBarcodeScannerConfigurationBarcodeTypeInvalid
};

/**
 * Object that encapsulates information from a barcode scan.
 * @since 2.4.2
 */
@interface MPAccessoryComponentBarcodeScannerData : NSObject

/**
 * The type of the barcode that was scanned.
 * @since 2.4.2
 */
@property (assign, nonatomic) MPAccessoryComponentBarcodeScannerConfigurationBarcodeType type;

/**
 * The parsed barcode, if the barcode type is known.
 * @since 2.4.2
 */
@property (strong, nonatomic, nullable) NSString *barcode;

/**
 * The raw response from the barcode hardware.
 * @since 2.4.2
 */
@property (strong, nonatomic, nonnull) NSData *rawResponse;

/**
 * The raw barcode from the barcode hardware.
 * @since 2.4.2
 */
@property (strong, nonatomic, nonnull) NSData *rawBarcode;

@end

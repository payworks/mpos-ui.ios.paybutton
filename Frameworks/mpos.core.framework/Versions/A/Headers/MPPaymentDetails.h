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
 * The actual source of the payment details (when applying the MPTransactionInputMethod).
 * @since 2.0.0
 */
typedef NS_ENUM(NSUInteger, MPPaymentDetailsSource) {
    /** Unknown or not available */
    MPPaymentDetailsSourceUnknown = 0,
    /** Manual entry */
    MPPaymentDetailsSourceManual,
    /** The source of the payment details was a ICC chip on a card */
    MPPaymentDetailsSourceICC,
    /** The source of the payment details was a magnetic track */
    MPPaymentDetailsSourceMagneticStripe,
    /** The source of the payment details was the magnetic track, but as a fallback to ICC */
    MPPaymentDetailsSourceMagneticStripeFallback,
    /** The source of the payment details was a NFC Card in EMV mode*/
    MPPaymentDetailsSourceNFCUsingEMV,
    /** The source of the payment details was a NFC Card in Magstripe mode*/
    MPPaymentDetailsSourceNFCUsingMSD,
};

/**
 * Schemes available for a transaction.
 * @since 2.0.0
 */
typedef NS_ENUM(NSUInteger, MPPaymentDetailsScheme){
    /** Unkndown or not available */
    MPPaymentDetailsSchemeUnknown = 0,
    /** Any kind of MasterCard */
    MPPaymentDetailsSchemeMasterCard,
    /** Any kind of VISA */
    MPPaymentDetailsSchemeVISA,
    /** Any kind of VISA Electron */
    MPPaymentDetailsSchemeVISAElectron,
    /** Any kind of Maestro */
    MPPaymentDetailsSchemeMaestro,
    /** Any kind of American Express*/
    MPPaymentDetailsSchemeAmericanExpress,
    /** Any kind of JCB*/
    MPPaymentDetailsSchemeJCB,
    /** Any kind of Diners Club*/
    MPPaymentDetailsSchemeDinersClub,
    /** Any kind of Discover*/
    MPPaymentDetailsSchemeDiscover,
    /** Any kind of UnionPay*/
    MPPaymentDetailsSchemeUnionPay
};

/**
 * The verification used for a transaction.
 * @since 2.0.0
 */
typedef NS_ENUM(NSUInteger, MPPaymentDetailsCustomerVerification) {
    /** Unknown method used */
    MPPaymentDetailsCustomerVerificationUnknown = 0,
    /** No method used */
    MPPaymentDetailsCustomerVerificationNone,
    /** A signature was used */
    MPPaymentDetailsCustomerVerificationSignature,
    /** A PIN was used */
    MPPaymentDetailsCustomerVerificationPIN,
    /** A PIN and a Signature was used */
    MPPaymentDetailsCustomerVerificationPINAndSignature,
    /** The customer device was doing the verification (i.e. Apple Pay) */
    MPPaymentDetailsCustomerVerificationCustomerDevice
};


/**
 * The payment params describe the actual account information used to complete a transactions. They differ dependent on the transaction workflow and params type.
 * @since 2.0.0
 */
@interface MPPaymentDetails : NSObject

/**
 * The source of the payment params.
 * @since 2.0.0
 */
@property (assign, readonly, nonatomic) MPPaymentDetailsSource source;

/**
 * The scheme used for the transaction
 * @since 2.0.0
 */
@property (assign, readonly, nonatomic) MPPaymentDetailsScheme scheme;

/**
 * The cardholder verification used for the transaction.
 * @since 2.0.0
 */
@property (assign, readonly, nonatomic) MPPaymentDetailsCustomerVerification customerVerification;

/**
 * The (masked) account number used for the transaction.
 * @since 2.4.0
 */
@property (strong, readonly, nonatomic, nullable) NSString *accountNumber;


@end


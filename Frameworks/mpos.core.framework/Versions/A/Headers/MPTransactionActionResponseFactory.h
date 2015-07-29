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

@class MPTransactionActionResponse;
@class UIImage;
@class MPApplicationInformation;

/**
 * Factory for creating action response messages in response to action required notifications.
 * @since 2.0.0
 */
@interface MPTransactionActionResponseFactory : NSObject

/**
 * Creates a new signature response object, used for a CustomerSignature request.
 * @param signatureVerified Indicates if the presented signature matches the reference on the card
 * @param signature The signature to provide by the customer
 * @return A new response to continue the transaction
 * @throws NSException if the parameters are invalid
 * @since 2.0.0
 */
- (MPTransactionActionResponse *)responseForCustomerSignatureWithResult:(BOOL)signatureVerified signature:(UIImage *)signature;

/**
 * Creates a new signature response object, used for a CustomerSignature request given on paper.
 * @return A new response to continue the transaction
 * @throws NSException if the parameters are invalid
 * @since 2.0.0
 */
- (MPTransactionActionResponse *)responseForCustomerSignatureOnReceipt;

/**
 * Creates a new customer identification response object, used for a CustomerIdentification request.
 * @param customerVerified Indicates if the id check was successful or not
 * @return A new response to continue the transaction
 * @throws NSException if the parameters are invalid
 * @since 2.0.0
 */
 
- (MPTransactionActionResponse *)responseForCustomerIdentificationWithResult:(BOOL)customerVerified;


/**
 * Creates a new applicatio selection response object, used for a ApplicationSelection request.
 * @param application The application that was selected
 * @return A new response to continue the transaction
 * @throws NSException if the parameters are invalid
 * @since 2.0.0
 */
- (MPTransactionActionResponse *)responseForApplicationSelectionWithApplication:(MPApplicationInformation *)application;

@end

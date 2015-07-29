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


#import "MPTransaction.h"
#import "MPAccessory.h"
@class MPProvider;
@class MPDisplayUpdateSupport;

/**
 * The type of display update.
 * @since 2.0.0
 */
typedef NS_ENUM(NSUInteger, MPProviderComponentDelegateDisplayUpdateType){
    /** A normal diplay update, no additional information provided */
    MPProviderComponentDelegateDisplayUpdateTypeText = 0,
    /** A PIN display update, additonal information is available using the PIN display support wrapper */
    MPProviderComponentDelegateDisplayUpdateTypePIN
};

/**
 * Delegate protocol for provider specific event that might occur.
 * @since 2.0.0
 */
@protocol MPProviderComponentDelegate <NSObject>

@optional

/**
 * The state of an accessory changed.
 * @param accessory The accessory for which the state change occured
 * @param state The new state
 * @since 2.0.0
 */
- (void)accessory:(MPAccessory *)accessory didChangeState:(MPAccessoryState)state;

/**
 * The state of a transaction changed.
 * @param transaction The transaction for which the state change occured
 * @param state The new state
 * @param abortable Indicates if the transaction is abortable in this state
 * @since 2.0.0
 */
- (void)transaction:(MPTransaction *)transaction didChangeState:(MPTransactionState)state abortable:(BOOL)abortable;

/**
 * The provider has new information that might be displayed. Using context specific wrappers for the support, more detailed information can be accessed.
 * @param provider The provider requesting the display update
 * @param type The type of display change
 * @param text The text to display in a preformatted format
 * @param support Additional support data providing additional context data
 * @since 2.0.0
 */
- (void)provider:(MPProvider *)provider didRequestDisplayUpdateForType:(MPProviderComponentDelegateDisplayUpdateType)type text:(NSArray *)text support:(MPDisplayUpdateSupport *)support;

@end

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

#import "MPAccessory.h"

/**
 * Card events that can occur on the accessory.
 * @since 2.0.0
 */
typedef NS_ENUM(NSUInteger , MPAccessoryCardEvent) {
    /** Unkndown or not available */
    MPAccessoryCardEventUnknown = 0,
    /** A card was inserted */
    MPAccessoryCardEventInserted,
    /** A card was removed */
    MPAccessoryCardEventRemoved,
    /** A card was swuiped*/
    MPAccessoryCardEventSwiped
};

/**
 * Key press events that can occur on the accessory.
 * @since 2.0.0
 */
typedef NS_ENUM(NSUInteger , MPAccessoryKeyEvent) {
    /** Unkndown or not available */
    MPAccessoryKeyEventUnknown = 0,
    /** A number key was pressed */
    MPAccessoryKeyEventNumeric,
    /** The cancel key was pressed */
    MPAccessoryKeyEventCancel,
    /** The OK key was pressed */
    MPAccessoryKeyEventOk,
    /** The back key was pressed */
    MPAccessoryKeyEventBack
};


/**
 * Delegate protocol for accessory specific events that might occur.
 * @since 2.0.0
 */
@protocol MPAccessoryComponentDelegate <NSObject>

@optional

/**
 * The battery state of the accessory changed.
 * @param accessory The accessory for which the battery state change occured
 * @param state The new battery state of the accessory
 * @param level The new battery level of the accessory
 * @since 2.0.0
 */
- (void)accessory:(MPAccessory *)accessory didChangeBatteryState:(MPAccessoryBatteryState)state level:(NSInteger)level;

/**
 * A card was inserted or swiped.
 * @param accessory The accessory for which the card event occured
 * @param event Information about the card
 * @since 2.0.0
 */
- (void)accessory:(MPAccessory *)accessory didEmitCardEvent:(MPAccessoryCardEvent)event;

/**
 * A key was pressed on the accessory.
 * @param accessory The accessory for which the key event occured
 * @param event The key that was pressed
 * @since 2.0.0
 */
- (void)accessory:(MPAccessory *)accessory didEmitKeyEvent:(MPAccessoryKeyEvent)event;

@end

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


#pragma mark - Properties and Enums

/**
 * The category of an accessory
 * @since 2.0.0
 */
typedef NS_ENUM(NSUInteger, MPAccessoryCategory){
    /** Unkndown or not available */
    MPAccessoryCategoryUnknown = 0,
    /** The accessory is a payment device, capable of handling card interactions */
    MPAccessoryCategoryPayment,
    /** The accessory is not a payment device but contains some components */
    MPAccessoryCategoryGeneric,
};

/**
 * The type of accessory.
 * @since 2.0.0
 */
typedef NS_ENUM(NSUInteger, MPAccessoryType){
    /** Unkndown or not available */
    MPAccessoryTypeUnknown = 0,
    /** Mock */
    MPAccessoryTypeMock,
    
    /** Miura Shuttle */
    MPAccessoryTypeMiuraShuttle,
    /** Miura M010 */
    MPAccessoryTypeMiuraM010,
    /** Miura M007 */
    MPAccessoryTypeMiuraM007,
    
    /** Verifone E105 */
    MPAccessoryTypeVerifoneE105,
    /** Verifone E315 */
    MPAccessoryTypeVerifoneE315,
    /** Verifone E335 */
    MPAccessoryTypeVerifoneE335,

    /** Sewoo LKP21 */
    MPAccessoryTypeSewooLKP21,

    /** BBPOS WisePad */
    MPAccessoryTypeBBPOSWisePad,
    /** BBPOS Chipper */
    MPAccessoryTypeBBPOSChipper
};



/**
 * Workflow states the accessory can be in.
 * @since 2.0.0
 */
typedef NS_ENUM(NSUInteger, MPAccessoryState){
    /** Unkndown or not available */
    MPAccessoryStateUnknown = 0,
    /** The accessory is unavailable (either unavailable or disconnected) */
    MPAccessoryStateUnavailable,
    /** The accessory is in idle mode */
    MPAccessoryStateIdle,
    /** The accessory currently authenticating against other system */
    MPAccessoryStateAuthenticating,
    /** The accessory is currently being updated */
    MPAccessoryStateUpdating,
    /** The accessory is currently in use for various operations (e.g a transaction or other onboard fuctionality) */
    MPAccessoryStateBusy,
    /** The accessory is reconnecting*/
    MPAccessoryStateReconnecting
};



/**
 * The connection used for the accessory.
 * @since 2.0.0
 */
typedef NS_ENUM(NSUInteger, MPAccessoryConnectionType){
    /** Unkndown or not available */
    MPAccessoryConnectionTypeUnknown = 0,
    /** Connected via Bluetooth or Lightning/Dock connector (MfI program) */
    MPAccessoryConnectionTypeExternalAccessory,
    /** Connected via a direct TCP connection */
    MPAccessoryConnectionTypeTCP,
    /** Connected via the headphone jack of the device */
    MPAccessoryConnectionTypeAudioJack
};

/**
 * The connection state of the accessory.
 * @since 2.0.0
 */
typedef NS_ENUM(NSUInteger, MPAccessoryConnectionState){
    /** Unkndown or not available */
    MPAccessoryConnectionStateUnknown = 0,
    /** The accessory is connected */
    MPAccessoryConnectionStateConnected,
    /** The accessory is connected but unavailable (out of range, updating etc.) */
    MPAccessoryConnectionStateConnectedButUnavailable,
    /** The accessory is disconnected */
    MPAccessoryConnectionStateDisconnected
};

/**
 * The battery state of the accessory, if available.
 * @since 2.0.0
 */
typedef NS_ENUM(NSUInteger, MPAccessoryBatteryState){
    /** Unkndown or not available */
    MPAccessoryBatteryStateUnknown = 0,
    /** The device is unplugged and using the battery */
    MPAccessoryBatteryStateUnplugged,
    /** The device is plugged in and charging the battery */
    MPAccessoryBatteryStateCharging,
    /** The battery is plugged in and fully charged */
    MPAccessoryBatteryStateFull,
    /** The battery level is critical */
    MPAccessoryBatteryStateCritical
};


/**
 * The locale to use for localizations on an accessory.
 * @since 2.0.0
 */
typedef NS_ENUM(NSUInteger, MPLocale){
    /** Gets replaced during runtime with the current locale (if available), or the default one (English). */
    MPLocale_SystemDefault = 0,
    /** German */
    MPLocale_de_DE,
    /** English */
    MPLocale_en_US,
    /** French */
    MPLocale_fr_FR,
    /** Italian */
    MPLocale_it_IT,
    /** Belgian */
    MPLocale_nl_BE,
    /** Portuguese */
    MPLocale_pt_PT,
    /** Spanish */
    MPLocale_es_ES
};


/**
 * Option flags indicating the different components that accessories can have.
 * @since 2.2.0
 */
typedef NS_OPTIONS(NSUInteger, MPAccessoryComponentType) {
    /** No componenets are available */
    MPAccessoryComponentTypeNone                = 0,
    /** Barcode scanner component available */
    MPAccessoryComponentTypeBarcodeScanner      = 1 << 0,
    /** Printer component available */
    MPAccessoryComponentTypePrinter             = 2 << 0,
    /** Log access component available */
    MPAccessoryComponentTypeLog                 = 3 << 0
};

@class MPAccessoryDetails;
@class MPAccessoryComponent;
/**
 * An accessory contains all information related to a specific accessory connection. The connection can be established by multiple channels (e.g. WiFi, Blueooth, Dock-Connector, audio jack).
 * @since 2.0.0
 */
@interface MPAccessory : NSObject

#pragma mark - General Information
/** @name General Information */

/**
 * The category of the accessory.
 * @since 2.0.0
 */
@property (assign, readonly, nonatomic) MPAccessoryCategory category;

/**
 * The accessory type.
 * @since 2.0.0
 */
@property (assign, readonly, nonatomic) MPAccessoryType type;

/**
 * Information about the device (including software version), only available once connected.
 * @since 2.0.0
 */
@property (strong, readonly, nonatomic) MPAccessoryDetails *details;



#pragma mark - Connection Information
/** @name Connection Information */

/**
 * Connection type used by the accessory.
 * @since 2.0.0
 */
@property (assign, readonly, nonatomic) MPAccessoryConnectionType connectionType;

/**
 * Connection state of the accessory.
 * @since 2.0.0
 */
@property (assign, readonly, nonatomic) MPAccessoryConnectionState connectionState;


#pragma mark - Battery Information
/** @name Battery Information */

/**
 * Battery state of the accessory
 * @since 2.0.0
 */
@property (assign, readonly, nonatomic) MPAccessoryBatteryState batteryState;

/**
 * Battery level of the accessory in range 0-100, -1 if not available.
 * @since 2.0.0
 */
@property (assign, readonly, nonatomic) NSInteger batteryLevel;

/**
 * The the current state the accessory is in.
 * @since 2.0.0
 */
@property (assign, readonly, nonatomic) MPAccessoryState state;


#pragma mark - Components Information

/**
 * Flas set of the components available on the accessory.
 * @since 2.1.0
 */
@property (assign, readonly, nonatomic) MPAccessoryComponentType components;

/**
 * Returns a specific component of the acccessory.
 * @param component The type of component to get
 * @return The respective component, or nil if the component is not available.
 * @since 2.1.0
 */
- (MPAccessoryComponent *)componentForType:(MPAccessoryComponentType)component;

@end



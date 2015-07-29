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
 * A collection of location information for the transaction. The reference for the values is WGS-84, so the information provided by a CLLocation object can be used without changes.
 * @since 2.0.0
 */
@interface MPLocationDetails : NSObject

/**
 * The latitude in decimal degrees.
 * @since 2.0.0
 */
@property (assign, nonatomic) double latitude;

/**
 * The latitude in decimal degrees.
 * @since 2.0.0
 */

@property (assign, nonatomic) double longitude;

/**
 * The accuracy of the latitude/longitude.
 * @since 2.0.0
 */
@property (assign, nonatomic) double horizontalAccuracy;


/**
 * Factory method for creating a new set of location information.
 * @param latitude The latitude for the location
 * @param longitude The longitude for the location
 * @param horizontalAccuracy The horizontal accuracy for the location
 * @return A new set of location information based on the given values
 * @throw NSException if the parameters are invalid
 * @since 2.0.0
 */
+ (instancetype)locationDetailsWithLatitude:(double)latitude longitude:(double)longitude horizontalAccuracy:(double)horizontalAccuracy;

@end

//
// PAYWORKS GMBH ("COMPANY") CONFIDENTIAL
// Copyright (c) 2015 payworks GmbH, All Rights Reserved.
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


@class MPAccessoryComponentLog;

typedef void (^MPAccessoryComponentLogDownloadLogSuccess)(MPAccessoryComponentLog * _Nonnull component, NSData * _Nonnull log);
typedef void (^MPAccessoryComponentLogDownloadLogFailure)(MPAccessoryComponentLog * _Nonnull component, NSError * _Nonnull error);

typedef void (^MPAccessoryComponentLogDeleteLogSuccess)(MPAccessoryComponentLog * _Nonnull component);
typedef void (^MPAccessoryComponentLogDeleteLogFailure)(MPAccessoryComponentLog * _Nonnull component, NSError * _Nonnull error);

@interface MPAccessoryComponentLog : MPAccessoryComponent

/** 
 * Downloads the log from the accessory and deletes it afterwards.
 * Please note that this command must not be executed while a transaction is ongoing. At the same time, do nt start a transaction while this command is still executing!
 * @param success The success callback for downloading the logs
 * @param failure The failure callback for downloading the logs
 * @since 2.5.0
 */
- (void)downloadLogWithSuccess:(nonnull MPAccessoryComponentLogDownloadLogSuccess)success
                       failure:(nonnull MPAccessoryComponentLogDownloadLogFailure)failure;

/**
 * Deletes the log from the accessory. This can be called before starting a new transaction in order to wipe the logs.
 * Please note that this command must not be executed while a transaction is ongoing. At the same time, do nt start a transaction while this command is still executing!
 * @param success The success callback for deleting the logs
 * @param failure The failure callback for deleting the logs
 * @since 2.5.0
 */
- (void)deleteLogWithSuccess:(nonnull MPAccessoryComponentLogDeleteLogSuccess)success
                     failure:(nonnull MPAccessoryComponentLogDeleteLogFailure)failure;

@end

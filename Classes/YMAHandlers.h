/*!
 @class YMAHandlers
 @version 4.3
 @author Dmitry Shakolo
 @creation_date 09.12.2015
 @copyright Copyright (c) 2015 NBCO Yandex.Money LLC. All rights reserved.
 @discussion SDK handlers
 */

@import Foundation;

/// Completion of block is used to get the ID of an installed copy of the application.
/// @param instanceId - ID of an installed copy of the application.
typedef void (^YMAIdHandler)(NSString *instanceId, NSError *error);

/// Completion block used by several methods of YMAExternalPaymentSession.
/// @param error - Error information or nil.
typedef void (^YMAHandler)(NSError *error);

/*!
 @class YMAHandlers
 @version 4.3
 @author Dmitry Shakolo
 @creation_date 09.12.2020
 @copyright Copyright (c) 2020 NBCO YooMoney LLC. All rights reserved.
 @discussion SDK handlers
 */

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

/// Completion of block is used to get the ID of an installed copy of the application.
/// @param instanceId - ID of an installed copy of the application.
typedef void (^YMAIdHandler)(NSString *__nullable instanceId, NSError *__nullable error);

/// Completion block used by several methods of YMAExternalPaymentSession.
/// @param error - Error information or nil.
typedef void (^YMAHandler)(NSError *__nullable error);

/// Completion block used by handle challenge in NSURLSessionDelegate method
typedef void (^YMASessionDidReceiveAuthenticationChallengeHandler)(NSURLSession *session,
                                                                   NSURLAuthenticationChallenge *challenge,
                                                                   void (^completion)(NSURLSessionAuthChallengeDisposition disposition,
                                                                                      NSURLCredential *__nullable credential));

/// Completion block used by handle challenge in NSURLSessionTaskDelegate method
typedef void (^YMASessionTaskDidReceiveAuthenticationChallengeHandler)(NSURLSession *session,
                                                                       NSURLSessionTask *task,
                                                                       NSURLAuthenticationChallenge *challenge,
                                                                       void (^completion)(NSURLSessionAuthChallengeDisposition disposition,
                                                                                          NSURLCredential *__nullable credential));

NS_ASSUME_NONNULL_END

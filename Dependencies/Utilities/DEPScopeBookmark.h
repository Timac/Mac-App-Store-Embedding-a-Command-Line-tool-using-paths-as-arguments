//
//  DEPScopeBookmark.h
//  Dependencies
//
//  Copyright © 2020 Alexandre Colucci. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DEPScopeBookmark : NSObject


/**
 Create a Scope Bookmark for the specified URL
 */
+(NSData *)createSecurityScopeBookmarkDataForURL:(NSURL *)inURL;


/**
 Resolve the Bookmark data
 */
+(NSURL *)resolveBookmarkData:(NSData **)inOutBookmarkData;

@end


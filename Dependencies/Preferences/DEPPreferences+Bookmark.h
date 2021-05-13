//
//  DEPPreferences+Bookmark.h
//  Dependencies
//
//  Copyright © 2020 Alexandre Colucci. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DEPPreferences.h"

@interface DEPPreferences (Bookmark)


// MARK: - Command Line Bookmark

+(void)createSecurityScopeCommandLineBookmark:(NSURL *)inURL;
+(NSURL *)resolveSecurityScopeCommandLineBookmark;

+(void)createSharedCommandLineBookmark:(NSURL *)inURL;
+(NSURL *)resolveSharedCommandLineBookmark;
+(void)removeSharedCommandLineBookmark;

@end


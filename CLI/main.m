//
//  main.m
//  dependencies
//
//  Copyright © 2020 Alexandre Colucci. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DEPPreferences.h"
#import "DEPPreferences+Bookmark.h"

int main(int argc, const char * argv[])
{
	@autoreleasepool
	{
		NSString *commandLineBookmarkPath = nil;
		
		// If there is a shared bookmark, try to convert it to a security scope bookmark
		NSURL *bookmarkURL = [DEPPreferences resolveSharedCommandLineBookmark];
		if(bookmarkURL != nil)
		{
			[DEPPreferences createSecurityScopeCommandLineBookmark:bookmarkURL];
			bookmarkURL = [DEPPreferences resolveSecurityScopeCommandLineBookmark];
			if(bookmarkURL != nil)
			{
				NSLog(@"Successfully imported the shared bookmark for %@", bookmarkURL);
				commandLineBookmarkPath = [bookmarkURL path];
			}
			
			[DEPPreferences removeSharedCommandLineBookmark];
		}
		
		// Try to load the security scope bookmark
		NSURL *securityScopeBookmarkURL = [DEPPreferences resolveSecurityScopeCommandLineBookmark];
		if(securityScopeBookmarkURL != nil)
		{
			NSLog(@"Command line support enabled for %@", securityScopeBookmarkURL);
			commandLineBookmarkPath = [securityScopeBookmarkURL path];
		}
		
		if(commandLineBookmarkPath == nil)
		{
			NSLog(@"Please enable the command line support in the Dependencies preferences.");
			return 1;
		}
		
		//[...]
	}
	
	return 0;
}

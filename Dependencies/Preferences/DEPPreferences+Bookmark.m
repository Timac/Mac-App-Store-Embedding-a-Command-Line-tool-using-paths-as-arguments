//
//  DEPPreferences+Bookmark.m
//  Dependencies
//
//  Copyright © 2020 Alexandre Colucci. All rights reserved.

#import "DEPPreferences+Bookmark.h"
#import "DEPScopeBookmark.h"

// The preference where the Scope Bookmark is saved to enable the command line support
NSString* const kCommandLineSupportSelectedFolder = @"CommandLineSupportSelectedFolder";


@implementation DEPPreferences (Bookmark)

// MARK: - Bookmarks

+(NSURL *)resolveBookmarkDataForKey:(NSString *)inPrefKey inUserDefaults:(NSUserDefaults *)inUserDefaults
{
	NSURL *outBookmarkURL = nil;
	if(inPrefKey != nil && inUserDefaults != nil)
	{
		NSData *bookmarkData = [inUserDefaults objectForKey:inPrefKey];
		if (bookmarkData != nil)
		{
			NSData *updatedBookmarkData = bookmarkData;
			outBookmarkURL = [DEPScopeBookmark resolveBookmarkData:&updatedBookmarkData];
			if(updatedBookmarkData != bookmarkData)
			{
				[inUserDefaults setObject:updatedBookmarkData forKey:inPrefKey];
			}
		}
		else
		{
			NSLog(@"No Bookmark data stored for %@", inPrefKey);
		}
	}
	
	return outBookmarkURL;
}


// MARK: - Command Line Bookmark

+(void)createSecurityScopeCommandLineBookmark:(NSURL *)inURL
{
	if(inURL != nil)
	{
		NSData *bookmark = [DEPScopeBookmark createSecurityScopeBookmarkDataForURL:inURL];
		if(bookmark != nil)
		{
			[[NSUserDefaults standardUserDefaults] setObject:bookmark forKey:kCommandLineSupportSelectedFolder];
		}
	}
}

+(NSURL *)resolveSecurityScopeCommandLineBookmark
{
	return [DEPPreferences resolveBookmarkDataForKey:kCommandLineSupportSelectedFolder inUserDefaults:[NSUserDefaults standardUserDefaults]];
}

+(void)createSharedCommandLineBookmark:(NSURL *)inURL
{
	if(inURL != nil)
	{
		NSError *error = nil;
		NSData *bookmarkData = [inURL bookmarkDataWithOptions:NSURLBookmarkCreationMinimalBookmark includingResourceValuesForKeys:nil relativeToURL:nil error:&error];
		if(bookmarkData != nil)
		{
			[[DEPPreferences sharedAppGroupPreferencesSuite] setObject:bookmarkData forKey:kCommandLineSupportSelectedFolder];
		}
		else
		{
			NSLog(@"Could not create the command line bookmark data for %@ due to %@", [inURL path], error);
		}
	}
}

+(NSURL *)resolveSharedCommandLineBookmark
{
	NSData *bookmarkData = [[DEPPreferences sharedAppGroupPreferencesSuite] objectForKey:kCommandLineSupportSelectedFolder];
	if(bookmarkData != nil)
	{
		BOOL bookmarkDataIsStale = NO;
		NSError *error = nil;
		NSURL *theURL = [NSURL URLByResolvingBookmarkData:bookmarkData options:NSURLBookmarkResolutionWithoutUI relativeToURL:nil bookmarkDataIsStale:&bookmarkDataIsStale error:&error];
		
		if(theURL != nil)
		{
			return theURL;
		}
		else if(error != nil)
		{
			NSLog(@"Could not get the url for the command line bookmark data due to %@", error);
		}
		else
		{
			NSLog(@"Could not get the url for the command line bookmark data");
		}
	}
	
	return nil;
}

+(void)removeSharedCommandLineBookmark
{
	[[DEPPreferences sharedAppGroupPreferencesSuite] removeObjectForKey:kCommandLineSupportSelectedFolder];
}

@end

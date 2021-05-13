//
//  DEPScopeBookmark.m
//  Dependencies
//
//  Copyright © 2020 Alexandre Colucci. All rights reserved.
//

#import "DEPScopeBookmark.h"

@implementation DEPScopeBookmark

+(NSData *)createSecurityScopeBookmarkDataForURL:(NSURL *)inURL
{
	if(inURL != nil)
	{
		NSError *error = nil;
		NSData *bookmarkData = [inURL bookmarkDataWithOptions:NSURLBookmarkCreationWithSecurityScope includingResourceValuesForKeys:nil relativeToURL:nil error:&error];
		if(bookmarkData != nil)
		{
			return bookmarkData;
		}
		else
		{
			NSLog(@"Could not create the Bookmark data for %@ due to %@", [inURL path], error);
		}
	}
	
	return nil;
}

+(NSURL *)resolveBookmarkData:(NSData **)inOutBookmarkData
{
	if(inOutBookmarkData == nil)
		return nil;
	
	NSURL *outBookmarkURL = nil;
	
	NSError *error = nil;
	NSData *bookmarkData = *inOutBookmarkData;
	if (bookmarkData != nil)
	{
		BOOL bookmarkDataIsStale = NO;
		NSURL *theURL = [NSURL URLByResolvingBookmarkData:bookmarkData options:NSURLBookmarkResolutionWithSecurityScope relativeToURL:nil bookmarkDataIsStale:&bookmarkDataIsStale error:&error];
		if (theURL != nil && bookmarkDataIsStale)
		{
			// Update the bookmark data
			NSData *updatedBookmark = [DEPScopeBookmark createSecurityScopeBookmarkDataForURL:theURL];
			if(updatedBookmark != nil)
			{
				*inOutBookmarkData = updatedBookmark;
			}
		}
		
		if(theURL != nil)
		{
			BOOL startAccessingSecurityScopedResourceResult = [theURL startAccessingSecurityScopedResource];
			if(!startAccessingSecurityScopedResourceResult)
			{
				NSLog(@"Could not start accessing the scoped URL");
			}
			else
			{
				outBookmarkURL = theURL;
			}
		}
		else
		{
			if(error != nil)
			{
				NSLog(@"Could not get the url for the bookmark data due to %@", error);
			}
			else
			{
				NSLog(@"Could not get the url for the bookmark data");
			}
		}
	}
	else
	{
		NSLog(@"No Bookmark data");
	}
	
	return outBookmarkURL;
}

@end

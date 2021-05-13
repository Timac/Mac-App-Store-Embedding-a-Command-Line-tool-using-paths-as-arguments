//
//  DEPPreferences.m
//  Dependencies
//
//  Copyright © 2020 Alexandre Colucci. All rights reserved.

#import "DEPPreferences.h"

// The App Group to share the preferences between the QuickLook plugin and the app
NSString *const kPreferencesAppGroup = @"QFL3YR6JR6.app.dependencies.dependencies.preferences";


@implementation DEPPreferences


+(NSUserDefaults*)sharedAppGroupPreferencesSuite
{
	static NSUserDefaults *sUserDefault = nil;
	if(sUserDefault == nil)
	{
		sUserDefault = [[NSUserDefaults alloc] initWithSuiteName:kPreferencesAppGroup];
	}
	
	return sUserDefault;
}

@end

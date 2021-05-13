//
//  DEPPreferences.h
//  Dependencies
//
//  Copyright © 2020 Alexandre Colucci. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface DEPPreferences : NSObject

+(NSUserDefaults*)sharedAppGroupPreferencesSuite;

@end


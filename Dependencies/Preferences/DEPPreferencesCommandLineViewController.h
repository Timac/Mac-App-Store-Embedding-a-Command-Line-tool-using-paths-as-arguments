//
//  DEPPreferencesCommandLineViewController.h
//  Dependencies
//
//  Copyright © 2020 Alexandre Colucci. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "DEPPreferencesWindowControllerProtocol.h"

@interface DEPPreferencesCommandLineViewController : NSViewController <DEPPreferencesWindowControllerProtocol>

- (instancetype)initViewController;

@end


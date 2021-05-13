//
//  DEPPreferencesWindowControllerProtocol.h
//  Dependencies
//
//  Copyright © 2020 Alexandre Colucci. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol DEPPreferencesWindowControllerProtocol <NSObject>

@required

@property (nonatomic, readonly, strong, nonnull) NSString *identifier;
@property (nonatomic, readonly, strong, nonnull) NSString *title;

@end

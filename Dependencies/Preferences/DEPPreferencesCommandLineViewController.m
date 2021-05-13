//
//  DEPPreferencesCommandLineViewController.m
//  Dependencies
//
//  Copyright © 2020 Alexandre Colucci. All rights reserved.

#import "DEPPreferencesCommandLineViewController.h"

#import "DEPPreferences.h"
#import "DEPPreferences+Bookmark.h"

@interface DEPPreferencesCommandLineViewController ()

@property (weak) IBOutlet NSTextField *grandAccessTextField;
@property (weak) IBOutlet NSTextField *statusTextField;

@property (weak) IBOutlet NSTextField *runCommandTextField;
@property (weak) IBOutlet NSTextField *runSysmlinkCommandTextField;

@property (weak) IBOutlet NSPathControl *pathControl;
@property (strong) NSURL *bookmarkURL;

@end


@implementation DEPPreferencesCommandLineViewController

- (instancetype)initViewController
{
    self = [super initWithNibName:@"DEPPreferencesCommandLineView" bundle:nil];
    if (self)
    {
		_bookmarkURL = [DEPPreferences resolveSecurityScopeCommandLineBookmark];
    }
    
    return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.grandAccessTextField.stringValue = [NSString stringWithFormat:@"Grant access to the command line tool:"];
	[self updateStatus];
}

- (void)viewWillAppear
{
	[super viewWillAppear];
	
	// Recreate the shared command line bookmark
	self.bookmarkURL = [DEPPreferences resolveSecurityScopeCommandLineBookmark];
	[self updateStatus];
	if(self.bookmarkURL != nil)
	{
		[DEPPreferences createSharedCommandLineBookmark:self.bookmarkURL];
	}
}

- (void)updateStatus
{
	if(self.bookmarkURL == nil)
	{
		[self.statusTextField setStringValue:@"Command Line support is currently not enabled."];
		[self.pathControl setToolTip:nil];
		[self.pathControl setHidden:YES];
	}
	else
	{
		[self.statusTextField setStringValue:@"Access is granted for"];
		[self.pathControl setURL:self.bookmarkURL];
		[self.pathControl setToolTip:[self.bookmarkURL path]];
		[self.pathControl setHidden:NO];
	}
}

-(NSString*)identifier
{
    return [[[self title] lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
}

-(NSString*)title
{
    return @"Command Line";
}

-(IBAction)doEnableCommandLine:(id)sender
{
	NSOpenPanel *openPanel = [NSOpenPanel openPanel];
	[openPanel setAllowsMultipleSelection:NO];
	[openPanel setCanChooseFiles:NO];
	[openPanel setCanChooseDirectories:YES];
	[openPanel setResolvesAliases:YES];
	[openPanel setDirectoryURL:[NSURL fileURLWithPath:[@"~" stringByExpandingTildeInPath]]];
	[openPanel setPrompt:@"Select"];
	[openPanel setMessage:@"Select a folder that Dependencies will be able to access from the command line."];
	
	NSModalResponse response = [openPanel runModal];
	if(response == NSModalResponseOK)
	{
		NSURL *url = [openPanel URLs].firstObject;
		if(url != nil)
		{
			//
			// 1. The user selected a folder to enable the command line
			// 2. This folder is saved as a secure scope bookmark in the app so that we can reuse the folder when the app is relaunched.
			//		This is used to display the selected folder in the UI and to resave the shared bookmark.
			// 3. The folder is also saved as a shared (non-secure) bookmark. Security scope bookmark can only be decrypted by the app that created it so the main app can't pass a secure scope bookmark to a command line tool.
			// 4. The user needs to launch the command line from the Terminal while the main app is still running (to ensure that the shared bookmark is still valid).
			// 5. The command line reads the shared bookmark and create a security scope bookmark.
			// 6. The command line now has read/write access to the folder even if the computer is restarted.
			[DEPPreferences createSharedCommandLineBookmark:url];
			[DEPPreferences createSecurityScopeCommandLineBookmark:url];
			self.bookmarkURL = [DEPPreferences resolveSecurityScopeCommandLineBookmark];
			[self updateStatus];
		}
	}
}

-(void)copyToClipboard:(NSTextField *)inTextField
{
	NSPasteboard *pasteBoard = [NSPasteboard generalPasteboard];
	[pasteBoard declareTypes:[NSArray arrayWithObjects:NSPasteboardTypeString, nil] owner:nil];
	[pasteBoard setString:[inTextField stringValue] forType:NSPasteboardTypeString];
}

-(IBAction)doCopyCommand:(id)sender
{
	[self copyToClipboard:self.runCommandTextField];
}

-(IBAction)doCopySymlinkCommand:(id)sender
{
	[self copyToClipboard:self.runSysmlinkCommandTextField];
}

@end

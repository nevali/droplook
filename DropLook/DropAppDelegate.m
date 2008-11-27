/*
 * DropLook: A simple wrapper for QuickLook.
 * @(#) $Id$
 */

/*
 * Copyright (c) 2008 Mo McRoberts.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. The names of the author(s) of this software may not be used to endorse
 *    or promote products derived from this software without specific prior
 *    written permission.
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, 
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY 
 * AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL
 * AUTHORS OF THIS SOFTWARE BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING 
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS 
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#ifdef HAVE_CONFIG_H
# include "config.h"
#endif

#import "DropAppDelegate.h"
#import "DropWinController.h"


@implementation DropAppDelegate

-(IBAction)showPreferences:(id)sender
{
	if(!prefsController)
	{
		[NSBundle loadNibNamed:@"Preferences.nib" owner:self];
	}
	[[prefsController window] makeKeyAndOrderFront:sender];
}

-(void)initQuickLook
{
	if(!quickLookAvailable)
	{
		quickLookAvailable = [[NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/QuickLookUI.framework"] load];
		if(!quickLookAvailable)
		{
			NSLog(@"QuickLook is not available");
			exit(1);
		}
	}
}

-(void)lookAtFile:(NSString *)path
{
	[self initQuickLook];
	[[DropWinController alloc] initWithPath:path];
}

-(void)lookAtIt:(NSPasteboard *)pboard
	   userData:(NSString *)userData
		  error:(NSString **)error
{
	NSArray *flist;
	unsigned int count, c;
	NSString *path;
	
	flist = [pboard propertyListForType:NSFilenamesPboardType];
	count = [flist count];
	for(c = 0; c < count; c++)
	{
		path = [flist objectAtIndex:c];
		[self lookAtFile:path];
	}
}

- (BOOL)application:(NSApplication *)sender openFile:(NSString *)path
{
	[self lookAtFile:path];
	return true;
}

@end

@implementation DropAppDelegate(NSApplicationNotifications)
-(void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [NSApp setServicesProvider:self];
}
@end

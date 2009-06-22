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

#import "Sparkle/SUUpdater.h"
#import "PrefsController.h"


@implementation PrefsController

- (NSWindow *)window
{
	return window;
}

- (void)awakeFromNib
{
	updater = [SUUpdater sharedUpdater];
	updateDateFormatter = [[NSDateFormatter alloc] init];
	[updateDateFormatter setDateStyle:NSDateFormatterLongStyle];
	[updateDateFormatter setTimeStyle:NSDateFormatterMediumStyle];
	lastCheckedString = NSLocalizedStringFromTable(@"Last checked for updates: %@", @"DropLook", @"Message displayed in preferences window showing last software update check.");
	updateInProgressString = NSLocalizedStringFromTable(@"Checking for updates", @"DropLook", @"Message displayed in preferences window showing that an update is in progress.");
	neverCheckedString = NSLocalizedStringFromTable(@"Never checked for updates.", @"DropLook", @"Message displayed in preferences window showing that automatic updates haven't yet run.");
	[self showLastUpdated];
	[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timerTick:) userInfo:NULL repeats:YES];
	
}

- (IBAction)checkNow:(id)sender
{
	[updater checkForUpdatesInBackground];
	[self showLastUpdated];
}

- (void)timerTick:(NSTimer*)theTimer
{
	[self showLastUpdated];
}

- (void)showLastUpdated
{
	NSDate *dt;
	
	if([updater updateInProgress])
	{
		[lastUpdated setStringValue:updateInProgressString];
	}
	else if(dt = [updater lastUpdateCheckDate])
	{
		[lastUpdated setStringValue:[NSString stringWithFormat:lastCheckedString, [updateDateFormatter stringFromDate:dt]]];
	}
	else
	{
		[lastUpdated setStringValue:neverCheckedString];
	}
}

@end

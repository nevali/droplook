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

#import "DropWinController.h"

#define QLPreviewPanel NSClassFromString(@"QLPreviewPanel")
#define QLPreviewView NSClassFromString(@"QLPreviewView")

@implementation DropWinController

-(id)initWithPath:(NSString *)path
{
	id qlpanel;
	
	[super init];
	if(YES != [NSBundle loadNibNamed:@"DropWindow.nib" owner:self])
	{
		NSLog(@"Failed to load DropWindow.nib");
		[self dealloc];
		return nil;
	}
	qlpanel = [QLPreviewView alloc];
	[window setTitleWithRepresentedFilename:path];
	[qlpanel initWithFrame:[window frame]];
	[qlpanel setURL:[NSURL fileURLWithPath:path]];
	[window setContentView: qlpanel];
	[window makeKeyAndOrderFront:self];
	return self;
}

@end

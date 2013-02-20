//
//  PonyDebuggerInjected.mm
//  PonyDebuggerInjected
//
//  Created by Den on 18/01/2013.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "CaptainHook/CaptainHook.h"
#include <notify.h> 
#import "PonyDebuggerInjectedController.h"

static void PreferenceChangedPostedNotification(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
	[[PonyDebuggerInjectedController sharedInstance] preferencesChanged];
}

CHConstructor // code block that runs immediately upon load
{
	// Don't load in SpringBoard to avoid crash
	if([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.springboard"]) {
		return;
	}
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
	[PonyDebuggerInjectedController sharedInstance];
    
	// this would be posted using: notify_post("com.open.PonyDebuggerInjected.preferenceChanged);
	CFNotificationCenterRef darwin = CFNotificationCenterGetDarwinNotifyCenter();
	CFNotificationCenterAddObserver(darwin, NULL, PreferenceChangedPostedNotification, CFSTR("com.open.PonyDebuggerInjected.preferenceChanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);

	[pool drain];
}

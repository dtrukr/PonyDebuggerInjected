//
//  PonyDebuggerInjectedController.m
//  PonyDebuggerInjected
//
//  Created by Den on 18/01/2013.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Imports

#import "PonyDebuggerInjectedController.h"
#import "PDDebugger.h"

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Defines

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Types

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Macros

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private Interface
@interface PonyDebuggerInjectedController ()

@end

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Implementation

@implementation PonyDebuggerInjectedController

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Synthesize

/* Public *********************************************************************/

/* Private ********************************************************************/



////////////////////////////////////////////////////////////////////////////////
#pragma mark - Class Methods

+ (PonyDebuggerInjectedController*)sharedInstance
{
    static PonyDebuggerInjectedController *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Setup & Teardown


- (id)init
{
    self = [super init];
    if (self)
    {
        if([self isEnabledInPreferences]) {
            [self startDebugger];
        }
        
    }
    return self;
}

- (void)dealloc
{   
    [super dealloc];
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Superclass Overrides

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public methods

-(BOOL)isEnabledInPreferences {
        
    NSMutableDictionary* plist = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/private/var/mobile/Library/Preferences/PonyDebuggerInjected.plist"];
    
    if (!plist) { // Preference file not found, don't hook
        NSLog(@"PonyDebuggerInjected - Preference file not found.");
        return FALSE;
    }
    else {
        id shouldHook = [plist objectForKey:@"ponyDebuggerInjectedEnabled"];
        if (shouldHook) {
            [plist release];
            return [shouldHook boolValue];
        }
        else { // Property was not set, don't hook
            NSLog(@"PonyDebuggerInjected - Preference not set.");
            [plist release];
            return FALSE;
        }
    }
    
    NSString *address = [self serverAddress];
    return address != nil;


}

- (NSString*)serverAddress {
    
    NSMutableDictionary* plist = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/private/var/mobile/Library/Preferences/PonyDebuggerInjected.plist"];
   
    
    if (!plist) { // Preference file not found, don't hook
        NSLog(@"PonyDebuggerInjected - Preference file not found.");
        return nil;
    }
    else {
        
        NSString* address = (NSString*)[plist objectForKey:@"ponyDebuggerInjectedServer"];
        if (address != nil) {
            NSString *serverAddress = [NSString stringWithString:address];
            [plist release];
            return serverAddress;
        }
        else { // Property was not set, don't hook
            NSLog(@"PonyDebuggerInjected - Preference not set for server address.");
            [plist release];
            return nil;
        }
    }

    
}

-(void)preferencesChanged {
    
    NSLog(@"Preferences changed for PonyDebuggerInjected");
    
    if([self isEnabledInPreferences]) {
        [self stopDebugger];
    } else {
        [self startDebugger];
    }
    
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private methods

-(void)startDebugger;
{
    
    NSString* address = [self serverAddress];
    if(address == nil || [address length]==0) {
    
        NSLog(@"Will not start debugger for %@ - the server address is not set",[[NSBundle mainBundle] bundleIdentifier]);
        return;
    }
    
    NSLog(@"Will start debugger for %@ on %@", [[NSBundle mainBundle] bundleIdentifier],address);
    
    PDDebugger *debugger = [PDDebugger defaultInstance];
    
    // Enable Network debugging, and automatically track network traffic that comes through any classes that NSURLConnectionDelegate methods.
    [debugger enableNetworkTrafficDebugging];
    [debugger forwardAllNetworkTraffic];
    
    // Enable Core Data debugging, and broadcast the main managed object context.
    //[debugger enableCoreDataDebugging];
    //[debugger addManagedObjectContext:self.managedObjectContext withName:@"Twitter Test MOC"];
    
    // Enable View Hierarchy debugging. This will swizzle UIView methods to monitor changes in the hierarchy
    // Choose a few UIView key paths to display as attributes of the dom nodes
    [debugger enableViewHierarchyDebugging];
    [debugger setDisplayedViewAttributeKeyPaths:@[@"frame", @"hidden", @"alpha", @"opaque"]];
    
    // Connect to a specific host
    [debugger connectToURL:[NSURL URLWithString:[NSString stringWithFormat:@"ws://%@/device",address]]];
    
}

-(void)stopDebugger
{
    PDDebugger *debugger = [PDDebugger defaultInstance];
    if ([debugger isConnected]) {
     
        [debugger disconnect];
        NSLog(@"Will stop debugger for %@", [[NSBundle mainBundle] bundleIdentifier]);
        
    }
}

@end

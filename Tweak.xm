#import <dlfcn.h>
#import <UIKit/UIKit.h>
#include <notify.h>
#include <objc/message.h>
#import <PonyDebugger/PDDebugger.h>

__attribute__((visibility("hidden")))
@interface PonyDebuggerInjected : NSObject {
@private
}
@end

#define kBundlePath @"/Library/MobileSubstrate/DynamicLibraries/PonyDebuggerInjectedBundle.bundle"

@implementation PonyDebuggerInjected

+ (instancetype)sharedInstance
{
    static PonyDebuggerInjected *_sharedFactory;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedFactory = [[self alloc] init];
    });

    return _sharedFactory;
}

- (id)init
{
        if ((self = [super init]))
        {
                     
        }
        return self;
}

-(void)inject {
	
	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.daapps.PonyDebuggerInjected.plist"];
	id setting = [settings objectForKey:[NSString stringWithFormat:@"PonyDebuggerInjectedEnabled-%@", [NSBundle mainBundle].bundleIdentifier]];
	if (setting && [setting boolValue]) {

	 	PDDebugger *debugger = [PDDebugger defaultInstance];
	    
	    // Enable Network debugging, and automatically track network traffic that comes through any classes that NSURLConnectionDelegate methods.
	    [debugger enableNetworkTrafficDebugging];
	    [debugger forwardAllNetworkTraffic];
	    
	    // Enable Core Data debugging, and broadcast the main managed object context.
	    [debugger enableCoreDataDebugging];
	    [self performSelector:@selector(attachToCoreData) withObject:nil afterDelay:1.0];
	    
	    // Enable View Hierarchy debugging. This will swizzle UIView methods to monitor changes in the hierarchy
	    // Choose a few UIView key paths to display as attributes of the dom nodes
	    [debugger enableViewHierarchyDebugging];
	    [debugger setDisplayedViewAttributeKeyPaths:@[@"frame", @"hidden", @"alpha", @"opaque"]];
	    
	    // Connect to a specific host
	    [debugger autoConnect];
		
	} 
	
}

-(void)attachToCoreData {
    
    PDDebugger *debugger = [PDDebugger defaultInstance];
    
    id app = (id)[UIApplication sharedApplication];
    if(app != nil)
    {
        
        id appDelegate = (id)[app delegate];
        if(appDelegate !=nil &&  [appDelegate respondsToSelector:@selector(managedObjectContext)]) {
            id ctx = [appDelegate managedObjectContext];
            
            if(ctx != nil) {
                
                [debugger addManagedObjectContext:ctx withName:@"Application Context"];
                NSLog(@"Adding application context to Core Data debugging");
                
            } else {
                NSLog(@"** There is no UIApplication Delegate Managed Context for Core Data");
            }
            
        } else {
            NSLog(@"** There is no UIApplication Delegate for Core Data or the delegate does not respond to managedObjectContext selector");
        }
        
    } else {
        NSLog(@"** There is no UIApplication for Core Data");
    }
    
}

@end


%ctor {

    [[NSNotificationCenter defaultCenter] addObserver:[PonyDebuggerInjected sharedInstance] selector:@selector(inject) name:UIApplicationDidFinishLaunchingNotification object:nil];

}
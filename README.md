PonyDebuggerInjected
=====================


PonyDebugger is a great remote debugging toolset. It is a client library and gateway server combination that uses Chrome Developer Tools on your browser to debug your application's network traffic, view tree, core data objects, etc.

One of the limitations of PonyDebugger is that one must implement the client functionality in project's source code and connect it to the gateway server. But what if you wanted to use PonyDebugger to get a peek on how other applications are built, inspect view tree hierarchy, get access to runtime objects and Core Data entities for the purpose of security/penetration testing or just for curiosity sake?

Here is where PonyDebuggerInjected comes in to play.

PonyDebuggerInjected is a MobileSubstrate extension, which can be used as a blackbox tool to inject PonyDebugger client library into running iOS Apps on a jailbroken iOS device. This allows one to use Chrome Developer Tools/PonyDebugger in your browser to inspect how applications are built, debug applications network traffic, managed object contexts, etc. For more info on PonyDebugger see https://github.com/square/PonyDebugger

Installation
------------

Most users should download the pre-compiled Debian package available at:
https://www.dropbox.com/s/geh03hpwjnaqggw/com.open.PonyDebuggerInjected_1.0-1_iphoneos-arm.deb

### Dependencies

PonyDebuggerInjected was tested on iOS 6.01 and 5.0. A jailbroken device
is required. Using Cydia make sure the following packages are installed:
- dpkg
- MobileSubstrate
- PreferenceLoader

Additionally, PonyDebugger Gateway Server must be installed and running on the client machine (https://github.com/square/PonyDebugger/blob/master/README_ponyd.rst)

### How to install

Download and copy the Debian package to the device; install it:  

    dpkg -i com.open.PonyDebuggerInjected_1.0-1_iphoneos-arm.deb

Respring the device:

    killall -HUP SpringBoard

There should be a new menu in the device's Settings where you can
enable the extension and set the server address (for example 192.168.0.3:9000).

![Settings](http://biudvikling.dk/images/ponydebugger/Injected_Settings.png)

Finally, start / restart the App you want to test and open PonyDebugger Server URL in your Chrome browser (http://localhost:9000 by default).

Once the an app is started we can connect to PonyDebugger and inspect the app:

[http://biudvikling.dk/images/ponydebugger/pony1-small.png](App Inspection)

### How to uninstall

 dpkg -r com.open.ponydebuggerinjected


Build
-----

Most users should just download and install the Debian package.
The build requires the iOSOpenDev suite to be installed; see http://iosopendev.com/download/
Once installed, clone this repository, do submodule init/update, open and build the included xcodeproj file.


## PonyDebugger Standard Features

The following PonyDebugger features can be used for debugging 3rd party apps injected using PonyDebuggerInjected:

- View Hierarchy Debugging
- Network Traffic Debugging
- Core Data Browser

## PonyDebugger Extensions for Advanced Debugging

The following extensions are currently a work in progress.

# Runtime Object Browser

This extension is built upon https://github.com/nst/RuntimeBrowser project and gives you access to all classes loaded in the runtime, shows every method implemented on each class and displays information in a header (.h) file format.

![Runtime Object Browser](http://biudvikling.dk/images/ponydebugger/pony-objects.png)

Header view:

![Runtime Object Browser - Header View](http://biudvikling.dk/images/ponydebugger/pony-source.png)

# Cycript Console

This extension is built upon http://www.cycript.org project and acts as a bridge between Objective-C runtime and Javascript console allowing one to run arbitrary code inside injected application context. Code typed in the console will be immediately executed inside application context and result returned back to the console.

Here is an example how to get current view controller and change title:

![Cycript console](http://biudvikling.dk/images/ponydebugger/screenshot-cycript.jpg)

![Cycript result](http://biudvikling.dk/images/ponydebugger/iphone2-new-small.png)

# Objective-C objc_msgSend Logger

This extension is built upon Subjective-C project (http://networkpx.blogspot.dk/2009/09/introducing-subjective-c.html) which allow you to log all objc_msgSend calls in order to understand how the code application code works from within.
The extension can be enabled usign Record/Stop button and logs all objc_msgSend calls (in a nice call tree), including all arguments, and the return value.

Here is an example of what happens after tapping an UIButton:

![Objective-C objc_msgSend Logger](http://biudvikling.dk/images/ponydebugger/pony-capturestack.png)

# CCCrypt API Logging

This extension is built upon hooking into CCCrypt* functions for the purpose of capturing all calls to symmetric encryption algorithms that your application uses. This can be helpful to determine whether the encryption keys are hardcoded inside the application.

This is implemented by creating an MSHookFunction hook to the appropriate CCCrypt API functions:

			
			static CCCryptorStatus (*old_CCCryptorCreate)(
			                                          CCOperation op,             /* kCCEncrypt, etc. */
			                                          CCAlgorithm alg,            /* kCCAlgorithmDES, etc. */
			                                          CCOptions options,          /* kCCOptionPKCS7Padding, etc. */
			                                          const void *key,            /* raw key material */
			                                          size_t keyLength,
			                                          const void *iv,             /* optional initialization vector */
			                                                 CCCryptorRef *cryptorRef);
			
			CCCryptorStatus hk_CCCryptorCreate(
			                                CCOperation op,             /* kCCEncrypt, etc. */
			                                CCAlgorithm alg,            /* kCCAlgorithmDES, etc. */
			                                CCOptions options,          /* kCCOptionPKCS7Padding, etc. */
			                                const void *key,            /* raw key material */
			                                size_t keyLength,
			                                const void *iv,             /* optional initialization vector */
			                                CCCryptorRef *cryptorRef)  /* RETURNED */
			{
			    
			    NSString *_operation;
			    if(op == kCCEncrypt) _operation = @"kCCEncrypt";
			    else if (op == kCCDecrypt) _operation = @"kCCDecrypt";
			    
			    NSString *_algorithm;
			    if(alg == kCCAlgorithmAES128) _algorithm = @"kCCAlgorithmAES128";
			    else if(alg == kCCAlgorithmDES) _algorithm = @"kCCAlgorithmDES";
			    else if(alg == kCCAlgorithm3DES) _algorithm = @"kCCAlgorithm3DES";
			    else if(alg == kCCAlgorithmCAST) _algorithm = @"kCCAlgorithmCAST";
			    else if(alg == kCCAlgorithmRC4) _algorithm = @"kCCAlgorithmRC4";
			    else if(alg == kCCAlgorithmRC2) _algorithm = @"kCCAlgorithmRC2";
			    else if(alg == kCCAlgorithmBlowfish) _algorithm = @"kCCAlgorithmBlowfish";
			    else _algorithm = @"Unknown";
			    
			    NSString *_options;
			    if(options == kCCOptionPKCS7Padding) _options = @"kCCOptionPKCS7Padding";
			    else if(options == kCCOptionECBMode) _options = @"kCCOptionECBMode";
			    else _options = @"Unknown";
			    
			    [[PDDebuggerdefaultInstance] writeToConsole:[NSStringstringWithFormat:@"CryptoDebug2> CCCryptCreate(Operation: %@, Algorithm: %@, Options: %@, Key: %s, Vector: %s, Key Length: %ld)", _operation, _algorithm, _options, key, iv, keyLength]];
			
			    return old_CCCryptorCreate(op,alg,options,key,keyLength,iv,cryptorRef);
			    
			}


Let's consider that we have the following code in our application:

		
			NSString *key =@"YourKey";
		    char keyPtr[kCCKeySizeAES256+1]; // room for terminator (unused)
		    bzero( keyPtr, sizeof(keyPtr) ); // fill with zeroes (for padding)
		    
		    // fetch key data
		    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
		    
		    char *dataIn = "This is your data";
		    char dataOut[500];// set it acc ur data
		    bzero(dataOut, sizeof(dataOut));
		    size_t numBytesEncrypted = 0;
		    
		    CCCryptorStatus result = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,kCCOptionPKCS7Padding,  keyPtr,kCCKeySizeAES256, NULL, dataIn, strlen(dataIn), dataOut, sizeof(dataOut), &numBytesEncrypted);

    
Here is what happens when such a call gets captured by PonyDebuggerInjected - as you can see there is both encryption key/vector and data visible:

![CCCrypt API](http://biudvikling.dk/images/ponydebugger/pony-key.png)


License
-------

PonyDebuggerInjected is licensed under the Apache Licence, Version 2.0 (http://www.apache.org/licenses/LICENSE-2.0.html).



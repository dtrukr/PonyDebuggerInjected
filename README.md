PonyDebuggerInjected
=====================

PonyDebuggerInjected is a MobileSubstrate extension which can be used as a blackbox tool to inject PonyDebugger client library into running iOS Apps on a jailbroken iOS device. This allows one to use Chrome Developer Tools/PonyDebugger in your browser to inspect how applications are built, debug applications network traffic, managed object contexts, etc. For more info on PonyDebugger see https://github.com/square/PonyDebugger

Description
-----------

Once installed on a jailbroken device, MobileLoader loads PonyDebuggerInjected patching code into the running application and opens a PonyDebugger client library session.

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

Finally, start / restart the App you want to test and open PonyDebugger Server URL in your Chrome browser (http://localhost:9000 by default).

### How to uninstall

	dpkg -r com.open.ponydebuggerinjected


Build
-----

Most users should just download and install the Debian package.
The build requires the iOSOpenDev suite to be installed; see http://iosopendev.com/download/
Once installed, clone this repository, do submodule init/update, open and build the included xcodeproj file.


License
-------

PonyDebuggerInjected is licensed under the Apache Licence, Version 2.0 (http://www.apache.org/licenses/LICENSE-2.0.html).


Author
------

Dennis Torbichuk - https://github.com/dtrukr
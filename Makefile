ARCHS = armv7 armv7s arm64
include theos/makefiles/common.mk

SDKVERSION = 8.1
INCLUDE_SDKVERSION = 8.1
TARGET_IPHONEOS_DEPLOYMENT_VERSION = 7.0
TARGET_CC = xcrun -sdk iphoneos clang
TARGET_CXX = xcrun -sdk iphoneos clang++
TARGET_LD = xcrun -sdk iphoneos clang++

TWEAK_NAME = PonyDebuggerInjected
PonyDebuggerInjected_FILES = Tweak.xm PonyDebugger/ObjC/DerivedSources/PDApplicationCacheDomain.m PonyDebugger/ObjC/DerivedSources/PDApplicationCacheTypes.m PonyDebugger/ObjC/DerivedSources/PDConsoleDomain.m PonyDebugger/ObjC/DerivedSources/PDConsoleTypes.m PonyDebugger/ObjC/DerivedSources/PDCSSDomain.m PonyDebugger/ObjC/DerivedSources/PDCSSTypes.m PonyDebugger/ObjC/DerivedSources/PDDatabaseDomain.m PonyDebugger/ObjC/DerivedSources/PDDatabaseTypes.m PonyDebugger/ObjC/DerivedSources/PDDebuggerDomain.m PonyDebugger/ObjC/DerivedSources/PDDebuggerTypes.m PonyDebugger/ObjC/DerivedSources/PDDOMDebuggerDomain.m PonyDebugger/ObjC/DerivedSources/PDDOMDomain.m PonyDebugger/ObjC/DerivedSources/PDDOMStorageDomain.m PonyDebugger/ObjC/DerivedSources/PDDOMStorageTypes.m PonyDebugger/ObjC/DerivedSources/PDDOMTypes.m PonyDebugger/ObjC/DerivedSources/PDFileSystemDomain.m PonyDebugger/ObjC/DerivedSources/PDFileSystemTypes.m PonyDebugger/ObjC/DerivedSources/PDIndexedDBDomain.m PonyDebugger/ObjC/DerivedSources/PDIndexedDBTypes.m PonyDebugger/ObjC/DerivedSources/PDInspectorDomain.m PonyDebugger/ObjC/DerivedSources/PDMemoryDomain.m PonyDebugger/ObjC/DerivedSources/PDMemoryTypes.m PonyDebugger/ObjC/DerivedSources/PDNetworkDomain.m PonyDebugger/ObjC/DerivedSources/PDNetworkTypes.m PonyDebugger/ObjC/DerivedSources/PDPageDomain.m PonyDebugger/ObjC/DerivedSources/PDPageTypes.m PonyDebugger/ObjC/DerivedSources/PDProfilerDomain.m PonyDebugger/ObjC/DerivedSources/PDProfilerTypes.m PonyDebugger/ObjC/DerivedSources/PDRuntimeDomain.m PonyDebugger/ObjC/DerivedSources/PDRuntimeTypes.m PonyDebugger/ObjC/DerivedSources/PDTimelineDomain.m PonyDebugger/ObjC/DerivedSources/PDTimelineTypes.m PonyDebugger/ObjC/DerivedSources/PDWebGLDomain.m PonyDebugger/ObjC/DerivedSources/PDWebGLTypes.m PonyDebugger/ObjC/DerivedSources/PDWorkerDomain.m PonyDebugger/ObjC/PonyDebugger/NSArray+PD_JSONObject.m PonyDebugger/ObjC/PonyDebugger/NSArray+PDRuntimePropertyDescriptor.m PonyDebugger/ObjC/PonyDebugger/NSData+PDDebugger.m PonyDebugger/ObjC/PonyDebugger/NSDate+PD_JSONObject.m PonyDebugger/ObjC/PonyDebugger/NSDate+PDDebugger.m PonyDebugger/ObjC/PonyDebugger/NSDictionary+PDRuntimePropertyDescriptor.m PonyDebugger/ObjC/PonyDebugger/NSError+PD_JSONObject.m PonyDebugger/ObjC/PonyDebugger/NSManagedObject+PDRuntimePropertyDescriptor.m PonyDebugger/ObjC/PonyDebugger/NSObject+PDRuntimePropertyDescriptor.m PonyDebugger/ObjC/PonyDebugger/NSOrderedSet+PDRuntimePropertyDescriptor.m PonyDebugger/ObjC/PonyDebugger/NSSet+PDRuntimePropertyDescriptor.m PonyDebugger/ObjC/PonyDebugger/PDConsoleDomainController.m PonyDebugger/ObjC/PonyDebugger/PDContainerIndex.m PonyDebugger/ObjC/PonyDebugger/PDDebugger.m PonyDebugger/ObjC/PonyDebugger/PDDefinitions.m PonyDebugger/ObjC/PonyDebugger/PDDomainController.m PonyDebugger/ObjC/PonyDebugger/PDDOMDomainController.m PonyDebugger/ObjC/PonyDebugger/PDDynamicDebuggerDomain.m PonyDebugger/ObjC/PonyDebugger/PDIndexedDBDomainController.m PonyDebugger/ObjC/PonyDebugger/PDInspectorDomainController.m PonyDebugger/ObjC/PonyDebugger/PDNetworkDomainController.m PonyDebugger/ObjC/PonyDebugger/PDObject.m PonyDebugger/ObjC/PonyDebugger/PDPageDomainController.m PonyDebugger/ObjC/PonyDebugger/PDPrettyStringPrinter.m PonyDebugger/ObjC/PonyDebugger/PDRuntimeDomainController.m PonyDebugger/ObjC/SocketRocket/SocketRocket/SRWebSocket.m 
PonyDebuggerInjected_FRAMEWORKS = UIKit CoreGraphics CoreData CFNetwork Security
PonyDebuggerInjected_LIBRARIES = icucore

ADDITIONAL_CFLAGS = -IPonyDebugger/ObjC/DerivedSources -IPonyDebugger/ObjC -IPonyDebugger/ObjC/SocketRocket -fobjc-arc -Os -IHeaders -IHeaders/PonyDebugger -Qunused-arguments -Wno-unused-const-variable -Wno-c++11-extensions -Xclang -fobjc-runtime-has-weak

BUNDLE_NAME = PonyDebuggerInjectedBundle
PonyDebuggerInjectedBundle_INSTALL_PATH = /Library/MobileSubstrate/DynamicLibraries
include $(THEOS)/makefiles/bundle.mk

include $(THEOS_MAKE_PATH)/tweak.mk


after-install::
	install.exec "killall -9 SpringBoard"

//
//  AppDelegate.m
//  ant-tool
//
//  Created by 7 on 2018/11/14.
//  Copyright © 2018 alisports. All rights reserved.
//

#import "AppDelegate.h"

//MacOS 开发 - 状态栏 NSStatusBar & NSStatusItem https://blog.csdn.net/lovechris00/article/details/78011718, https://www.jianshu.com/p/bd801d926314

bool ChmodFileWithElevatedPrivilegesFromLocation(NSString *location)
{
    // Create authorization reference
    OSStatus status;
    AuthorizationRef authorizationRef;
    
    status = AuthorizationCreate(NULL, kAuthorizationEmptyEnvironment, kAuthorizationFlagDefaults, &authorizationRef);
    if (status != errAuthorizationSuccess)
    {
        NSLog(@"Error Creating Initial Authorization: %d", status);
        return NO;
    }
    
    AuthorizationItem right = {kAuthorizationRightExecute, 0, NULL, 0};
    AuthorizationRights rights = {1, &right};
    AuthorizationFlags flags =
    kAuthorizationFlagDefaults |
    kAuthorizationFlagInteractionAllowed |
    kAuthorizationFlagPreAuthorize |
    kAuthorizationFlagExtendRights;
    
    status = AuthorizationCopyRights(authorizationRef, &rights, NULL, flags, NULL);
    if (status != errAuthorizationSuccess)
    {
        NSLog(@"Copy Rights Unsuccessful: %d", status);
        return NO;
    }
    
    // use chmod
    char *tool = "/bin/chmod";
    char *args[] = {"777", (char *)[location UTF8String], NULL};
    FILE *pipe = NULL;
    status = AuthorizationExecuteWithPrivileges(authorizationRef, tool, kAuthorizationFlagDefaults, args, &pipe);
    if (status != errAuthorizationSuccess)
    {
        NSLog(@"Error: %d", status);
        return NO;
    }
    
    status = AuthorizationFree(authorizationRef, kAuthorizationFlagDestroyRights);
    return YES;
}

bool MVFileWithElevatedPrivilegesFromLocation(NSString *src, NSString *dst) {
    // Create authorization reference
    OSStatus status;
    AuthorizationRef authorizationRef;
    
    status = AuthorizationCreate(NULL, kAuthorizationEmptyEnvironment, kAuthorizationFlagDefaults, &authorizationRef);
    if (status != errAuthorizationSuccess)
    {
        NSLog(@"Error Creating Initial Authorization: %d", status);
        return NO;
    }
    
    AuthorizationItem right = {kAuthorizationRightExecute, 0, NULL, 0};
    AuthorizationRights rights = {1, &right};
    AuthorizationFlags flags = kAuthorizationFlagDefaults | kAuthorizationFlagInteractionAllowed |
    kAuthorizationFlagPreAuthorize | kAuthorizationFlagExtendRights;
    
    status = AuthorizationCopyRights(authorizationRef, &rights, NULL, flags, NULL);
    if (status != errAuthorizationSuccess)
    {
        NSLog(@"Copy Rights Unsuccessful: %d", status);
        return NO;
    }
    
    // use chmod
    char *tool = "/bin/mv";
    char *args[] = {(char *)[src UTF8String], (char *)[dst UTF8String], NULL};
    FILE *pipe = NULL;
    status = AuthorizationExecuteWithPrivileges(authorizationRef, tool, kAuthorizationFlagDefaults, args, &pipe);
    if (status != errAuthorizationSuccess)
    {
        NSLog(@"Error: %d", status);
        return NO;
    }
    
    status = AuthorizationFree(authorizationRef, kAuthorizationFlagDestroyRights);
    
    return YES;
}

BOOL RMFileWithElevatedPrivilegesFromLocation(NSString *location)

{
    
    // Create authorization reference
    
    OSStatus status;
    
    AuthorizationRef authorizationRef;
    
    // AuthorizationCreate and pass NULL as the initial
    
    // AuthorizationRights set so that the AuthorizationRef gets created
    
    // successfully, and then later call AuthorizationCopyRights to
    
    // determine or extend the allowable rights.
    
    //  CodeGo.net
    
    status = AuthorizationCreate(NULL, kAuthorizationEmptyEnvironment, kAuthorizationFlagDefaults, &authorizationRef);
    
    if (status != errAuthorizationSuccess)
        
    {
        
        NSLog(@"Error Creating Initial Authorization: %d", status);
        
        return NO;
        
    }
    
    // kAuthorizationRightExecute == "system.privilege.admin"
    
    AuthorizationItem right = {kAuthorizationRightExecute, 0, NULL, 0};
    
    AuthorizationRights rights = {1, &right};
    
    AuthorizationFlags flags = kAuthorizationFlagDefaults | kAuthorizationFlagInteractionAllowed |
    
    kAuthorizationFlagPreAuthorize | kAuthorizationFlagExtendRights;
    
    // Call AuthorizationCopyRights to determine or extend the allowable rights.
    
    status = AuthorizationCopyRights(authorizationRef, &rights, NULL, flags, NULL);
    
    if (status != errAuthorizationSuccess)
        
    {
        
        NSLog(@"Copy Rights Unsuccessful: %d", status);
        
        return NO;
        
    }
    
    // use rm tool with -rf
    
    char *tool = "/bin/rm";
    
    char *args[] = {"-rf", (char *)[location UTF8String], NULL};
    
    FILE *pipe = NULL;
    
    status = AuthorizationExecuteWithPrivileges(authorizationRef, tool, kAuthorizationFlagDefaults, args, &pipe);
    
    if (status != errAuthorizationSuccess)
        
    {
        
        NSLog(@"Error: %d", status);
        
        return NO;
        
    }
    
    // The only way to guarantee that a credential acquired when you
    
    // request a right is not shared with other authorization instances is
    
    // to destroy the credential. To do so, call the AuthorizationFree
    
    // function with the flag kAuthorizationFlagDestroyRights.
    
    //  CodeGo.net
    
    status = AuthorizationFree(authorizationRef, kAuthorizationFlagDestroyRights);
    
    return YES;
    
}



//NSDictionary *errorInfo = [NSDictionary new];
//NSString *script =  [NSString stringWithFormat:@"do shell script \"%@\" with administrator privileges", fullScript];
//
//NSAppleScript *appleScript = [[NSAppleScript new] initWithSource:script];
//NSAppleEventDescriptor * eventResult = [appleScript executeAndReturnError:&errorInfo];
//
//// Check errorInfo
//if (! eventResult)
//{
//    // do something you want
//}

@interface AppDelegate ()

@property (nonatomic,strong) NSStatusItem *statusItem;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    
    // Insert code here to initialize your application
    
//    [((NSApplication *)self).mainWindow setAccessibilityHidden:YES];
    
    [self addStatusItem];
    
    // 下面打开沙盒权限，则输出沙盒路径，关闭沙盒权限，则输出系统路径，此时可以获取系统目录操作权限，并执行shell等指令
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *userPath = [NSSearchPathForDirectoriesInDomains(NSUserDirectory, NSUserDomainMask, YES) lastObject];
    NSString *sysPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *desktopPath = [NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"doc path = %@", documentPath);
    NSLog(@"user path = %@", userPath);
    NSLog(@"cache path = %@", sysPath);
    NSLog(@"home path = %@", NSHomeDirectory());
    NSLog(@"desktop path = %@", desktopPath);
    
    NSLog(@"user name = %@", NSUserName());
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

// MARK: -

- (void)runShellCommand:(NSString *)cmd arguments:(NSArray *)arguments {
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath: cmd];
    //数组index 0 shell路径, 如果shell 脚本有输入参数,可以加入数组里，index 1 可以输入$1 @[path,@"$1"],依次延后。
    [task setArguments: arguments];
    [task launch];
}

// MARK: -

- (void)statusOnClick:(NSStatusItem *)item{
    
    NSLog(@"statusOnClick ----- ");
}



- (void)addStatusItem {
    
    //获取系统单例NSStatusBar对象
    NSStatusBar *statusBar = [NSStatusBar systemStatusBar];
    
    NSStatusItem *statusItem = [statusBar statusItemWithLength: NSSquareStatusItemLength];
    
    self.statusItem = statusItem;
    
//    [statusItem setAction:@selector(statusOnClick:)];
    
    [statusItem setToolTip:@"小程序IDE终结者"];
    
    [statusItem setHighlightMode:YES];
    [statusItem setImage: [NSImage imageNamed:@"app-icon_gaitubao_com_20x20"]]; //设置图标，请注意尺寸
    
    
    NSMenu *subMenu = [[NSMenu alloc] initWithTitle:@"Load_TEXT"];
    
    [subMenu addItemWithTitle:@"切换到日常环境"action:@selector(switch2daily) keyEquivalent:@""];
    [subMenu addItemWithTitle:@"切换到预发环境"action:@selector(switch2preproduction) keyEquivalent:@""];
    
   statusItem.menu = subMenu;
}

- (void)switch2daily {
    NSString *src = [NSString stringWithFormat:@"/Users/%@/.ant-devtool.json.bak", NSUserName()];
    NSString *dst = [NSString stringWithFormat:@"/Users/%@/.ant-devtool.json", NSUserName()];
    bool bRet = MVFileWithElevatedPrivilegesFromLocation(src, dst);
    if(!bRet)
    {
        NSLog(@"error");
    }
    else
    {
        NSLog(@"sucess");
    }

}

- (void)switch2preproduction {
    NSString *dst = [NSString stringWithFormat:@"/Users/%@/.ant-devtool.json.bak", NSUserName()];
    NSString *src = [NSString stringWithFormat:@"/Users/%@/.ant-devtool.json", NSUserName()];
    bool bRet = MVFileWithElevatedPrivilegesFromLocation(src, dst);
    if(!bRet)
    {
        NSLog(@"error");
    }
    else
    {
        NSLog(@"sucess");
    }
}

// MARK: -

@end

//
//FOUNDATION_EXPORT NSString *NSUserName(void);
//FOUNDATION_EXPORT NSString *NSFullUserName(void);
//
//FOUNDATION_EXPORT NSString *NSHomeDirectory(void);
//FOUNDATION_EXPORT NSString * _Nullable NSHomeDirectoryForUser(NSString * _Nullable userName);
//
//FOUNDATION_EXPORT NSString *NSTemporaryDirectory(void);
//
//FOUNDATION_EXPORT NSString *NSOpenStepRootDirectory(void);
//
//typedef NS_ENUM(NSUInteger, NSSearchPathDirectory) {
//    NSApplicationDirectory = 1,             // supported applications (Applications)
//    NSDemoApplicationDirectory,             // unsupported applications, demonstration versions (Demos)
//    NSDeveloperApplicationDirectory,        // developer applications (Developer/Applications). DEPRECATED - there is no one single Developer directory.
//    NSAdminApplicationDirectory,            // system and network administration applications (Administration)
//    NSLibraryDirectory,                     // various documentation, support, and configuration files, resources (Library)
//    NSDeveloperDirectory,                   // developer resources (Developer) DEPRECATED - there is no one single Developer directory.
//    NSUserDirectory,                        // user home directories (Users)
//    NSDocumentationDirectory,               // documentation (Documentation)
//    NSDocumentDirectory,                    // documents (Documents)
//    NSCoreServiceDirectory,                 // location of CoreServices directory (System/Library/CoreServices)
//    NSAutosavedInformationDirectory API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)) = 11,   // location of autosaved documents (Documents/Autosaved)
//    NSDesktopDirectory = 12,                // location of user's desktop
//    NSCachesDirectory = 13,                 // location of discardable cache files (Library/Caches)
//    NSApplicationSupportDirectory = 14,     // location of application support files (plug-ins, etc) (Library/Application Support)
//    NSDownloadsDirectory API_AVAILABLE(macos(10.5), ios(2.0), watchos(2.0), tvos(9.0)) = 15,              // location of the user's "Downloads" directory
//    NSInputMethodsDirectory API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)) = 16,           // input methods (Library/Input Methods)
//    NSMoviesDirectory API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)) = 17,                 // location of user's Movies directory (~/Movies)
//    NSMusicDirectory API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)) = 18,                  // location of user's Music directory (~/Music)
//    NSPicturesDirectory API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)) = 19,               // location of user's Pictures directory (~/Pictures)
//    NSPrinterDescriptionDirectory API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)) = 20,     // location of system's PPDs directory (Library/Printers/PPDs)
//    NSSharedPublicDirectory API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)) = 21,           // location of user's Public sharing directory (~/Public)
//    NSPreferencePanesDirectory API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)) = 22,        // location of the PreferencePanes directory for use with System Preferences (Library/PreferencePanes)
//    NSApplicationScriptsDirectory NS_ENUM_AVAILABLE(10_8, NA) = 23,      // location of the user scripts folder for the calling application (~/Library/Application Scripts/code-signing-id)
//    NSItemReplacementDirectory API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)) = 99,        // For use with NSFileManager's URLForDirectory:inDomain:appropriateForURL:create:error:
//    NSAllApplicationsDirectory = 100,       // all directories where applications can occur
//    NSAllLibrariesDirectory = 101,          // all directories where resources can occur
//    NSTrashDirectory API_AVAILABLE(macos(10.8), ios(11.0)) API_UNAVAILABLE(watchos, tvos) = 102             // location of Trash directory
//
//};
//
//typedef NS_OPTIONS(NSUInteger, NSSearchPathDomainMask) {
//    NSUserDomainMask = 1,       // user's home directory --- place to install user's personal items (~)
//    NSLocalDomainMask = 2,      // local to the current machine --- place to install items available to everyone on this machine (/Library)
//    NSNetworkDomainMask = 4,    // publically available location in the local area network --- place to install items available on the network (/Network)
//    NSSystemDomainMask = 8,     // provided by Apple, unmodifiable (/System)
//    NSAllDomainsMask = 0x0ffff  // all domains: all of the above and future items
//};
//
//FOUNDATION_EXPORT NSArray<NSString *> *NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory directory, NSSearchPathDomainMask domainMask, BOOL expandTilde);
//
//NS_ASSUME_NONNULL_END


#import "AppDelegate.h"
#import "GN_Data.h"
@interface AppDelegate () <NSWindowDelegate>

@property (weak) IBOutlet NSWindow *window;
@end
static GN_HelloworldViewController *_shareGN_RVC;
static NSWindow *gnKeyWindow;
@implementation AppDelegate
+ (NSWindow *)getGNKeyWindow
{
    return gnKeyWindow;
}
+ (void)updateData
{
    if ([GN_Data shared].gnIpaPath != nil) {
        _shareGN_RVC.ipaPath.stringValue = [GN_Data shared].gnIpaPath;
    }
    if ([GN_Data shared].gnP12Name != nil) {
        _shareGN_RVC.p12Name.stringValue = [GN_Data shared].gnP12Name;
    }
    if ([GN_Data shared].gnP12Path != nil) {
        _shareGN_RVC.p12Path.stringValue = [GN_Data shared].gnP12Path;
    }
    if ([GN_Data shared].gnMobileProvisionPath != nil) {
        _shareGN_RVC.mobileProvisionPath.stringValue = [GN_Data shared].gnMobileProvisionPath;
    }
    if ([GN_Data shared].gnTeamId != nil) {
        _shareGN_RVC.teamId.stringValue = [GN_Data shared].gnTeamId;
        [GN_Data setDataByKey:gn_TeamId andValue:[GN_Data shared].gnTeamId];
    }
    if ([GN_Data shared].gnBundleId != nil) {
        _shareGN_RVC.bundleId.stringValue = [GN_Data shared].gnBundleId;
        [GN_Data setDataByKey:gn_BundleId andValue:[GN_Data shared].gnBundleId];
    }
    
    if ([GN_Data shared].gnControlLogs != nil) {
        [[[_shareGN_RVC.controlLogs textStorage] mutableString] appendString:[GN_Data shared].gnControlLogs];
    }
}

#pragma mark - NSWindowDelegate
-(BOOL)windowShouldClose:(id)sender
{
    [gnKeyWindow orderOut:nil];
    // 窗口消失
    exit(0);
    return NO;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
    // Insert code here to initialize your application
    self.gnHelloworldViewController = [[GN_HelloworldViewController alloc] initWithNibName:@"GN_HelloworldViewController" bundle:nil];
    _shareGN_RVC = self.gnHelloworldViewController;
    
    [self.window.contentView addSubview:self.gnHelloworldViewController.view];
    self.gnHelloworldViewController.view.frame = self.window.contentView.bounds;
    gnKeyWindow = self.window;
    gnKeyWindow.delegate = self;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    // Insert code here to tear down your application
}

@end

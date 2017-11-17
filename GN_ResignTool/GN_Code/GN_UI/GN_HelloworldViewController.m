
#import "GN_HelloworldViewController.h"
#import "GN_Data.h"
#import "AppDelegate.h"

@interface GN_HelloworldViewController ()

@end

@implementation GN_HelloworldViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    static BOOL isInit;
    if (isInit) {
        return;
    }
    isInit = YES;
    [self.p12Password setDelegate:self];
    [self.teamId setDelegate:self];
    [self.bundleId setDelegate:self];
    
    self.ipaPath.stringValue = [GN_Data getDataByKey:gn_IpaPath];
    [GN_Data shared].gnIpaPath = self.ipaPath.stringValue;
    
    self.p12Password.stringValue = [GN_Data getDataByKey:gn_P12Password];
    [GN_Data shared].gnP12Password = self.p12Password.stringValue;
    
    self.p12Name.stringValue = [GN_Data getDataByKey:gn_P12Name];
    [GN_Data shared].gnP12Name = self.p12Name.stringValue;
    
    self.teamId.stringValue = [GN_Data getDataByKey:gn_TeamId];
    [GN_Data shared].gnTeamId = self.teamId.stringValue;

    self.bundleId.stringValue = [GN_Data getDataByKey:gn_BundleId];
    [GN_Data shared].gnBundleId = self.bundleId.stringValue;

    self.p12Path.stringValue = [GN_Data getDataByKey:gn_P12Path];
    [GN_Data shared].gnP12Path = self.p12Path.stringValue;

    self.mobileProvisionPath.stringValue = [GN_Data getDataByKey:gn_MobileProvisionPath];
    [GN_Data shared].gnMobileProvisionPath = self.mobileProvisionPath.stringValue;
    
    [GN_Data shared].isExpiration_mp= [[GN_Data getDataByKey:gn_IsExpiration_mp] boolValue];
    [GN_Data shared].isExpiration_p12= [[GN_Data getDataByKey:gn_IsExpiration_p12] boolValue];
    [GN_Data shared].isIpa= [[GN_Data getDataByKey:gn_IsIpa] boolValue];
    [GN_Data shared].isP12= [[GN_Data getDataByKey:gn_IsP12] boolValue];
    [GN_Data shared].isMobileProvision= [[GN_Data getDataByKey:gn_IsMobileProvision] boolValue];
    [GN_Data shared].isDevP12= [[GN_Data getDataByKey:gn_IsDevP12] boolValue];
    [GN_Data shared].isDevMobileProvision= [[GN_Data getDataByKey:gn_IsDevMobileProvision] boolValue];


    // Do view setup here.
}
- (void)controlTextDidChange:(NSNotification *)obj
{
    if (self.p12Name.stringValue != nil) {
        [GN_Data shared].gnP12Name = self.p12Name.stringValue;
        [GN_Data setDataByKey:gn_P12Name andValue:self.p12Name.stringValue];
    }
    if (self.p12Password.stringValue != nil) {
        [GN_Data shared].gnP12Password = self.p12Password.stringValue;
    }
    if (self.teamId.stringValue != nil) {
        [GN_Data shared].gnTeamId = self.teamId.stringValue;
        [GN_Data setDataByKey:gn_TeamId andValue:self.teamId.stringValue];
    }
    if (self.bundleId.stringValue != nil) {
        [GN_Data shared].gnBundleId = self.bundleId.stringValue;
        [GN_Data setDataByKey:gn_BundleId andValue:self.bundleId.stringValue];
    }
}
- (void)controlTextDidEndEditing:(NSNotification *)obj
{
    [self.p12Password abortEditing];
}
- (IBAction)clearLogs:(id)sender
{
    [[[self.controlLogs textStorage] mutableString] setString:@""];
    [[GN_Data shared].gnControlLogs setString:@""];
}

- (IBAction)enterpriseIpa:(id)sender
{
    if ([GN_Data isNotAllowResign_enterprise]) {
        return;
    }
//    [AppDelegate updateData];

    NSString *result = @"";
    NSString *shellPath = [GN_Data getShellPath:[[NSBundle mainBundle] resourcePath]];
    NSMutableString *entitlements = [NSMutableString stringWithString:shellPath];

    [entitlements appendFormat:@"/gn_entitlements.plist"];
    [GN_Data shared].gnP12Password = [GN_Data getDataByKey:gn_P12Password];
    NSString *cmd = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@ %@.%@",
                     [GN_Data shared].gnIpaPath,
                     [GN_Data shared].gnMobileProvisionPath,
                     [GN_Data shared].gnP12Path,
                     [GN_Data shared].gnP12Password,
                     entitlements,
                     [GN_Data shared].gnBundleId,
                     [GN_Data shared].gnTeamId,
                     [GN_Data shared].gnBundleId];
    result = [GN_Data shellName:@"gn_resignEnterprise.sh" cmd:cmd inTerminal:YES];
    //    NSLog(@"result=%@", result);
//    [AppDelegate updateData];
}

- (IBAction)devIpa:(id)sender
{
    if ([GN_Data isNotAllowResign_dev]) {
        return;
    }
//    [AppDelegate updateData];
    
    NSString *result = @"";
    NSString *shellPath = [GN_Data getShellPath:[[NSBundle mainBundle] resourcePath]];
    NSMutableString *entitlements = [NSMutableString stringWithString:shellPath];
    [entitlements appendFormat:@"/gn_development.plist"];
    
    NSString *cmd = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@ %@",
                     [GN_Data shared].gnIpaPath,
                     [GN_Data shared].gnMobileProvisionPath,
                     [GN_Data shared].gnP12Path,
                     [GN_Data shared].gnP12Password,
                     entitlements,
                     [GN_Data shared].gnBundleId,
                     [GN_Data shared].gnTeamId];
    result = [GN_Data shellName:@"gn_resignDev.sh" cmd:cmd inTerminal:YES];
    //    NSLog(@"result=%@", result);
//    [AppDelegate updateData];
}

- (IBAction)viewInfoPlist:(id)sender
{
    //    [AppDelegate updateData];
    
    NSString *result = @"";
    NSString *shellPath = [GN_Data getShellPath:[[NSBundle mainBundle] resourcePath]];
    NSMutableString *entitlements = [NSMutableString stringWithString:shellPath];
    [entitlements appendFormat:@"/gn_development.plist"];
    
    NSString *cmd = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@ %@",
                     [GN_Data shared].gnIpaPath,
                     [GN_Data shared].gnMobileProvisionPath,
                     [GN_Data shared].gnP12Path,
                     [GN_Data shared].gnP12Password,
                     entitlements,
                     [GN_Data shared].gnBundleId,
                     [GN_Data shared].gnTeamId];
    result = [GN_Data shellName:@"gn_viewInfoPlist.sh" cmd:cmd inTerminal:YES];
    //    NSLog(@"result=%@", result);
    //    [AppDelegate updateData];
}

- (IBAction)manualReignDev:(id)sender
{
    //    [AppDelegate updateData];
    
    NSString *result = @"";
    NSString *shellPath = [GN_Data getShellPath:[[NSBundle mainBundle] resourcePath]];
    NSMutableString *entitlements = [NSMutableString stringWithString:shellPath];
    [entitlements appendFormat:@"/gn_development.plist"];
    
    NSString *cmd = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@ %@",
                     [GN_Data shared].gnIpaPath,
                     [GN_Data shared].gnMobileProvisionPath,
                     [GN_Data shared].gnP12Path,
                     [GN_Data shared].gnP12Password,
                     entitlements,
                     [GN_Data shared].gnBundleId,
                     [GN_Data shared].gnTeamId];
    result = [GN_Data shellName:@"gn_manualRegisnDev.sh" cmd:cmd inTerminal:YES];
    //    NSLog(@"result=%@", result);
    //    [AppDelegate updateData];
}

@end

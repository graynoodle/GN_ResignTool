
#import <Cocoa/Cocoa.h>
#import "GN_HelloworldViewController.h"
#import "GN_ipaPath.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, strong) IBOutlet GN_HelloworldViewController *gnHelloworldViewController;

+ (void)updateData;
+ (NSWindow *)getGNKeyWindow;
@end


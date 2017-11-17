
#import <Cocoa/Cocoa.h>

@interface GN_HelloworldViewController : NSViewController <NSTextFieldDelegate>
@property (assign) IBOutlet NSTextField *ipaPath;
@property (assign) IBOutlet NSTextField *p12Path;
@property (assign) IBOutlet NSTextField *p12Name;

@property (assign) IBOutlet NSTextField *p12Password;
@property (assign) IBOutlet NSTextField *mobileProvisionPath;
@property (assign) IBOutlet NSTextView *controlLogs;
@property (assign) IBOutlet NSTextField *teamId;
@property (assign) IBOutlet NSTextField *bundleId;

@end



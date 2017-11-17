#import "GN_mobileprovision_path.h"
#import "GN_Data.h"
#import "AppDelegate.h"

@implementation GN_mobileprovision_path


- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType, nil]];

    }
    
    return self;
}

-(NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender{
	NSPasteboard *pboard = [sender draggingPasteboard];
    
	if ([[pboard types] containsObject:NSFilenamesPboardType]) {
			return NSDragOperationCopy;
	}
    
	return NSDragOperationNone;
}

-(BOOL)prepareForDragOperation:(id<NSDraggingInfo>)sender
{
    NSPasteboard *zPasteboard = [sender draggingPasteboard];

    NSArray *list = [zPasteboard propertyListForType:NSFilenamesPboardType];
    NSString *path = [list firstObject];
    
    NSArray *mobileprovision = [path componentsSeparatedByString:@".mobileprovision"];
    [GN_Data setDataByKey:gn_IsMobileProvision andValue:gn_YES];

    if (mobileprovision.count > 1) {
        path = [GN_Data getShellPath:path];

//        path = [path stringByReplacingOccurrencesOfString:@" " withString:@"\\ "];
//        path = [path stringByReplacingOccurrencesOfString:@"(" withString:@"\\("];
//        path = [path stringByReplacingOccurrencesOfString:@")" withString:@"\\)"];
        [GN_Data shared].gnMobileProvisionPath = path;
        //    NSLog(@">>> %@",[GN_Data shared].gnMobileProvisionPath);
        
        NSString *result = @"";
        
        result = [GN_Data shellName:@"gn_importMobileProvision.sh" cmd:[NSString stringWithFormat:@"%@", path] inTerminal:NO];
        //    NSLog(@"result=%@", result);
        
        // 读取teamId和bundleId
        NSArray *identifier = [result componentsSeparatedByString:@"application-identifier</key>\n\t\t<string>"];
        identifier = [[identifier lastObject] componentsSeparatedByString:@"</string>"];
        NSString *identifierStr = [identifier firstObject];
        
        [GN_Data shared].gnTeamId = [[identifierStr componentsSeparatedByString:@"."] firstObject];
        [GN_Data shared].gnBundleId = [[identifierStr componentsSeparatedByString:[NSString stringWithFormat:@"%@.", [GN_Data shared].gnTeamId]] lastObject];
        
        // 授权文件类型
        NSArray *mobileprovisionType = [result componentsSeparatedByString:@"get-task-allow</key>\n\t\t<"];
        mobileprovisionType = [[mobileprovisionType lastObject] componentsSeparatedByString:@"/>"];
        NSString *mobileprovisionTypeStr = [mobileprovisionType firstObject];
        
    
        if ([mobileprovisionTypeStr
             rangeOfString:@"true"].location != NSNotFound) {
            [GN_Data shared].isDevMobileProvision = YES;
            [GN_Data setDataByKey:gn_IsDevMobileProvision andValue:gn_YES];
        } else {
            [GN_Data shared].isDevMobileProvision = NO;
            [GN_Data setDataByKey:gn_IsDevMobileProvision andValue:gn_NO];
        }
        
        // 判断有效期
        NSArray *expiration = [result componentsSeparatedByString:@"ExpirationDate</key>\n\t<date>"];
        expiration = [[expiration lastObject] componentsSeparatedByString:@"Z</date>"];
        NSString *expirationDate = [expiration firstObject];
        expirationDate = [expirationDate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        
        NSDate *currentDate = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
        NSString *currentDateStr = [formatter stringFromDate:currentDate];
        
        [GN_Data addControlLogs:[NSString stringWithFormat:@"\nExpirationDate:%@\n  CurrentDate:%@\n ", expirationDate ,currentDateStr]];
        if ([GN_Data compareDate:currentDateStr withDate:expirationDate dateType:@"YYYY-MM-dd hh:mm:ss"] > 0) {
            [GN_Data addControlLogs:@"mobileprovision is correct\n "];
            [GN_Data shared].isExpiration_mp = NO;
            [GN_Data setDataByKey:gn_IsExpiration_mp andValue:gn_NO];
            [GN_Data setDataByKey:gn_MobileProvisionPath andValue:path];

        } else {
            [GN_Data alertSheetFirstBtnTitle:@"Ok" SecondBtnTitle:@"" MessageText:@"Hint" InformativeText:@"mobileprovision is expired"];
            
            [GN_Data addControlLogs:@"mobileprovision is expired, delete it\n "];
            [GN_Data shellName:@"gn_deleteMobileProvision.sh" cmd:path inTerminal:NO];
            [GN_Data shared].isExpiration_mp = YES;
            [GN_Data setDataByKey:gn_IsExpiration_mp andValue:gn_YES];
        }
        [GN_Data shared].isMobileProvision = YES;

    } else {
        if ([[GN_Data shared].gnMobileProvisionPath rangeOfString:@".mobileprovision"].location != NSNotFound) {
            [GN_Data shared].isMobileProvision = YES;
        } else {
            [GN_Data shared].isMobileProvision = NO;
            [GN_Data setDataByKey:gn_IsMobileProvision andValue:gn_NO];
        }
        
        [GN_Data alertSheetFirstBtnTitle:@"Ok" SecondBtnTitle:@"" MessageText:@"Hint" InformativeText:@"please load a correct mobileprovision"];

        [GN_Data addControlLogs:@"please load a correct mobileprovision\n "];
    }
    

    return YES;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}

@end

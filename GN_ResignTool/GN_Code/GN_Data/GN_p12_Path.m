
#import "GN_p12_Path.h"
#import "GN_Data.h"
#import "AppDelegate.h"

@implementation GN_Get_p12_Path


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

-(BOOL)prepareForDragOperation:(id<NSDraggingInfo>)sender{
    
    NSPasteboard *zPasteboard = [sender draggingPasteboard];
    NSArray *list = [zPasteboard propertyListForType:NSFilenamesPboardType];
    NSString *path = [list firstObject];
    
    NSArray *p12 = [path componentsSeparatedByString:@".p12"];
    [GN_Data setDataByKey:gn_IsP12 andValue:gn_YES];

    if (p12.count > 1) {
        path = [GN_Data getShellPath:path];

//        path = [path stringByReplacingOccurrencesOfString:@" " withString:@"\\ "];
//        path = [path stringByReplacingOccurrencesOfString:@"(" withString:@"\\("];
//        path = [path stringByReplacingOccurrencesOfString:@")" withString:@"\\)"];

        [GN_Data shared].gnP12Path = path;
        
        NSString *result = @"";
        result = [GN_Data shellName:@"gn_importP12.sh" cmd:[NSString stringWithFormat:@"%@ %@", path ,[GN_Data shared].gnP12Password] inTerminal:NO];
        // 判断证书是否成功导入
        if ([result rangeOfString:@"invalid password"].location != NSNotFound) {
            [GN_Data alertSheetFirstBtnTitle:@"Ok" SecondBtnTitle:@"" MessageText:@"Hint" InformativeText:@"p12's password is wrong, please retry!"];
            [GN_Data addControlLogs:@"p12's password is wrong, please retry!\n "];
            
            if ([[GN_Data shared].gnP12Path rangeOfString:@".p12"].location != NSNotFound) {
                [GN_Data shared].isP12 = YES;
            } else {
                [GN_Data shared].isP12 = NO;
                [GN_Data setDataByKey:gn_IsP12 andValue:gn_NO];
            }
            return YES;
        }
        
        // 读取p12Name
        NSArray *p12Name = [result componentsSeparatedByString:@"=iPhone "];
        // 验证证书是否是开发者证书
        if (p12Name.count < 2) {
            if ([[GN_Data shared].gnP12Path rangeOfString:@".p12"].location != NSNotFound) {
                [GN_Data shared].isP12 = YES;
            } else {
                [GN_Data shared].isP12 = NO;
                [GN_Data setDataByKey:gn_IsP12 andValue:gn_NO];
            }
            
            [GN_Data alertSheetFirstBtnTitle:@"Ok" SecondBtnTitle:@"" MessageText:@"Hint" InformativeText:@"p12 is not developer certificate, please retry!"];
            [GN_Data addControlLogs:@"p12 is not developer certificate, please retry!\n "];

            return YES;
        }
        p12Name = [[p12Name lastObject] componentsSeparatedByString:@"/OU="];
        [GN_Data shared].gnP12Name = [NSString stringWithFormat:@"iPhone %@", [p12Name firstObject]];
        //    NSLog(@"result=%@", [GN_Data shared].gnP12Name);
        // 获取证书类型
        if ([[GN_Data shared].gnP12Name
             rangeOfString:@"Distribution"].location == NSNotFound) {
            [GN_Data shared].isDevP12 = YES;
            [GN_Data setDataByKey:gn_IsDevP12 andValue:gn_YES];
        } else {
            [GN_Data setDataByKey:gn_IsDevP12 andValue:gn_NO];
            [GN_Data shared].isDevP12 = NO;
            
        }
        NSArray *valid = [result componentsSeparatedByString:@"identity imported."];
        //    [GN_Data addControlLogs:[NSString stringWithFormat:@"\n当前证书有效期:%@\n当前系统的时间:%@\n ", expirationDate ,currentDateStr]];
        if (valid.count > 1) {
            [GN_Data addControlLogs:@"p12 certificate is correct\n "];
            [GN_Data setDataByKey:gn_P12Path andValue:path];
            [GN_Data setDataByKey:gn_P12Name andValue:[GN_Data shared].gnP12Name];
            
            [GN_Data shared].isExpiration_p12 = NO;
            [GN_Data setDataByKey:gn_IsExpiration_p12 andValue:gn_NO];
            [GN_Data setDataByKey:gn_P12Password andValue:[GN_Data shared].gnP12Password];

        } else {
            [GN_Data shared].isExpiration_p12 = YES;
            [GN_Data setDataByKey:gn_IsExpiration_p12 andValue:gn_YES];

            [GN_Data alertSheetFirstBtnTitle:@"Ok" SecondBtnTitle:@"" MessageText:@"Hint" InformativeText:@"p12 is expired, please retry"];
            
        }
        [GN_Data shared].isP12 = YES;
    } else {
        if ([[GN_Data shared].gnP12Path rangeOfString:@".p12"].location != NSNotFound) {
            [GN_Data shared].isP12 = YES;
        } else {
            [GN_Data shared].isP12 = NO;
            [GN_Data setDataByKey:gn_IsP12 andValue:gn_NO];
        }
        
        [GN_Data alertSheetFirstBtnTitle:@"Ok" SecondBtnTitle:@"" MessageText:@"Hint" InformativeText:@"please load a correct p12 certificate"];
        [GN_Data addControlLogs:@"please load a correct p12 certificate\n "];
    }
    
    
    return YES;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}

@end

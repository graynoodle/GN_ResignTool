
#import "GN_Data.h"
#import "AppDelegate.h"

static GN_Data *_uniqueGN;

@implementation GN_Data

+ (GN_Data*)shared
{
    if (_uniqueGN == nil) {
        _uniqueGN = [[GN_Data alloc] init];
        _uniqueGN.gnControlLogs = [[NSMutableString alloc] init];
        _uniqueGN.gnP12Password = @"1234";

    }
    return _uniqueGN;
}
+ (NSString *)getShellPath:(NSString *)str
{
    NSString *shellPath = [str copy];
    shellPath = [shellPath stringByReplacingOccurrencesOfString:@" " withString:@"\\ "];
    shellPath = [shellPath stringByReplacingOccurrencesOfString:@"(" withString:@"\\("];
    shellPath = [shellPath stringByReplacingOccurrencesOfString:@")" withString:@"\\)"];
    
    return shellPath;
}

+ (NSString *)shellName:(NSString *)shell cmd:(NSString *)cmd inTerminal:(BOOL)status
{
    NSString *shellPath = [GN_Data getShellPath:[[NSBundle mainBundle] resourcePath]];
    NSMutableString *resourcePath = [NSMutableString stringWithString:shellPath];
    
    if (status) {
        [resourcePath appendFormat:@"/gn_executeInTerminal.sh %@", shell];
    } else {
        [resourcePath appendFormat:@"/%@", shell];
    }
    [resourcePath appendFormat:@" %@", cmd];
    NSLog(@"\nshell:%@\n ", resourcePath);
    [GN_Data addControlLogs:[NSString stringWithFormat:@"shell:\n%@\n ", resourcePath]];

    // 初始化并设置shell路径
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath: @"/bin/bash"];
    // -c 用来执行string-commands（命令字符串），也就说不管后面的字符串里是什么都会被当做shellcode来执行
    NSArray *arguments = [NSArray arrayWithObjects: @"-c", resourcePath, nil];
    [task setArguments: arguments];
    
    // 新建输出管道作为Task的输出
    NSPipe *pipe = [NSPipe pipe];
    
//    [task setStandardInput: pipe];
    [task setStandardOutput: pipe];
    [task setStandardError: pipe];
    // 开始task
    NSFileHandle *file = [pipe fileHandleForReading];
    [task launch];
    [task waitUntilExit]; // Alternatively, make it asynchronous.
    
    // 获取运行结果
    NSData *data = [file readDataToEndOfFile];
    NSString * result = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];

    [GN_Data addControlLogs:result];
    
    return result;
}
+ (void)addControlLogs:(NSString *)logs
{
    [[GN_Data shared].gnControlLogs setString:[NSString stringWithFormat:@"%@\n", logs]];
    [AppDelegate updateData];
}
//比较两个日期大小
+ (int)compareDate:(NSString*)firstDate withDate:(NSString*)secondDate dateType:(NSString *)dateType
{
    int comparisonResult;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateType];
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] init];
    date1 = [formatter dateFromString:firstDate];
    date2 = [formatter dateFromString:secondDate];
//    NSLog(@"result==%@",dateType);
//
//    NSLog(@"result==%@",firstDate);
//    NSLog(@"result==%@",secondDate);
//    NSLog(@"result==%@",date1);
//    NSLog(@"result==%@",date2);
    NSComparisonResult result = [date1 compare:date2];
//    NSLog(@"result==%ld",(long)result);
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending:
            comparisonResult = 1;
            break;
            //date02比date01小
        case NSOrderedDescending:
            comparisonResult = -1;
            break;
            //date02=date01
        case NSOrderedSame:
            comparisonResult = 0;
            break;
        default:
            NSLog(@"erorr dates %@, %@", date1, date2);
            break;
    }
    return comparisonResult;
}
#pragma mark- 数据存储
+ (id)getDataByKey:(NSString *)key
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *data = [ud objectForKey:key];
    if (data == nil) {
        data = @"";
    }
    return data;
}
+ (void)setDataByKey:(NSString *)key andValue:(id)value
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:value forKey:key];
    [ud synchronize];
}
#pragma mark- 重签检测
+ (BOOL)commonNotAllow
{
    if ([GN_Data shared].isExpiration_mp) {
        [GN_Data alertSheetFirstBtnTitle:@"Ok" SecondBtnTitle:@"" MessageText:@"Hint" InformativeText:@"mobileprovision is expired"];
        return YES;
    }
    
    if ([GN_Data shared].isExpiration_p12) {
        [GN_Data alertSheetFirstBtnTitle:@"Ok" SecondBtnTitle:@"" MessageText:@"Hint" InformativeText:@"p12 certificate is expired"];
        return YES;
    }
    
    if (![GN_Data shared].isIpa) {
        [GN_Data alertSheetFirstBtnTitle:@"Ok" SecondBtnTitle:@"" MessageText:@"Hint" InformativeText:@"please load a correct ipa or zip"];
        return YES;
    }
    
    if (![GN_Data shared].isP12) {
        [GN_Data alertSheetFirstBtnTitle:@"Ok" SecondBtnTitle:@"" MessageText:@"Hint" InformativeText:@"please load a correct p12 certificate"];
        return YES;
    }
    
    if (![GN_Data shared].isMobileProvision) {
        [GN_Data alertSheetFirstBtnTitle:@"Ok" SecondBtnTitle:@"" MessageText:@"Hint" InformativeText:@"please load a correct mobileprovision"];
        return YES;
    }
    return NO;
}
+ (BOOL)isNotAllowResign_enterprise
{
    if ([GN_Data commonNotAllow]) {
        return YES;
    }
    
    if ([GN_Data shared].isDevP12) {
        [GN_Data alertSheetFirstBtnTitle:@"Ok" SecondBtnTitle:@"" MessageText:@"Hint" InformativeText:@"p12 is a DEV certificate, can not inHouse resign!"];
        return YES;
    }
    
    if ([GN_Data shared].isDevMobileProvision) {
        [GN_Data alertSheetFirstBtnTitle:@"Ok" SecondBtnTitle:@"" MessageText:@"Hint" InformativeText:@"mobileprovision is a DEV provision, can not inHouse resign!"];
        return YES;
    }
    
    return NO;
}
+ (BOOL)isNotAllowResign_dev
{
    if ([GN_Data commonNotAllow]) {
        return YES;
    }
    
    if (![GN_Data shared].isDevP12) {
        [GN_Data alertSheetFirstBtnTitle:@"Ok" SecondBtnTitle:@"" MessageText:@"Hint" InformativeText:@"p12 is a DIS certificate, can not dev resign!"];
        return YES;
    }
    
    if (![GN_Data shared].isDevMobileProvision) {
        [GN_Data alertSheetFirstBtnTitle:@"Ok" SecondBtnTitle:@"" MessageText:@"Hint" InformativeText:@"mobileprovision is a DIS provision, can not inHouse resign!"];
        return YES;
    }
    
    return NO;
}

#pragma mark- AlertHint
+ (void)alertSheetFirstBtnTitle:(NSString *)firstname SecondBtnTitle:(NSString *)secondname MessageText:(NSString *)messagetext InformativeText:(NSString *)informativetext
{

    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:firstname];
    if (![secondname isEqualToString:@""]) {
        [alert addButtonWithTitle:secondname];
    }
    //    [alert addButtonWithTitle:@"chenglibin1"];//可以添加三个按钮
    [alert setMessageText:messagetext];
    [alert setInformativeText:informativetext];
    [alert setAlertStyle:NSWarningAlertStyle];

    NSWindow *window = [[NSApplication sharedApplication] keyWindow];
    if (window == nil) {
        window = [AppDelegate getGNKeyWindow];
    }
//    NSLog(@"window=%@", window);

    [alert beginSheetModalForWindow:window completionHandler:^(NSInteger result) {
        
        if (result == NSAlertFirstButtonReturn) {
            //响应第一个按钮被按下：name：firstname；
            NSLog(@"Ok");
        }
        
        if (result == NSAlertSecondButtonReturn) {
            NSLog(@"Cancel");
        }
        
        if (result == NSAlertThirdButtonReturn) {
            NSLog(@"chenglibin1");
        }
        
    }];
    

}
@end

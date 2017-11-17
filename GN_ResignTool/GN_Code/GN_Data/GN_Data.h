
#import <Foundation/Foundation.h>
#define gn_YES @"1"
#define gn_NO @"0"

#define gn_IpaPath @"gnIpaPath"
#define gn_P12Path @"gnP12Path"
#define gn_P12Name @"gnP12Name"
#define gn_P12Password @"gnP12Password"
#define gn_MobileProvisionPath @"gnMobileProvisionPath"
#define gn_TeamId @"gnTeamId"
#define gn_IsExpiration_mp @"gnIsExpiration_mp"
#define gn_IsExpiration_p12 @"gnIsExpiration_p12"
#define gn_IsIpa @"gnIsIpa"
#define gn_IsP12 @"gnIsP12"
#define gn_BundleId @"gnBundleId"
#define gn_IsMobileProvision @"gnIsMobileProvision"
#define gn_IsDevP12 @"gnIsDevP12"
#define gn_IsDevMobileProvision @"gnIsDevMobileProvision"

@interface GN_Data : NSObject
@property (nonatomic , copy) NSString *gnIpaPath;
@property (nonatomic , copy) NSString *gnP12Path;
@property (nonatomic , copy) NSString *gnP12Name;
@property (nonatomic , copy) NSString *gnP12Password;
@property (nonatomic , copy) NSString *gnMobileProvisionPath;
@property (nonatomic , strong) NSMutableString *gnControlLogs;
@property (nonatomic , copy) NSString *gnTeamId;
@property (nonatomic , copy) NSString *gnBundleId;
@property (nonatomic , assign) BOOL isExpiration_mp;
@property (nonatomic , assign) BOOL isExpiration_p12;
@property (nonatomic , assign) BOOL isIpa;
@property (nonatomic , assign) BOOL isP12;
@property (nonatomic , assign) BOOL isMobileProvision;
@property (nonatomic , assign) BOOL isDevP12;
@property (nonatomic , assign) BOOL isDevMobileProvision;

+ (GN_Data*)shared;
+ (NSString *)shellName:(NSString *)shell cmd:(NSString *)cmd inTerminal:(BOOL)status;
+ (id)getDataByKey:(NSString *)key;
+ (void)setDataByKey:(NSString *)key andValue:(id)value;
+ (int)compareDate:(NSString*)firstDate withDate:(NSString*)secondDate dateType:(NSString *)dateType;
+ (void)addControlLogs:(NSString *)logs;

+ (void)alertSheetFirstBtnTitle:(NSString *)firstname SecondBtnTitle:(NSString *)secondname MessageText:(NSString *)messagetext InformativeText:(NSString *)informativetext;

+ (BOOL)isNotAllowResign_enterprise;
+ (BOOL)isNotAllowResign_dev;
+ (NSString *)getShellPath:(NSString *)str;

@end




#import "GlobalFunctions.h"
#import "GlobalVariables.h"

//#define API_URL @"http://192.168.0.99:8888/trainy"

#define API_URL @"http://52.11.105.182/trainy"

#define MAIN_BUNDLE               [NSBundle mainBundle]
#define MAIN_STORYBOARD           [UIStoryboard storyboardWithName:@"Main" bundle:MAIN_BUNDLE]
#define APPLICATION               [UIApplication sharedApplication]
#define APPLICATION_DELEGATE      ((AppDelegate *)APPLICATION.delegate)
#define CURRENT_DEVICE            [UIDevice currentDevice]
#define USER_DEFAULTS             [NSUserDefaults standardUserDefaults]
#define NOTIFICATION_CENTER       [NSNotificationCenter defaultCenter]
#define CURRENT_CALENDAR          [NSCalendar currentCalendar]
#define LOCAL_TIME_ZONE           [NSTimeZone localTimeZone]
#define CURRENT_RUN_LOOP          [NSRunLoop currentRunLoop]

#define INSTANTIATE_CONTROLLER(controllerIdent) [MAIN_STORYBOARD instantiateViewControllerWithIdentifier:controllerIdent]
#define INSTANTIATE_CONTROLLER_WITH_TYPE(controllerIdent, controllerType) (controllerType *)[MAIN_STORYBOARD instantiateViewControllerWithIdentifier:controllerIdent]

#define STATUS_BAR_HEIGHT         20


// app colors
#define RGB(r, g, b)              [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define RGBA(r, g, b, a)          [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

// main bundle macros
#define MAIN_BUNDLE_OBJECT(key)   [[MAIN_BUNDLE infoDictionary] objectForKey:key]


// iOS version check macros
#define IS_IOS_VERSION_EQ(ver)    ([[CURRENT_DEVICE systemVersion] floatValue] == ver)
#define IS_IOS_VERSION_GT(ver)    ([[CURRENT_DEVICE systemVersion] floatValue] > ver)
#define IS_IOS_VERSION_GTEQ(ver)  ([[CURRENT_DEVICE systemVersion] floatValue] >= ver)
#define IS_IOS_VERSION_LT(ver)    ([[CURRENT_DEVICE systemVersion] floatValue] < ver)


// device check macros
#define IS_IPAD                   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)


// localize macros
#define L(key)                    NSLocalizedString(key, nil)
#define LOC(key, comment)         NSLocalizedString(key, comment)


// log macros
#ifdef DEBUG
#    define DLog(...) NSLog(__VA_ARGS__)
#else
#    define DLog(...) /* */
#endif
#define ALog(...) NSLog(__VA_ARGS__)

#define KEY_USERINFO                    @"UserInfo"

#define KEY_SUCCESS                     @"SUCCESS"
#define KEY_RESULT                      @"Results"

#define ERROR_TITLE                     @"ALERT!"
#define MISSED_NAME                     @"Please add your name"
#define MISSED_USERNAME                 @"Please add your username"
#define MISSED_PASSWORD                 @"Please add your password"
#define MISSED_EMAIL                    @"Please add your email address"
#define INVALID_EMAIL                   @"Your email address is not valid"
#define MISSED_PROFILE_PHOTO            @"Please add your profile photo"
#define MISSED_WEBSITE                  @"Please add your website"
#define MISSED_CITY                     @"Please add your city"
#define MISSED_PERSONALINFO             @"Please add your personal info"
#define MISSED_BACKGROUND               @"Please add your background"
#define ERROR_CANT_MAIL                 @"This device cannt send mail"
#define MISSED_REVIEW                   @"Please write your review"

#define INTERNET_BROKEN                 @"Your request couldn't be completed.\nPlease check your internet connection."

#define ACTION_BOOKMARK                 @"BOOKMARK Action"



#define CURRENT_USER                    [GlobalVariables sharedInstance].curUser
#define CURRENT_USER_ID                 CURRENT_USER.user_id

#define SEARCHED_USERS                  [GlobalVariables sharedInstance].arr_SearchedUsers
#define SEARCHED_BOOKMARKED_TRAINER     [GlobalVariables sharedInstance].arr_SearchedBookmarkedTrainer
#define SEARCHED_BOOKMARKED_TRAINEE     [GlobalVariables sharedInstance].arr_SearchedBookmarkedTrainee

#define isCurUser                       [GlobalVariables sharedInstance].fSelfUser
#define DEVICE_TOKEN                    [GlobalVariables sharedInstance].deviceToken

#define DataManager                     [GlobalVariables sharedInstance]
#define FUNCTION                        [GlobalFunctions sharedInstance]



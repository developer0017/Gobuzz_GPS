//
//  SocialNetwork.h
//  HashApp
//
//  Created by Alexey Grabov on 7/16/15.
//
//

typedef void (^completionService) (NSData *data, NSURLResponse *response, NSError *error);

#import <Foundation/Foundation.h>

@interface SocialNetwork : NSObject
{
    NSString    *method;
    NSURLConnection *connection;
    completionService   service;
}
-(void)deleteUser:(NSDictionary *)params withCompletion:(completionService) block;
-(void)regisreUser:(NSDictionary *)params withImage:(UIImage*)image withCompletion:(completionService) block;
-(void)updateUserInfo:(NSDictionary *)params withImage:(UIImage*)image withCompletion:(completionService) block;
-(void)loginUser:(NSDictionary *)params withCompletion:(completionService) block;
-(void)updateEmailVerification:(NSDictionary *)params withCompletion:(completionService) block;
-(void)getUserInfo:(NSDictionary *)params withCompletion:(completionService) block;
-(void)getAroundUser:(NSDictionary *)params withCompletion:(completionService) block;
-(void)updateUser:(NSDictionary *)params withCompletion:(completionService) block;
-(void)updateConnects:(NSDictionary *)params withCompletion:(completionService) block;
-(void)sendInfo:(NSDictionary*)params withCompletion:(completionService) block;
-(void)getInfos:(NSDictionary*)params withCompletion:(completionService) block;
-(void)sendNotifications:(NSDictionary*)params withCompletion:(completionService) block;
-(void)getNotifications:(NSDictionary*)params withCompletion:(completionService) block;
-(void)declineNotifications:(NSDictionary*)params withCompletion:(completionService) block;
-(void)acceptNotifications:(NSDictionary*)params withCompletion:(completionService) block;
-(void)forgotPassword:(NSDictionary*)params withCompletion:(completionService) block;
-(void)emailVerification:(NSDictionary*)params withCompletion:(completionService) block;
-(void)checkEmail:(NSDictionary*)params withCompletion:(completionService) block;
-(void)checkMobile:(NSDictionary*)params withCompletion:(completionService) block;
-(void)deleteHistory:(NSDictionary *)params withCompletion:(completionService) block;
@end


static const NSString *SERVER_URL = @"http://gobuzz.buzz/gobuzz/apis/";

#import "SocialNetwork.h"

@implementation SocialNetwork

- (id) init {
    if (self = [super init]) {

    }
    return self;
}

- (void)sendRequest:(NSDictionary *)dictionary
{

    NSString *serviceUrl = [NSString stringWithFormat:@"%@%@",SERVER_URL, [dictionary objectForKey:@"method"]];
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig
                                  delegate:nil
                             delegateQueue:nil];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:serviceUrl]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSDictionary *paramsDic = [dictionary objectForKey:@"params"];
    NSMutableData *body = [NSMutableData data];
    for (NSString *key in paramsDic) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[paramsDic objectForKey:key] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    NSURLSessionDataTask *jsonDataTask = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData *data,
                                                                NSURLResponse *response,
                                                                NSError *error) {
                                                if (service != nil) {
                                                    service(data, response, error);
                                                }                                                
                                            }];
    [jsonDataTask resume];
}

- (void)sendRequest:(NSDictionary *)dictionary withImage:(UIImage *)image
{

    NSString *serviceUrl = [NSString stringWithFormat:@"%@%@",SERVER_URL, [dictionary objectForKey:@"method"]];
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig
                                                          delegate:nil
                                                     delegateQueue:nil];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:serviceUrl]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    NSDictionary *paramsDic = [dictionary objectForKey:@"params"];
    for (NSString *key in paramsDic) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[paramsDic objectForKey:key] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"userimage\"; filename=\"ipodfile.png\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:UIImagePNGRepresentation(image)]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    NSURLSessionDataTask *jsonDataTask = [session dataTaskWithRequest:request
                         completionHandler:^(NSData *data,
                                             NSURLResponse *response,
                                             NSError *error) {
                             
                             service(data, response, error);
                             
                         }];
    [jsonDataTask resume];
}

-(void)deleteUser:(NSDictionary *)params withCompletion:(completionService) block
{
    service = block;
    method = @"deleteuser.php";
    [self sendRequest:[NSDictionary dictionaryWithObjectsAndKeys:method, @"method", params, @"params", nil]];
}

-(void)regisreUser:(NSDictionary *)params withImage:(UIImage*)image withCompletion:(completionService) block
{
    service = block;
    method = @"register.php";
    [self sendRequest:[NSDictionary dictionaryWithObjectsAndKeys:method, @"method", params, @"params", nil] withImage:image];
}

-(void)updateUserInfo:(NSDictionary *)params withImage:(UIImage*)image withCompletion:(completionService) block
{
    service = block;
    method = @"updateuserinfo.php";
    [self sendRequest:[NSDictionary dictionaryWithObjectsAndKeys:method, @"method", params, @"params", nil] withImage:image];
}

-(void)loginUser:(NSDictionary *)params withCompletion:(completionService) block
{
    service = block;
    method = @"loginuser.php";
    [self sendRequest:[NSDictionary dictionaryWithObjectsAndKeys:method, @"method", params, @"params", nil]];
}

-(void)updateEmailVerification:(NSDictionary *)params withCompletion:(completionService) block
{
    service = block;
    method = @"updateverification.php";
    [self sendRequest:[NSDictionary dictionaryWithObjectsAndKeys:method, @"method", params, @"params", nil]];
}

-(void)getUserInfo:(NSDictionary *)params withCompletion:(completionService) block
{
    service = block;
    method = @"getuserinfo.php";
    [self sendRequest:[NSDictionary dictionaryWithObjectsAndKeys:method, @"method", params, @"params", nil]];
}

-(void)getAroundUser:(NSDictionary *)params withCompletion:(completionService) block
{
    service = block;
    method = @"getarounduser.php";
    [self sendRequest:[NSDictionary dictionaryWithObjectsAndKeys:method, @"method", params, @"params", nil]];
}

-(void)updateUser:(NSDictionary *)params withCompletion:(completionService) block
{
    service = block;
    method = @"updateuser.php";
    [self sendRequest:[NSDictionary dictionaryWithObjectsAndKeys:method, @"method", params, @"params", nil]];
}

-(void)updateConnects:(NSDictionary *)params withCompletion:(completionService) block
{
    service = block;
    method = @"updateconnects.php";
    [self sendRequest:[NSDictionary dictionaryWithObjectsAndKeys:method, @"method", params, @"params", nil]];
}


-(void)sendInfo:(NSDictionary*)params withCompletion:(completionService) block
{
    service = block;
    method = @"sendinfos.php";
    [self sendRequest:[NSDictionary dictionaryWithObjectsAndKeys:method, @"method", params, @"params", nil]];
}

-(void)getInfos:(NSDictionary*)params withCompletion:(completionService) block
{
    service = block;
    method = @"getinfos.php";
    [self sendRequest:[NSDictionary dictionaryWithObjectsAndKeys:method, @"method", params, @"params", nil]];
}

-(void)sendNotifications:(NSDictionary*)params withCompletion:(completionService) block
{
    service = block;
    method = @"sendnotification.php";
    [self sendRequest:[NSDictionary dictionaryWithObjectsAndKeys:method, @"method", params, @"params", nil]];
}

-(void)getNotifications:(NSDictionary*)params withCompletion:(completionService) block
{
    service = block;
    method = @"getnotifications.php";
    [self sendRequest:[NSDictionary dictionaryWithObjectsAndKeys:method, @"method", params, @"params", nil]];
}

-(void)declineNotifications:(NSDictionary*)params withCompletion:(completionService) block
{
    service = block;
    method = @"declinenotification.php";
    [self sendRequest:[NSDictionary dictionaryWithObjectsAndKeys:method, @"method", params, @"params", nil]];
}

-(void)acceptNotifications:(NSDictionary*)params withCompletion:(completionService) block
{
    service = block;
    method = @"acceptnotification.php";
    [self sendRequest:[NSDictionary dictionaryWithObjectsAndKeys:method, @"method", params, @"params", nil]];
}

-(void)forgotPassword:(NSDictionary*)params withCompletion:(completionService) block
{
    service = block;
    method = @"forgot_password.php";
    [self sendRequest:[NSDictionary dictionaryWithObjectsAndKeys:method, @"method", params, @"params", nil]];
}

-(void)emailVerification:(NSDictionary*)params withCompletion:(completionService) block
{
    service = block;
    method = @"emailverification.php";
    [self sendRequest:[NSDictionary dictionaryWithObjectsAndKeys:method, @"method", params, @"params", nil]];
}

-(void)checkEmail:(NSDictionary*)params withCompletion:(completionService) block
{
    service = block;
    method = @"checkemail.php";
    [self sendRequest:[NSDictionary dictionaryWithObjectsAndKeys:method, @"method", params, @"params", nil]];
}

-(void)checkMobile:(NSDictionary*)params withCompletion:(completionService) block
{
    service = block;
    method = @"checkmobile.php";
    [self sendRequest:[NSDictionary dictionaryWithObjectsAndKeys:method, @"method", params, @"params", nil]];
}

-(void)deleteHistory:(NSDictionary *)params withCompletion:(completionService) block
{
    service = block;
    method = @"deletehistory.php";
    [self sendRequest:[NSDictionary dictionaryWithObjectsAndKeys:method, @"method", params, @"params", nil]];
}
@end

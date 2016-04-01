//
//  APIManager.m
//
//  Copyright © 2015 Aje. All rights reserved.


#import "APIManager.h"

@implementation APIManager
@synthesize strDeviceToken;

+(APIManager*)sharedInstance{
    
    static APIManager * _sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[APIManager alloc] init];
        

    });
    
    
    return _sharedInstance;
}


- (void)callAPIwithURL:(NSString *)strURL withParameters:(NSDictionary *)parameters withCompletionHandler:(void (^)(id, NSError *, AFHTTPSessionManager *))handler{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
    [serializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [serializer setValue:@"*/*" forHTTPHeaderField:@"Accept"];
    manager.requestSerializer = serializer;
    
    [manager.requestSerializer setValue:@"" forHTTPHeaderField:@""];
    
    [manager POST:strURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
     NSLog(@"parameters  %@", parameters );
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        handler(responseObject, nil, manager);
                
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        handler(nil, error, manager);
        
    }];
}



@end

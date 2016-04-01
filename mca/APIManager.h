//  APIManager.h
//  Copyright © 2015 Aje. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "AFNetworking.h"

@interface APIManager : NSObject

@property (strong,nonatomic)NSString *strDeviceToken;

+ (APIManager*)sharedInstance;


- (void)callAPIwithURL:(NSString *)strURL withParameters:(NSDictionary *)parameters withCompletionHandler:(void(^)(id responseObject, NSError* error, AFHTTPSessionManager *operation))completionHandler ;




@end

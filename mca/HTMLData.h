//
//  HTMLData.h
//  
//
//  Created by Aurionpro2 on 24/02/16.
//
//

#import <Foundation/Foundation.h>

#define KEY_REQUEST_ID @"KEY_REQUEST_ID"
#define KEY_CAPTCHA @"KEY_CAPTCHA"

@interface HTMLData : NSObject
//new changes
-(NSDictionary*)dataFromHtmlForCaptchNRequestId:(NSString*) ogHtml;


//old
-(NSString*)dataFromHtmlForKYPByPAN:(NSString*) ogHtml;
-(NSString*)dataFromHtmlForKYPByName:(NSString*) ogHtml;
-(NSMutableArray*)dataFromHtmlForCatOfDeduction:(NSString*) ogHtml;
-(NSMutableArray*)dataFromHtmlForState:(NSString*) ogHtml;

//tan

-(id)dataFromHtmlForCompList:(NSString*) ogHtml;
-(NSString*)dataFromHtmlForCompanyTAN:(NSString*) ogHtml;
@end


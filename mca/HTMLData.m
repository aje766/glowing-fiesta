//
//  HTMLData.m
//  
//
//  Created by Aurionpro2 on 24/02/16.
//
//

#import "HTMLData.h"
#import "HTMLParser.h"




@implementation HTMLData


-(NSDictionary*)dataFromHtmlForCaptchNRequestId:(NSString*) ogHtml
{
    NSMutableDictionary * dictResult= [[NSMutableDictionary alloc] init];
    NSError *error = nil;
    NSString *html = ogHtml;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
    
    NSString * strRequestId = @"";
    NSString * strCaptchURL = @"";
    
    if (error) {
        NSLog(@"Error: %@", error);
        
    }
    else
    {
        HTMLNode *bodyNode = [parser body];
        
        NSArray *inputNodes = [bodyNode findChildTags:@"input"];
        
        for (HTMLNode *inputNode in inputNodes) {
//            if ([[inputNode getAttributeNamed:@"id"] isEqualToString:@"KnowYourJurisdiction_requestId"]) {
            if ([[inputNode getAttributeNamed:@"name"] isEqualToString:@"requestId"]) {
                
                NSLog(@"%@", [inputNode getAttributeNamed:@"value"]); //Answer to first question
                strRequestId = [inputNode getAttributeNamed:@"value"];
                
                break;
            }
        }
        
        [dictResult setValue:strRequestId forKey:KEY_REQUEST_ID];
        
        
        NSArray *inputNodes1 = [bodyNode findChildTags:@"img"];
        
        for (HTMLNode *inputNode in inputNodes1) {
            if ([[inputNode getAttributeNamed:@"id"] isEqualToString:@"captchaImg"]) {
                NSLog(@"%@", [inputNode getAttributeNamed:@"src"]); //Answer to first question
                strCaptchURL = [inputNode getAttributeNamed:@"src"];
                
                break;
            }
        }
        
        [dictResult setValue:strCaptchURL forKey:KEY_CAPTCHA];
        
        //        NSArray *spanNodes = [bodyNode findChildTags:@"span"];
        //
        //        for (HTMLNode *spanNode in spanNodes) {
        //            if ([[spanNode getAttributeNamed:@"class"] isEqualToString:@"spantext"]) {
        //                NSLog(@"%@", [spanNode rawContents]); //Answer to second question
        //            }
        //        }
        
        
        
    }
    
    return dictResult;
}


-(NSString*)dataFromHtmlForKYPByPAN:(NSString*) ogHtml
{
    NSString *strReturn = @"";
    NSError *error = nil;
    NSString *html = ogHtml;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
    
    
    if (error) {
        NSLog(@"Error: %@", error);
        strReturn = @"";
    }
    else
    {
        HTMLNode *bodyNode = [parser body];
        
        NSArray *inputNodes = [bodyNode findChildTags:@"div"];
        
        for (HTMLNode *inputNode in inputNodes) {
            if ([[inputNode getAttributeNamed:@"class"] isEqualToString:@"reportsTopDiv"]) {
                NSLog(@"%@", [inputNode rawContents]); //Answer to first question
                strReturn = [inputNode rawContents];
           
                break;
            }
        }
        
//        NSArray *spanNodes = [bodyNode findChildTags:@"span"];
//        
//        for (HTMLNode *spanNode in spanNodes) {
//            if ([[spanNode getAttributeNamed:@"class"] isEqualToString:@"spantext"]) {
//                NSLog(@"%@", [spanNode rawContents]); //Answer to second question
//            }
//        }
        
  
        
    }
    
    return strReturn;
}

-(NSString*)dataFromHtmlForKYPByName:(NSString*) ogHtml
{
    NSString *strReturn = @"";
    NSError *error = nil;
    NSString *html = ogHtml;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
    
    
    if (error) {
        NSLog(@"Error: %@", error);
        strReturn = @"";
    }
    else 
    {
        HTMLNode *bodyNode = [parser body];
        
        NSArray *inputNodes = [bodyNode findChildTags:@"div"];
        
        for (HTMLNode *inputNode in inputNodes) {
            if ([[inputNode getAttributeNamed:@"id"] isEqualToString:@"staticContentsUrl"]) {
//                NSArray *capTag = [inputNode findChildTag:@"caption"];
//                [inputNode ra]
                NSArray *arrTable = [inputNode findChildTags:@"table"];
                for (HTMLNode *tableNode in arrTable) {
                    HTMLNode *captionNode = [tableNode findChildTag:@"caption"];
                    if ([[captionNode rawContents] isEqualToString:@"<caption>PAN Details</caption>"]) {
                        NSLog(@"%@", [tableNode rawContents]); //Answer to first question
                        strReturn = [tableNode rawContents];
                        break;
                    }
                }
               
                
                
            }
        }
        
        //        NSArray *spanNodes = [bodyNode findChildTags:@"span"];
        //
        //        for (HTMLNode *spanNode in spanNodes) {
        //            if ([[spanNode getAttributeNamed:@"class"] isEqualToString:@"spantext"]) {
        //                NSLog(@"%@", [spanNode rawContents]); //Answer to second question
        //            }
        //        }
        
        
        
    }
    
    return strReturn;
}


-(NSMutableArray*)dataFromHtmlForCatOfDeduction:(NSString*) ogHtml
{
    NSString *strReturn = @"";
    NSError *error = nil;
    NSString *html = ogHtml;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
    
    NSMutableArray *arrMainData = [[NSMutableArray alloc] init];
    
    if (error) {
        NSLog(@"Error: %@", error);
        strReturn = @"";
    }
    else
    {
        HTMLNode *bodyNode = [parser body];
        
        NSArray *inputNodes = [bodyNode findChildTags:@"select"];
        
        for (HTMLNode *inputNode in inputNodes) {
            if ([[inputNode getAttributeNamed:@"id"] isEqualToString:@"KnowYourTan_searchCriteria_category"]) {
                NSArray *arrOptions = [inputNode findChildTags:@"option"];
                
                
                for (HTMLNode *optionNode in arrOptions) {
                    
                    NSString * strValueContent = [[optionNode contents] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    
                    if (![strValueContent.uppercaseString isEqualToString:@"SELECT"]) {
                        NSMutableArray *arrTempOptionNode = [[NSMutableArray alloc] init];
                        [arrTempOptionNode addObject:[optionNode getAttributeNamed:@"value"]];
                        [arrTempOptionNode addObject:strValueContent];
                        
                        [arrMainData addObject:arrTempOptionNode];
                    }
                    
                    
                }
                
                
                
            }
        }
        
        
        
    }
    
    return arrMainData;
}
-(NSMutableArray*)dataFromHtmlForState:(NSString*) ogHtml
{
    NSString *strReturn = @"";
    NSError *error = nil;
    NSString *html = ogHtml;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
    
    NSMutableArray *arrMainData = [[NSMutableArray alloc] init];
    
    if (error) {
        NSLog(@"Error: %@", error);
        strReturn = @"";
    }
    else
    {
        HTMLNode *bodyNode = [parser body];
        
        NSArray *inputNodes = [bodyNode findChildTags:@"select"];
        
        for (HTMLNode *inputNode in inputNodes) {
            if ([[inputNode getAttributeNamed:@"id"] isEqualToString:@"KnowYourTan_searchCriteria_state"]) {
                NSArray *arrOptions = [inputNode findChildTags:@"option"];
                
                
                for (HTMLNode *optionNode in arrOptions) {
                    
                    NSString * strValueContent = [[optionNode contents] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    
                    if (![strValueContent.uppercaseString isEqualToString:@"SELECT"]) {
                        NSMutableArray *arrTempOptionNode = [[NSMutableArray alloc] init];
                        [arrTempOptionNode addObject:[optionNode getAttributeNamed:@"value"]];
                        [arrTempOptionNode addObject:strValueContent];
                        
                        [arrMainData addObject:arrTempOptionNode];
                    }
                    
                }
                
                
                
            }
        }
        
        
        
    }
    
    return arrMainData;
}


-(id)dataFromHtmlForCompList:(NSString*) ogHtml
{
    NSString *strReturn = @"";
    NSError *error = nil;
    NSString *html = ogHtml;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
    
    NSMutableArray *arrMainData = [[NSMutableArray alloc] init];
    
    if (error) {
        NSLog(@"Error: %@", error);
        strReturn = @"";
        
        return @"";
    }
    else
    {
        if ([ogHtml rangeOfString:@"TAN AO Code"].location == NSNotFound) {
            
            HTMLNode *bodyNode = [parser body];
            
            NSArray *inputNodes = [bodyNode findChildTags:@"div"];
            
            for (HTMLNode *inputNode in inputNodes) {
                if ([[inputNode getAttributeNamed:@"class"] isEqualToString:@"reportsTopDiv"]) {
                    
                    NSArray *arrTable = [inputNode findChildTags:@"table"];
                    for (HTMLNode *tableNode in arrTable) {
                        HTMLNode *captionNode = [tableNode findChildTag:@"caption"];
                        if ([[captionNode rawContents] isEqualToString:@"<caption>TAN Details</caption>"]) {
                            NSLog(@"%@", [tableNode rawContents]); //Answer to first question
                            
                            NSArray *arrTr = [inputNode findChildTags:@"tr"];
                            for (HTMLNode *trNode in arrTr) {
                                NSArray *arrTd = [trNode findChildTags:@"td"];
                                NSMutableDictionary *dictTempValueNode = [[NSMutableDictionary alloc] init];
                                for (HTMLNode *tdNode in arrTd) {
                                    //                                NSString * strValueContent = [[optionNode contents] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                                    
                                    HTMLNode *aNode = [tdNode findChildTag:@"a"];
                                    if (aNode != nil) {
                                        NSString *strHref = [aNode getAttributeNamed:@"href"];
                                        NSString *strHrefText = [tdNode rawContents];
                                        
                                        [dictTempValueNode setValue:strHref forKey:@"href"];
                                        
                                        NSRange r1 = [strHrefText rangeOfString:@"</a>"];
                                        NSRange r2 = [strHrefText rangeOfString:@"</td>"];
                                        NSRange rSub = NSMakeRange(r1.location + r1.length, r2.location - r1.location - r1.length);
                                        NSString *sub = [strHrefText substringWithRange:rSub];
                                        
                                        [dictTempValueNode setValue:[sub  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"hrefText"];
                                    }
                                    else
                                    {
                                        NSString *strContent = [tdNode contents];
                                        if([strContent intValue] == 0)
                                        {
                                            if ([strContent isEqualToString:@""] || strContent == nil) {
                                                strContent = @"NO PLACE";
                                            }
                                            [dictTempValueNode setValue:strContent forKey:@"place"];
                                        }
                                        else
                                        {
                                            [dictTempValueNode setValue:strContent forKey:@"index"];
                                        }
                                        
                                    }
                                    
                                }
                                if (dictTempValueNode.count >= 4) {
                                    [arrMainData addObject:dictTempValueNode];
                                }
                                
                            }
                            
                            break;
                        }
                    }
                    
                    
                    
                }
            }
            
            
            NSLog(@"%@", arrMainData);
            return arrMainData;
            
        }
        else
        {
            HTMLNode *bodyNode = [parser body];
            
            NSArray *inputNodes = [bodyNode findChildTags:@"div"];
            
            for (HTMLNode *inputNode in inputNodes) {
                if ([[inputNode getAttributeNamed:@"id"] isEqualToString:@"staticContentsUrl"]) {
                    //                NSArray *capTag = [inputNode findChildTag:@"caption"];
                    //                [inputNode ra]
                    NSArray *arrTable = [inputNode findChildTags:@"table"];
                    for (HTMLNode *tableNode in arrTable) {
                        HTMLNode *captionNode = [tableNode findChildTag:@"caption"];
                        if ([[captionNode rawContents] isEqualToString:@"<caption>TAN Details</caption>"]) {
                            NSLog(@"%@", [tableNode rawContents]); //Answer to first question
                            strReturn = [tableNode rawContents];
                            break;
                        }
                    }
                    
                    
                    
                }
            }
            
            return strReturn;
            
        }
    }
    
}



-(NSString*)dataFromHtmlForCompanyTAN:(NSString*) ogHtml
{
    NSString *strReturn = @"";
    NSError *error = nil;
    NSString *html = ogHtml;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
    
    
    if (error) {
        NSLog(@"Error: %@", error);
        strReturn = @"";
    }
    else
    {
        HTMLNode *bodyNode = [parser body];
        
        NSArray *inputNodes = [bodyNode findChildTags:@"div"];
        
        for (HTMLNode *inputNode in inputNodes) {
            if ([[inputNode getAttributeNamed:@"id"] isEqualToString:@"staticContentsUrl"]) {
                //                NSArray *capTag = [inputNode findChildTag:@"caption"];
                //                [inputNode ra]
                NSArray *arrTable = [inputNode findChildTags:@"table"];
                for (HTMLNode *tableNode in arrTable) {
                    HTMLNode *captionNode = [tableNode findChildTag:@"caption"];
                    if ([[captionNode rawContents] isEqualToString:@"<caption>TAN Details</caption>"]) {
                        NSLog(@"%@", [tableNode rawContents]); //Answer to first question
                        strReturn = [tableNode rawContents];
                        break;
                    }
                }
                
                
                
            }
        }
        
        
    }
    
    return strReturn;
}



@end

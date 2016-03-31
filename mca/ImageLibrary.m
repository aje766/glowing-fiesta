//
//  ImageLibrary.m
//  mca
//
//  Created by Ajay on 31/03/16.
//  Copyright © 2016 Ajay. All rights reserved.
//

#import "ImageLibrary.h"
#import "AFNetwork/AFNetworking.h"
#include <sys/xattr.h> // Needed import for setting file attributes exclude form backup

@implementation ImageLibrary




-(void)downloadImage
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:@"https://themobilewallet.com/TMWB2C/Image/x/anniversary_icon.png"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
        [self addSkipBackupAttributeToItemAtURL:filePath]; //prevent from cloud backup
        
        
    }];
    [downloadTask resume];
}


- (void)getImageWith:(NSString*)imageName withDownloadCompletionHandler:(void (^)(NSURLResponse *, NSURL *, NSError *, UIImage *))handler
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:imageName];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:getImagePath];
    if (fileExists) {
        UIImage *img = [UIImage imageWithContentsOfFile:getImagePath];
        
        handler(nil, [NSURL URLWithString:getImagePath], nil, img);
    }
    else
    {
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        NSString *strURL = [NSString stringWithFormat:@"%@%@",@"https://www.google.co.in/logos/doodles/2016/",imageName];
        
        NSURL *URL = [NSURL URLWithString:strURL]; //@"https://themobilewallet.com/TMWB2C/Image/x/anniversary_icon.png"
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            NSLog(@"File downloaded to: %@", filePath);
            [self addSkipBackupAttributeToItemAtURL:filePath]; //prevent from cloud backup
            
            
            NSArray *pathsNew = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectoryNew = [pathsNew objectAtIndex:0];
            NSString *getImagePathNew = [documentsDirectoryNew stringByAppendingPathComponent:imageName];
            
            UIImage *imgNew = [UIImage imageWithContentsOfFile:getImagePathNew];
            
            
            handler(response, filePath, error, imgNew);
            
        }];
        [downloadTask resume];
        
        
    }
    
    //    _tempImg.frame = CGRectMake(0, 0, img.size.width/2, img.size.height/2);
    //    _tempImg.image = img;
    
}


-(NSString *)imageNameForOccasion:(NSString *)occasionName
{
    NSString * strOccasionName = [occasionName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *strImgName = @"placeholder";
//    if ([strOccasionName caseInsensitiveCompare:@"Anniversary"] == NSOrderedSame){
//        strImgName = kIMG_ANNIVERSARY;
//    }
//    else if ([strOccasionName caseInsensitiveCompare:@"Birthday"] == NSOrderedSame){
//        strImgName = kIMG_BIRTHDAY;
//    }
//    else if ([strOccasionName caseInsensitiveCompare:@"Sorry"] == NSOrderedSame){
//        strImgName = kIMG_SORRY;
//    }
//    else if ([strOccasionName caseInsensitiveCompare:@"ThankYou"] == NSOrderedSame){
//        strImgName = kIMG_THANK_YOU;
//    }
//    else if ([strOccasionName caseInsensitiveCompare:@"GetWellSoon"] == NSOrderedSame){
//        strImgName = kIMG_GET_WELL;
//    }
//    else if ([strOccasionName caseInsensitiveCompare:@"Congratulation"] == NSOrderedSame){
//        strImgName = kIMG_CONGRATULATION;
//    }
    
    return strImgName;
}


-(void)preloadImageFromServer
{
    [self getImageWith:@"icc-mens-semi-final-india-v-west-indies-5746904882216960.2-hp.jpg"withDownloadCompletionHandler:^(NSURLResponse *r, NSURL *u, NSError *e, UIImage *i) {}];
    
}


//prevent from Cloud backup
-(BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)fileURL {
    
    // First ensure the file actually exists
    if (![[NSFileManager defaultManager] fileExistsAtPath:[fileURL path]]) {
        NSLog(@"File %@ doesn't exist!",[fileURL path]);
        return NO;
    }
    
    // Determine the iOS version to choose correct skipBackup method
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    
    if ([currSysVer isEqualToString:@"5.0.1"]) {
        const char* filePath = [[fileURL path] fileSystemRepresentation];
        const char* attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = 1;
        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        NSLog(@"Excluded '%@' from backup",fileURL);
        return result == 0;
    }
    else if (&NSURLIsExcludedFromBackupKey) {
        NSError *error = nil;
        BOOL result = [fileURL setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
        if (result == NO) {
            NSLog(@"Error excluding '%@' from backup. Error: %@",fileURL, error);
            return NO;
        }
        else { // Succeeded
            NSLog(@"Excluded '%@' from backup",fileURL);
            return YES;
        }
    } else {
        // iOS version is below 5.0, no need to do anything
        return YES;
    }
}





@end

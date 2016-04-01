//
//  Service.swift
//  OIM
//
//  Created by Krutika Phirke on 31/10/14.
//  Copyright (c) 2014 aurionpro. All rights reserved.
//


var GlobalJSESSIONID:String = ""

import UIKit

@objc protocol ServiceReponseDelegate {

    func didReceivedAPIResults(connection: NSURLConnection!,responseResult results : NSMutableDictionary)

    optional func didReceivedAPIError(connection: NSURLConnection!,responseError errorDetails : NSDictionary)
    
    optional func didReceivedHTML(connection: NSURLConnection!,responseHTML htmlData : NSData)
    
    
    
}

class Service : NSObject {

    var jsonResponseData : NSMutableData?
    var delegate: ServiceReponseDelegate?
    var isErrorCode404:Bool = false
    
    func connection(connection: NSURLConnection!, didReceiveResponse response: NSURLResponse!)
    {
        
        
        var httpResponse = response as! NSHTTPURLResponse
        var errorCode = httpResponse.statusCode;
        
        var headersRes:NSDictionary = httpResponse.allHeaderFields
        print(headersRes)
        
        print(headersRes.valueForKey("Set-Cookie"))
        
        var cookies = NSHTTPCookie.cookiesWithResponseHeaderFields(headersRes as! [String : String] , forURL: connection.originalRequest.URL!)
        var strJSESSIONID = ""
        var strITDEFILING = ""
        
        for var i = 0; i<cookies.count; i++
        {
            if let tempHttpC = cookies[i] as? NSHTTPCookie
            {
                if tempHttpC.name == "JSESSIONID"
                {
                    strJSESSIONID = String(format: "%@=%@; ", tempHttpC.name, tempHttpC.value)
                }
                else if tempHttpC.name == "ITDEFILING"
                {
                    strITDEFILING = String(format: "%@=%@", tempHttpC.name, tempHttpC.value)
                }
            }
        }
        
        
        if GlobalJSESSIONID == ""{
            GlobalJSESSIONID = String(format: "%@%@",strJSESSIONID, strITDEFILING)
            
        }

        
//        if let strTest = headersRes.valueForKey("Set-Cookie") as? String
//        {
//            var arr = strTest.componentsSeparatedByString("; ")
//            
//                var js = (arr[0] as NSString).stringByReplacingOccurrencesOfString("Secure, ", withString: " ")
//                var it = (arr[3] as NSString).stringByReplacingOccurrencesOfString("Secure, ", withString: " ")
////                GlobalJSESSIONID = String(format: "%@%@",js, it)
//                if GlobalJSESSIONID == ""{
//        //            GlobalJSESSIONID = String(format: "%@%@",strJSESSIONID, strITDEFILING)
//                    GlobalJSESSIONID = String(format: "%@%@",js, it)
//                }
//            
//        }
        
        
        var foo = httpResponse.allHeaderFields

        var last_modified = NSString(format: "%@",foo)

        print("Response Header value --- >\(last_modified)")
        
//        //code for log
//        var reqDataString = NSString(data: connection.originalRequest.HTTPBody!, encoding: NSUTF8StringEncoding) as! String
//        
//        var strTemp = "\nURL::-> \(connection.originalRequest.URL)\n\nRequest Data::-> \(reqDataString)"
//        
//        println(strTemp)
//        //end///code for log
        

        isErrorCode404 = false
        if(errorCode == 200){

            self.jsonResponseData = NSMutableData()

        }
        else if(errorCode == 404){
            isErrorCode404 = true
            self.jsonResponseData = nil;
            
            var errDict:NSMutableDictionary = NSMutableDictionary()
            //           errDict.setValue(connection.originalRequest.URL, forKey: kREQUESTED_URL)
            var strErrorDesciption = "HTTP ERROR CODE :" + String(errorCode)
            errDict.setValue(strErrorDesciption, forKey: "ERROR_DESCRIPTION")
            errDict.setValue(errorCode, forKey: "ERROR_CODE")
            self.delegate?.didReceivedAPIError!(connection, responseError: errDict)
            //AppHelper.getErrorAlert(strErrorDesciption)
            
        }
        else{

            self.jsonResponseData = nil;
            
            var errDict:NSMutableDictionary = NSMutableDictionary()
 //           errDict.setValue(connection.originalRequest.URL, forKey: kREQUESTED_URL)
            var strErrorDesciption = "HTTP ERROR CODE :" + String(errorCode)
            errDict.setValue(strErrorDesciption, forKey: "ERROR_DESCRIPTION")
            errDict.setValue(errorCode, forKey: "ERROR_CODE")
            //AppHelper.removeActivityIndicator()
            self.delegate?.didReceivedAPIError!(connection, responseError: errDict)


        }
    }    
    func connection(connection: NSURLConnection!, didReceiveData _data: NSData!)
    {

        // println("original URL didReceiveData-->\(connection.originalRequest.URL)")
        if self.jsonResponseData == nil{

            return
        }
        self.jsonResponseData?.appendData(_data)
    }

    func connectionDidFinishLoading(connection: NSURLConnection!)
    {
        
        
        if isErrorCode404 == true
        {
            return
        }

//        let err: NSError?

        NSLog("connectionDidFinishLoading")
        
        var response: AnyObject!
        var responseDict: NSMutableDictionary! = NSMutableDictionary()

        if jsonResponseData != nil
        {
            

            do
            {
                response = try NSJSONSerialization.JSONObjectWithData(jsonResponseData!,options: NSJSONReadingOptions.MutableContainers)
            } catch {
                // report error
                let responceHTML = NSString(data: jsonResponseData!, encoding: NSUTF8StringEncoding)
                print(responceHTML)
                delegate?.didReceivedHTML!(connection, responseHTML: jsonResponseData!)
                return
            }
            
            if let tempRespo = response
            {
                responseDict = tempRespo as! NSMutableDictionary
            }
            else
            {
                // report error
                let responceHTML = NSString(data: jsonResponseData!, encoding: NSUTF8StringEncoding)
                print(responceHTML)
                delegate?.didReceivedHTML!(connection, responseHTML: jsonResponseData!)
                return
            }
            
            

        }

        
        if responseDict.count > 0
        {
           // responseDict.setValue(connection.originalRequest.URL, forKey: kREQUESTED_URL)
            print("original URL connectionDidFinishLoading-->\(connection.originalRequest.URL)")
            print("connectionDidFinishLoading \(responseDict)")
            
            self.delegate?.didReceivedAPIResults(connection, responseResult: responseDict)
            
            
        }
        else
        {
            
            let errDict:NSMutableDictionary = NSMutableDictionary()
            let strErrorDesciption = "Server Error"
            errDict.setValue(strErrorDesciption, forKey: "ERROR_DESCRIPTION")
            errDict.setValue(0, forKey: "ERROR_CODE")
            self.delegate?.didReceivedAPIError!(connection, responseError: errDict)

        }



    }

    func connection(connection: NSURLConnection!, didFailWithError error: NSError!)
    {
      
        print("original URL didFailWithError-->\(connection.originalRequest.URL)")
        
        let errDict:NSMutableDictionary = NSMutableDictionary()
        // errDict.setValue(connection.originalRequest.URL, forKey: kREQUESTED_URL)
        let strErrorDesciption = String(error.localizedDescription)
        
//        let userInfo: [NSObject : AnyObject] =
//        [
//            NSLocalizedDescriptionKey : "The network connection was lost.",
//            
//        ]
//        var internetError = NSError(domain: "", code: 500, userInfo:userInfo)
        
        errDict.setValue(strErrorDesciption, forKey: "ERROR_DESCRIPTION")
        errDict.setValue(0, forKey: "ERROR_CODE")
        
      
        
        self.delegate?.didReceivedAPIError!(connection, responseError: errDict)
     
//        AppHelper.removeActivityIndicator()
        print(error.description)

    }

    //below two methods used used for https protocol
    func connection(connection: NSURLConnection, canAuthenticateAgainstProtectionSpace protectionSpace: NSURLProtectionSpace?) -> Bool
    {

        return protectionSpace?.authenticationMethod == NSURLAuthenticationMethodServerTrust as String?
    }

    func connection(connection: NSURLConnection, didReceiveAuthenticationChallenge challenge: NSURLAuthenticationChallenge?)
    {

        print("HOST:-    \(challenge!.protectionSpace.host)");
        if challenge?.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust as String?
        {
            if challenge?.protectionSpace.host == "172.16.1.94"
            {
                let credentials = NSURLCredential(forTrust: challenge!.protectionSpace.serverTrust!)
                challenge!.sender!.useCredential(credentials, forAuthenticationChallenge: challenge!)
                
            }
        }
        
        challenge?.sender!.continueWithoutCredentialForAuthenticationChallenge(challenge!)
    }

}

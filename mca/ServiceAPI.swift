//
//  ApiService.swift
//  
//
//  Created by Aurionpro2 on 15/12/15.
//
//

import UIKit
import MapKit
import CoreLocation

class ServiceAPI: NSObject {
    
    
    func getjsession(strURL:String) -> NSURLConnection{
        
        //GlobalJSESSIONID = ""
        
        let urlString = strURL
        
        let service:Service = Service()
        //service.delegate = delegate
        
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        request.timeoutInterval = 30
        request.HTTPMethod = "POST"
        request.HTTPShouldHandleCookies = true
        return NSURLConnection(request: request, delegate: service, startImmediately: true)!
        
    }
    func getCaptch(strURL:String, delegate:ServiceReponseDelegate) -> NSURLConnection{
        
        //GlobalJSESSIONID = ""
        
        let urlString = strURL
        
        let service:Service = Service()
        service.delegate = delegate
        
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        request.timeoutInterval = 30
        request.HTTPMethod = "POST"
        request.HTTPShouldHandleCookies = true
        return NSURLConnection(request: request, delegate: service, startImmediately: true)!        
        
    }
    
    
    
    func getKnowYourJurisdiction(reqId:String, panNumber:String, captchaString:String, delegate:ServiceReponseDelegate) -> NSURLConnection{
        
        let mainUrlString = String(format: "https://incometaxindiaefiling.gov.in/e-Filing/Services/KnowYourJurisdiction.html?requestId=%@&panOfDeductee=%@&captchaCode=%@", reqId, panNumber, captchaString)
        
        let urlString = mainUrlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        let service:Service = Service()
        service.delegate = delegate
        
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        
//        request.setValue("text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", forHTTPHeaderField:"Accept")
        
//        request.setValue("en-US,en;q=0.5", forHTTPHeaderField:"Accept-Language")
        
//        Connection
//        keep-alive
//        
//        
//        Host
//        incometaxindiaefiling.gov.in
        
        
        //request.setValue("JSESSIONID=VnVfWMtLcy6hZvW2MGGp9YtLcBS6J0y2rCbRCMTjQhJZjyRCx3pb!-1186365257; ITDEFILING=763039433761", forHTTPHeaderField:"Cookie")
     
        request.setValue(GlobalJSESSIONID, forHTTPHeaderField:"Cookie")
        
        
        
//        request.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:44.0) Gecko/20100101 Firefox/44.0", forHTTPHeaderField:"User-Agent")
        
        
        
        
        //request.setValue("text/htm", forHTTPHeaderField: "Content-Type")
        // request.setValue(LoginObject.sharedInstance.securityToken, forHTTPHeaderField: "securityId")
        request.timeoutInterval = 30
        // request.HTTPBody = content;
        request.HTTPMethod = "POST"
        
        
//        var htmldata = NSData(contentsOfURL: NSURL(string: urlString)!)
//        
//        var strhtmldata = NSString(data: htmldata!, encoding: NSUTF8StringEncoding)
//        println(strhtmldata)
        
        request.HTTPShouldHandleCookies = true
        return NSURLConnection(request: request, delegate: service, startImmediately: true)!
        
        
    }
    
    
    
    func getKnowYourPAN(reqId:String, dob:String, surname:String, middlename:String, firstname:String, captchaString:String, delegate:ServiceReponseDelegate) -> NSURLConnection{
       
        let strDob = (dob as NSString).stringByReplacingOccurrencesOfString("/", withString: "%2F")
        let mainUrlString = String(format: "https://incometaxindiaefiling.gov.in/e-Filing/Services/KnowYourPan.html?requestId=%@&dateOfBirth=%@&userNameDetails.surName=%@&userNameDetails.middleName=%@&userNameDetails.firstName=%@&captchaCode=%@",reqId, strDob, surname, middlename, firstname, captchaString)
        
        let urlString = mainUrlString //.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        let service:Service = Service()
        service.delegate = delegate
        
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        
        request.setValue(GlobalJSESSIONID, forHTTPHeaderField:"Cookie")
        request.timeoutInterval = 30
        // request.HTTPBody = content;
        request.HTTPMethod = "POST"
        
        request.HTTPShouldHandleCookies = true
        return NSURLConnection(request: request, delegate: service, startImmediately: true)!
        
        
    }
    
    
    
    
    func getTANCatNState(delegate:ServiceReponseDelegate) -> NSURLConnection{
        
        
        let urlString = "https://incometaxindiaefiling.gov.in/e-Filing/Services/KnowYourTanLink.html"
        
        let service:Service = Service()
        service.delegate = delegate
        
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        
        request.setValue(GlobalJSESSIONID, forHTTPHeaderField:"Cookie")
        request.timeoutInterval = 30
        // request.HTTPBody = content;
        request.HTTPMethod = "GET"
        
        request.HTTPShouldHandleCookies = true
        return NSURLConnection(request: request, delegate: service, startImmediately: true)!
        
        
    }

    
    
   
    
    func retryRequest(curConnection: NSURLConnection, delegate:ServiceReponseDelegate) -> NSURLConnection{
        
        let service:Service = Service()
        service.delegate = delegate
        let connection=NSURLConnection(request: curConnection.originalRequest, delegate: service, startImmediately: true)
        
        return connection!
        
    }
    
    
    func getKnowYourTANByTAN(strCategory:String, strState:String, strTAN:String, captchaString:String, refURL:String, delegate:ServiceReponseDelegate) -> NSURLConnection{
        
        let strNewName = (strTAN as NSString).stringByReplacingOccurrencesOfString(" ", withString: "+").uppercaseString
        
        let mainUrlString = String(format: "https://incometaxindiaefiling.gov.in/e-Filing/Services/KnowYourTan.html?ID=&pagniationParam.showAdvSearch=&searchCriteria.category=%@&searchCriteria.state=%@&searchCriteria.searchOption=tan&searchCriteria.name=&searchCriteria.tan=%@&captchaCode=%@&search=Search", strCategory, strState, strNewName, captchaString)
        
        
        let urlString = mainUrlString //.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        let service:Service = Service()
        service.delegate = delegate
        
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        
        request.setValue(GlobalJSESSIONID, forHTTPHeaderField:"Cookie")
        request.setValue(refURL, forHTTPHeaderField: "Referer")
        request.timeoutInterval = 30
        // request.HTTPBody = content;
        request.HTTPMethod = "POST"
        
        request.HTTPShouldHandleCookies = true
        return NSURLConnection(request: request, delegate: service, startImmediately: true)!
        
        
    }
    
    
    func getKnowYourTANByName(strCategory:String, strState:String, strName:String, captchaString:String, refURL:String, delegate:ServiceReponseDelegate) -> NSURLConnection{
       
       let strNewName = (strName as NSString).stringByReplacingOccurrencesOfString(" ", withString: "+").uppercaseString
        
       let mainUrlString = String(format: "https://incometaxindiaefiling.gov.in/e-Filing/Services/KnowYourTan.html?ID=&pagniationParam.showAdvSearch=&searchCriteria.category=%@&searchCriteria.state=%@&searchCriteria.searchOption=name&searchCriteria.name=%@&searchCriteria.tan=&captchaCode=%@&search=Search", strCategory, strState, strNewName, captchaString)
        
        //var mainUrlString = String(format: "https://incometaxindiaefiling.gov.in/e-Filing/Services/KnowYourTan.html?ID=&pagniationParam.showAdvSearch=&searchCriteria.category=3&searchCriteria.state=19&searchCriteria.searchOption=name&searchCriteria.name=TATA+BUSINESS+SUPPORT+&searchCriteria.tan=&captchaCode=%@&search=Search", captchaString)
        
        
        
        let urlString = mainUrlString //.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        let service:Service = Service()
        service.delegate = delegate
        
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        
        request.setValue(GlobalJSESSIONID, forHTTPHeaderField:"Cookie")
        request.setValue(refURL, forHTTPHeaderField: "Referer")
        request.timeoutInterval = 30
        // request.HTTPBody = content;
        request.HTTPMethod = "POST"
        
        request.HTTPShouldHandleCookies = true
        return NSURLConnection(request: request, delegate: service, startImmediately: true)!
        
        
    }
    
    
    func getKnowYourTANByCompnay(mainUrl:String, refURL:String, delegate:ServiceReponseDelegate) -> NSURLConnection{
        
        
        let urlString = mainUrl
        
        let service:Service = Service()
        service.delegate = delegate
        
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        
        request.setValue(GlobalJSESSIONID, forHTTPHeaderField:"Cookie")
        request.setValue(refURL, forHTTPHeaderField: "Referer")
        request.timeoutInterval = 30
        // request.HTTPBody = content;
        request.HTTPMethod = "GET"
        
        request.HTTPShouldHandleCookies = true
        return NSURLConnection(request: request, delegate: service, startImmediately: true)!
        
        
    }
    
    
}


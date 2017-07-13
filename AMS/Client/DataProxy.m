//
//  DataProxy.m
//  IQC
//
//  Created by SonTayTo on 9/21/16.
//  Copyright © 2016 SonTayTo. All rights reserved.
//

#import "DataProxy.h"

#define U_LOGIN @"users/signIn"
#define STAFFS @"staffs"
#define MANAGERS @"managers"
#define GET_LIST_AQUACULTURE @"getListAquaculture"
#define GET_AQUACULTURE_DETAIL @"getAquacultureDetail"
#define GET_LIST_FOOD @"getListFood"
#define GET_LIST_HEALTH @"getListHealth"
#define GET_LIST_MEDICINE @"getListMedicine"
#define CHECK_LIST @"checkList"
#define GET_COMMAND @"getCommand"
#define GET_CHART_FISH_DEAD @"getChartFishDead"
#define GET_CHART_FISH_SIZE @"getChartSize"
#define GET_CHART_FOOD @"getChartFood"
#define GET_CHART_ENVIRONMENT @"getChartEnvironment"
#define GET_CHECKLIST_DETAIL @"getCheckListDetail"
#define USERS @"users"
#define CHECK_VERSION @"checkVersion"
#define SEARCH @"searchAquaculture"
#define GET_LIST_USER_BY_AREA @"getListUserByArea"
#define COMMAND @"command"
#define CHANGE_PASSWORD @"changePassword"
#define UPDATE_TOKEN @"updateToken"
#define REMOVE_TOKEN @"removeToken"
#define GET_NOTIFY @"GetNotify"
#define UPDATE_NOTIFY @"updateStatusNotify"
#define BADGE @"getBadge"
#define GET_COMMAND_DETAIL @"getCommandDetail"

@implementation DataProxy

#pragma mark LOGIN

- (void)login:(NSString *)username password:(NSString *)password
completeHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler {
    
    BaseOperation * callOp = [[BaseOperation alloc] init];
    NSString *urlStr = StringFormat(@"%@/%@",BaseURL,U_LOGIN);
    NSURL *url = [NSURL URLWithString:urlStr];

    callOp.request = [NSMutableURLRequest requestWithURL:url];
    
    //create json
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:username forKey:@"username"];
    [dict setObject:password forKey:@"password"];
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    
    [(NSMutableURLRequest*)callOp.request setHTTPMethod:@"POST"];
    [(NSMutableURLRequest*)callOp.request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [(NSMutableURLRequest*)callOp.request setHTTPBody:jsonData];
    
    callOp.completionHandler = ^(NSDictionary *result, NSURLResponse *res) {
        [self endLogin:result response:res completionHandler:handler errorHandler:errHandler];
    };
    
    callOp.errorHandler = ^(NSError *err) {
        errHandler(err);
    };
    
    [callOp start];
}

- (void)endLogin:(NSDictionary *)result response:(NSURLResponse *)response
completionHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler {
    
    NSInteger httpCode = [(NSHTTPURLResponse*)response statusCode];
    if(httpCode != 200){
        NSError *err = [[NSError alloc] initWithDomain:HTTPDOMAIN code:httpCode userInfo:nil];
        errHandler(err);
        return;
    }
    NSString *errorCode = [result objectForKey:@"code"];
    NSDictionary *root = [result objectForKey:@"data"]?:nil;
    
    NSString *message = [result objectForKey:@"message"];
    if(![errorCode isEqualToString:@"0"]){
        [self showError:errorCode message:message errorHandler:errHandler];
        return;
    }
    
    UserRecord *user = [UserRecord new];
    user.u_id = [root objectForKey:@"_id"];
    user.u_name = [root objectForKey:@"username"];
    user.name = [root objectForKey:@"name"];
    user.u_email = [root objectForKey:@"email"];
    user.u_mobile = [root objectForKey:@"mobile"];
    user.u_birthday = [root objectForKey:@"birthday"];
    user.u_inJob = [root objectForKey:@"inJob"];
    user.u_status = [root objectForKey:@"status"];
    user.u_appType = [root objectForKey:@"appType"];
    user.u_role = [root objectForKey:@"role"];
    user.u_area = [root objectForKey:@"area"];
    user.u_aquaculture = [root objectForKey:@"aquaculture"];
    user.accessToken = [root objectForKey:@"accessToken"];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:user.accessToken forKeyPath:@"accessToken"];
    [dict setValue:user.u_id forKey:@"userId"];
    [dict setValue:user.u_name forKey:@"username"];
    [dict setValue:user.u_area forKey:@"userArea"];
     [ShareHelper saveUserDefaults:dict];
    
    handler(user,errorCode,nil);
//     NSError *err = [[NSError alloc] initWithDomain:message code:[errorCode integerValue] userInfo:nil];
//     errHandler(err);
//     
//     return;
//     }

}

#pragma mark get ListAquaculture Staff
-(void)getListAquaculture :(NSString *)pageNum PerPage:(NSString *)perPage completionHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler{
    BaseOperation *callOp = [[BaseOperation alloc] init];
    NSString *urlString = StringFormat(@"%@/%@/%@",BaseURL,STAFFS,GET_LIST_AQUACULTURE);
    NSURL *url = [NSURL URLWithString:urlString];
    
    //[urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
//    callOp.request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:20];
    callOp.request = [NSMutableURLRequest requestWithURL:url];
    
    NSString *userId = [ShareHelper getUserDefaults:@"userId"];
    NSString *accessToken = [ShareHelper getUserDefaults:@"accessToken"];
    //create json
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:perPage forKey:@"perPage"];
    [dict setObject:pageNum forKey:@"pageNum"];
    [dict setObject:userId forKey:@"userId"];
    [dict setObject:accessToken forKey:@"accessToken"];
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];

    
    [(NSMutableURLRequest*)callOp.request setHTTPMethod:@"POST"];
    [(NSMutableURLRequest*)callOp.request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [(NSMutableURLRequest*)callOp.request setHTTPBody:jsonData];
    
    callOp.completionHandler = ^(NSDictionary *result, NSURLResponse *res) {
        [self endGetListAquaculture:result response:res completionHandler:handler errorHandler:errHandler];
    };
    
    callOp.errorHandler = ^(NSError *err) {
        errHandler(err);
    };
    
    [callOp start];
}

-(void)endGetListAquaculture:(NSDictionary *)result response:(NSURLResponse *)response
 completionHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler{
    NSInteger httpCode = [(NSHTTPURLResponse*)response statusCode];
    if(httpCode != 200){
        NSError *err = [[NSError alloc] initWithDomain:HTTPDOMAIN code:httpCode userInfo:nil];
        errHandler(err);
        return;
    }
    /*Parse json response*/
    NSString *errorCode = [result objectForKey:@"code"];
    NSDictionary *root = [result objectForKey:@"data"]?:nil;
    NSString *message = [result objectForKey:@"message"];
    if(![errorCode isEqualToString:@"0"]){
        [self showError:errorCode message:message errorHandler:errHandler];
        return;
    }
    
    ListAquacultureRecord *data = [ListAquacultureRecord new];
    data.l_total = [root objectForKey:@"total"];
    data.l_limit = [root objectForKey:@"limit"];
    data.l_page = [root objectForKey:@"page"];
    data.l_pages = [root objectForKey:@"pages"];
    data.l_array = [self parseDocs:[root objectForKey:@"docs"]];
    
    handler(data,errorCode,nil);
}

-(NSArray *)parseDocs:(NSArray *) array{
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in array) {
        AquacultureRecord *item = [AquacultureRecord new];
        item = [self parseAquaculture:dict];
        [temp addObject:item];
    }
    NSArray *data = [temp copy];
    return data;
}

-(AquacultureRecord *)parseAquaculture:(NSDictionary *)dict{
    AquacultureRecord *item = [AquacultureRecord new];
    item.a_id = [dict objectForKey:@"_id"];
    item.a_name = [dict objectForKey:@"name"];
    item.a_fishpond = [dict objectForKey:@"fishpond"];
    item.a_area = [dict objectForKey:@"area"];
    item.a_season = [dict objectForKey:@"season"];
    item.a_importDate = [dict objectForKey:@"importDate"];
    item.a_exportDate = [dict objectForKey:@"exportDate"];
    item.a_totalFish = [dict objectForKey:@"totalFish"];
    item.a_totalWeightFish = [dict objectForKey:@"totalWeightFish"];
    item.a_densityWeight = [dict objectForKey:@"densityWeight"];
    item.a_densityStretch = [dict objectForKey:@"densityStretch"];
    item.a_createdBy = [dict objectForKey:@"createdBy"];
    item.a_createdDate = [dict objectForKey:@"createdDate"];
    item.a_currentInfo = [self parseInfo:[dict objectForKey:@"currentInfo"]];
    item.a_stretch = [dict objectForKey:@"stretch"];
    return item;
}

-(CurrentInfoRecord *)parseInfo:(NSDictionary *)dict{
    CurrentInfoRecord *info = [CurrentInfoRecord new];
    info.i_calculatedDate = [dict objectForKey:@"calculatedDate"];
    info.i_averageWeight = [dict objectForKey:@"averageWeight"];
    info.i_totalFood = [dict objectForKey:@"totalFood"];
    info.i_deadFishWeight = [dict objectForKey:@"deadFishWeight"];
    info.i_deadFishCount = [dict objectForKey:@"deadFishCount"];
    info.i_deadFishCountDay = [dict objectForKey:@"deadFishCountDay"];
    info.i_deadFishWeightDay = [dict objectForKey:@"deadFishWeightDay"];
    info.i_health = [self parseHealth:[dict objectForKey:@"health"]];
    info.i_images = [dict objectForKey:@"images"];
    return  info;
}

-(HealthRecord *)parseHealth:(NSDictionary *)dict{
    HealthRecord *item = [HealthRecord new];
    item.h_note = [dict objectForKey:@"note"];
    item.h_status = [dict objectForKey:@"status"];
    return item;
}

#pragma mark get ListAquaculture Manager
-(void)getListAquacultureManager :(NSString *)pageNum PerPage:(NSString *)perPage completionHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler{
    BaseOperation *callOp = [[BaseOperation alloc] init];
    NSString *urlString = StringFormat(@"%@/%@/%@",BaseURL,MANAGERS,GET_LIST_AQUACULTURE);
    NSURL *url = [NSURL URLWithString:urlString];
    
    //[urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //    callOp.request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:20];
    callOp.request = [NSMutableURLRequest requestWithURL:url];
    
    NSString *userId = [ShareHelper getUserDefaults:@"userId"];
    NSString *accessToken = [ShareHelper getUserDefaults:@"accessToken"];
    //create json
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:perPage forKey:@"perPage"];
    [dict setObject:pageNum forKey:@"pageNum"];
    [dict setObject:userId forKey:@"userId"];
    [dict setObject:accessToken forKey:@"accessToken"];
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    
    
    [(NSMutableURLRequest*)callOp.request setHTTPMethod:@"POST"];
    [(NSMutableURLRequest*)callOp.request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [(NSMutableURLRequest*)callOp.request setHTTPBody:jsonData];
    
    callOp.completionHandler = ^(NSDictionary *result, NSURLResponse *res) {
        [self endGetListAquacultureManager:result response:res completionHandler:handler errorHandler:errHandler];
    };
    
    callOp.errorHandler = ^(NSError *err) {
        errHandler(err);
    };
    
    [callOp start];
}

-(void)endGetListAquacultureManager:(NSDictionary *)result response:(NSURLResponse *)response
           completionHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler{
    NSInteger httpCode = [(NSHTTPURLResponse*)response statusCode];
    if(httpCode != 200){
        NSError *err = [[NSError alloc] initWithDomain:HTTPDOMAIN code:httpCode userInfo:nil];
        errHandler(err);
        return;
    }
    /*Parse json response*/
    NSString *errorCode = [result objectForKey:@"code"];
    NSDictionary *root = [result objectForKey:@"data"]?:nil;
    NSString *message = [result objectForKey:@"message"];
    if(![errorCode isEqualToString:@"0"]){
        [self showError:errorCode message:message errorHandler:errHandler];
        return;
    }
    
    ListAquacultureRecord *data = [ListAquacultureRecord new];
    data.l_total = [root objectForKey:@"total"];
    data.l_limit = [root objectForKey:@"limit"];
    data.l_page = [root objectForKey:@"page"];
    data.l_pages = [root objectForKey:@"pages"];
    data.l_array = [self parseDocs:[root objectForKey:@"docs"]];
    
    handler(data,errorCode,nil);
}


#pragma mark get Aquaculture Detail
-(void)getAquacultureDetail :(NSString *)aquaId completionHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler{
    BaseOperation *callOp = [[BaseOperation alloc] init];
    NSString *urlString = StringFormat(@"%@/%@/%@",BaseURL,STAFFS,GET_AQUACULTURE_DETAIL);
    NSURL *url = [NSURL URLWithString:urlString];
    
    callOp.request = [NSMutableURLRequest requestWithURL:url];
    NSString *accessToken = [ShareHelper getUserDefaults:@"accessToken"];
    //create json
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:aquaId forKey:@"aquaId"];
    [dict setObject:accessToken forKey:@"accessToken"];
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    
    [(NSMutableURLRequest*)callOp.request setHTTPMethod:@"POST"];
    [(NSMutableURLRequest*)callOp.request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [(NSMutableURLRequest*)callOp.request setHTTPBody:jsonData];
    
    callOp.completionHandler = ^(NSDictionary *result, NSURLResponse *res) {
        [self endGetAquacultureDetail:result response:res completionHandler:handler errorHandler:errHandler];
    };
    
    callOp.errorHandler = ^(NSError *err) {
        errHandler(err);
    };
    
    [callOp start];
}

-(void)endGetAquacultureDetail:(NSDictionary *)result response:(NSURLResponse *)response
           completionHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler{
    NSInteger httpCode = [(NSHTTPURLResponse*)response statusCode];
    if(httpCode != 200){
        NSError *err = [[NSError alloc] initWithDomain:HTTPDOMAIN code:httpCode userInfo:nil];
        errHandler(err);
        return;
    }
    /*Parse json response*/
    NSString *errorCode = [result objectForKey:@"code"];
    NSDictionary *root = [result objectForKey:@"data"]?:nil;
    NSString *message = [result objectForKey:@"message"];
    if(![errorCode isEqualToString:@"0"]){
        [self showError:errorCode message:message errorHandler:errHandler];
        return;
    }

    
    AquacultureRecord *data = [AquacultureRecord new];
    data = [self parseAquaculture:root];
    handler(data,errorCode,nil);
}

#pragma mark get Aquaculture Detail Manager
-(void)getAquacultureDetailManager :(NSString *)aquaId completionHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler{
    BaseOperation *callOp = [[BaseOperation alloc] init];
    NSString *urlString = StringFormat(@"%@/%@/%@",BaseURL,MANAGERS,GET_AQUACULTURE_DETAIL);
    NSURL *url = [NSURL URLWithString:urlString];
    
    callOp.request = [NSMutableURLRequest requestWithURL:url];
    NSString *accessToken = [ShareHelper getUserDefaults:@"accessToken"];
    //create json
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:aquaId forKey:@"aquaId"];
    [dict setObject:accessToken forKey:@"accessToken"];
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    
    [(NSMutableURLRequest*)callOp.request setHTTPMethod:@"POST"];
    [(NSMutableURLRequest*)callOp.request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [(NSMutableURLRequest*)callOp.request setHTTPBody:jsonData];
    
    callOp.completionHandler = ^(NSDictionary *result, NSURLResponse *res) {
        [self endGetAquacultureDetailManager:result response:res completionHandler:handler errorHandler:errHandler];
    };
    
    callOp.errorHandler = ^(NSError *err) {
        errHandler(err);
    };
    
    [callOp start];
}

-(void)endGetAquacultureDetailManager:(NSDictionary *)result response:(NSURLResponse *)response
             completionHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler{
    NSInteger httpCode = [(NSHTTPURLResponse*)response statusCode];
    if(httpCode != 200){
        NSError *err = [[NSError alloc] initWithDomain:HTTPDOMAIN code:httpCode userInfo:nil];
        errHandler(err);
        return;
    }
    /*Parse json response*/
    NSString *errorCode = [result objectForKey:@"code"];
    NSDictionary *root = [result objectForKey:@"data"]?:nil;
    NSString *message = [result objectForKey:@"message"];
    if(![errorCode isEqualToString:@"0"]){
        [self showError:errorCode message:message errorHandler:errHandler];
        return;
    }
    
    
    AquacultureRecord *data = [AquacultureRecord new];
    data = [self parseAquaculture:root];
    handler(data,errorCode,nil);
}


- (void)getListFood:(NSString *)pageNum PerPage:(NSString *)perPage
completeHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler {
    
    BaseOperation * callOp = [[BaseOperation alloc] init];
    NSString *urlStr = StringFormat(@"%@/%@/%@",BaseURL,STAFFS,GET_LIST_FOOD);
    NSURL *url = [NSURL URLWithString:urlStr];
    
    callOp.request = [NSMutableURLRequest requestWithURL:url];
    
    //create json
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:pageNum forKey:@"pageNum"];
    [dict setObject:perPage forKey:@"perPage"];
    [dict setObject:[ShareHelper getUserDefaults:@"accessToken"] forKey:@"accessToken"];
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    
    [(NSMutableURLRequest*)callOp.request setHTTPMethod:@"POST"];
    [(NSMutableURLRequest*)callOp.request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [(NSMutableURLRequest*)callOp.request setHTTPBody:jsonData];
    
    callOp.completionHandler = ^(NSDictionary *result, NSURLResponse *res) {
        [self endGetListFood:result response:res completionHandler:handler errorHandler:errHandler];
    };
    
    callOp.errorHandler = ^(NSError *err) {
        errHandler(err);
    };
    
    [callOp start];
}

- (void)endGetListFood:(NSDictionary *)result response:(NSURLResponse *)response
completionHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler {
    
    NSInteger httpCode = [(NSHTTPURLResponse*)response statusCode];
    if(httpCode != 200){
        NSError *err = [[NSError alloc] initWithDomain:HTTPDOMAIN code:httpCode userInfo:nil];
        errHandler(err);
        return;
    }
    NSString *errorCode = [result objectForKey:@"code"];
    NSDictionary *root = [result objectForKey:@"data"]?:nil;
    NSString *message = [result objectForKey:@"message"];
    if(![errorCode isEqualToString:@"0"]){
        [self showError:errorCode message:message errorHandler:errHandler];
        return;
    }
    
    ListDataRecord *data = [ListDataRecord new];
    data.l_total = [root objectForKey:@"total"];
    data.l_limit = [root objectForKey:@"limit"];
    data.l_page = [root objectForKey:@"page"];
    data.l_pages = [root objectForKey:@"pages"];
    
    NSArray *arrFood = [root objectForKey:@"docs"];
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in arrFood) {
        FoodRecord *item = [FoodRecord new];
        item = [self parseFood:dict];
        [temp addObject:item];
    }
    data.l_docs = [temp copy];
    handler(data,errorCode,@"success");
}

-(FoodRecord *)parseFood:(NSDictionary *)dict{
    FoodRecord *item = [FoodRecord new];
    item.f__id = [dict objectForKey:@"_id"];
    item.f_id = [dict objectForKey:@"id"];
    item.f_v = [dict objectForKey:@"_v"];
    item.f_name  = [dict objectForKey:@"name"];
    item.f_unit = [dict objectForKey:@"unit"];
    item.f_createBy = [dict objectForKey:@"createBy"];
    item.f_createDate = [dict objectForKey:@"createDate"];
    item.f_quantity = [dict objectForKey:@"quantity"];
    item.f_use = [dict objectForKey:@"use"];
    return  item;
}

- (void)getListHealth:(NSString *)pageNum PerPage:(NSString *)perPage
    completeHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler {
    
    BaseOperation * callOp = [[BaseOperation alloc] init];
    NSString *urlStr = StringFormat(@"%@/%@/%@",BaseURL,STAFFS,GET_LIST_HEALTH);
    NSURL *url = [NSURL URLWithString:urlStr];
    
    callOp.request = [NSMutableURLRequest requestWithURL:url];
    
    //create json
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:pageNum forKey:@"pageNum"];
    [dict setObject:perPage forKey:@"perPage"];
    [dict setObject:[ShareHelper getUserDefaults:@"accessToken"] forKey:@"accessToken"];
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    
    [(NSMutableURLRequest*)callOp.request setHTTPMethod:@"POST"];
    [(NSMutableURLRequest*)callOp.request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [(NSMutableURLRequest*)callOp.request setHTTPBody:jsonData];
    
    callOp.completionHandler = ^(NSDictionary *result, NSURLResponse *res) {
        [self endGetListHealth:result response:res completionHandler:handler errorHandler:errHandler];
    };
    
    callOp.errorHandler = ^(NSError *err) {
        errHandler(err);
    };
    
    [callOp start];
}

- (void)endGetListHealth:(NSDictionary *)result response:(NSURLResponse *)response
     completionHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler {
    
    NSInteger httpCode = [(NSHTTPURLResponse*)response statusCode];
    if(httpCode != 200){
        NSError *err = [[NSError alloc] initWithDomain:HTTPDOMAIN code:httpCode userInfo:nil];
        errHandler(err);
        return;
    }
    NSString *errorCode = [result objectForKey:@"code"];
    NSDictionary *root = [result objectForKey:@"data"]?:nil;
    NSString *message = [result objectForKey:@"message"];
    if(![errorCode isEqualToString:@"0"]){
        [self showError:errorCode message:message errorHandler:errHandler];
        return;
    }
    ListDataRecord *data = [ListDataRecord new];
    data.l_total = [root objectForKey:@"total"];
    data.l_limit = [root objectForKey:@"limit"];
    data.l_page = [root objectForKey:@"page"];
    data.l_pages = [root objectForKey:@"pages"];
    
    NSArray *arrHealth = [root objectForKey:@"docs"];
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in arrHealth) {
        Health1Record *item = [Health1Record new];
        item = [self parseHealth1:dict];
        [temp addObject:item];
    }
    data.l_docs = [temp copy];
    handler(data,errorCode,@"success");
}

-(Health1Record *)parseHealth1:(NSDictionary *)dict{
    Health1Record *item = [Health1Record new];
    item.h_id = [dict objectForKey:@"_id"];
    item.h_name  = [dict objectForKey:@"name"];
    item.h_desc = [dict objectForKey:@"desc"];
    return  item;
}

- (void)getListMedicine:(NSString *)pageNum PerPage:(NSString *)perPage
      completeHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler {
    
    BaseOperation * callOp = [[BaseOperation alloc] init];
    NSString *urlStr = StringFormat(@"%@/%@/%@",BaseURL,STAFFS,GET_LIST_MEDICINE);
    NSURL *url = [NSURL URLWithString:urlStr];
    
    callOp.request = [NSMutableURLRequest requestWithURL:url];
    
    //create json
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:pageNum forKey:@"pageNum"];
    [dict setObject:perPage forKey:@"perPage"];
    [dict setObject:[ShareHelper getUserDefaults:@"accessToken"] forKey:@"accessToken"];
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    
    [(NSMutableURLRequest*)callOp.request setHTTPMethod:@"POST"];
    [(NSMutableURLRequest*)callOp.request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [(NSMutableURLRequest*)callOp.request setHTTPBody:jsonData];
    
    callOp.completionHandler = ^(NSDictionary *result, NSURLResponse *res) {
        [self endGetListMedicine:result response:res completionHandler:handler errorHandler:errHandler];
    };
    
    callOp.errorHandler = ^(NSError *err) {
        errHandler(err);
    };
    
    [callOp start];
}

- (void)endGetListMedicine:(NSDictionary *)result response:(NSURLResponse *)response
       completionHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler {
    
    NSInteger httpCode = [(NSHTTPURLResponse*)response statusCode];
    if(httpCode != 200){
        NSError *err = [[NSError alloc] initWithDomain:HTTPDOMAIN code:httpCode userInfo:nil];
        errHandler(err);
        return;
    }
    NSString *errorCode = [result objectForKey:@"code"];
    NSDictionary *root = [result objectForKey:@"data"]?:nil;
    NSString *message = [result objectForKey:@"message"];
    if(![errorCode isEqualToString:@"0"]){
        [self showError:errorCode message:message errorHandler:errHandler];
        return;
    }
    
    ListDataRecord *data = [ListDataRecord new];
    data.l_total = [root objectForKey:@"total"];
    data.l_limit = [root objectForKey:@"limit"];
    data.l_page = [root objectForKey:@"page"];
    data.l_pages = [root objectForKey:@"pages"];
    
    NSArray *arrMedicine = [root objectForKey:@"docs"];
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in arrMedicine) {
        MedicineRecord *item = [MedicineRecord new];
        item = [self parseMedicine:dict];
        [temp addObject:item];
    }
    data.l_docs = [temp copy];
    handler(data,errorCode,@"success");
}

-(MedicineRecord *)parseMedicine:(NSDictionary *)dict{
    MedicineRecord *item = [MedicineRecord new];
    item.m_id = [dict objectForKey:@"_id"];
    item.m_name  = [dict objectForKey:@"name"];
    item.m_unit = [dict objectForKey:@"unit"];
    item.m_use = [dict objectForKey:@"use"];
    item.m_quantity = [dict objectForKey:@"quantity"];
    return  item;
}

#pragma mark Upload Data
-(void)uploadData:(NSData *)jsonData completeHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler{
    BaseOperation * callOp = [[BaseOperation alloc] init];
    
    NSString *urlString = StringFormat(@"%@/%@/%@",BaseURL,STAFFS,CHECK_LIST);
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    callOp.request = [NSMutableURLRequest requestWithURL:url];
    
    
    [(NSMutableURLRequest*)callOp.request setHTTPMethod:@"POST"];
    [(NSMutableURLRequest*)callOp.request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [(NSMutableURLRequest*)callOp.request setHTTPBody:jsonData];
    
    callOp.completionHandler = ^(NSDictionary *result, NSURLResponse *res) {
        [self endUploadData:result response:res completionHandler:handler errorHandler:errHandler];
    };
    
    callOp.errorHandler = ^(NSError *err) {
        errHandler(err);
    };
    
    [callOp start];
    
}

-(void)endUploadData:(NSDictionary *)result response:(NSURLResponse *)response
   completionHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler{
    NSInteger httpCode = [(NSHTTPURLResponse*)response statusCode];
    if(httpCode != 200){
        NSError *err = [[NSError alloc] initWithDomain:HTTPDOMAIN code:httpCode userInfo:nil];
        errHandler(err);
        return;
    }
    /*Parse json response*/
    NSString *errorCode = [result objectForKey:@"code"];
    NSString *message = [result objectForKey:@"message"];
    //NSDictionary *root = [result objectForKey:@"data"]?:nil;
    if(![errorCode isEqualToString:@"0"]){
        [self showError:errorCode message:message errorHandler:errHandler];
        return;
    }
    handler(nil,errorCode,nil);
}

#pragma mark Update Data
-(void)updateData:(NSData *)jsonData completeHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler{
    BaseOperation * callOp = [[BaseOperation alloc] init];
    
    NSString *urlString = StringFormat(@"%@/%@/%@",BaseURL,STAFFS,CHECK_LIST);
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    callOp.request = [NSMutableURLRequest requestWithURL:url];
    
    
    [(NSMutableURLRequest*)callOp.request setHTTPMethod:@"PUT"];
    [(NSMutableURLRequest*)callOp.request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [(NSMutableURLRequest*)callOp.request setHTTPBody:jsonData];
    
    callOp.completionHandler = ^(NSDictionary *result, NSURLResponse *res) {
        [self endUpdateData:result response:res completionHandler:handler errorHandler:errHandler];
    };
    
    callOp.errorHandler = ^(NSError *err) {
        errHandler(err);
    };
    
    [callOp start];
    
}

-(void)endUpdateData:(NSDictionary *)result response:(NSURLResponse *)response
   completionHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler{
    NSInteger httpCode = [(NSHTTPURLResponse*)response statusCode];
    if(httpCode != 200){
        NSError *err = [[NSError alloc] initWithDomain:HTTPDOMAIN code:httpCode userInfo:nil];
        errHandler(err);
        return;
    }
    /*Parse json response*/
    NSString *errorCode = [result objectForKey:@"code"];
    NSString *message = [result objectForKey:@"message"];
    //NSDictionary *root = [result objectForKey:@"data"]?:nil;
    if(![errorCode isEqualToString:@"0"]){
        [self showError:errorCode message:message errorHandler:errHandler];
        return;
    }
    handler(nil,errorCode,nil);
}


#pragma mark get Staff Command

- (void)getStaffCommand:(NSString *)pageNum PerPage:(NSString *)perPage
        completeHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler {
    
    BaseOperation * callOp = [[BaseOperation alloc] init];
    NSString *urlStr = StringFormat(@"%@/%@/%@",BaseURL,STAFFS,GET_COMMAND);
    NSURL *url = [NSURL URLWithString:urlStr];
    
    callOp.request = [NSMutableURLRequest requestWithURL:url];
    
    //create json
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[ShareHelper getUserDefaults:@"username"] forKey:@"username"];
    [dict setObject:pageNum forKey:@"pageNum"];
    [dict setObject:perPage forKey:@"perPage"];
    [dict setObject:[ShareHelper getUserDefaults:@"accessToken"] forKey:@"accessToken"];
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    
    [(NSMutableURLRequest*)callOp.request setHTTPMethod:@"POST"];
    [(NSMutableURLRequest*)callOp.request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [(NSMutableURLRequest*)callOp.request setHTTPBody:jsonData];
    
    callOp.completionHandler = ^(NSDictionary *result, NSURLResponse *res) {
        [self endGetStaffCommand:result response:res completionHandler:handler errorHandler:errHandler];
    };
    
    callOp.errorHandler = ^(NSError *err) {
        errHandler(err);
    };
    
    [callOp start];
}

- (void)endGetStaffCommand:(NSDictionary *)result response:(NSURLResponse *)response
         completionHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler {
    
    NSInteger httpCode = [(NSHTTPURLResponse*)response statusCode];
    if(httpCode != 200){
        NSError *err = [[NSError alloc] initWithDomain:HTTPDOMAIN code:httpCode userInfo:nil];
        errHandler(err);
        return;
    }
    NSString *errorCode = [result objectForKey:@"code"];
    NSDictionary *root = [result objectForKey:@"data"]?:nil;
    NSString *message = [result objectForKey:@"message"];
    if(![errorCode isEqualToString:@"0"]){
        [self showError:errorCode message:message errorHandler:errHandler];
        return;
    }
    ListDataRecord *data = [ListDataRecord new];
    data.l_total = [root objectForKey:@"total"];
    data.l_limit = [root objectForKey:@"limit"];
    data.l_page = [root objectForKey:@"page"];
    data.l_pages = [root objectForKey:@"pages"];
    
    NSArray *arrCommand = [root objectForKey:@"docs"];
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in arrCommand) {
        CommandRecord *item = [CommandRecord new];
        item = [self parseCommand:dict];
        [temp addObject:item];
    }
    data.l_docs = [temp copy];
    handler(data,errorCode,@"success");
}

-(CommandRecord *)parseCommand:(NSDictionary *)dict{
    CommandRecord *item = [CommandRecord new];
    
    item.c_id = [dict objectForKey:@"_id"];
    item.c_username = [dict objectForKey:@"username"];
    item.c_message = [dict objectForKey:@"message"];
    item.c_aquaId = [dict objectForKey:@"aquaId"];
    item.c_toGroup = [dict objectForKey:@"toGroup"];
    item.c_except = [dict objectForKey:@"except"];
    item.c_createdBy = [dict objectForKey:@"createdBy"];
    item.c_createdDate = [dict objectForKey:@"createdDate"];
    
    return item;
}

#pragma mark get Aquaculture Detail
-(void)getStaffCommandDetail :(NSString *)commandId completionHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler{
    BaseOperation *callOp = [[BaseOperation alloc] init];
    NSString *urlString = StringFormat(@"%@/%@/%@",BaseURL,STAFFS,GET_COMMAND_DETAIL);
    NSURL *url = [NSURL URLWithString:urlString];
    
    callOp.request = [NSMutableURLRequest requestWithURL:url];
    NSString *accessToken = [ShareHelper getUserDefaults:@"accessToken"];
    //create json
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:commandId forKey:@"commandId"];
    [dict setObject:accessToken forKey:@"accessToken"];
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    
    [(NSMutableURLRequest*)callOp.request setHTTPMethod:@"POST"];
    [(NSMutableURLRequest*)callOp.request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [(NSMutableURLRequest*)callOp.request setHTTPBody:jsonData];
    
    callOp.completionHandler = ^(NSDictionary *result, NSURLResponse *res) {
        [self endGetStaffCommandDetail:result response:res completionHandler:handler errorHandler:errHandler];
    };
    
    callOp.errorHandler = ^(NSError *err) {
        errHandler(err);
    };
    
    [callOp start];
}

-(void)endGetStaffCommandDetail:(NSDictionary *)result response:(NSURLResponse *)response
             completionHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler{
    NSInteger httpCode = [(NSHTTPURLResponse*)response statusCode];
    if(httpCode != 200){
        NSError *err = [[NSError alloc] initWithDomain:HTTPDOMAIN code:httpCode userInfo:nil];
        errHandler(err);
        return;
    }
    /*Parse json response*/
    NSString *errorCode = [result objectForKey:@"code"];
    NSDictionary *root = [result objectForKey:@"data"]?:nil;
    NSString *message = [result objectForKey:@"message"];
    if(![errorCode isEqualToString:@"0"]){
        [self showError:errorCode message:message errorHandler:errHandler];
        return;
    }
  
    CommandRecord *data = [CommandRecord new];
    data = [self parseCommand:root];
    handler(data,errorCode,nil);
}


#pragma mark get Chart

#pragma mark get FishDead
-(void)getChartFishDead:(NSString *)aquaId FromDate:(NSString *)fromDate ToDate:(NSString *)toDate completionHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler{
    BaseOperation *callOp = [[BaseOperation alloc] init];
    NSString *urlString = StringFormat(@"%@/%@/%@",BaseURL,MANAGERS,GET_CHART_FISH_DEAD);
    NSURL *url = [NSURL URLWithString:urlString];
    
    callOp.request = [NSMutableURLRequest requestWithURL:url];
    NSString *accessToken = [ShareHelper getUserDefaults:@"accessToken"];
    //create json
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:aquaId forKey:@"aquaId"];
    [dict setObject:accessToken forKey:@"accessToken"];
    [dict setObject:fromDate forKey:@"fromDate"];
    [dict setObject:toDate forKey:@"toDate"];
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    
    [(NSMutableURLRequest*)callOp.request setHTTPMethod:@"POST"];
    [(NSMutableURLRequest*)callOp.request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [(NSMutableURLRequest*)callOp.request setHTTPBody:jsonData];
    
    callOp.completionHandler = ^(NSDictionary *result, NSURLResponse *res) {
        [self endGetChartFishDead:result response:res completionHandler:handler errorHandler:errHandler];
    };
    
    callOp.errorHandler = ^(NSError *err){
        errHandler(err);
    };
    
    [callOp start];
}

-(void)endGetChartFishDead:(NSDictionary *)result response:(NSURLResponse *)response
             completionHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler{
    NSInteger httpCode = [(NSHTTPURLResponse*)response statusCode];
    if(httpCode != 200){
        NSError *err = [[NSError alloc] initWithDomain:HTTPDOMAIN code:httpCode userInfo:nil];
        errHandler(err);
        return;
    }
    /*Parse json response*/
    NSString *errorCode = [result objectForKey:@"code"];
    NSDictionary *root = [result objectForKey:@"data"]?:nil;
    NSString *message = [result objectForKey:@"message"];
    if(![errorCode isEqualToString:@"0"]){
        [self showError:errorCode message:message errorHandler:errHandler];
        return;
    }
    
    NSArray *arrdata = [root objectForKey:@"chart"];
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in arrdata) {
        FishDeadRecord *item = [FishDeadRecord new];
        item.fD_numberDeadOfFish = [self parseDeadFish:[dict objectForKey:@"numberOfDeadFish"]];
        item.fD_date = [dict objectForKey:@"date"];
        [temp addObject:item];
    }
    NSArray *data = [temp copy];
    handler(data,errorCode,nil);
}

-(DetailFishDeadRecord *)parseDeadFish:(NSDictionary *)dict{
    DetailFishDeadRecord *item = [DetailFishDeadRecord new];
    item.dF_countDead = [dict objectForKey:@"countDead"];
    item.dF_weight = [dict objectForKey:@"weight"];
    return  item;
}

#pragma mark get Fish Size
-(void)getChartFishSize:(NSString *)aquaId FromDate:(NSString *)fromDate ToDate:(NSString *)toDate completionHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler{
    BaseOperation *callOp = [[BaseOperation alloc] init];
    NSString *urlString = StringFormat(@"%@/%@/%@",BaseURL,MANAGERS,GET_CHART_FISH_SIZE);
    NSURL *url = [NSURL URLWithString:urlString];
    
    callOp.request = [NSMutableURLRequest requestWithURL:url];
    NSString *accessToken = [ShareHelper getUserDefaults:@"accessToken"];
    //create json
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:aquaId forKey:@"aquaId"];
    [dict setObject:accessToken forKey:@"accessToken"];
    [dict setObject:fromDate forKey:@"fromDate"];
    [dict setObject:toDate forKey:@"toDate"];
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    
    [(NSMutableURLRequest*)callOp.request setHTTPMethod:@"POST"];
    [(NSMutableURLRequest*)callOp.request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [(NSMutableURLRequest*)callOp.request setHTTPBody:jsonData];
    
    callOp.completionHandler = ^(NSDictionary *result, NSURLResponse *res) {
        [self endGetChartFishSize:result response:res completionHandler:handler errorHandler:errHandler];
    };
    
    callOp.errorHandler = ^(NSError *err){
        errHandler(err);
    };
    
    [callOp start];
}

-(void)endGetChartFishSize:(NSDictionary *)result response:(NSURLResponse *)response
         completionHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler{
    NSInteger httpCode = [(NSHTTPURLResponse*)response statusCode];
    if(httpCode != 200){
        NSError *err = [[NSError alloc] initWithDomain:HTTPDOMAIN code:httpCode userInfo:nil];
        errHandler(err);
        return;
    }
    /*Parse json response*/
    NSString *errorCode = [result objectForKey:@"code"];
    NSDictionary *root = [result objectForKey:@"data"]?:nil;
    NSString *message = [result objectForKey:@"message"];
    if(![errorCode isEqualToString:@"0"]){
        [self showError:errorCode message:message errorHandler:errHandler];
        return;
    }
    
    NSArray *arrdata = [root objectForKey:@"chart"];
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in arrdata) {
        FishSizeRecord *item = [FishSizeRecord new];
        item.f_size = [dict objectForKey:@"size"];
        item.f_date = [dict objectForKey:@"date"];
        [temp addObject:item];

    }
    NSArray *data = [temp copy];
    handler(data,errorCode,nil);
}

#pragma mark get Chart Food
-(void)getChartFood:(NSString *)aquaId FromDate:(NSString *)fromDate ToDate:(NSString *)toDate completionHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler{
    BaseOperation *callOp = [[BaseOperation alloc] init];
    NSString *urlString = StringFormat(@"%@/%@/%@",BaseURL,MANAGERS,GET_CHART_FOOD);
    NSURL *url = [NSURL URLWithString:urlString];
    
    callOp.request = [NSMutableURLRequest requestWithURL:url];
    NSString *accessToken = [ShareHelper getUserDefaults:@"accessToken"];
    //create json
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:aquaId forKey:@"aquaId"];
    [dict setObject:accessToken forKey:@"accessToken"];
    [dict setObject:fromDate forKey:@"fromDate"];
    [dict setObject:toDate forKey:@"toDate"];
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    
    [(NSMutableURLRequest*)callOp.request setHTTPMethod:@"POST"];
    [(NSMutableURLRequest*)callOp.request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [(NSMutableURLRequest*)callOp.request setHTTPBody:jsonData];
    
    callOp.completionHandler = ^(NSDictionary *result, NSURLResponse *res) {
        [self endGetChartFood:result response:res completionHandler:handler errorHandler:errHandler];
    };
    
    callOp.errorHandler = ^(NSError *err){
        errHandler(err);
    };
    
    [callOp start];
}

-(void)endGetChartFood:(NSDictionary *)result response:(NSURLResponse *)response
         completionHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler{
    NSInteger httpCode = [(NSHTTPURLResponse*)response statusCode];
    if(httpCode != 200){
        NSError *err = [[NSError alloc] initWithDomain:HTTPDOMAIN code:httpCode userInfo:nil];
        errHandler(err);
        return;
    }
    /*Parse json response*/
    NSString *errorCode = [result objectForKey:@"code"];
    NSDictionary *root = [result objectForKey:@"data"]?:nil;
    NSString *message = [result objectForKey:@"message"];
    if(![errorCode isEqualToString:@"0"]){
        [self showError:errorCode message:message errorHandler:errHandler];
        return;
    }
    
    NSArray *arrdata = [root objectForKey:@"chart"];
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in arrdata) {
        ChartFoodRecord *item = [ChartFoodRecord new];
        item.f_quantity = [dict objectForKey:@"quantity"];
        item.f_date = [dict objectForKey:@"date"];
        [temp addObject:item];
        
    }
    NSArray *data = [temp copy];
    handler(data,errorCode,nil);
}

#pragma mark get Chart Environment
-(void)getChartEnvironment:(NSString *)aquaId FromDate:(NSString *)fromDate ToDate:(NSString *)toDate completionHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler{
    BaseOperation *callOp = [[BaseOperation alloc] init];
    NSString *urlString = StringFormat(@"%@/%@/%@",BaseURL,MANAGERS,GET_CHART_ENVIRONMENT);
    NSURL *url = [NSURL URLWithString:urlString];
    
    callOp.request = [NSMutableURLRequest requestWithURL:url];
    NSString *accessToken = [ShareHelper getUserDefaults:@"accessToken"];
    //create json
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:aquaId forKey:@"aquaId"];
    [dict setObject:accessToken forKey:@"accessToken"];
    [dict setObject:fromDate forKey:@"fromDate"];
    [dict setObject:toDate forKey:@"toDate"];
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    
    [(NSMutableURLRequest*)callOp.request setHTTPMethod:@"POST"];
    [(NSMutableURLRequest*)callOp.request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [(NSMutableURLRequest*)callOp.request setHTTPBody:jsonData];
    
    callOp.completionHandler = ^(NSDictionary *result, NSURLResponse *res) {
        [self endGetChartEnvironment:result response:res completionHandler:handler errorHandler:errHandler];
    };
    
    callOp.errorHandler = ^(NSError *err){
        errHandler(err);
    };
    
    [callOp start];
}

-(void)endGetChartEnvironment:(NSDictionary *)result response:(NSURLResponse *)response
     completionHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler{
    NSInteger httpCode = [(NSHTTPURLResponse*)response statusCode];
    if(httpCode != 200){
        NSError *err = [[NSError alloc] initWithDomain:HTTPDOMAIN code:httpCode userInfo:nil];
        errHandler(err);
        return;
    }
    /*Parse json response*/
    NSString *errorCode = [result objectForKey:@"code"];
    NSDictionary *root = [result objectForKey:@"data"]?:nil;
    NSString *message = [result objectForKey:@"message"];
    if(![errorCode isEqualToString:@"0"]){
        [self showError:errorCode message:message errorHandler:errHandler];
        return;
    }
    
    NSArray *arrdata = [root objectForKey:@"chart"];
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in arrdata) {
        ChartEnvironmentRecord *item = [ChartEnvironmentRecord new];
        item.e_environment = [self parseEnvironment:[dict objectForKey:@"environment"]];
        item.e_date = [dict objectForKey:@"date"];
        [temp addObject:item];
        
    }
    NSArray *data = [temp copy];
    handler(data,errorCode,nil);
}

-(EnvironmentRecord *)parseEnvironment:(NSDictionary *)dict{
    EnvironmentRecord *item = [EnvironmentRecord new];
    item.e_do = [dict objectForKey:@"do"];
    item.e_no2 = [dict objectForKey:@"no2"];
    item.e_ph = [dict objectForKey:@"ph"];
    return item;
}

#pragma mark Get CheckList Detail
- (void)getCheckListDetail:(NSString *)aquaId completeHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler {
    
    BaseOperation * callOp = [[BaseOperation alloc] init];
    NSString *urlStr = StringFormat(@"%@/%@/%@",BaseURL,STAFFS,GET_CHECKLIST_DETAIL);
    NSURL *url = [NSURL URLWithString:urlStr];
    
    callOp.request = [NSMutableURLRequest requestWithURL:url];
    //create json
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:aquaId forKey:@"aquaId"];
    [dict setObject:[ShareHelper getUserDefaults:@"accessToken"] forKey:@"accessToken"];
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    
    [(NSMutableURLRequest*)callOp.request setHTTPMethod:@"POST"];
    [(NSMutableURLRequest*)callOp.request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [(NSMutableURLRequest*)callOp.request setHTTPBody:jsonData];
    
    callOp.completionHandler = ^(NSDictionary *result, NSURLResponse *res) {
        [self endGetCheckListDetail:result response:res completionHandler:handler errorHandler:errHandler];
    };
    
    callOp.errorHandler = ^(NSError *err) {
        errHandler(err);
    };
    
    [callOp start];
}

- (void)endGetCheckListDetail:(NSDictionary *)result response:(NSURLResponse *)response
         completionHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler {
    
    NSInteger httpCode = [(NSHTTPURLResponse*)response statusCode];
    if(httpCode != 200){
        NSError *err = [[NSError alloc] initWithDomain:HTTPDOMAIN code:httpCode userInfo:nil];
        errHandler(err);
        return;
    }
    NSString *errorCode = [result objectForKey:@"code"];
    NSDictionary *root = [result objectForKey:@"data"]?:nil;
    NSString *message = [result objectForKey:@"message"];
    if(![errorCode isEqualToString:@"0"]){
        [self showError:errorCode message:message errorHandler:errHandler];
        return;
    }
    
    CheckListDetailRecord *data = [CheckListDetailRecord new];
    data.c_id = [root objectForKey:@"_id"];
    data.c_aquaId = [root objectForKey:@"aquaId"];
    data.c_averageWeight = [root objectForKey:@"averageWeight"];
    data.c_detailFishDeadRecord = [self parseFishDead:[root objectForKey:@"numberOfDeadFish"]];
    data.c_health = [self parseHealth:[root objectForKey:@"health"]];
    
    NSArray *arrFood = [root objectForKey:@"food"];
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in arrFood) {
        FoodRecord *item = [FoodRecord new];
        item = [self parseFood:dict];
        [temp addObject:item];
    }
    data.c_food = [temp copy];
    
    NSArray *arrMedicine = [root objectForKey:@"medicine"];
    NSMutableArray *temp1 = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in arrMedicine) {
        MedicineRecord *item = [MedicineRecord new];
        item = [self parseMedicine:dict];
        [temp1 addObject:item];
    }
    data.c_medicine = [temp1 copy];
    data.c_environmentRecord = [self parseEnvironment:[root objectForKey:@"environment"]];
    handler(data,errorCode,@"success");
}

-(DetailFishDeadRecord *)parseFishDead:(NSDictionary *)dict{
    DetailFishDeadRecord *item = [DetailFishDeadRecord new];
    item.dF_countDead = [dict objectForKey:@"countDead"];
    item.dF_weight = [dict objectForKey:@"weight"];
    item.dF_images = [(NSMutableArray *)[dict objectForKey:@"images"] mutableCopy];
    return item;
}

#pragma mark Check Version
-(void)checkVersion:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler{
    BaseOperation * callOp = [[BaseOperation alloc] init];
    
    NSString *urlString = StringFormat(@"%@/%@/%@",BaseURL,USERS,CHECK_VERSION);
    NSURL *url = [NSURL URLWithString:urlString];
    callOp.request = [NSMutableURLRequest requestWithURL:url];
    
    NSString *appType = @"1";
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *platform = @"2";
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:currentVersion forKey:@"version"];
    [dict setObject:appType forKey:@"appType"];
    [dict setObject:platform forKey:@"platform"];
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    
    [(NSMutableURLRequest*)callOp.request setHTTPMethod:@"POST"];
    [(NSMutableURLRequest*)callOp.request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [(NSMutableURLRequest*)callOp.request setHTTPBody:jsonData];
    
    callOp.completionHandler = ^(NSDictionary *result, NSURLResponse *res) {
        [self endCheckVersion:result response:res completionHandler:handler errorHandler:errHandler];
    };
    
    callOp.errorHandler = ^(NSError *err) {
        errHandler(err);
    };
    
    [callOp start];
    
}

-(void)endCheckVersion:(NSDictionary *)result response:(NSURLResponse *)response
   completionHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler{
    NSInteger httpCode = [(NSHTTPURLResponse*)response statusCode];
    if(httpCode != 200){
        NSError *err = [[NSError alloc] initWithDomain:HTTPDOMAIN code:httpCode userInfo:nil];
        errHandler(err);
        return;
    }
    /*Parse json response*/
    NSString *errorCode = [result objectForKey:@"code"];
    NSString *data = [result objectForKey:@"data"];
    //NSDictionary *root = [result objectForKey:@"data"]?:nil;
    handler(data,errorCode,nil);
}

#pragma mark Search Staff

- (void)searchAquaStaff:(NSString *)key completeHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler {
    
    BaseOperation * callOp = [[BaseOperation alloc] init];
    NSString *urlStr = StringFormat(@"%@/%@/%@",BaseURL,STAFFS,SEARCH);
    NSURL *url = [NSURL URLWithString:urlStr];
    
    callOp.request = [NSMutableURLRequest requestWithURL:url];
    //create json
    NSString *userId = [ShareHelper getUserDefaults:@"userId"];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:userId forKey:@"userId"];
    [dict setObject:key forKey:@"key"];
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    
    [(NSMutableURLRequest*)callOp.request setHTTPMethod:@"POST"];
    [(NSMutableURLRequest*)callOp.request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [(NSMutableURLRequest*)callOp.request setHTTPBody:jsonData];
    
    callOp.completionHandler = ^(NSDictionary *result, NSURLResponse *res) {
        [self endSearchAquaStaff:result response:res completionHandler:handler errorHandler:errHandler];
    };
    
    callOp.errorHandler = ^(NSError *err) {
        errHandler(err);
    };
    
    [callOp start];
}

- (void)endSearchAquaStaff:(NSDictionary *)result response:(NSURLResponse *)response
            completionHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler {
    NSInteger httpCode = [(NSHTTPURLResponse*)response statusCode];
    if(httpCode != 200){
        NSError *err = [[NSError alloc] initWithDomain:HTTPDOMAIN code:httpCode userInfo:nil];
        errHandler(err);
        return;
    }
    /*Parse json response*/
    NSString *errorCode = [result objectForKey:@"code"];
    NSDictionary *root = [result objectForKey:@"data"]?:nil;
    NSString *message = [result objectForKey:@"message"];
    if(![errorCode isEqualToString:@"0"]){
        [self showError:errorCode message:message errorHandler:errHandler];
        return;
    }
    
    ListAquacultureRecord *data = [ListAquacultureRecord new];
    data.l_total = [root objectForKey:@"total"];
    data.l_limit = [root objectForKey:@"limit"];
    data.l_page = [root objectForKey:@"page"];
    data.l_pages = [root objectForKey:@"pages"];
    data.l_array = [self parseDocs:[root objectForKey:@"docs"]];
    
    handler(data,errorCode,nil);
}

#pragma mark Search Staff

- (void)searchAquaManager:(NSString *)key completeHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler {
    
    BaseOperation * callOp = [[BaseOperation alloc] init];
    NSString *urlStr = StringFormat(@"%@/%@/%@",BaseURL,MANAGERS,SEARCH);
    NSURL *url = [NSURL URLWithString:urlStr];
    
    callOp.request = [NSMutableURLRequest requestWithURL:url];
    //create json
    NSString *userId = [ShareHelper getUserDefaults:@"userId"];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:userId forKey:@"userId"];
    [dict setObject:key forKey:@"key"];
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    
    [(NSMutableURLRequest*)callOp.request setHTTPMethod:@"POST"];
    [(NSMutableURLRequest*)callOp.request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [(NSMutableURLRequest*)callOp.request setHTTPBody:jsonData];
    
    callOp.completionHandler = ^(NSDictionary *result, NSURLResponse *res) {
        [self endSearchAquaManager:result response:res completionHandler:handler errorHandler:errHandler];
    };
    
    callOp.errorHandler = ^(NSError *err) {
        errHandler(err);
    };
    
    [callOp start];
}

- (void)endSearchAquaManager:(NSDictionary *)result response:(NSURLResponse *)response
         completionHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler {
    NSInteger httpCode = [(NSHTTPURLResponse*)response statusCode];
    if(httpCode != 200){
        NSError *err = [[NSError alloc] initWithDomain:HTTPDOMAIN code:httpCode userInfo:nil];
        errHandler(err);
        return;
    }
    /*Parse json response*/
    NSString *errorCode = [result objectForKey:@"code"];
    NSDictionary *root = [result objectForKey:@"data"]?:nil;
    NSString *message = [result objectForKey:@"message"];
    if(![errorCode isEqualToString:@"0"]){
        [self showError:errorCode message:message errorHandler:errHandler];
        return;
    }
    
    ListAquacultureRecord *data = [ListAquacultureRecord new];
    data.l_total = [root objectForKey:@"total"];
    data.l_limit = [root objectForKey:@"limit"];
    data.l_page = [root objectForKey:@"page"];
    data.l_pages = [root objectForKey:@"pages"];
    data.l_array = [self parseDocs:[root objectForKey:@"docs"]];
    
    handler(data,errorCode,nil);
}

#pragma mark get Manager Command

- (void)getManagerCommand:(NSString *)pageNum PerPage:(NSString *)perPage
        completeHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler {
    
    BaseOperation * callOp = [[BaseOperation alloc] init];
    NSString *urlStr = StringFormat(@"%@/%@/%@",BaseURL,MANAGERS,GET_COMMAND);
    NSURL *url = [NSURL URLWithString:urlStr];
    
    callOp.request = [NSMutableURLRequest requestWithURL:url];
    
    //create json
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[ShareHelper getUserDefaults:@"username"] forKey:@"username"];
    [dict setObject:pageNum forKey:@"pageNum"];
    [dict setObject:perPage forKey:@"perPage"];
    [dict setObject:[ShareHelper getUserDefaults:@"accessToken"] forKey:@"accessToken"];
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    
    [(NSMutableURLRequest*)callOp.request setHTTPMethod:@"POST"];
    [(NSMutableURLRequest*)callOp.request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [(NSMutableURLRequest*)callOp.request setHTTPBody:jsonData];
    
    callOp.completionHandler = ^(NSDictionary *result, NSURLResponse *res) {
        [self endGetManagerCommand:result response:res completionHandler:handler errorHandler:errHandler];
    };
    
    callOp.errorHandler = ^(NSError *err) {
        errHandler(err);
    };
    
    [callOp start];
}

- (void)endGetManagerCommand:(NSDictionary *)result response:(NSURLResponse *)response
         completionHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler {
    
    NSInteger httpCode = [(NSHTTPURLResponse*)response statusCode];
    if(httpCode != 200){
        NSError *err = [[NSError alloc] initWithDomain:HTTPDOMAIN code:httpCode userInfo:nil];
        errHandler(err);
        return;
    }
    NSString *errorCode = [result objectForKey:@"code"];
    NSDictionary *root = [result objectForKey:@"data"]?:nil;
    NSString *message = [result objectForKey:@"message"];
    if(![errorCode isEqualToString:@"0"]){
        [self showError:errorCode message:message errorHandler:errHandler];
        return;
    }
    ListDataRecord *data = [ListDataRecord new];
    data.l_total = [root objectForKey:@"total"];
    data.l_limit = [root objectForKey:@"limit"];
    data.l_page = [root objectForKey:@"page"];
    data.l_pages = [root objectForKey:@"pages"];
    
    NSArray *arrCommand = [root objectForKey:@"docs"];
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in arrCommand) {
        CommandRecord *item = [CommandRecord new];
        item = [self parseCommand:dict];
        [temp addObject:item];
    }
    data.l_docs = [temp copy];
    handler(data,errorCode,@"success");
}

#pragma mark getListUserByArea manager
-(void)getListUserByArea :(NSString *)pageNum PerPage:(NSString *)perPage completionHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler{
    BaseOperation *callOp = [[BaseOperation alloc] init];
    NSString *urlString = StringFormat(@"%@/%@/%@",BaseURL,MANAGERS,GET_LIST_USER_BY_AREA);
    NSURL *url = [NSURL URLWithString:urlString];
    
    callOp.request = [NSMutableURLRequest requestWithURL:url];
    
    NSString *userArea = [ShareHelper getUserDefaults:@"userArea"];
    NSString *accessToken = [ShareHelper getUserDefaults:@"accessToken"];
    //create json
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:perPage forKey:@"perPage"];
    [dict setObject:pageNum forKey:@"pageNum"];
    [dict setObject:userArea forKey:@"area"];
    [dict setObject:accessToken forKey:@"accessToken"];
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    
    
    [(NSMutableURLRequest*)callOp.request setHTTPMethod:@"POST"];
    [(NSMutableURLRequest*)callOp.request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [(NSMutableURLRequest*)callOp.request setHTTPBody:jsonData];
    
    callOp.completionHandler = ^(NSDictionary *result, NSURLResponse *res) {
        [self endGetListUserByArea:result response:res completionHandler:handler errorHandler:errHandler];
    };
    
    callOp.errorHandler = ^(NSError *err) {
        errHandler(err);
    };
    
    [callOp start];
}

-(void)endGetListUserByArea:(NSDictionary *)result response:(NSURLResponse *)response
           completionHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler{
    NSInteger httpCode = [(NSHTTPURLResponse*)response statusCode];
    if(httpCode != 200){
        NSError *err = [[NSError alloc] initWithDomain:HTTPDOMAIN code:httpCode userInfo:nil];
        errHandler(err);
        return;
    }
    /*Parse json response*/
    NSString *errorCode = [result objectForKey:@"code"];
    NSDictionary *root = [result objectForKey:@"data"]?:nil;
    NSString *message = [result objectForKey:@"message"];
    if(![errorCode isEqualToString:@"0"]){
        [self showError:errorCode message:message errorHandler:errHandler];
        return;
    }
    
    ListDataRecord *data = [ListDataRecord new];
    data.l_total = [root objectForKey:@"total"];
    data.l_limit = [root objectForKey:@"limit"];
    data.l_page = [root objectForKey:@"page"];
    data.l_pages = [root objectForKey:@"pages"];
    data.l_docs = [self parseDocsUserArea:[root objectForKey:@"docs"]];
    
    handler(data,errorCode,nil);
}

#pragma mark Post Command Manager
-(void)postCommand :(NSString *)username Message:(NSString *)message completionHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler{
    BaseOperation *callOp = [[BaseOperation alloc] init];
    NSString *urlString = StringFormat(@"%@/%@/%@",BaseURL,MANAGERS,COMMAND);
    NSURL *url = [NSURL URLWithString:urlString];
    
    callOp.request = [NSMutableURLRequest requestWithURL:url];
    
    NSString *accessToken = [ShareHelper getUserDefaults:@"accessToken"];
    NSString *userName = [ShareHelper getUserDefaults:@"username"];
    //create json
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:username forKey:@"username"];
    [dict setObject:message forKey:@"message"];
    [dict setObject:@"" forKey:@"aquaId"];
    [dict setObject:@"" forKey:@"toGroup"];
    [dict setObject:@"" forKey:@"except"];
    [dict setObject:userName forKey:@"by"];
    [dict setObject:accessToken forKey:@"accessToken"];
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    
    
    [(NSMutableURLRequest*)callOp.request setHTTPMethod:@"POST"];
    [(NSMutableURLRequest*)callOp.request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [(NSMutableURLRequest*)callOp.request setHTTPBody:jsonData];
    
    callOp.completionHandler = ^(NSDictionary *result, NSURLResponse *res) {
        [self endPostCommand:result response:res completionHandler:handler errorHandler:errHandler];
    };
    
    callOp.errorHandler = ^(NSError *err) {
        errHandler(err);
    };
    
    [callOp start];
}

-(void)endPostCommand:(NSDictionary *)result response:(NSURLResponse *)response
          completionHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler{
    NSInteger httpCode = [(NSHTTPURLResponse*)response statusCode];
    if(httpCode != 200){
        NSError *err = [[NSError alloc] initWithDomain:HTTPDOMAIN code:httpCode userInfo:nil];
        errHandler(err);
        return;
    }
    /*Parse json response*/
    NSString *errorCode = [result objectForKey:@"code"];
    NSDictionary *root = [result objectForKey:@"data"]?:nil;
    NSString *message = [result objectForKey:@"message"];
    if(![errorCode isEqualToString:@"0"]){
        [self showError:errorCode message:message errorHandler:errHandler];
        return;
    }
    
//    ListAquacultureRecord *data = [ListAquacultureRecord new];
//    data.l_total = [root objectForKey:@"total"];
//    data.l_limit = [root objectForKey:@"limit"];
//    data.l_page = [root objectForKey:@"page"];
//    data.l_pages = [root objectForKey:@"pages"];
//    data.l_array = [self parseDocsUserArea:[root objectForKey:@"docs"]];
    
    handler(nil,errorCode,nil);
}


-(NSArray *)parseDocsUserArea:(NSArray *)array{
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in array) {
        UserAreaRecord *item = [UserAreaRecord new];
        item = [self parseUserArea:dict];
        [temp addObject:item];
    }
    NSArray *data = [temp copy];
    return data;
}

-(UserAreaRecord *)parseUserArea:(NSDictionary *)dict{
    UserAreaRecord *item = [UserAreaRecord new];
    item.u_id = [dict objectForKey:@"_id"];
    item.u_name = [dict objectForKey:@"name"];
    item.u_username = [dict objectForKey:@"username"];
    return  item;
}

#pragma mark change password

- (void)changePassword:(NSString *)oldPass NewPass:(NSString *)newPass
          completeHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler {
    
    BaseOperation * callOp = [[BaseOperation alloc] init];
    NSString *urlStr = StringFormat(@"%@/%@/%@",BaseURL,USERS,CHANGE_PASSWORD);
    NSURL *url = [NSURL URLWithString:urlStr];
    
    callOp.request = [NSMutableURLRequest requestWithURL:url];
    
    NSString *userId = [ShareHelper getUserDefaults:@"userId"];
    
    //create json
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:userId forKey:@"userId"];
    [dict setObject:oldPass forKey:@"oldPass"];
    [dict setObject:newPass forKey:@"newPass"];
    [dict setObject:[ShareHelper getUserDefaults:@"accessToken"] forKey:@"accessToken"];
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    
    [(NSMutableURLRequest*)callOp.request setHTTPMethod:@"POST"];
    [(NSMutableURLRequest*)callOp.request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [(NSMutableURLRequest*)callOp.request setHTTPBody:jsonData];
    
    callOp.completionHandler = ^(NSDictionary *result, NSURLResponse *res) {
        [self endChangePassword:result response:res completionHandler:handler errorHandler:errHandler];
    };
    
    callOp.errorHandler = ^(NSError *err) {
        errHandler(err);
    };
    
    [callOp start];
}

- (void)endChangePassword:(NSDictionary *)result response:(NSURLResponse *)response
           completionHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler {
    
    NSInteger httpCode = [(NSHTTPURLResponse*)response statusCode];
    if(httpCode != 200){
        NSError *err = [[NSError alloc] initWithDomain:HTTPDOMAIN code:httpCode userInfo:nil];
        errHandler(err);
        return;
    }
    NSString *errorCode = [result objectForKey:@"code"];
    //NSDictionary *root = [result objectForKey:@"data"]?:nil;
    NSString *message = [result objectForKey:@"message"];
    if(![errorCode isEqualToString:@"0"]){
        [self showError:errorCode message:message errorHandler:errHandler];
        return;
    }
    handler(nil,errorCode,@"success");
}

#pragma mark Notification

-(void)updateToken:(NSString *)userName token:(NSString *)token completeHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler{
    BaseOperation * callOp = [[BaseOperation alloc] init];
    NSString *urlStr = StringFormat(@"%@/%@/%@",BaseURL,USERS,UPDATE_TOKEN);
    NSURL *url = [NSURL URLWithString:urlStr];
    NSString *deviceIMEI = [OpenUDID value];
    
    callOp.request = [NSMutableURLRequest requestWithURL:url];
    
    //create json
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:userName forKey:@"username"];
    [dict setObject:deviceIMEI forKey:@"deviceIMEI"];
    [dict setObject:token forKey:@"token"];
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    
    [(NSMutableURLRequest*)callOp.request setHTTPMethod:@"POST"];
    [(NSMutableURLRequest*)callOp.request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [(NSMutableURLRequest*)callOp.request setHTTPBody:jsonData];
    
    callOp.completionHandler = ^(NSDictionary *result, NSURLResponse *res) {
        [self endUpdateToken:result response:res completionHandler:handler errorHandler:errHandler];
    };
    
    callOp.errorHandler = ^(NSError *err) {
        errHandler(err);
    };
    
    [callOp start];
}

- (void)endUpdateToken:(NSDictionary *)result response:(NSURLResponse *)response
     completionHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler {
    
    NSInteger httpCode = [(NSHTTPURLResponse*)response statusCode];
    if(httpCode != 200){
        NSError *err = [[NSError alloc] initWithDomain:HTTPDOMAIN code:httpCode userInfo:nil];
        errHandler(err);
        return;
    }
    NSString *errorCode = [result objectForKey:@"code"];
    //NSDictionary *root = [result objectForKey:@"data"]?:nil;
    NSString *message = [result objectForKey:@"message"];
    if(![errorCode isEqualToString:@"0"]){
        [self showError:errorCode message:message errorHandler:errHandler];
        return;
    }
    handler(nil,errorCode,@"success");
}

-(void)removeToken:(NSString *)userName completeHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler{
    BaseOperation * callOp = [[BaseOperation alloc] init];
    NSString *urlStr = StringFormat(@"%@/%@/%@",BaseURL,USERS,REMOVE_TOKEN);
    NSURL *url = [NSURL URLWithString:urlStr];
    NSString *deviceIMEI = [OpenUDID value];
    
    callOp.request = [NSMutableURLRequest requestWithURL:url];
    
    //create json
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:userName forKey:@"username"];
    [dict setObject:deviceIMEI forKey:@"deviceIMEI"];
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    
    [(NSMutableURLRequest*)callOp.request setHTTPMethod:@"POST"];
    [(NSMutableURLRequest*)callOp.request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [(NSMutableURLRequest*)callOp.request setHTTPBody:jsonData];
    
    callOp.completionHandler = ^(NSDictionary *result, NSURLResponse *res) {
        [self endRemoveToken:result response:res completionHandler:handler errorHandler:errHandler];
    };
    
    callOp.errorHandler = ^(NSError *err) {
        errHandler(err);
    };
    
    [callOp start];
}

- (void)endRemoveToken:(NSDictionary *)result response:(NSURLResponse *)response
     completionHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler {
    
    NSInteger httpCode = [(NSHTTPURLResponse*)response statusCode];
    if(httpCode != 200){
        NSError *err = [[NSError alloc] initWithDomain:HTTPDOMAIN code:httpCode userInfo:nil];
        errHandler(err);
        return;
    }
    NSString *errorCode = [result objectForKey:@"code"];
    //NSDictionary *root = [result objectForKey:@"data"]?:nil;
    NSString *message = [result objectForKey:@"message"];
    if(![errorCode isEqualToString:@"0"]){
        [self showError:errorCode message:message errorHandler:errHandler];
        return;
    }
    handler(nil,errorCode,@"success");
}

- (void)getNotify:(NSString *)pageNum PerPage:(NSString *)perPage
          completeHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler {
    
    BaseOperation * callOp = [[BaseOperation alloc] init];
    NSString *urlStr = StringFormat(@"%@/%@/%@",BaseURL,STAFFS,GET_NOTIFY);
    NSURL *url = [NSURL URLWithString:urlStr];
    
    callOp.request = [NSMutableURLRequest requestWithURL:url];
    
    //create json
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[ShareHelper getUserDefaults:@"username"] forKey:@"username"];
    [dict setObject:pageNum forKey:@"pageNum"];
    [dict setObject:perPage forKey:@"perPage"];
    [dict setObject:[ShareHelper getUserDefaults:@"accessToken"] forKey:@"accessToken"];
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    
    [(NSMutableURLRequest*)callOp.request setHTTPMethod:@"POST"];
    [(NSMutableURLRequest*)callOp.request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [(NSMutableURLRequest*)callOp.request setHTTPBody:jsonData];
    
    callOp.completionHandler = ^(NSDictionary *result, NSURLResponse *res) {
        [self endGetNotify:result response:res completionHandler:handler errorHandler:errHandler];
    };
    
    callOp.errorHandler = ^(NSError *err) {
        errHandler(err);
    };
    
    [callOp start];
}

- (void)endGetNotify:(NSDictionary *)result response:(NSURLResponse *)response
           completionHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler {
    
    NSInteger httpCode = [(NSHTTPURLResponse*)response statusCode];
    if(httpCode != 200){
        NSError *err = [[NSError alloc] initWithDomain:HTTPDOMAIN code:httpCode userInfo:nil];
        errHandler(err);
        return;
    }
    NSString *errorCode = [result objectForKey:@"code"];
    NSDictionary *root = [result objectForKey:@"data"]?:nil;
    NSString *message = [result objectForKey:@"message"];
    if(![errorCode isEqualToString:@"0"]){
        [self showError:errorCode message:message errorHandler:errHandler];
        return;
    }
    ListDataRecord *data = [ListDataRecord new];
    data.l_total = [root objectForKey:@"total"];
    data.l_limit = [root objectForKey:@"limit"];
    data.l_page = [root objectForKey:@"page"];
    data.l_pages = [root objectForKey:@"pages"];
    
    NSArray *arrNoti = [root objectForKey:@"docs"];
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in arrNoti) {
        NotificationRecord *item = [NotificationRecord new];
        item = [self parseNoti:dict];
        [temp addObject:item];
    }
    data.l_docs = [temp copy];
    handler(data,errorCode,@"success");
}

-(void)updateStatusNotify:(NSString *)notifyId completeHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler{
    BaseOperation * callOp = [[BaseOperation alloc] init];
    NSString *urlStr = StringFormat(@"%@/%@/%@",BaseURL,STAFFS,UPDATE_NOTIFY);
    NSURL *url = [NSURL URLWithString:urlStr];
    
    callOp.request = [NSMutableURLRequest requestWithURL:url];
    
    //create json
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:notifyId forKey:@"notifyId"];
    [dict setObject:[ShareHelper getUserDefaults:@"accessToken"] forKey:@"accessToken"];
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    
    [(NSMutableURLRequest*)callOp.request setHTTPMethod:@"POST"];
    [(NSMutableURLRequest*)callOp.request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [(NSMutableURLRequest*)callOp.request setHTTPBody:jsonData];
    
    callOp.completionHandler = ^(NSDictionary *result, NSURLResponse *res) {
        [self endUpdateStatusNotify:result response:res completionHandler:handler errorHandler:errHandler];
    };
    
    callOp.errorHandler = ^(NSError *err) {
        errHandler(err);
    };
    
    [callOp start];
}

- (void)endUpdateStatusNotify:(NSDictionary *)result response:(NSURLResponse *)response
     completionHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler {
    
    NSInteger httpCode = [(NSHTTPURLResponse*)response statusCode];
    if(httpCode != 200){
        NSError *err = [[NSError alloc] initWithDomain:HTTPDOMAIN code:httpCode userInfo:nil];
        errHandler(err);
        return;
    }
    NSString *errorCode = [result objectForKey:@"code"];
    //NSDictionary *root = [result objectForKey:@"data"]?:nil;
    NSString *message = [result objectForKey:@"message"];
    if(![errorCode isEqualToString:@"0"]){
        [self showError:errorCode message:message errorHandler:errHandler];
        return;
    }
    handler(nil,errorCode,@"success");
}

-(void)getBadge:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler{
    BaseOperation * callOp = [[BaseOperation alloc] init];
    NSString *urlStr = StringFormat(@"%@/%@/%@",BaseURL,STAFFS,BADGE);
    NSURL *url = [NSURL URLWithString:urlStr];
    
    callOp.request = [NSMutableURLRequest requestWithURL:url];
    
    NSString *userName = [ShareHelper getUserDefaults:@"username"];
    
    //create json
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:userName forKey:@"username"];
    [dict setObject:[ShareHelper getUserDefaults:@"accessToken"] forKey:@"accessToken"];
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    
    [(NSMutableURLRequest*)callOp.request setHTTPMethod:@"POST"];
    [(NSMutableURLRequest*)callOp.request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [(NSMutableURLRequest*)callOp.request setHTTPBody:jsonData];
    
    callOp.completionHandler = ^(NSDictionary *result, NSURLResponse *res) {
        [self endGetBadge:result response:res completionHandler:handler errorHandler:errHandler];
    };
    
    callOp.errorHandler = ^(NSError *err) {
        errHandler(err);
    };
    
    [callOp start];
}

- (void)endGetBadge:(NSDictionary *)result response:(NSURLResponse *)response
            completionHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler {
    
    NSInteger httpCode = [(NSHTTPURLResponse*)response statusCode];
    if(httpCode != 200){
        NSError *err = [[NSError alloc] initWithDomain:HTTPDOMAIN code:httpCode userInfo:nil];
        errHandler(err);
        return;
    }
    NSString *errorCode = [result objectForKey:@"code"];
    NSDictionary *root = [result objectForKey:@"data"]?:nil;
    NSString *message = [result objectForKey:@"message"];
    if(![errorCode isEqualToString:@"0"]){
        [self showError:errorCode message:message errorHandler:errHandler];
        return;
    }
    
    NSString *badge = StringFormat(@"%@",[root objectForKey:@"badge"]);
    handler(badge,errorCode,@"success");
}


-(NotificationRecord *)parseNoti:(NSDictionary *)dict{
    NotificationRecord *item = [NotificationRecord new];
    
    item.n_id = [dict objectForKey:@"_id"];
    item.n_username = [dict objectForKey:@"username"];
    item.n_message = [dict objectForKey:@"message"];
    item.n_type = [dict objectForKey:@"type"];
    item.n_data = [self parseNotificationData:[dict objectForKey:@"data"]];
    item.n_toGroup = [dict objectForKey:@"toGroup"];
    item.n_except = [dict objectForKey:@"except"];
    item.n_createdBy = [dict objectForKey:@"createdBy"];
    item.n_createdDate = [dict objectForKey:@"createdDate"];
    item.n_read = StringFormat(@"%@",[dict objectForKey:@"read"]);
    
    return item;
}

-(NotificationDataRecord *)parseNotificationData:(NSDictionary *)dict{
    NotificationDataRecord *item = [NotificationDataRecord new];
    item.d_aquaId = [dict objectForKey:@"_id"];
    //item.d_name = [dict objectForKey:@"name"];
    return item;
}

#pragma mark show error
-(void)showError:(NSString *)errCode errorHandler:(ErrorBlock)errHandler{
    NSString *meg = StringFormat(@"%@",errCode);
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    [details setValue:meg forKey:NSLocalizedDescriptionKey];
    NSError *err = [[NSError alloc] initWithDomain:meg code:errCode.integerValue userInfo:details];
    errHandler(err);
}
-(void)showError:(NSString *)errCode message:(NSString *)message errorHandler:(ErrorBlock)errHandler{
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    [details setValue:message forKey:NSLocalizedDescriptionKey];
    NSError *err = [[NSError alloc] initWithDomain:message code:errCode.integerValue userInfo:details];
    errHandler(err);
}
@end

//
//  RequestManager.m
//  心灵FM
//
//  Created by qianfeng on 16/2/20.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "RequestManager.h"
#import "AFNetworking.h"

@implementation RequestManager

+(void)postRequestWithUrl:(NSString*)urlStr dict:(NSDictionary*)dict block:(requestResultBlock)block
{
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];

    [manager POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        block(YES,responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        block(NO,error.description);
    }];
}

+ (void)getRequestWithUrl:(NSString*)urlStr dict:(NSDictionary*)dict block:(requestResultBlock)block{
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
 
    [manager GET:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        block(YES,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        block(NO,error.description);
    }];
}


@end

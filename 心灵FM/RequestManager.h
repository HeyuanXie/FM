//
//  RequestManager.h
//  心灵FM
//
//  Created by qianfeng on 16/2/20.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^requestResultBlock)(BOOL isSuccess,id respondObject);

@interface RequestManager : NSObject

+(void)postRequestWithUrl:(NSString*)urlStr dict:(NSDictionary*)dict block:(requestResultBlock)block;

+(void)getRequestWithUrl:(NSString*)urlStr dict:(NSDictionary*)dict block:(requestResultBlock)block;

@end

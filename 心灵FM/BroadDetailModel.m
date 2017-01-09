//
//  BroadDetailModel.m
//  心灵FM
//
//  Created by qianfeng on 16/2/23.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "BroadDetailModel.h"
#import "MJExtension.h"

@implementation BroadDetailModel

+(NSDictionary*)mj_replacedKeyFromPropertyName
{
    NSDictionary* dict = @{@"ID":@"id"};
    return dict;
}

+(NSDictionary* )mj_objectClassInArray
{
    NSDictionary* dict = @{@"diantai":@"diantaiModel"};
    return dict;
}

@end

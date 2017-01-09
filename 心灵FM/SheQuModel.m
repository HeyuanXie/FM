//
//  SheQuModel.m
//  心灵FM
//
//  Created by qianfeng on 16/2/27.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "SheQuModel.h"
#import "MJExtension.h"

@implementation SheQuModel

+(NSDictionary*)mj_replacedKeyFromPropertyName
{
    NSDictionary* dict = @{@"ID":@"id",@"theFloor":@"floor"};
    return dict;
}

@end


@implementation UserModel

+(NSDictionary*)mj_replacedKeyFromPropertyName
{
    NSDictionary* dict = @{@"ID":@"id"};
    return dict;
}

@end
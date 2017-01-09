//
//  HomeModel.m
//  心灵FM
//
//  Created by qianfeng on 16/2/20.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "HomeModel.h"
#import "MJExtension.h"

@implementation HomeModel

+(NSDictionary* )mj_objectClassInArray
{
    NSDictionary* dict = @{@"tuijian":@"tuijianModel",@"category":@"categoryModel",@"hotfm":@"fmModel",@"newfm":@"fmModel",@"newlesson":@"fmModel",@"diantai":@"diantaiModel"};
    return dict;
}

@end


//推荐model
@implementation tuijianModel



@end


//分类model
@implementation categoryModel

+(NSDictionary* )mj_replacedKeyFromPropertyName{
    
    NSDictionary* dict = @{@"ID":@"id"};
    return dict;
}

@end


//fm model
@implementation fmModel

+(NSDictionary*)mj_replacedKeyFromPropertyName
{
    NSDictionary* dict = @{@"ID":@"id"};
    return dict;
}

@end


//电台model
@implementation diantaiModel

+(NSDictionary*)mj_replacedKeyFromPropertyName
{
    NSDictionary* dict = @{@"ID":@"id"};
    return dict;
}

@end
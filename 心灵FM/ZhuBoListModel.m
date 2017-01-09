//
//  ZhuBoListModel.m
//  心灵FM
//
//  Created by qianfeng on 16/2/25.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "ZhuBoListModel.h"
#import "MJExtension.h"
#import "HomeModel.h"

//@class diantaiModel;
@implementation ZhuBoListModel

+(NSDictionary*)mj_objectClassInArray
{
    NSDictionary* dict = @{@"tuijian":@"diantaiModel",@"newlist":@"diantaiModel",@"hotlist":@"diantaiModel"};
    return dict;
}

@end

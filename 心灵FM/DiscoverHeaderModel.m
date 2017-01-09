//
//  DiscoverHeaderModel.m
//  FM
//
//  Created by qianfeng on 16/3/1.
//  Copyright © 2016年 CYH. All rights reserved.
//

#import "DiscoverHeaderModel.h"
#import "MJExtension.h"

@implementation DiscoverHeaderModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    NSDictionary *dic = @{@"ID":@"id"};
    return dic;
}

@end

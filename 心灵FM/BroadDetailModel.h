//
//  BroadDetailModel.h
//  心灵FM
//
//  Created by qianfeng on 16/2/23.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
@class diantaiModel;

@interface BroadDetailModel : NSObject

WS(ID);
WS(title);
WS(cover);
WS(speak);
WS(viewnum);
WS(url);
WS(absolute_url);

@property(nonatomic,strong)diantaiModel* diantai;
@property(nonatomic,strong)NSArray* user_gift_list;

@end

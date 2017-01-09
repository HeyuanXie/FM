//
//  HomeModel.h
//  心灵FM
//
//  Created by qianfeng on 16/2/20.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class diantaiModel;
@interface HomeModel : NSObject

@property(nonatomic,strong)NSArray* tuijian;
@property(nonatomic,strong)NSArray* category;
@property(nonatomic,strong)NSArray* hotfm;
@property(nonatomic,strong)NSArray* newfm;
@property(nonatomic,strong)NSArray* newlesson;
@property(nonatomic,strong)NSArray* diantai;

@end


//推荐model
@interface tuijianModel : NSObject
WS(title);
WS(cover);
WS(value);
WS(url);
@end


//分类model
@interface categoryModel : NSObject
WS(ID);
WS(cover);
WS(name);
@end


//fm model
@interface fmModel : NSObject
WS(ID);//重名
WS(title);
WS(cover);
WS(url);
WS(speak);
WS(favnum);
WS(viewnum);

@property(nonatomic,strong)diantaiModel* diantai;

@end


//电台model
@interface diantaiModel : NSObject
WS(content);
WS(ID);//重名
WS(title);
WS(viewnum);
WS(favnum);
WS(cover);
WS(user_id);
WS(fmnum);

@end
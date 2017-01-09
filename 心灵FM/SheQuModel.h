//
//  SheQuModel.h
//  心灵FM
//
//  Created by qianfeng on 16/2/27.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserModel;
@interface SheQuModel : NSObject

WS(ID);
WS(title);
WS(content);
WS(created);
WS(updated);
WS(commentnum);

@property(nonatomic,assign)NSInteger theFloor;
@property(nonatomic,strong)UserModel* user;
@property(nonatomic,strong)NSString* images;

@end


@interface UserModel : NSObject

WS(ID);
WS(nickname);
WS(avatar);
WS(introduce);

@end
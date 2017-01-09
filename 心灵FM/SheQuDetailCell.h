//
//  SheQuDetailCell.h
//  心灵FM
//
//  Created by qianfeng on 16/2/29.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SheQuDetailCell : UITableViewCell

-(void)setUIWithModel:(id)model;

@property (weak, nonatomic) IBOutlet UITextView* contentTextView;

@end

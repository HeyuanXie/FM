//
//  SheQuCell.h
//  心灵FM
//
//  Created by qianfeng on 16/2/27.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SheQuCell : UITableViewCell

-(void)setUIWithModel:(id)model;

@property (weak, nonatomic) IBOutlet UITextView* contentTextView;

@end

//
//  YTChatCell.m
//  YTIMDemo
//
//  Created by yanl on 2018/2/5.
//  Copyright © 2018年 yanl. All rights reserved.
//

#import "YTChatCell.h"
#import "AppMacro.h"
#import "YYKit.h"

@implementation YTChatCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI
{
    self.lblContent = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenW - 30, 16)];
    
    _lblContent.font = Font(12.f);
    _lblContent.textColor = HexColor(@"444444");
    
    [self.contentView addSubview:_lblContent];
}

@end

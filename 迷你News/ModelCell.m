//
//  ModelCell.m
//  迷你News
//
//  Created by qingyun on 16/3/23.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "ModelCell.h"
#import "Model.h"
#import "UIImageView+WebCache.h"
@interface ModelCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end

@implementation ModelCell


- (void)awakeFromNib {
    // Initialization code
}

-(void)bangdingStatus:(Model *)status
{
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:status.picUrl]];
    self.time.text = status.ctime;
    self.title.text = status.title;
    self.content.text = status.desc;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

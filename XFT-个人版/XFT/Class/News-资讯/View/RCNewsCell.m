//
//  RCNewsCell.m
//  XFT
//
//  Created by 夏增明 on 2019/8/28.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCNewsCell.h"
#import "RCNews.h"
#import "RCMyCollectNews.h"

@interface RCNewsCell ()
@property (weak, nonatomic) IBOutlet UIImageView *head_ic;
@property (weak, nonatomic) IBOutlet UILabel *news_title;
@property (weak, nonatomic) IBOutlet UILabel *news_look;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end
@implementation RCNewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setNews:(RCNews *)news
{
    _news = news;
    [self.head_ic sd_setImageWithURL:[NSURL URLWithString:_news.headPic]];
    [self.news_title setTextWithLineSpace:5.f withString:_news.title withFont:[UIFont systemFontOfSize:16]];
    self.news_look.text = [NSString stringWithFormat:@"已查看%@人",_news.clickNum];
    self.time.text = _news.createTime;
}
-(void)setCollectNews:(RCMyCollectNews *)collectNews
{
    _collectNews = collectNews;
    [self.head_ic sd_setImageWithURL:[NSURL URLWithString:_collectNews.headPic]];
    [self.news_title setTextWithLineSpace:5.f withString:_collectNews.title withFont:[UIFont systemFontOfSize:16]];
    self.news_look.text = [NSString stringWithFormat:@"已查看%@人",_collectNews.clickNum];
    self.time.text = _collectNews.publishTime;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

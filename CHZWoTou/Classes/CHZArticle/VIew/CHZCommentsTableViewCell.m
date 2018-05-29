//
//  CHZCommentsTableViewCell.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/14.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZCommentsTableViewCell.h"
#import "CHZCommentModel.h"
#import "CHZCommentFrames.h"


/**  固定边距 */
#define KIconImgBorder 5
/**  tool 字体大小 */
#define KToolFont 15
/**  nick 字体大小 */
#define KNickFont 15
/**  time 字体大小 */
#define KTimeFont 12
/**  正文 字体大小 */
#define KTextFont 17
@interface CHZCommentsTableViewCell()
//数据
@property (nonatomic, strong)CHZCommentModel *status;

/**底层imgView */
@property (nonatomic, weak)UIImageView *topImgView;
/**iconImgView */
@property (nonatomic, weak)UIImageView *iconImgView;

/**namelabel */
@property (nonatomic, weak)UILabel *namelabel;
/**timelabel */
@property (nonatomic, weak)UILabel *timelabel;
/**textlabel */
@property (nonatomic, weak)UILabel *contentTextlabel;
@property (nonatomic, weak)UIButton *praiseBtn;
@property (nonatomic, weak)UILabel *numLB;


/** */
@property (nonatomic,assign)BOOL flag;


@end

@implementation CHZCommentsTableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"status";
    CHZCommentsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[CHZCommentsTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        //设置cell的被点击效果为None
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.contentView.backgroundColor = CHZGlobalBg;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //添加发送文字图片view
        [self addInfoView];
        
    }
    
    return self;
}

//添加发送文字图片view
- (void)addInfoView{
    /**底部imgView */
    UIImageView *topImgView = [[UIImageView alloc] init];
    topImgView.image = [UIImage resizedImage:@"timeline_cardH"];
    topImgView.highlightedImage = [UIImage resizedImage:@"timeline_card"];
    [self.contentView addSubview:topImgView];
    self.topImgView = topImgView;
    
    /**iconImgView */
    UIImageView *iconImgView = [[UIImageView alloc] init];
//    iconImgView.image = [UIImage imageNamed:@"perImg"];
    
    iconImgView.layer.masksToBounds = YES;
    
    [self.contentView addSubview:iconImgView];
    self.iconImgView = iconImgView;
    
    
    
    /**namelabel */
    UILabel *namelabel = [[UILabel alloc] init];
    namelabel.font = [UIFont systemFontOfSize:KNickFont];
    [self.contentView addSubview:namelabel];
    namelabel.backgroundColor = [UIColor clearColor];
    self.namelabel = namelabel;
    
    /**timeLabel */
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = [UIFont systemFontOfSize:KTimeFont];
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.textColor = CHZRGBColor(240, 140, 19);
    [self.contentView addSubview:timeLabel];
    
    self.timelabel = timeLabel;
    
    UILabel *contentTextlabel = [[UILabel alloc] init];
    [contentTextlabel setFont:[UIFont systemFontOfSize:KTextFont]];
    contentTextlabel.numberOfLines = 0;
    contentTextlabel.textAlignment = NSTextAlignmentLeft;
    contentTextlabel.textColor = CHZRGBColor(39, 39, 39);
    contentTextlabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:contentTextlabel];
    self.contentTextlabel = contentTextlabel;

    
    
    UIButton *praiseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [praiseBtn addTarget:self action:@selector(praiseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [praiseBtn setBackgroundImage:[UIImage imageNamed:@"priseBtn_off"] forState:UIControlStateNormal];
    [self.contentView addSubview:praiseBtn];
    self.praiseBtn = praiseBtn;
    
    //数
    UILabel *numLB = [[UILabel alloc] init];
    numLB.textAlignment = NSTextAlignmentRight;
    numLB.font = [UIFont systemFontOfSize:13];
    
    [self.contentView addSubview:numLB];
    self.numLB = numLB;
    
}

- (void)praiseBtnClick:(UIButton *)btn{
    
    if (!_status.is_zan) {
        [self.praiseBtn setBackgroundImage:[UIImage imageNamed:@"priseBtn"] forState:UIControlStateNormal];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"id"] = [CHZUserDefaults objectForKey:@"userId"];
        params[@"token"] = [CHZUserDefaults objectForKey:@"token"];
        params[@"cid"] = _status.cid;
        params[@"uid"] = params[@"id"];
        NSString *url;
        switch (_type) {
            case 1:
                url = API_ZANPOST;
                break;
            case 2:
                url = API_BOOKZANPOST;
                break;
                
            case 3:
                url = API_INTERVIEWZANPOST;
                break;
                
            default:
                break;
        }
        if (url.length >0) {
            // 1.创建请求管理对象
            AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
            // 说明服务器返回的JSON数据
            mgr.responseSerializer = [AFJSONResponseSerializer serializer];
            
            [mgr POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (200 == [responseObject[@"code"] integerValue]) {
                    _status.is_zan = YES;
                    [[NSUserDefaults standardUserDefaults] setObject:_status.name forKey:@"token"];
                    _status.zan = [NSString stringWithFormat:@"%ld",([_status.zan integerValue] + 1)];
                    self.numLB.text = _status.zan;
                    [SVProgressHUD showSuccessWithStatus:@"点赞成功"];
                }else if(400 == [responseObject[@"code"] integerValue]){
                    
                    [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"点赞失败"];
                    [btn setBackgroundImage:[UIImage imageNamed:@"priseBtn_off"] forState:UIControlStateNormal];
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [btn setBackgroundImage:[UIImage imageNamed:@"priseBtn_off"] forState:UIControlStateNormal];
                [SVProgressHUD showErrorWithStatus:@"点赞失败,稍后再试"];
                
            }];
        }
        
        
        
    }else{
        [SVProgressHUD showInfoWithStatus:@"已经赞过了"];
    }
    
    
    
    
}

- (void)setStatusFrame:(CHZCommentFrames *)statusFrame{
    _statusFrame = statusFrame;
    _status = self.statusFrame.statusInfo;
    
    self.topImgView.frame = self.statusFrame.topImgViewF;
    self.iconImgView.frame = self.statusFrame.IconImgF;
    self.iconImgView.layer.cornerRadius = self.statusFrame.IconImgF.size.height *0.5;
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:_status.head_pic] placeholderImage:[UIImage imageNamed:@"perImg"]];
    self.namelabel.frame = self.statusFrame.nameLabelF;
    self.namelabel.text = _status.name;
    
    self.timelabel.frame = self.statusFrame.timeLabelF;
    
    self.timelabel.text = _status.add_time;
    
    self.praiseBtn.frame = self.statusFrame.praiseBtnF;
    self.numLB.frame = self.statusFrame.numLBF;
    
    self.numLB.text = _status.zan;
    
    self.contentTextlabel.frame = self.statusFrame.textLabelF;
    
    if (_status.reply.length > 0) {
        
        NSString *str = [NSString stringWithFormat:@"%@\n\n%@:%@",_status.content,_status.reply_name,_status.reply];
        NSMutableAttributedString * attriStr=[[NSMutableAttributedString alloc]initWithString:str];
        NSRange range = [str rangeOfString:_status.reply_name];
        [attriStr addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:range];
        self.contentTextlabel.attributedText = attriStr;
    }else{
        self.contentTextlabel.text = _status.content;
    }
 
}

- (void)layoutSubviews{
    UIImage *img = self.imageView.image;
    self.imageView.image = [UIImage imageNamed:@"perImg"];
    [super layoutSubviews];
    self.imageView.image = img;
    if (_status) {
        if (_status.is_zan) {
            [self.praiseBtn setBackgroundImage:[UIImage imageNamed:@"priseBtn"] forState:UIControlStateNormal];
//            self.praiseBtn.enabled = NO;
        }else{
            [self.praiseBtn setBackgroundImage:[UIImage imageNamed:@"priseBtn_off"] forState:UIControlStateNormal];
        }
    }
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

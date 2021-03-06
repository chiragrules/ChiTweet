//
//  TweetTableViewCell.m
//  ChiTweet
//
//  Created by Chirag Davé on 6/22/14.
//  Copyright (c) 2014 Chirag Davé. All rights reserved.
//

#import "TweetTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "MHPrettyDate.h"

@interface TweetTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *profilePhoto;
@property (weak, nonatomic) IBOutlet UILabel *fullName;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UILabel *timestamp;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;
@property (weak, nonatomic) IBOutlet UILabel *retweetedBy;

@property (strong, nonatomic) User *author;

@end

@implementation TweetTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onProfileTap:)];
    
    [self.profilePhoto addGestureRecognizer:tapGestureRecognizer];
    self.profilePhoto.userInteractionEnabled = YES;
}

- (void)onProfileTap:(UIImageView *)target {
    [self.delegate showProfile:self.author];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweet:(Tweet *)tweet {
    self.author = tweet.author;
    self.fullName.text = tweet.author.fullName;
    self.screenName.text = [NSString stringWithFormat:@"@%@",tweet.author.screenName];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    [df setDateStyle:NSDateFormatterLongStyle];
    [df setFormatterBehavior:NSDateFormatterBehavior10_4];
    [df setDateFormat: @"EEE MMM dd HH:mm:ss Z yyyy"];
    
    NSDate *newDate = [df dateFromString:tweet.timestamp];
    NSString *prettyDate = [MHPrettyDate prettyDateFromDate:newDate withFormat:MHPrettyDateShortRelativeTime];
    
    self.timestamp.text = prettyDate;
    self.tweetText.text= tweet.text;
    
    if (tweet.retweeted) {
        self.retweetedBy.text = [NSString stringWithFormat:@"RT'd By: %@", tweet.retweetedBy];
    } else {
        self.retweetedBy.text = @"";
    }
    
    [self.profilePhoto setImageWithURL:tweet.author.profileImageURL];
}

@end

//
//  CommentViewController.m
//  NetworkApplication
//
//  Created by Dennis Yang on 12-12-21.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "CommentViewController.h"

#import "CommentCell.h"
#import "Comment.h"

#import "AudioPlayer.h"

@interface CommentViewController ()

@end

@implementation CommentViewController

@synthesize photo = _photo;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评论";
    
    if (__IPHONE5) {
        _bottombar = [[BottomInputBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height   , self.view.frame.size.width, 44)];
    } else {
        _bottombar = [[BottomInputBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-88, self.view.frame.size.width, 44)];
    }
    _bottombar.delegate = self;
    _bottombar.backgroundColor = [UIColor redColor];
    [self.view addSubview:_bottombar];
    [_bottombar release];
    
    _data = [[NSMutableArray alloc] init];
    
    [self loadComments];
}

- (void)loadComments {
    [__requester setCallback:^(NSDictionary *dic) {
        [_data removeAllObjects];
        [_data addObjectsFromArray:[__parser commentsWithData:dic]];
        _total = [__parser listLengthWithData:dic];
        [_tableView reloadData];
        [_tableView setContentOffset:CGPointMake(0, 0)];
        [SVProgressHUD dismiss];
    }];
    [__requester commentsOfPhoto:self.photo.imageId fromPosition:0 withLength:20];
    
    [SVProgressHUD showWithStatus:@"Loading..."];
}

- (void)playSound:(id)sender {
    UIButton *btn= (UIButton *)sender;
    btn.selected = !btn.selected;
    
    Comment *cmm = [_data objectAtIndex:btn.tag];
    NSData *amr = [NSData dataWithContentsOfURL:[NSURL URLWithString:IMAGE(cmm.voiceId)]];
    
    [[AudioPlayer player] play_amr:amr sender:btn];
}

UIImage* resizableImage(NSString *img, float top, float left, float bottom, float right) {
    UIImage *image = [UIImage imageNamed:img];
    if(__IPHONE5) {
        [image resizableImageWithCapInsets:UIEdgeInsetsMake(top, left, bottom, right)];
    } else {
        [image stretchableImageWithLeftCapWidth:left topCapHeight:top];
    }
    return image;
}

#pragma mark - BottomInputBarDelegate

- (void)bottomInputBar:(BottomInputBar *)bar didFinishInputText:(NSString *)text {
    [__requester setCallback:^(NSDictionary *dic) {
        [self loadComments];
    }];
    [__requester sendPhotoComment:self.photo.imageId comment:text];
    
    [SVProgressHUD showWithStatus:@"发送评论..."];
}

- (void)bottomInputBar:(BottomInputBar *)bar didFinishInputVoice:(NSData *)voice {
    if (voice.length < 2048) {
        [SVProgressHUD showErrorWithStatus:@"评论内容太短！"];
        return;
    }
    
    [__requester setCallback:^(NSDictionary *dic) {
        [self loadComments];
    }];
    [__requester sendPhotoComment:self.photo.imageId voice:voice length:floor(voice.length/2048)];
    
    [SVProgressHUD showWithStatus:@"发送评论..."];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil] lastObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    Comment *cmm = [_data objectAtIndex:indexPath.row];
    
    
    [cell.headerView setImageWithURL:[NSURL URLWithString:IMAGE(cmm.people.peopleHeaderURL)]];
    [cell.headerView.layer setCornerRadius:4];
    [cell.headerView.layer setMasksToBounds:YES];
    
    [cell.commentView setText:[NSString stringWithFormat:@"%@: %@", cmm.people.peopleNickName, cmm.voiceId ? @"" : cmm.content]];
    UIFont *font = [UIFont systemFontOfSize:16.0];
    CGSize size = [cell.commentView.text sizeWithFont:font
                                    constrainedToSize:CGSizeMake(177.0f, 1000.0f)
                                        lineBreakMode:UILineBreakModeWordWrap];
    [cell.commentView setFrame:CGRectMake(40, 5, 220, size.height + 5)];
    
    [cell.recorderButton setHidden:!cmm.voiceId];
    [cell.recorderButton setTag:indexPath.row];
    [cell.recorderButton setBackgroundImage:resizableImage(@"feeds_audio_play_btn.png", 5, 30, 5, 30) forState:UIControlStateNormal];;
    [cell.recorderButton setBackgroundImage:resizableImage(@"feeds_audio_pause_btn.png", 5, 30, 5, 30) forState:UIControlStateHighlighted];;
    [cell.recorderButton setBackgroundImage:resizableImage(@"feeds_audio_pause_btn.png", 5, 30, 5, 30) forState:UIControlStateSelected];;
    [cell.recorderButton addTarget:self action:@selector(playSound:) forControlEvents:UIControlEventTouchUpInside];
    [cell.recorderButton setFrame:CGRectMake(cell.commentView.frame.origin.x + size.width, cell.recorderButton.frame.origin.y,
                                             cell.recorderButton.frame.size.width + cmm.length * 2, cell.recorderButton.frame.size.height)];
    
    if (cmm.length > 0) {
        [cell.lengthLabel setText:[NSString stringWithFormat:@"%d", cmm.length]];
        [cell.lengthLabel setFrame:CGRectMake(cell.recorderButton.frame.origin.x + 20, cell.recorderButton.frame.origin.y + 10, 30, 15)];
    }
    
    [cell.dateLabel setText:cmm.date];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Comment *cmm = [_data objectAtIndex:indexPath.row];
     
	UIFont *font = [UIFont systemFontOfSize:16];
    CGSize size = [cmm.content sizeWithFont:font
                              constrainedToSize:CGSizeMake(160.0f, 1000.0f)
                                  lineBreakMode:UILineBreakModeWordWrap];
    
    return 44.0 + ( size.height > 44 ? size.height - 60 : 0 );
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if ( [self needLoadMore] == YES ) {
        [__requester setCallback:^(NSDictionary *dic) {
            [_data addObjectsFromArray:[__parser commentsWithData:dic]];
            [_tableView reloadData];
            [SVProgressHUD dismiss];
        }];
        [__requester commentsOfPhoto:self.photo.imageId fromPosition:[_data count] withLength:20];
        
        [SVProgressHUD showWithStatus:@"Loading..."];
    }
}

- (BOOL)needLoadMore {
    BOOL isBottom = (_tableView.contentOffset.y + _tableView.frame.size.height) == _tableView.contentSize.height ? YES : NO;
    BOOL isLast = [_data count] < _total ? NO : YES ;
    return (isBottom & !isLast);
}

- (void)dealloc {
    [_photo release];
    [_data release];
    [super dealloc];
}

@end

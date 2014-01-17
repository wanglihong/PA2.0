//
//  ShareViewController.m
//  NetworkApplication
//
//  Created by Dennis Yang on 12-12-20.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "ShareViewController.h"

#define _share_content [NSString stringWithFormat:@"#Let’s PA！#我在%@活动分享了图片，快来看看吧！[%@]", self.party.partyName, [Tools dateStringWithDate:[NSDate date]]]

@interface ShareViewController ()

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 向微博注册
    weiBoEngine = [[WBEngine alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
    [weiBoEngine setRootViewController:self];
    [weiBoEngine setDelegate:self];
    [weiBoEngine setRedirectURI:kWBRedirectURI];
    [weiBoEngine setIsUserExclusive:NO];
    
    // 向微信注册
    [WXApi registerApp:kWeixinAppId];
}

- (void)share {
    UIActionSheet *sheet = [[[UIActionSheet alloc] initWithTitle:nil
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"分享至微信", @"分享至新浪微博", @"邮件分享", @"短信分享", nil]
                            autorelease];
    [sheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self sendWeixin];
            break;
            
        case 1:
            [self sendWeibo];
            break;
            
        case 2:
            [self sendEMail];
            break;
            
        case 3:
            [self sendMessage];
            break;
            
        default:
            break;
    }
}

/*
 *--------------------------------------------------------------------------------------
 *
 * start: 发送微信 的相关函数
 *
 *--------------------------------------------------------------------------------------
 */

- (void)sendWeixin
{/*
  SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
  req.bText = YES;
  req.text = @"#Let’s PA！#我在xxx活动分享了图片，快来看看吧！";
  req.scene = WXSceneSession;
  
  [WXApi sendReq:req];
  */
    
    if ([WXApi isWXAppInstalled] == NO) {
        [Tools alertWithTitle:@"请先安装微信"];
        return;
    } else if ([WXApi isWXAppSupportApi] == NO) {
        [Tools alertWithTitle:@"微信当前版本不支持开放接口"];
        return;
    } else if (_share_image == nil) {
        [Tools alertWithTitle:@"请选择您要分享的图片"];
        return;
    }
    
    CGSize newSize = CGSizeMake(60, 60);
    UIGraphicsBeginImageContext(newSize);
    [_share_image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:newImage];
    
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = UIImageJPEGRepresentation(_share_image, 1.0) ;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];
}

// 向微信发送请求后，收到来自微信的响应是调用此方法
- (void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"发送结果"];
        NSString *strMsg = [NSString stringWithFormat:@"发送媒体消息结果:%d", resp.errCode];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}

/*
 *--------------------------------------------------------------------------------------
 *
 * end__: 发送微信 的相关函数
 *
 *--------------------------------------------------------------------------------------
 */

/*
 *--------------------------------------------------------------------------------------
 *
 * start: 发送微博 的相关函数
 *
 *--------------------------------------------------------------------------------------
 */

- (void)sendWeibo
{
    if (![weiBoEngine isLoggedIn] && [weiBoEngine isAuthorizeExpired]) {
        [weiBoEngine logIn];
    } else {
        [weiBoEngine sendWeiBoWithText:_share_content image:_share_image];
        [SVProgressHUD showWithStatus:@"Loading..."];
    }
}

- (void)engine:(WBEngine *)engine requestDidFailWithError:(NSError *)error
{
    NSLog(@"%@ %d", error.localizedDescription, error.code);
    NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
    
    if(detailedErrors != nil && [detailedErrors count] > 0) {
        for(NSError* detailedError in detailedErrors) {
            NSLog(@" DetailedError: %@", [detailedError userInfo]);
        }
        
    }else {
        NSLog(@"%@",[error userInfo]);
    }
    
    [SVProgressHUD dismiss];
    [Tools alertWithTitle:[[error userInfo] objectForKey:@"error"]];
}

- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result
{
    NSLog(@"%@", result);
    [SVProgressHUD showSuccessWithStatus:@"分享成功"];
}

/*
 *--------------------------------------------------------------------------------------
 *
 * end__: 发送微博 的相关函数
 *
 *--------------------------------------------------------------------------------------
 */

/*
 *--------------------------------------------------------------------------------------
 *
 * start: 发送邮件 的相关函数
 *
 *--------------------------------------------------------------------------------------
 */

- (void)sendEMail
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    
    if (mailClass != nil) {
        if ([mailClass canSendMail]) [self displayComposerSheet];
        else [self launchMailAppOnDevice];
    } else
        [self launchMailAppOnDevice];
}

//可以发送邮件的话
-(void)displayComposerSheet
{
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    
    mailPicker.mailComposeDelegate = self;
    /*
     //设置主题
     [mailPicker setSubject: @""];
     
     // 添加发送者
     NSArray *toRecipients = [NSArray arrayWithObject: @"first@example.com"];
     NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
     //NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com", nil];
     [mailPicker setToRecipients: toRecipients];
     [mailPicker setCcRecipients:ccRecipients];
     //[picker setBccRecipients:bccRecipients];
     */
    
    // 添加图片
    //UIImage *addPic = [UIImage imageNamed: @"3.jpg"];
    //NSData *imageData = UIImagePNGRepresentation(addPic);            // png
    NSData *imageData = UIImageJPEGRepresentation(_share_image, 1.0);    // jpeg
    [mailPicker addAttachmentData:imageData mimeType:@"" fileName:@"3.jpg"];
    
    NSString *emailBody = _share_content;
    [mailPicker setMessageBody:emailBody isHTML:YES];
    
    [self presentModalViewController: mailPicker animated:YES];
    [mailPicker release];
}

- (void)launchMailAppOnDevice
{
    NSString *recipients = @"mailto:first@example.com&subject=my email!";
    NSString *body = @"&body=email body!";
    
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
    email = [email stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:email]];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSString *msg;
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            msg = @"邮件发送取消";
            break;
        case MFMailComposeResultSaved:
            [SVProgressHUD showSuccessWithStatus:@"邮件保存成功"];
            break;
        case MFMailComposeResultSent:
            [SVProgressHUD showSuccessWithStatus:@"邮件发送成功"];
            break;
        case MFMailComposeResultFailed:
            [SVProgressHUD showErrorWithStatus:@"邮件发送失败"];
            break;
        default:
            break;
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

/*
 *--------------------------------------------------------------------------------------
 *
 * end__: 发送邮件 的相关函数
 *
 *--------------------------------------------------------------------------------------
 */

/*
 *--------------------------------------------------------------------------------------
 *
 * start: 发送短信 的相关函数
 *
 *--------------------------------------------------------------------------------------
 */

- (void)sendMessage
{
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    
    if (messageClass != nil) {
        
        if ([messageClass canSendText]) {
            [self displaySMSComposerSheet];
        }
        else {
            [Tools alertWithTitle:@"设备没有短信功能"];
        }
    }
    else {
        [Tools alertWithTitle:@"iOS版本过低,iOS4.0以上才支持程序内发送短信"];
    }
}

- (void)displaySMSComposerSheet
{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    
    picker.body = _share_content;
    
    [self presentModalViewController:picker animated:YES];
    [picker release];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    
    switch (result)
    {
        case MessageComposeResultCancelled:
            NSLog(@"Result: SMS sending canceled");
            break;
        case MessageComposeResultSent:
            NSLog(@"Result: SMS sent");
            break;
        case MessageComposeResultFailed:
            [Tools alertWithTitle:@"短信发送失败"];
            break;
        default:
            NSLog(@"Result: SMS not sent");
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
    
}

/*
 *--------------------------------------------------------------------------------------
 *
 * end__:  发送短信 的相关函数
 *
 *--------------------------------------------------------------------------------------
 */

- (void)dealloc {
    [weiBoEngine setDelegate:nil];
    [weiBoEngine release], weiBoEngine = nil;
    
    [super dealloc];
}

@end

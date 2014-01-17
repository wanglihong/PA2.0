//
//  UpdatePeopleInformationViewController.m
//  NetworkApplication
//
//  Created by Dennis Yang on 12-12-17.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "UpdatePeopleInformationViewController.h"

@interface UpdatePeopleInformationViewController () {
    NSString *_gender;
}

@property (nonatomic, retain) NSString *gender;
@property (nonatomic, retain) NSString *nickName;
@property (nonatomic, retain) NSString *realName;
@property (nonatomic, retain) NSString *department;
@property (nonatomic, retain) NSString *qqNumber;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *information;

@end

@implementation UpdatePeopleInformationViewController

@synthesize gender, nickName, realName, department, qqNumber, email, information;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"完善资料";
    _gender = [[LocalData data] currentPeople].peopleGender;
    
    UIBarButtonItem *rithtBarItem = [[UIBarButtonItem alloc] initWithTitle:@"提交"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(updatePeopleInformation)];
    self.navigationItem.rightBarButtonItem = rithtBarItem;
    
    self.gender = [[LocalData data] currentPeople].peopleGender;
    self.nickName = [[LocalData data] currentPeople].peopleNickName;
    self.realName = [[LocalData data] currentPeople].peopleRealName;
    self.department = [[LocalData data] currentPeople].peopleDepartment;
    self.qqNumber = [[LocalData data] currentPeople].peopleQQ;
    self.email = [[LocalData data] currentPeople].peopleEmail;
    self.information = [[LocalData data] currentPeople].peopleInformation;
}

- (void)dealloc {
    [gender release];
    [nickName release];
    [realName release];
    [department release];
    [qqNumber release];
    [email release];
    [information release];
    [super dealloc];
}

- (void)textChanged:(NSNotification *)notification {
    UITextField *textField = [notification object];
    NSIndexPath *indexPath = [_tableView indexPathForCell:(UITableViewCell *)[textField superview]];
    
    switch (indexPath.row) {
        case 0:
            self.nickName = textField.text;
            break;
        case 1:
            self.realName = textField.text;
            break;
        case 2:
            self.department = textField.text;
            break;
        case 3:
            self.qqNumber = textField.text;
            break;
        case 4:
            self.email = textField.text;
            break;
            
        default:
            break;
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    self.information = textView.text;
}

- (void)updatePeopleInformation {
    /*
    UITextField *nickNameField = [self fieldForRow:0 inSection:1];
    UITextField *realNameField = [self fieldForRow:1 inSection:1];
    UITextField *departmentField = [self fieldForRow:2 inSection:1];
    UITextField *qqNumberField = [self fieldForRow:3 inSection:1];
    UITextField *emailField = [self fieldForRow:4 inSection:1];
    UITextView  *informationField = [self textViewForRow:0 inSection:2];
    */
    if ([nickName isEqual:@""] || nickName.length == 0)
        [Tools alertWithTitle:@"请输入您的昵称"];
    
    else if ([realName isEqual:@""] || realName.length == 0)
        [Tools alertWithTitle:@"请输入您的真实姓名"];
    
    else if ([department isEqual:@""] || department.length == 0)
        [Tools alertWithTitle:@"请输入您所在部门"];
    
    else if ([qqNumber isEqual:@""] || qqNumber.length == 0)
        [Tools alertWithTitle:@"请输入您的QQ号"];
    
    else if ([email isEqual:@""] || email.length == 0)
        [Tools alertWithTitle:@"请输入您的电子邮箱"];
    
    else {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                _gender,     @"gender",
                                nickName,    @"name",
                                realName,    @"truename",
                                department,  @"dept",
                                qqNumber,    @"qq",
                                email,       @"email",
                                information, @"description", nil];
        
        [__requester setCallback:^(NSDictionary *dic) {
            [[LocalData data] setCurrentPeople:[__parser peopleWithData:dic]];
            [[LocalData data] setUSER_INFORMATION_CHANGED:YES];
            [SVProgressHUD showSuccessWithStatus:@"资料已更新"];
        }];
        [__requester updatePeopleInformation:params];
        
        [SVProgressHUD showWithStatus:@"正在提交个人信息..."];
    }
}

- (void)updatePeopleHeaderIcon:(UIImage *)icon {
    
    [__requester setCallback:^(NSDictionary *dic) {
        [[LocalData data] currentPeople].peopleHeaderURL = [[dic objectForKey:@"data"] objectForKey:@"_id"];
        [[LocalData data] setUSER_INFORMATION_CHANGED:YES];
        [_tableView reloadData];
        [SVProgressHUD showSuccessWithStatus:@"头像已更新"];
    }];
    [__requester updatePeopleHeaderIcon:icon];
    
    [SVProgressHUD showWithStatus:@"更新头像..."];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger num;
    
    switch (section) {
        case 0:
            num = 1;
            break;
        case 1:
            num = 5;
            break;
        case 2:
            num = 1;
            break;
            
        default:
            num = 0;
            break;
    }
    
    return num;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    switch (indexPath.section) {
            
        case 0:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell_0"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell_0"];
            }
            
            GridViewItem *item = (GridViewItem *)[cell viewWithTag:1000];
            if (!item) {
                item = [[GridViewItem alloc] initWithFrame:CGRectMake(15, 5, 45, 45)];
                item.imageView.layer.cornerRadius = 4;
                item.tag = 1000;
                item.delegate = self;
                [cell addSubview:item];
                [item release];
            }
            [item.imageView setImageWithURL:[NSURL URLWithString:IMAGE([LocalData data].currentPeople.peopleHeaderURL)]];
            
            UIButton *genderBtn = (UIButton *)[cell viewWithTag:1001];
            if (!genderBtn) {
                genderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                genderBtn.frame = CGRectMake(80, 5, 44, 44);
                genderBtn.tag = 1001;
                [genderBtn setImage:[UIImage imageNamed:@"female.png"] forState:UIControlStateNormal];
                [genderBtn setImage:[UIImage imageNamed:@"male.png"] forState:UIControlStateSelected];
                [cell addSubview:genderBtn];
            }
            genderBtn.selected = [_gender isEqual:@"m"];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
            
        case 1:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell_1"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell_1"];
            }
            
            UILabel *label = (UILabel *)[cell viewWithTag:1020];
            if (!label) {
                label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 70, 55)];
                label.backgroundColor = [UIColor clearColor];
                label.textAlignment = UITextAlignmentRight;
                label.font = [UIFont boldSystemFontOfSize:16.0];
                label.tag = 1020;
                [cell addSubview:label];
                [label release];
            }
            label.text = [[Constants peopleInformationNames] objectAtIndex:indexPath.row];
            
            UITextField *input = (UITextField *)[cell viewWithTag:1021];
            if (!input) {
                input = [[UITextField alloc] initWithFrame:CGRectMake(90, 0, 230, 55)];
                input.borderStyle = UITextBorderStyleNone;
                input.returnKeyType = UIReturnKeyDefault;
                input.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                input.font = [UIFont systemFontOfSize:16.0];
                input.tag = 1021;
                input.delegate = self;
                [input addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventValueChanged];
                [cell addSubview:input];
                [input release];
            }
            input.placeholder = [[Constants peopleInformationPlaceholders] objectAtIndex:indexPath.row];
            
            switch (indexPath.row) {
                case 0:
                    input.text = [[LocalData data] currentPeople].peopleNickName;
                    break;
                case 1:
                    input.text = [[LocalData data] currentPeople].peopleRealName;
                    break;
                case 2:
                    input.text = [[LocalData data] currentPeople].peopleDepartment;
                    break;
                case 3:
                    input.text = [[LocalData data] currentPeople].peopleQQ;
                    break;
                case 4:
                    input.text = [[LocalData data] currentPeople].peopleEmail;
                    break;
                default:
                    break;
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
            break;
            
        case 2:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell_3"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell_3"];
            }
            
            UILabel *label = (UILabel *)[cell viewWithTag:1030];
            if (!label) {
                label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 70, 55)];
                label.backgroundColor = [UIColor clearColor];
                label.textAlignment = UITextAlignmentRight;
                label.font = [UIFont boldSystemFontOfSize:16.0];
                label.tag = 1030;
                [cell addSubview:label];
                [label release];
            }
            label.text = @"个人简介:";
            
            UITextView *text = (UITextView *)[cell viewWithTag:1031];
            if (!text) {
                text = [[UITextView alloc] initWithFrame:CGRectMake(82, 10, 230, 90)];
                text.backgroundColor = [UIColor clearColor];
                text.font = [UIFont systemFontOfSize:16.0];
                text.scrollEnabled = NO;
                text.delegate = self;
                text.tag = 1031;
                [cell addSubview:text];
                [text release];
            }
            text.text = [[LocalData data] currentPeople].peopleInformation;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
            break;
            
        default:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            }
        }
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    float cellHeight;
    
    switch (indexPath.section) {
        case 0:
        case 1:
            cellHeight = 55;
            break;
        case 2:
            cellHeight = 120;
            break;
            
        default:
            cellHeight = 55;
            break;
    }
    
    return cellHeight;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        UIButton *genderBtn = (UIButton *)[[tableView cellForRowAtIndexPath:indexPath] viewWithTag:1001];
        genderBtn.selected = !genderBtn.selected;
        _gender = genderBtn.selected ? @"m" : @"f" ;
    }
}

#pragma mark - GridViewItemDelegate

- (void)gridViewItem:(GridViewItem *)gridViewItem didSelectedItemAtIndex:(NSInteger)index {
    UIActionSheet *sheet = [[[UIActionSheet alloc] initWithTitle:@"添加照片"
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"拍照", @"从相册选择", nil]
                            autorelease];
    [sheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if        (buttonIndex == 2) {
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    
	if        (buttonIndex == 0) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
	} else if (buttonIndex == 1) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentModalViewController:imagePicker animated:YES];
    [imagePicker release];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissModalViewControllerAnimated:YES];
    
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    [NSThread detachNewThreadSelector:@selector(useImage:) toTarget:self withObject:image];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)useImage:(UIImage *)image {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    CGSize newSize = CGSizeMake(320, 320);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //[_header setImage:newImage];
    [self performSelectorOnMainThread:@selector(updatePeopleHeaderIcon:) withObject:newImage waitUntilDone:NO];
    
    [pool release];
}

@end

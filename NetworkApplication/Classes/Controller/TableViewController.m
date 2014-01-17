//
//  TableViewController.m
//  NetworkApplication
//
//  Created by Dennis Yang on 12-12-18.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [super dealloc];
}

- (void)textChanged:(NSNotification *)notification
{
    
}

#pragma mark - UITextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Private methods

- (UITextField *)fieldForRow:(NSInteger)row inSection:(NSInteger)section {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    UITableViewCell *cell  = [_tableView cellForRowAtIndexPath:indexPath];
    UITextField *textField = (UITextField *)[cell viewWithTag:1021];
    
    return textField;
}

- (UITextView *)textViewForRow:(NSInteger)row inSection:(NSInteger)section {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    UITableViewCell *cell  = [_tableView cellForRowAtIndexPath:indexPath];
    UITextView *textView = (UITextView *)[cell viewWithTag:1031];
    
    return textView;
}

@end

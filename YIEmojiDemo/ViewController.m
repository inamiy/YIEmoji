//
//  ViewController.m
//  YIEmojiDemo
//
//  Created by Yasuhiro Inami on 12/04/03.
//  Copyright (c) 2012年 Yasuhiro Inami. All rights reserved.
//

#import "ViewController.h"
#import "NSString+YIEmoji.h"


@interface ViewController ()

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)handleInputButton:(id)sender 
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Input String" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert textFieldAtIndex:0].clearButtonMode = UITextFieldViewModeWhileEditing;
    [alert show];
}

#pragma mark -

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITextField* textField = [alertView textFieldAtIndex:0];
    
    NSLog(@"input = %@",textField.text);
    NSLog(@"hasEmoji = %d",[textField.text hasEmoji]);
    NSLog(@"trueLength = %d",[textField.text emojiContainedLength]);
    NSLog(@"emojiTrimmedString = %@",[textField.text stringByTrimmingEmojis]);
}

@end

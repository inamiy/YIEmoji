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

@synthesize textView = _textView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSString* text = @"😄😊😃☺1⃣test2⃣☀☔☁⛄";        // iOS5
    text = [text stringByAppendingString:@"🐝"];    // iOS6
    
    self.textView.text = text;
    
    [self handleOKButton:nil];
}

- (void)viewDidUnload
{
    [self setTextView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.textView becomeFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -

#pragma mark IBActions

- (IBAction)handleOKButton:(id)sender 
{
    NSString* text = self.textView.text;
    
    NSLog(@"text = %@",text);
    NSLog(@"hasEmoji = %d",[text hasEmoji]);
    NSLog(@"trueLength = %d",[text emojiContainedTrueLength]);
    NSLog(@"emojiTrimmedString = %@",[text stringByTrimmingEmojis]);
}

@end

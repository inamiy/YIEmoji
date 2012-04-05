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
}

- (void)viewDidUnload
{
    [self setTextView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)handleOKButton:(id)sender 
{
    NSString* text = self.textView.text;
    
    NSLog(@"input = %@",text);
    NSLog(@"hasEmoji = %d",[text hasEmoji]);
    NSLog(@"trueLength = %d",[text emojiContainedTrueLength]);
    NSLog(@"emojiTrimmedString = %@",[text stringByTrimmingEmojis]);
}

@end

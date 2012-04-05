//
//  ViewController.h
//  YIEmojiDemo
//
//  Created by Yasuhiro Inami on 12/04/03.
//  Copyright (c) 2012年 Yasuhiro Inami. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextView *textView;

- (IBAction)handleOKButton:(id)sender;

@end

//
//  NSString+YIEmoji.h
//  YIEmoji
//
//  Created by Yasuhiro Inami on 12/04/03.
//  Copyright (c) 2012年 Yasuhiro Inami. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (YIEmoji)

- (BOOL)hasEmoji;
- (NSArray *)componentsSeparatedByEmojis;

- (NSUInteger)emojiContainedTrueLength;
- (NSString*)stringByTrimmingEmojis;

@end

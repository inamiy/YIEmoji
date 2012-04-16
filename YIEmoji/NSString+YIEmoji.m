//
//  NSString+YIEmoji.m
//  YIEmoji
//
//  Created by Yasuhiro Inami on 12/04/03.
//  Copyright (c) 2012年 Yasuhiro Inami. All rights reserved.
//

#import "NSString+YIEmoji.h"
#import "AFJSONUtilities.h"

static NSArray* __emojis = nil;
//static NSCharacterSet* __emojiCharacterSet = nil;
static NSCharacterSet* __iOS4EmojiCharacterSet = nil;

#define YI_IOS5_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"5.0"] != NSOrderedAscending)


@implementation NSString (YIEmoji)

+ (void)load
{
//    // NOTE: this won't work when JSONKit is included in certain static library
//    @autoreleasepool {
//        [self setupYIEmoji];
//    }
}

+ (void)setupYIEmoji
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        //
        // iOS5 Unicode6.0 Emoji
        // http://punchdrunker.github.com/iOSEmoji/table_html/index.html
        //
        NSURL* dataURL = [[NSBundle mainBundle] URLForResource:@"emoji" withExtension:@"json" subdirectory:@"YIEmoji.bundle"];
        
        NSData* data = [NSData dataWithContentsOfURL:dataURL];
        
        NSArray* json = nil;
        NSError* error = nil;
        
        if (YI_IOS5_OR_LATER) {
            json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        }
        else {
            json = AFJSONDecode(data, &error);
        }
        
        if (error) {
            NSLog(@"YIEmoji error: %@",error.localizedDescription);
            return;
        }
        
        NSMutableArray* emojis = [NSMutableArray array];
        NSMutableCharacterSet* emojiCharacterSet = [[NSMutableCharacterSet alloc] init];
        
        for (NSString* utf16 in json) {
            NSArray* bytes = [utf16 componentsSeparatedByString:@" "];
            
            NSMutableString* emoji = [NSMutableString string];
            for (NSInteger i = 0; i < [bytes count]; i++) {
                [emoji appendFormat:@"%C",[[bytes objectAtIndex:i] _hexIntValue]];
            }
            
            [emojis addObject:emoji];
            [emojiCharacterSet addCharactersInString:emoji];
        }
        
        __emojis = emojis;
        //__emojiCharacterSet = emojiCharacterSet;
        
        
        //
        // iOS4 Emoji
        // http://d.hatena.ne.jp/kurusaki/20100425/1272187639
        //
        if (!YI_IOS5_OR_LATER) {
            
            NSMutableString* iOS4EmojiString = [NSMutableString string];
            for (unichar u = 0xE001; u <= 0xE05A; u++) {
                [iOS4EmojiString appendFormat:@"%C",u];
            }
            for (unichar u = 0xE101; u <= 0xE15A; u++) {
                [iOS4EmojiString appendFormat:@"%C",u];
            }
            for (unichar u = 0xE201; u <= 0xE253; u++) {
                [iOS4EmojiString appendFormat:@"%C",u];
            }
            for (unichar u = 0xE301; u <= 0xE34D; u++) {
                [iOS4EmojiString appendFormat:@"%C",u];
            }
            for (unichar u = 0xE401; u <= 0xE44C; u++) {
                [iOS4EmojiString appendFormat:@"%C",u];
            }
            for (unichar u = 0xE501; u <= 0xE537; u++) {
                [iOS4EmojiString appendFormat:@"%C",u];
            }
            
            NSMutableCharacterSet* iOS4EmojiCharacterSet = [[NSMutableCharacterSet alloc] init];
            [iOS4EmojiCharacterSet addCharactersInString:iOS4EmojiString];
            
            __iOS4EmojiCharacterSet = iOS4EmojiCharacterSet;
        }
    });
}

- (BOOL)hasEmoji
{
    // NOTE: using characterSet is unreliable
//    [NSString setupYIEmoji];
//    
//    if (YI_IOS5_OR_LATER) {
//        return ([self rangeOfCharacterFromSet:__emojiCharacterSet].location != NSNotFound);
//    }
//    else {
//        return ([self rangeOfCharacterFromSet:__emojiCharacterSet].location != NSNotFound ||
//                [self rangeOfCharacterFromSet:__iOS4EmojiCharacterSet].location != NSNotFound);
//    }
    
    if ([[self componentsSeparatedByEmojis] count] > 1) {
        return YES;
    }
    else {
        return NO;
    }
}

- (NSArray *)componentsSeparatedByEmojis
{
    [NSString setupYIEmoji];
    
    NSMutableString* mutableString = [self mutableCopy];
    
    NSString* emoji0 = nil;
    if (YI_IOS5_OR_LATER) {
        emoji0 = [__emojis objectAtIndex:0];
    }
    else {
        emoji0 = [NSString stringWithFormat:@"%C",0xE001];
    }
    
    for (NSString* emoji in __emojis) {
        [mutableString replaceOccurrencesOfString:emoji withString:emoji0 options:NSRegularExpressionSearch range:NSMakeRange(0, [mutableString length])];
    }
    
    if (YI_IOS5_OR_LATER) {
        return [mutableString componentsSeparatedByString:emoji0];
    }
    else {
        return [mutableString componentsSeparatedByCharactersInSet:__iOS4EmojiCharacterSet];
    }
}

- (NSUInteger)emojiContainedTrueLength
{
//    // doesn't work
//    NSArray* components = [self componentsSeparatedByCharactersInSet:__emojiCharacterSet];
    
    NSArray* components = [self componentsSeparatedByEmojis];
    NSUInteger length = 0;
    for (NSString* component in components) {
        length += [component length];
    }
    return length+[components count]-1;
}

- (NSString*)stringByTrimmingEmojis
{
//    // doesn't work
//    return [self stringByTrimmingCharactersInSet:__emojiCharacterSet];
    
    return [[self componentsSeparatedByEmojis] componentsJoinedByString:@""];
}

#pragma mark -

#pragma mark Private

// http://www.cocoabuilder.com/archive/cocoa/232974-hexvalue-for-nsstring.html
- (unsigned int)_hexIntValue
{
    NSScanner* scanner;
    unsigned int result;

    scanner = [NSScanner scannerWithString:self];
    
    [scanner scanHexInt:&result];
    
    return result;
}

@end

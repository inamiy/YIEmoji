//
//  NSString+YIEmoji.m
//  YIEmojiDemo
//
//  Created by Yasuhiro Inami on 12/04/03.
//  Copyright (c) 2012年 Yasuhiro Inami. All rights reserved.
//

#import "NSString+YIEmoji.h"

static NSArray* __emojis = nil;
static NSCharacterSet* __emojiCharacterSet = nil;


@implementation NSString (YIEmoji)

+ (void)load
{
    @autoreleasepool {
        
        NSError* error = nil;
        
        // http://punchdrunker.github.com/iOSEmoji/table_html/index.html
        NSURL* dataURL = [[NSBundle mainBundle] URLForResource:@"emoji" withExtension:@"json" subdirectory:@"YIEmoji.bundle"];
        
        NSData* data = [NSData dataWithContentsOfURL:dataURL];
        NSArray* json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        
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
        __emojiCharacterSet = emojiCharacterSet;
        
    }
}

- (BOOL)hasEmoji
{
    return ([self rangeOfCharacterFromSet:__emojiCharacterSet].location != NSNotFound);
}

- (NSUInteger)emojiContainedLength
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

- (NSArray *)componentsSeparatedByEmojis
{
    NSMutableString* mutableString = [self mutableCopy];
    NSString* emoji0 = [__emojis objectAtIndex:0];
    
    for (NSString* emoji in __emojis) {
        [mutableString replaceOccurrencesOfString:emoji withString:emoji0 options:NSRegularExpressionSearch range:NSMakeRange(0, [mutableString length])];
    }
    
    return [mutableString componentsSeparatedByString:emoji0];
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

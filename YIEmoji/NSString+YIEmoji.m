//
//  NSString+YIEmoji.m
//  YIEmoji
//
//  Created by Yasuhiro Inami on 12/04/03.
//  Copyright (c) 2012年 Yasuhiro Inami. All rights reserved.
//

#import "NSString+YIEmoji.h"

#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_5_0
#import "AFJSONUtilities.h"
#endif

static NSArray* __emojis = nil;
//static NSCharacterSet* __emojiCharacterSet = nil;


@implementation NSString (YIEmoji)

+ (void)load
{
    @autoreleasepool {
        [self setupYIEmoji];
    }
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
        
        NSError* error = nil;
        NSArray* json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        
        if (error) {
            NSLog(@"YIEmoji error: %@",error.localizedDescription);
            return;
        }
        
        NSMutableArray* emojis = [NSMutableArray array];
        //NSMutableCharacterSet* emojiCharacterSet = [[NSMutableCharacterSet alloc] init];
        
        for (NSString* utf16 in json) {
            NSArray* bytes = [utf16 componentsSeparatedByString:@" "];
            
            NSMutableString* emoji = [NSMutableString string];
            for (NSInteger i = 0; i < [bytes count]; i++) {
                [emoji appendFormat:@"%C",(unsigned short)[[bytes objectAtIndex:i] _hexIntValue]];
            }
            
            [emojis addObject:emoji];
            //[emojiCharacterSet addCharactersInString:emoji];
        }
        
        // NOTE: using characterSet (componentsSeparatedByCharactersInSet) is unreliable
        //__emojiCharacterSet = emojiCharacterSet;
        __emojis = emojis;
        
    });
}

- (BOOL)hasEmoji
{
//    return ([self rangeOfCharacterFromSet:__emojiCharacterSet].location != NSNotFound);
    
    if ([[self componentsSeparatedByEmojis] count] > 1) {
        return YES;
    }
    else {
        return NO;
    }
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

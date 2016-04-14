//
//  ContactManager.m
//  contactsDemo
//
//  Created by frankhou on 15/8/25.
//  Copyright (c) 2015年 qinggong. All rights reserved.
//

#import "ContactManager.h"
#import "Contact.h"

@interface ContactManager ()

@property (nonatomic, strong) NSArray *myContacts;
@property (nonatomic, strong) NSMutableDictionary *contactsDic;

@end

@implementation ContactManager

+ (NSString *)phonetic:(NSString*)sourceString
{
    NSMutableString *source = [sourceString mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformStripDiacritics, NO);
    return source;
}

- (instancetype)initWithArray:(NSArray *)contacts
{
    if (self = [super init]) {
        _myContacts = contacts;
    }
    return self;
}

- (NSDictionary *)contactsWithGroup
{
    for(id item in _myContacts)
    {
        Contact *people = [Contact contactWithItem:item];
        
        NSString *nameInEnglish = [ContactManager phonetic:people.name];
        //如果为空跳出
        if ([nameInEnglish isEqualToString:@""]) {
            continue;
        }
        nameInEnglish = [nameInEnglish capitalizedString];
        unichar k = [nameInEnglish characterAtIndex:0];
        if (!(k >= 'A' && k <= 'Z')) {
            k = '#';
        }
        NSString *key = [NSString stringWithFormat:@"%c",k];
        
        NSMutableArray *arrayGroupK = [self.contactsDic objectForKey:key];
        if (!arrayGroupK) {
            arrayGroupK = [[NSMutableArray alloc]initWithCapacity:5];
            [arrayGroupK addObject:people];
            if (nil == self.contactsDic) {
                self.contactsDic = [[NSMutableDictionary alloc]initWithCapacity:5];
            }
            [self.contactsDic setObject:arrayGroupK forKey:key];
        }else{
            [arrayGroupK addObject:people];
        }
    }
    
    return self.contactsDic;
}

@end

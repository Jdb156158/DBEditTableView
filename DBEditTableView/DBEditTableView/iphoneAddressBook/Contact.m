//
//  Contact.m
//  CommandLineDemo
//
//  Created by frankhou on 7/9/15.
//  Copyright (c) 2015 qinggong. All rights reserved.
//

#import "Contact.h"
#import <AddressBook/AddressBook.h>

@implementation Contact

+ (instancetype)contactWithItem:(id)item
{
    return [[Contact alloc] initWithItem:item];
}

- (instancetype)initWithItem:(id)item
{
    if (self = [super init]) {
        NSString* tmpFirstName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(item), kABPersonFirstNameProperty);
        NSString* tmpLastName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(item), kABPersonLastNameProperty);
        ABMultiValueRef tmpPhones = ABRecordCopyValue((__bridge ABRecordRef)(item), kABPersonPhoneProperty);
        
        self.name = [NSString stringWithFormat:@"%@%@", tmpLastName?tmpLastName:@"", tmpFirstName?tmpFirstName:@""];
        self.phone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(tmpPhones, 0);
        CFRelease(tmpPhones);
    }
    return self;
}

@end

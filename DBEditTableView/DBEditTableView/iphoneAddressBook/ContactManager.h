//
//  ContactManager.h
//  contactsDemo
//
//  Created by frankhou on 15/8/25.
//  Copyright (c) 2015年 qinggong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactManager : NSObject

- (instancetype)initWithArray:(NSArray *)contacts;
- (NSDictionary *)contactsWithGroup;

@end

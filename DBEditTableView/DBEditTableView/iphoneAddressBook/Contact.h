//
//  Contact.h
//  CommandLineDemo
//
//  Created by frankhou on 7/9/15.
//  Copyright (c) 2015 qinggong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contact : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phone;

+ (instancetype)contactWithItem:(id)item;
- (instancetype)initWithItem:(id)item;

@end

//
//  SendTheContactViewController.h
//  HuaBao
//
//  Created by Jdb on 16/4/13.
//  Copyright © 2016年 uimbank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import "Contact.h"
#import "ContactManager.h"
#import "MBProgressHUD.h"
@interface SendTheContactViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    UIImageView *navBarHairlineImageView;
}
@property (nonatomic, assign) ABAddressBookRef addressBook;
@property (nonatomic, strong) ContactManager *contactManager;
@property (nonatomic, strong) NSDictionary *contactsDic;
@property (nonatomic, strong) NSMutableArray *keys;

/** 底部删除按钮 */
@property (nonatomic ,strong)UIButton *deleteButton;
/** 标记是否全选 */
@property (nonatomic ,assign)BOOL isAllSelected;
@property (weak, nonatomic) IBOutlet UITableView *addbooksTableview;

@end

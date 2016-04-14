//
//  ViewController.h
//  DBEditTableView
//
//  Created by Jdb on 16/4/14.
//  Copyright © 2016年 uimbank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
}

@property (weak, nonatomic) IBOutlet UITableView *TableVieMifiList;
@property (nonatomic, retain) NSArray *MIFITitle;//我的列表标题
@end


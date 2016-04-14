//
//  SendTheContactViewController.m
//  HuaBao
//
//  Created by Jdb on 16/4/13.
//  Copyright © 2016年 uimbank. All rights reserved.
//

#import "SendTheContactViewController.h"

@interface SendTheContactViewController ()

@end

@implementation SendTheContactViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"备份电话簿";
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    // Do any additional setup after loading the view from its nib.
    
    self.addbooksTableview.delegate = self;
    self.addbooksTableview.dataSource = self;
    self.addbooksTableview.tag = 1;
    [self.addbooksTableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.addbooksTableview.sectionIndexBackgroundColor = [UIColor clearColor];
    [self checkAddressBookAuthorizationStatus];
    
    /*=========================至关重要============================*/
    self.addbooksTableview.allowsMultipleSelectionDuringEditing = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"选择" style:UIBarButtonItemStyleDone target:self action:@selector(edit)];
    /** 下发电话簿 */
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteButton = deleteButton;
    //[self.view addSubview:deleteButton];
    [deleteButton setTitle:@"上传信息至云端" forState:UIControlStateNormal];
    [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deleteButton setBackgroundColor:[UIColor colorWithRed:17/255.0 green:137/255.0 blue:156/255.0 alpha:0.7f]];
    [deleteButton setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 40)];
    deleteButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [deleteButton addTarget:self action:@selector(sendArr) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    navBarHairlineImageView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    navBarHairlineImageView.hidden = NO;
}

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

//检查通讯录
- (void)checkAddressBookAuthorizationStatus{
    //初始化
    self.addressBook = ABAddressBookCreateWithOptions(nil, nil);
    
    if (kABAuthorizationStatusAuthorized == ABAddressBookGetAuthorizationStatus())
    {
        NSLog(@"已经授权");
    }
    
    ABAddressBookRequestAccessWithCompletion(self.addressBook, ^(bool granted, CFErrorRef error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                NSLog(@"Error: %@", error);
            }else if (!granted){
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Authorization Denied"
                                                                message:@"Set permissions in Setting>Genearl>Privacy."
                                                               delegate:nil
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"OK", nil];
                [alert show];
            }else{
                //还原 ABAddressBookRef
                ABAddressBookRevert(self.addressBook);
                
                self.contactManager = [[ContactManager alloc] initWithArray:(__bridge NSArray *)(ABAddressBookCopyArrayOfAllPeople(self.addressBook))];
                self.contactsDic = [self.contactManager contactsWithGroup];
                
                self.keys = [NSMutableArray arrayWithArray:[[self.contactsDic allKeys] sortedArrayUsingSelector:@selector(compare:)]];
                //self.keys = [[self.contactsDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                //跟新当前tableview
                [self.addbooksTableview setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
                [self.addbooksTableview reloadData];
            }
        });
    });
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.keys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = [self.keys objectAtIndex:section];
    NSArray * array = [self.contactsDic objectForKey:key];
    return [array count];
}

//- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return self.keys[section];
//}

- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section{
    UIView *v_headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 45)];
    if (section == 0) {
//        NSString *key = [self.keys objectAtIndex:0];
//        Contact *people = [[self.contactsDic objectForKey:key] objectAtIndex:0];
//        UILabel *v_headerLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 60/2-10, self.view.frame.size.width, 20)];//创建一个UILable（v_headerLab）用来显示标题
//        v_headerLab.text = [NSString stringWithFormat:@"当前主叫：%@-%@",people.name,people.phone];//@"当前主叫：";//@"我的余额 :";
//        v_headerLab.textAlignment = NSTextAlignmentCenter;
//        //v_headerLab.backgroundColor = [UIColor redColor];//设置v_headerLab的背景颜色
//        v_headerLab.textColor = [UIColor whiteColor];//设置v_headerLab的字体颜色
//        v_headerLab.font = [UIFont fontWithName:@"Arial" size:15];//设置v_headerLab的字体样式和大小
//        [v_headerView addSubview:v_headerLab];
//        [v_headerView setBackgroundColor:[UIColor colorWithRed:17/255.0 green:137/255.0 blue:156/255.0 alpha:0.85]];
    }else{
        UILabel *v_headerLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.view.frame.size.width-30, 20)];//创建一个UILable（v_headerLab）用来显示标题
        v_headerLab.text = self.keys[section];//@"我的余额 :";
        //v_headerLab.backgroundColor = [UIColor redColor];//设置v_headerLab的背景颜色
        v_headerLab.textColor = [UIColor blackColor];//设置v_headerLab的字体颜色
        v_headerLab.font = [UIFont fontWithName:@"Arial" size:14];//设置v_headerLab的字体样式和大小
        [v_headerView addSubview:v_headerLab];
        [v_headerView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    }
    return v_headerView;
}

- (NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.keys;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"contactCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    NSString *key = [self.keys objectAtIndex:indexPath.section];
    Contact *people = [[self.contactsDic objectForKey:key] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = people.name;
    /**
     *  单元格的选中类型一定不能设置为 UITableViewCellSelectionStyleNone，如果加上这一句，全选勾选不出来
     */
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;//选中无风格
    
    //清楚UITableView底部多余的分割线
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    return cell;
}

//头部高
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewCellEditingStyleDelete;
    
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIApplication *app = [UIApplication sharedApplication];
    if (buttonIndex == 1) {
        [app openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", alertView.message]]];
    }
}

#pragma mark - 编辑
-(void)edit
{
    /** 每次点击 rightBarButtonItem 都要取消全选 */
    self.isAllSelected = NO;
    
    NSString *string = !self.addbooksTableview.editing?@"取消":@"选择";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:string style:UIBarButtonItemStyleDone target:self action:@selector(edit)];
    
    
    if (self.keys.count) {
        [self.view addSubview:_deleteButton];
        self.navigationItem.leftBarButtonItem = !self.addbooksTableview.editing? [[UIBarButtonItem alloc]initWithTitle:@"全选" style:UIBarButtonItemStyleDone target:self action:@selector(selectAll)]:nil;
        CGFloat height = !self.addbooksTableview.editing?40:0;
        
        [UIView animateWithDuration:0.25 animations:^{
            self.deleteButton.frame = CGRectMake(0, self.view.frame.size.height - height, self.view.frame.size.width, 40);
            
        }];
    }else{
        [_deleteButton removeFromSuperview];
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
        
//        [UIView animateWithDuration:0.25 animations:^{
//            self.deleteButton.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 40);
//            
//        }];
    }
    
    self.addbooksTableview.editing = !self.addbooksTableview.editing;
}

#pragma mark - 上传信息至云端
-(void)sendArr
{
    
    NSMutableArray *deleteArrarys = [NSMutableArray array];
    //读出当前
    for (NSIndexPath *indexPath in self.addbooksTableview.indexPathsForSelectedRows) {
        NSString *key = [self.keys objectAtIndex:indexPath.section];
        Contact *people = [[self.contactsDic objectForKey:key] objectAtIndex:indexPath.row];
        NSLog(@"-名字-%@-电话-%@",people.name,people.phone);
        [deleteArrarys addObject:people.name];
    }
    
    
    [UIView animateWithDuration:0 animations:^{
        [_deleteButton removeFromSuperview];
        self.navigationItem.leftBarButtonItem = nil;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 animations:^{
            
            if (!self.keys.count) {
                self.navigationItem.leftBarButtonItem = nil;
                self.navigationItem.rightBarButtonItem = nil;
                self.deleteButton.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 40);
                
                
            }
            
        } completion:^(BOOL finished) {
            /** 考虑到全选之后 ，反选几个 再删除  需要将全选置为NO, */
            self.isAllSelected = NO;
            
        }];
    }];
    NSString *string = !self.addbooksTableview.editing?@"取消":@"选择";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:string style:UIBarButtonItemStyleDone target:self action:@selector(edit)];
    self.addbooksTableview.editing = !self.addbooksTableview.editing;
    
}


#pragma mark - 全选
-(void)selectAll
{
    
    self.isAllSelected = !self.isAllSelected;
    
    //当前分组
    for (int i = 0; i<self.keys.count; i++) {
        NSString *key = [self.keys objectAtIndex:i];//字母
        NSArray * array = [self.contactsDic objectForKey:key];//当前字母下联系人总是
        //当前分组的行
        for (int j = 0; j<array.count; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            
            if (self.isAllSelected) {
                [self.addbooksTableview selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            }else{//反选
                
                [self.addbooksTableview deselectRowAtIndexPath:indexPath animated:YES];
                
            }
        }
        
    }
}

- (void)dealloc
{
    CFRelease(self.addressBook);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

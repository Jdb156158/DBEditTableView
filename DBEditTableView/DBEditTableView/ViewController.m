//
//  ViewController.m
//  DBEditTableView
//
//  Created by Jdb on 16/4/14.
//  Copyright © 2016年 uimbank. All rights reserved.
//

#import "ViewController.h"
#import "UBHallViewController.h"
#import "SendTheContactViewController.h"
@interface ViewController ()

@end

@implementation ViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:17/255.0 green:137/255.0 blue:156/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc] init];
    returnButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = returnButtonItem;
    
    //添加tableview
    self.MIFITitle =@[@"1编辑进行多选和全选来获取数据",@"2进入我的github看更多开源代码"];
    self.TableVieMifiList.delegate = self;
    self.TableVieMifiList.dataSource = self;
    self.TableVieMifiList.tag = 1;
    [self.TableVieMifiList registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    //告诉TableView有几个分区
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell...
    
    NSUInteger row = [indexPath row];
    static NSString *CellIdentifier = @"Cell";
    //正确写法
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell != nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    UILabel *ShopTitletext =nil;
    ShopTitletext = [[UILabel alloc] initWithFrame:CGRectMake(15,50/2-5, self.view.frame.size.width, 20)];
    ShopTitletext.font = [UIFont systemFontOfSize:15.0f];
    //标题
    ShopTitletext.text = [self.MIFITitle objectAtIndex:row];
    [cell.contentView addSubview:ShopTitletext];
    
    //cell.separatorInset=UIEdgeInsetsZero;
    //cell.layoutMargins=UIEdgeInsetsZero;
    //cell.preservesSuperviewLayoutMargins=NO;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//后边有小箭头
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//选中无风格
    
    return cell;
    
}
//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
//头部高
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 40;
}
//尾部部高
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
//分组标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"用电话簿作为操作的例子";
}
//点击每行的事件处理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;//当前分区
    NSInteger row=indexPath.row;//当前行
    NSLog(@"当前第%li组第%li行",(long)section,(long)row);
    if (row == 0) {
        SendTheContactViewController *SendTheContactView = [[SendTheContactViewController alloc] init];
        [self.navigationController pushViewController:SendTheContactView animated:YES];
    }else if (row == 1){
        UBHallViewController *webhall = [[UBHallViewController alloc] init];
        [webhall setMyWebTitle:@"BingBingJia 的github" andsetMyWebUrlpath:@"https://github.com/Jdb156158"];
        [self.navigationController pushViewController:webhall animated:YES];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

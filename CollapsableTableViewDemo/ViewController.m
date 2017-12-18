//
//  ViewController.m
//  CollapsableTableViewDemo
//
//  Created by hanxiaoming on 2017/12/15.
//  Copyright © 2017年 Amap. All rights reserved.
//

#import "ViewController.h"
#import "MACollapsableTableViewItem.h"

#define kSectionHeaderHeight 44
#define kSectionHeaderMargin 13

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<MACollapsableTableViewItem *> *managedItems;

/// 已展开顺序item数组
@property (nonatomic, strong) NSArray<MACollapsableTableViewItem *> *expandedItems;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTableView];
    [self setupTableData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    
    [self.view addSubview:self.tableView];
}

- (void)setupTableData
{
    self.managedItems = [NSMutableArray array];
    
    MACollapsableTableViewItem *item1 = [[MACollapsableTableViewItem alloc] init];
    MACollapsableTableViewItem *item2 = [[MACollapsableTableViewItem alloc] init];
    MACollapsableTableViewItem *item3 = [[MACollapsableTableViewItem alloc] init];
    item1.itemTitle = @"item1";
    item2.itemTitle = @"item2";
    item3.itemTitle = @"item3";
    
    MACollapsableTableViewItem *item21 = [[MACollapsableTableViewItem alloc] init];
    MACollapsableTableViewItem *item22 = [[MACollapsableTableViewItem alloc] init];
    MACollapsableTableViewItem *item23 = [[MACollapsableTableViewItem alloc] init];
    item21.itemTitle = @"-item21";
    item22.itemTitle = @"-item22";
    item23.itemTitle = @"-item23";
    
    item2.listItems = @[item21, item22, item23];
    item2.expanded = YES;
    
    MACollapsableTableViewItem *item221 = [[MACollapsableTableViewItem alloc] init];
    MACollapsableTableViewItem *item222 = [[MACollapsableTableViewItem alloc] init];
    MACollapsableTableViewItem *item223 = [[MACollapsableTableViewItem alloc] init];
    item221.itemTitle = @"--item221";
    item222.itemTitle = @"--item222";
    item223.itemTitle = @"--item223";
    
    item22.listItems = @[item221, item222, item223];
    item22.expanded = YES;
    
    MACollapsableTableViewItem *item31 = [[MACollapsableTableViewItem alloc] init];
    MACollapsableTableViewItem *item32 = [[MACollapsableTableViewItem alloc] init];
    MACollapsableTableViewItem *item33 = [[MACollapsableTableViewItem alloc] init];
    item31.itemTitle = @"-item31";
    item32.itemTitle = @"-item32";
    item33.itemTitle = @"-item33";
    
    item3.listItems = @[item31, item32, item33];
    
    MACollapsableTableViewItem *item331 = [[MACollapsableTableViewItem alloc] init];
    MACollapsableTableViewItem *item332 = [[MACollapsableTableViewItem alloc] init];
    MACollapsableTableViewItem *item333 = [[MACollapsableTableViewItem alloc] init];
    item331.itemTitle = @"--item331";
    item332.itemTitle = @"--item332";
    item333.itemTitle = @"--item333";
    
    item33.listItems = @[item331, item332, item333];
    item33.expanded = YES;
    
    [self.managedItems addObject:item1];
    [self.managedItems addObject:item2];
    [self.managedItems addObject:item3];
    
    self.expandedItems = [MACollapsableTableViewItem allItemsExpandedWithListItems:self.managedItems];
    
    NSLog(@"expandedItems :%@", self.expandedItems);
    
}

#pragma mark - Helpers

- (void)toggleCollapseStatusWithItem:(MACollapsableTableViewItem *)item atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"toggle item :%@, isExpanded :%d", item.itemTitle, item.isExpanded);
    
    BOOL needToRemoveRows = item.isExpanded;
    NSInteger editingRowsCount = [MACollapsableTableViewItem calculateCountForListItems:item.listItems];
    
    
    item.expanded = !item.expanded;
    self.expandedItems = [MACollapsableTableViewItem allItemsExpandedWithListItems:self.managedItems];
    
    
    NSMutableArray *pathsToEdit = [NSMutableArray array];
    for (int i = 0; i < editingRowsCount; ++i) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:indexPath.row + 1 + i inSection:indexPath.section];
        [pathsToEdit addObject:path];
    }
    
    if (needToRemoveRows) {
        [self.tableView deleteRowsAtIndexPaths:pathsToEdit withRowAnimation:UITableViewRowAnimationNone];
    }
    else {
        [self.tableView insertRowsAtIndexPaths:pathsToEdit withRowAnimation:UITableViewRowAnimationNone];
    }
    
}

- (MACollapsableTableViewItem *)listDataItemWithIndexPath:(NSIndexPath *)indexPath
{
    NSAssert(indexPath.row >= 0 && indexPath.row < self.expandedItems.count, @"Invalid items count");
    
    return self.expandedItems[indexPath.row];
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kSectionHeaderHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.expandedItems.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *theTitle = @"测试数据";
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), kSectionHeaderHeight)];
    headerView.backgroundColor = [UIColor lightGrayColor];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(kSectionHeaderMargin, 0, CGRectGetWidth(self.tableView.bounds) - kSectionHeaderMargin - 2, kSectionHeaderHeight - 2)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *lb = [[UILabel alloc] initWithFrame:backgroundView.bounds];
    lb.backgroundColor = [UIColor whiteColor];
    lb.text = theTitle;
    lb.textColor = [UIColor blackColor];
    
    [headerView addSubview:backgroundView];
    [headerView addSubview:lb];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cityCellIdentifier = @"cityCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cityCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cityCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    MACollapsableTableViewItem *item = [self listDataItemWithIndexPath:indexPath];
    cell.textLabel.text = item.itemTitle;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    MACollapsableTableViewItem *item = [self listDataItemWithIndexPath:indexPath];
    
    if (item.isCollapsable) {
        [self toggleCollapseStatusWithItem:item atIndexPath:indexPath];
    }
    else {
        NSLog(@"indexPath :%@, item :%@", indexPath, item.itemTitle);
    }
}

@end

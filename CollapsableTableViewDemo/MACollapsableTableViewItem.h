//
//  MACollapsableTableViewItem.h
//  CollapsableTableViewDemo
//
//  Created by hanxiaoming on 2017/12/15.
//  Copyright © 2017年 Amap. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MACollapsableTableViewItem : NSObject

/// 标记是否可折叠，listDataItems.count大于0时此属性为YES
@property (nonatomic, readonly, getter=isCollapsable) BOOL collapsable;

/// 标记是否已经展开，默认为NO
@property (nonatomic, assign, getter=isExpanded) BOOL expanded;

/// 用于显示的title
@property (nonatomic, copy) NSString *itemTitle;

/// 当前listData所对应的item，可以为空
@property (nonatomic, strong) id userInfo;

/// 子items，下一级数据
@property (nonatomic, strong) NSArray<MACollapsableTableViewItem *> *listItems;

#pragma mark -

/// 展开listItems，获取一维数组，仅用于通过索引检索
+ (NSArray<MACollapsableTableViewItem *> *)allItemsExpandedWithListItems:(NSArray<MACollapsableTableViewItem *> *)listItems;

/// 获取item的数量，计算展开状态。
+ (NSInteger)calculateCountForListItems:(NSArray<MACollapsableTableViewItem *> *)listItems;

@end


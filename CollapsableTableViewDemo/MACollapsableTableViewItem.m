//
//  MACollapsableTableViewItem.m
//  CollapsableTableViewDemo
//
//  Created by hanxiaoming on 2017/12/15.
//  Copyright © 2017年 Amap. All rights reserved.
//

#import "MACollapsableTableViewItem.h"

@implementation MACollapsableTableViewItem

- (BOOL)isCollapsable
{
    return self.listItems.count > 0;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<Item: %p, title: %@, isCollapsable: %d, isExpanded: %d>", self, self.itemTitle, self.isCollapsable, self.isExpanded];
}

#pragma mark -

+ (NSArray<MACollapsableTableViewItem *> *)allItemsExpandedWithListItems:(NSArray<MACollapsableTableViewItem *> *)listItems
{
    NSMutableArray *resultArray = [NSMutableArray array];
    [self expandItemsWithListItems:listItems resutlArray:resultArray];
    return [resultArray copy];
}

+ (void)expandItemsWithListItems:(NSArray<MACollapsableTableViewItem *> *)listItems resutlArray:(NSMutableArray *)resultArray
{
    if (listItems.count == 0) {
        return;
    }
    NSAssert(resultArray != nil, @"result array must not be nil");
    
    for (MACollapsableTableViewItem *oneItem in listItems) {
        [resultArray addObject:oneItem];
        if (oneItem.isCollapsable && oneItem.isExpanded) {
            [self expandItemsWithListItems:oneItem.listItems resutlArray:resultArray];
        }
    }
}

+ (NSInteger)calculateCountForListItems:(NSArray<MACollapsableTableViewItem *> *)listItems
{
    NSInteger count = 0;
    for (MACollapsableTableViewItem *subItem in listItems) {
        
        count++;
        if (subItem.isCollapsable && subItem.isExpanded) {
            count += [self calculateCountForListItems:subItem.listItems];
        }
    }
    
    return count;
}

@end



//
//  contentView.m
//  scrollViewTest
//
//  Created by Longwei on 16/11/18.
//  Copyright © 2016年 Longwei. All rights reserved.
//

#import "contentView.h"

@implementation contentView
-(void)setPage:(int)page
{
    _page = page;
    self.mylabel.text = [[NSString alloc] initWithFormat:@"第 %d 页", page];
}
@end

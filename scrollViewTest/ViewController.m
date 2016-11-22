//
//  ViewController.m
//  scrollViewTest
//
//  Created by Longwei on 16/11/18.
//  Copyright © 2016年 Longwei. All rights reserved.
//

#import "ViewController.h"
#import "contentView.h"

#define screenWidth ([[UIScreen mainScreen] bounds].size.width)
#define screenHeight ([[UIScreen mainScreen] bounds].size.height)

typedef NS_ENUM(NSUInteger, scrollDirection) {
    forward,
    backward,
};

@interface ViewController ()<UIScrollViewDelegate>
{
    CGFloat currentPage;
    CGFloat offsetAfter;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) int pages;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    currentPage = 1;
    offsetAfter = 0;
    
    [self setupUI];
}

- (void)setupUI
{
    int pages = arc4random() % 10 + 5;
    self.pages = pages;
    self.scrollView.pagingEnabled = YES;
    NSLog(@"self.pages = %d",self.pages);
   
    self.scrollView.contentSize = CGSizeMake(screenWidth * 3, screenHeight);
    contentView *view = [self contentViewWithIndex:1];
    view.page = 1;
    [self.scrollView addSubview:view];
    
    view = [self contentViewWithIndex:2];
    view.page = 2;
    [self.scrollView addSubview:view];
  //  [self.scrollView setContentOffset:CGPointMake(2 * screenWidth, 0) animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)resizeScrollViewWithDirection:(scrollDirection) direction
{
    if (direction == forward)
    {
        if (self.scrollView.subviews.count >= 6)
        {
            for (contentView* view in self.scrollView.subviews)
            {
                if ([view isKindOfClass:[contentView class]])
                {
                    if (view.page == (int)currentPage - 2)
                    {
                        [view removeFromSuperview];
                         break;
                    }
                }
            }//for
        }
    }
    else
    {
        if (self.scrollView.subviews.count >= 6)
        {
            for (contentView* view in self.scrollView.subviews)
            {
                if ([view isKindOfClass:[contentView class]])
                {
                    if (view.page == (int)currentPage + 2)
                    {
                        [view removeFromSuperview];
                         break;
                    }
                }
            }
        }
    }
}

#pragma mark -UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidEndDecelerating");
    
    if ((int)currentPage < 1) {
        return;
    }
    
    CGFloat offset = scrollView.contentOffset.x ;
    //currentPage = (int)(offset/screenWidth);
    if (offsetAfter == offset) {
        return;
    }
    if (offset > offsetAfter) { //页面增加
        if ((int)currentPage + 1 >= self.pages) {
            return;
        }
        currentPage++;
        
        self.scrollView.contentSize =  CGSizeMake(currentPage * screenWidth , screenHeight);
        NSLog(@"forward currentPage = %f",currentPage);
       // if ((int)currentPage < self.pages) {
            if (self.scrollView.subviews.count == 4) {
                contentView *next = [self contentViewWithIndex:3];
                next.page = (int)currentPage + 1;
                [self.scrollView addSubview:next];
                
            }
            else if (self.scrollView.subviews.count == 5) {
                contentView *next = [self contentViewWithIndex:(currentPage + 1)];
                next.page = (int)currentPage + 1;
                [self.scrollView addSubview:next];
                
                [self resizeScrollViewWithDirection:forward];
            }
        //}
    }
    else if (offset < offsetAfter) { //页面减少
        if (currentPage -1 <= 1) {
            return;
        }
        
        currentPage--;
        NSLog(@"backword currentPage = %f",currentPage);
        
        self.scrollView.contentSize =  CGSizeMake(currentPage * screenWidth , screenHeight);
        contentView *prePage = [self contentViewWithIndex:(currentPage - 1)];
        prePage.page = (int)currentPage - 1;
        [self.scrollView addSubview:prePage];
        
        [self resizeScrollViewWithDirection:backward];
    }
    offsetAfter = offset;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"scrollView.contentOffset.x = %f",scrollView.contentOffset.x);
    self.scrollView.contentSize =  CGSizeMake((currentPage + 1) * screenWidth , screenHeight);
   
}


#pragma mark-

-(contentView *)contentViewWithIndex:(int)index
{
    contentView * view = [[NSBundle mainBundle] loadNibNamed:@"contentView" owner:self options:nil][0];
    CGFloat _x = (index - 1) * screenWidth;
    view.frame = CGRectMake(_x + 4, 0, screenWidth - 8, screenHeight);
    [self.scrollView addSubview:view];
    return view;
}

@end

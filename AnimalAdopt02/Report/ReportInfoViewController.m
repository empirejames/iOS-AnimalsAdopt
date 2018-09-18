//
//  FindMainViewController.m
//  TcapoIOSApp
//
//  Created by Casper on 15/4/19.
//  Copyright (c) 2015年 haoyu. All rights reserved.
//

#import "ReportInfoViewController.h"
#import "JDSideMenu.h"
#import "JDMenuViewController.h"
#import "UIViewController+JDSideMenu.h"
#import "MainViewController.h"

@interface ReportInfoViewController (){
    IBOutlet UIScrollView *v_scrollView;
    IBOutlet UIScrollView *img_scrollView;
    NSTimer *_timer;
    BOOL isAdd;
    NSMutableArray *advsList;
    int page_point ;
}

@end

@implementation ReportInfoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
#ifdef __IPHONE_7_0
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
#endif
    [self addView];
    [self showAdvs];
    [self addNSTimer];
   
  
    CGSize mSize = [[UIScreen mainScreen] bounds].size;
    CGFloat screenWidth = mSize.width;
    CGFloat screenHeight = mSize.height;
    
   
    
    [v_scrollView setContentSize:CGSizeMake(screenWidth, 700)];
    
    [v_scrollView setPagingEnabled:YES];
    [v_scrollView setBounces:NO];
    //[scrollView setBackgroundColor:[UIColor blackColor]];
    
    [v_scrollView setShowsVerticalScrollIndicator:NO];
    [v_scrollView setShowsHorizontalScrollIndicator:NO];
    
    [v_scrollView setDelegate:self];
    
   
}

- (IBAction)btnBack:(id)sender;
{
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark -添加控件
- (void)addView{
    
    advsList= [[NSMutableArray alloc]init];
    //添加图片
    for (int i = 1; i < 3; i++) {
        [advsList addObject:[NSString stringWithFormat:@"report_title%d.jpg",i]];
    }
    //self.view.backgroundColor = [UIColor whiteColor];
    
    //添加滑动视图
    // self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 150)];
    //设置代理这个必须的
    img_scrollView.delegate = self;
    //设置总大小也就是里面容纳的大小
    img_scrollView.contentSize = CGSizeMake(self.view.frame.size.width * advsList.count,150);
    [img_scrollView setBackgroundColor:[UIColor blackColor]];
    //里面的子视图跟随父视图改变大小
    [img_scrollView setAutoresizesSubviews:YES];
    //设置分页形式，这个必须设置
    [img_scrollView setPagingEnabled:YES];
    //隐藏横竖滑动块
    [img_scrollView setShowsVerticalScrollIndicator:NO];
    [img_scrollView setShowsHorizontalScrollIndicator:NO];
    //[self.view addSubview:self.scrollView];
    //场景UIPageControl显示控件，并修改小点颜色
    /*  self.pagePoint = [[UIPageControl alloc]init];
     self.pagePoint.currentPageIndicatorTintColor = [UIColor blackColor];
     self.pagePoint.pageIndicatorTintColor = [UIColor grayColor];
     self.pagePoint.frame = CGRectMake(self.view.frame.size.width - self.pagePoint.bounds.size.width-self.advsList.count*10, self.scrollView.frame.origin.y+135, self.pagePoint.bounds.size.width, self.pagePoint.bounds.size.height);
     [self.pagePoint setNumberOfPages:[self.advsList count]];
     [self.view addSubview:self.pagePoint];*/
}
#pragma mark -展示广告位,初始化
-(void)showAdvs{
    
    isAdd = true;
    
    CGSize mSize = [[UIScreen mainScreen] bounds].size;
    
    
    
    for (UIView *view in [img_scrollView subviews]){
        [view removeFromSuperview];
    }
    for(int i = 0; i < [advsList count]; i ++){
        UIButton *thumbView = [[UIButton alloc] init];
        [thumbView addTarget:self
                      action:@selector(myDidSelectAdvAtIndex:)
            forControlEvents:UIControlEventTouchUpInside];
        thumbView.tag = i;
        
        //thumbView.frame = CGRectMake(self.view.frame.size.width * i, 0, self.view.frame.size.width, 150);
        thumbView.frame = CGRectMake(mSize.width * i, 0, mSize.width, 150);
        [thumbView setBackgroundImage:[UIImage imageNamed:advsList[i]] forState:UIControlStateNormal];
        thumbView.adjustsImageWhenHighlighted = NO;
        [img_scrollView addSubview:thumbView];
    }
}

#pragma mark -添加定时器
-(void)addNSTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    //添加到runloop中
    [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
    _timer = timer;
}

#pragma mark -删除定时器
-(void)removeNSTimer
{
    [ _timer invalidate];
    _timer =nil;
}


#pragma mark -定时器下一页
- (void)nextPage{
    //int num = self.pagePoint.currentPage;
    int num = page_point;
    if(isAdd){
        num++;
        if(num == advsList.count -1){
            isAdd = false;
        }
    }else{
        num--;
        if(num == 0){
            isAdd = true;
        }
    }
    [self scrollToIndex:num];
}

#pragma mark -滑动的距离
- (void)scrollToIndex:(NSInteger)index
{
    CGSize mSize = [[UIScreen mainScreen] bounds].size;
    
    /*CGRect frame = img_scrollView.frame;
     
     frame.origin.x = frame.size.width * index;
     frame.origin.y = 0;
     [img_scrollView scrollRectToVisible:frame animated:YES];
     */
    [ img_scrollView setContentOffset:CGPointMake(mSize.width * index, 0) animated:YES];
}

#pragma mark -滑动完成时计算滑动到第几页
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat pageWidth = scrollView.frame.size.width;
    //int page = floor((scrollView.contentOffset.x - pageWidth / 2) /pageWidth) +1;
    page_point  = floor((scrollView.contentOffset.x - pageWidth / 2) /pageWidth) +1;
    // [self.pagePoint setCurrentPage:page];
}

#pragma mark -当用户开始拖拽的时候就调用移除计时器
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeNSTimer];
}
#pragma mark -当用户停止拖拽的时候调用添加定时器
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addNSTimer];
}

#pragma mark -点击广告
- (void)myDidSelectAdvAtIndex:(id) index
{
    UIButton *thumbView = (UIButton *)index;
    NSLog(@"你点击了第个%d广告",thumbView.tag);
}


//編輯
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if([textView isFirstResponder]){
        return YES;
    }
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

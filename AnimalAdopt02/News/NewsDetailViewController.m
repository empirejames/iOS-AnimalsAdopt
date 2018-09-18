//
//  NewsDetailViewController.m
//  TaiJiApp
//
//  Created by Casper on 15/3/25.
//  Copyright (c) 2015年 haoyu. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "Utility.h"

@interface NewsDetailViewController (){
    NSMutableArray *entries;
    NSUserDefaults *defaults;
    NSMutableData *receivedData;
    NSURLConnection *connection;
    NSMutableArray *dataAry;
    IBOutlet UIScrollView *img_scrollView;
    IBOutlet UIScrollView *detail_scrollView;
    IBOutlet UILabel *datelabel;
    IBOutlet UILabel *titlelabel;
    IBOutlet UILabel  *Detailtxt;
    NSString *title,*date,*content,*pic;
    CGFloat screenWidth,screenHeight;
    NSTimer *_timer;
    BOOL isAdd;
    int page_point ;
    NSMutableArray *advsList;

}

@end

@implementation NewsDetailViewController
@synthesize indexId;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CGSize mSize = [[UIScreen mainScreen] bounds].size;
    screenWidth = mSize.width;
    screenHeight = mSize.height;
    page_point = 0;
    [self connectHttp];
    
    
}


-(void)connectHttp
{
    if(receivedData==nil)
    {
        receivedData = [[NSMutableData alloc] init];
    }
    
    [receivedData setLength:0];
    
     NSString *img_url =[NSString stringWithFormat:@"%@/Query/AppNewsItem.ashx?id=%@",NSLocalizedString(@"api_ip", @""),indexId];
    
    NSLog(@"%@",img_url);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:img_url]];

    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(!connection)
    {
        receivedData = nil;
    }
    
}

- (void)connection:(NSURLConnection *)_connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];
}

//Tea update
- (void)connection:(NSURLConnection *)_connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    //   NSLog([NSString stringWithFormat:@"Connection failed: %@", [error description]]);
    connection = nil;
    receivedData = nil;
    
    
    //By Richard 2016.11.27
    //[Utility alertWithTitle:@"訊息" message:@"連結失敗!! 請重新讀取!!"];
    
    [Utility alertWithDialog:@"訊息" message:@"連結失敗!! 請開啟網路連線!!"];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)_connection {
    
    // convert to JSON
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingMutableLeaves error:&myError];
    
  
    title = [res objectForKey:@"title"];
    content= [res objectForKey:@"content"];
    pic= [res objectForKey:@"pic"];
    date= [res objectForKey:@"date"];
    
    
    [titlelabel setText:title];
    [datelabel setText:date];
    
    
    CGSize size = [content sizeWithFont:Detailtxt.font constrainedToSize:CGSizeMake(Detailtxt.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    // 設定Label的內容跟尺寸
    [Detailtxt setFrame:CGRectMake(Detailtxt.frame.origin.x, Detailtxt.frame.origin.y, Detailtxt.frame.size.width, size.height)];
    
    [detail_scrollView setContentSize:CGSizeMake(screenWidth , size.height+50)];
    [Detailtxt setText:content];
    
    [self addView:pic];
    [self showAdvs];
    [self addNSTimer];
}

#pragma mark -添加控件
- (void)addView:(NSArray*)picAry{
    
    
    advsList = [(NSArray*)picAry mutableCopy];
    
    
    // advsList= [[NSMutableArray alloc]init];
    //添加图片
    /*for (int i = 1; i < 4; i++) {
     [advsList addObject:[NSString stringWithFormat:@"about_logo%d.jpg",i]];
     }*/
    
    
    //设置代理这个必须的
    img_scrollView.delegate = self;
    //设置总大小也就是里面容纳的大小
    img_scrollView.contentSize = CGSizeMake(self.view.frame.size.width * advsList.count,180);
    [img_scrollView setBackgroundColor:[UIColor whiteColor]];
    //里面的子视图跟随父视图改变大小
    [img_scrollView setAutoresizesSubviews:YES];
    //设置分页形式，这个必须设置
    [img_scrollView setPagingEnabled:YES];
    //隐藏横竖滑动块
    [img_scrollView setShowsVerticalScrollIndicator:NO];
    [img_scrollView setShowsHorizontalScrollIndicator:NO];
    
}



#pragma mark -展示广告位,初始化
-(void)showAdvs{
    
    CGSize size = CGSizeMake(img_scrollView.frame.size.width, img_scrollView.frame.size.height);
    
    isAdd = true;
    
    for (UIView *view in [img_scrollView subviews]){
        [view removeFromSuperview];
    }
    for(int i = 0; i < [advsList count]; i ++){
        UIButton *thumbView = [[UIButton alloc] init];
        [thumbView addTarget:self
                      action:@selector(myDidSelectAdvAtIndex:)
            forControlEvents:UIControlEventTouchUpInside];
      //  thumbView.tag = i;
       // thumbView.frame = CGRectMake(self.view.frame.size.width * i, 0, self.view.frame.size.width, img_scrollView.frame.size.height);
        
        NSString *img_url =[NSString stringWithFormat:@"%@Upload/Pic/%@",NSLocalizedString(@"api_ip", @""), [advsList objectAtIndex:i]];
     
        //UIImage *urlimage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:img_url]]];
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:img_url]];
       
        
        UIImage *urlimage = [self resizeImage:[[UIImage alloc] initWithData:imageData] reSize:size];
        
        CGSize mSize = [[UIScreen mainScreen] bounds].size;
        
        //urlimage width
        CGFloat imgWidth = urlimage.size.width*(img_scrollView.frame.size.height/urlimage.size.height)-(mSize.width/3);
        CGFloat imgHeight = img_scrollView.frame.size.height;
        
        CGFloat flagWidth = mSize.width -150;
        if (imgWidth<flagWidth) {
            imgWidth = flagWidth;
        }
        
        thumbView.tag = i;
        thumbView.bounds = CGRectMake(0, 0, imgWidth, imgHeight);
        thumbView.center = CGPointMake(mSize.width *( 0.5 + i) , imgHeight * 0.5);

        [thumbView setBackgroundImage:urlimage forState:UIControlStateNormal];
        
        
        thumbView.adjustsImageWhenHighlighted = NO;
        [img_scrollView addSubview:thumbView];
    }
}

- (UIImage*)resizeImage:(UIImage*)aImage reSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext(newSize);
    [aImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
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
    
    CGRect frame = img_scrollView.frame;
    frame.origin.x = frame.size.width * index;
    frame.origin.y = 0;
    [img_scrollView scrollRectToVisible:frame animated:YES];
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)back:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];
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

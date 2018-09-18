//
//  FindMainViewController.m
//  TcapoIOSApp
//
//  Created by Casper on 15/4/19.
//  Copyright (c) 2015年 haoyu. All rights reserved.
//

#import "AdoptMainViewController.h"
#import "UIImageView+AFNetworking.h"

@implementation AdoptMainViewController
@synthesize cv, pageType;

#pragma mark - Initial

- (void)viewDidLoad {
    [super viewDidLoad];
    currentIndex = 1;

    aryUrl = [[NSArray alloc] initWithObjects:
              [NSString stringWithFormat:@"%@Query/MissingList.ashx", NSLocalizedString(@"api_ip", @"")],
              [NSString stringWithFormat:@"%@Query/BulletinList.ashx", NSLocalizedString(@"api_ip", @"")],
              [NSString stringWithFormat:@"%@Query/AcceptList.ashx", NSLocalizedString(@"api_ip", @"")],
              [NSString stringWithFormat:@"%@Query/AppMovies.ashx",NSLocalizedString(@"api_ip", @"")], nil];
    aryPhoto = [[NSArray alloc] initWithObjects:
                [NSString stringWithFormat:@"%@Upload/Pic", NSLocalizedString(@"api_ip", @"")],
                [NSString stringWithFormat:@"%@Upload/Pic", NSLocalizedString(@"api_ip", @"")],
                @"http://163.29.39.183/amlnew/upload/pic/",
                @"http://163.29.39.183/amlnew/upload/pic/", nil];
    aryTitle = [[NSArray alloc] initWithObjects:
                @"寵物失蹤協尋公告",
                @"寵物線上通報",
                @"動物認養",
                @"動物影音", nil];
    mtData = [[NSMutableData alloc] init];
    mtaDataInfo = [[NSMutableArray alloc] init];
    UINib *nib = [UINib nibWithNibName:@"AdoptMainViewCell" bundle: [NSBundle mainBundle]];
    [cv registerNib: nib forCellWithReuseIdentifier:@"cell"];

}

- (void)viewWillAppear: (BOOL)animated {
    [super viewWillAppear: animated];
    [title_label setText:[aryTitle objectAtIndex:pageType]];
    
    if(pageType == 0 || pageType == 1) {
        [NavBtnView setBackgroundImage:[UIImage imageNamed:@"back_icon.png"] forState:UIControlStateNormal];
        [HomeBtnView setHidden:YES];
    } else if(pageType == 3) {
        [footerView setHidden:YES];
    }
    
    [self connectHttp: currentIndex];
}

#pragma mark - Action

- (IBAction)searchBtn:(UIButton *)sender {
    SearchViewController *vc;

    switch (pageType) {
        case 0:
        case 1:
            vc = [[SearchViewController alloc] initWithNibName: @"MissOnlinBulletin_search" bundle:nil];
            break;
        default:
            vc = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
            break;
    }

    [vc setDelegate: self];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController: vc];
    [[nvc navigationBar] setHidden: YES];
    [self presentViewController: nvc animated: NO completion: nil];
}

- (IBAction)btnHome:(id)sender {
    MainViewController *vc = [[MainViewController alloc] initWithNibName: @"MainViewController" bundle: nil];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController: vc];
    [[nvc navigationBar] setHidden: YES];
    [self presentViewController: nvc animated: NO completion: nil];
}

- (IBAction)btnNav:(id)sender {
    switch (pageType) {
        case 0:
        case 1:
            [self.navigationController dismissViewControllerAnimated: NO completion: nil];
            break;
        default:
            if (![self.jdsideMenuController isMenuVisible]) {
                [self.jdsideMenuController showMenuAnimated: YES];
            } else {
                [self.jdsideMenuController hideMenuAnimated: YES];
            }
    }
}

- (IBAction)btnSearch:(UIButton *)sender {
    [self openAlertLoading];
    currentIndex = sender.tag;
    [cv setContentOffset: CGPointMake(0, 0)];
    [self connectHttp: sender.tag];
}

#pragma mark - Customize Methods

- (void)openAlertLoading {
    myAlertView = [[UIAlertView alloc] initWithTitle: @"Loading..." message: @"" delegate: self cancelButtonTitle: nil otherButtonTitles: nil];
    UIActivityIndicatorView *aiView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(125.0, 30.0, 30.0, 30.0)];
    aiView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;

    if ([[[UIDevice currentDevice] systemVersion] compare: @"7.0"] != NSOrderedAscending) {
        [myAlertView setValue: aiView forKey: @"accessoryView"];
    } else {
        [myAlertView addSubview: aiView];
    }
    
    [myAlertView show];
    [aiView startAnimating];
}

- (void)connectHttp:(NSInteger)index {
    [mtData setLength: 0];
    [mtaDataInfo removeAllObjects];
    NSString *urlApi = @"";

    if(pageType != 3) {
        if(index != 4) {
            urlApi =[NSString stringWithFormat: @"%@?type=%ld", [aryUrl objectAtIndex: pageType], (long)index];
        } else {
            urlApi = [NSString stringWithFormat: @"%@?type=%@&age=%@&sex=%@&size=%@&hair=%@&area=%@&name=%@&acceptnum=%@", [aryUrl objectAtIndex: pageType], str_type, str_age, str_sex, str_size, str_hair, str_area, str_name, str_acceptnum];
        }
    } else {
        urlApi =[aryUrl objectAtIndex: pageType];
    }

    NSString *escapedPath = [urlApi stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: escapedPath]];
    urlConnect = [[NSURLConnection alloc] initWithRequest: request delegate: self];
}

#pragma mark - PassValueDelegate

- (void)passValue:(SearchEntity *)value {
    str_type = value.search_type;
    str_sex = value.search_sex;
    str_area = value.search_area;
    str_age = value.search_age;
    str_size = value.search_size;
    str_hair = value.search_hair;
    str_name = value.search_name;
    str_acceptnum = value.search_acceptnum;
    currentIndex = 4;
    [cv reloadData];
}

#pragma mark - UICollectionViewDelegateFlowLayout | UICollectionViewDelegate | UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [mtaDataInfo count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AdoptMainViewCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"cell" forIndexPath: indexPath];
    
    if ([mtaDataInfo count] > indexPath.item) {
        NSDictionary *dic = [mtaDataInfo objectAtIndex: indexPath.item];
        NSString *imgUrl =[NSString stringWithFormat:@"%@/%@",[aryPhoto objectAtIndex: pageType], dic[@"pic"]];
        [cell.imgv setImageWithURL: [NSURL URLWithString:imgUrl] placeholderImage: [UIImage imageNamed:@"default_icon.jpg"]];
        [cell.lbName setText: dic[@"name"]];
        [cell.lbNumber setText: dic[@"num"]];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (collectionView.frame.size.width) / 3;
    CGFloat height = (collectionView.frame.size.height - (collectionView.contentInset.top + collectionView.contentInset.bottom)) / 3;
    return CGSizeMake(width, height);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (mtaDataInfo.count == 0) { return; }
    AdoptMainViewCollectionCell *cell = (AdoptMainViewCollectionCell *)[collectionView cellForItemAtIndexPath: indexPath];
    NSDictionary *dic = [mtaDataInfo objectAtIndex: indexPath.item];
    DetailViewController *vc = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    [vc setPage_type: pageType];
    [vc setDetail_id: dic[@"id"]];
    [vc setDetail_tid: dic[@"tid"]];
    [vc setImgDefault: cell.imgv.image];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController: vc];
    [[nvc navigationBar] setHidden: YES];
    [self presentViewController: nvc animated: NO completion: nil];
}

#pragma mark - NSURLConnectionDelegate | NSURLConnectionDataDelegate | NSURLConnectionDownloadDelegate

- (void)connection:(NSURLConnection *)_connection didReceiveData:(NSData *)data {
    [mtData appendData:data];
}

- (void)connection:(NSURLConnection *)_connection didFailWithError:(NSError *)error {
    urlConnect = nil;
    [mtData setLength: 0];
    [Utility alertWithDialog: @"訊息" message: @"連結失敗!! 請開啟網路連線!!"];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)_connection {
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData: mtData options: NSJSONReadingMutableLeaves error: &myError];
    
    for (NSDictionary *p in res) {
        NSMutableDictionary *mtd = [NSMutableDictionary dictionary];
        [mtd setValue: @"" forKey: @"tid"];
        [mtd setValue: [p valueForKey: @"pic"] forKey: @"pic"];
        [mtd setValue: [p valueForKey: @"id"] forKey: @"id"];
        [mtd setValue: [p valueForKey: @"name"] forKey: @"name"];
        [mtd setValue: @"" forKey: @"num"];

        if ([p valueForKey:@"tid"] != nil) {
            [mtd setValue: [p valueForKey:@"tid"] forKey: @"tid"];
        }

        if ([p valueForKey:@"acceptnum"] != nil) {
            [mtd setValue: [p valueForKey:@"acceptnum"] forKey: @"num"];
        }

        [mtaDataInfo addObject: mtd];
    }
    
    if(mtaDataInfo.count == 0) {
        [Utility alertWithTitle: @"訊息" message: @"目前無資料!!"];
    }
    
    [myAlertView dismissWithClickedButtonIndex: 0 animated: YES];
    [cv reloadData];
}

@end

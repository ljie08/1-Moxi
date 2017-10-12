//
//  HomeViewController.m
//  MMMemorandum
//
//  Created by lijie on 2017/7/17.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import "HomeViewController.h"
#import "SettingViewController.h"//设置
#import "AddThingsViewController.h"//添加
#import "DetailViewController.h"
#import "HomeTableViewCell.h"
#import "ListView.h"
#import "HeaderView.h"//显示置顶数据
#import "HomeViewModel.h"

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource, HeaderDelegate> {
    ListView *_listview;
    HeaderView *_headerview;
    HomeViewModel *_viewModel;
    UIVisualEffectView *_eBgView;//
    BOOL _isChanged;//是否改变
    NSTimer *_dayAnimationTimer;
}

@property (nonatomic, strong) UIButton *titleTypeBtn;//标题view
@property (nonatomic, strong) NSString *titleStr;//标题
@property (weak, nonatomic) IBOutlet UITableView *memoryTable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topPadding;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *effectBgView;//毛玻璃背景


@end

@implementation HomeViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isChanged = NO;
    
    self.titleStr = [NSString stringWithFormat:@"记忆"];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self initUI];
    
    [self.memoryTable addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    //self.topPadding.constant = 245*Screen_Height/667;
    //self.effectBgView.frame = CGRectMake(0, 245*Screen_Height/667, Screen_Width, Screen_Height-245*Screen_Height/667);
    //NSLog(@"topPadding --- %f", self.topPadding.constant);
    //NSLog(@"yPadding --- %f", 245*Screen_Height/667);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isChanged) name:@"dateType" object:nil];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _isChanged = NO;
}

#pragma mark - viewmodel
- (void)initViewModelBinding {
    _viewModel = [[HomeViewModel alloc] init];
}

- (void)loadData {
    [_viewModel getHomeDataIsChanged:_isChanged success:^(BOOL result) {
        [self setHeader];
        [self.memoryTable reloadData];
        
    } failure:^(NSString *errorString) {
        NSLog(@"failure");
    }];
}


#pragma mark - UI
- (void)initUI {
//    self.automaticallyAdjustsScrollViewInsets = NO;
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 181*Screen_Height/667)];
    header.backgroundColor = [UIColor clearColor];
    self.memoryTable.tableHeaderView = header;
    self.memoryTable.tableFooterView = [UIView new];
    self.memoryTable.separatorColor = [UIColor grayColor];
    [self setNavbar];
    
    _eBgView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    _eBgView.frame = CGRectMake(0, 245*Screen_Height/667, Screen_Width, Screen_Height-245*Screen_Height/667);
    _eBgView.alpha = 0.7;
    [self.view addSubview:_eBgView];
    [self.view insertSubview:_eBgView belowSubview:self.memoryTable];
}

- (void)setNavbar {
    UIButton *meBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    meBtn.frame = CGRectMake(0, 0, 23, 22);
    [meBtn setImage:[UIImage imageNamed:@"me"] forState:UIControlStateNormal];
    [meBtn addTarget:self action:@selector(setting) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(0, 0, 22, 22);
    [addBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addThings) forControlEvents:UIControlEventTouchUpInside];
    
    self.titleTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.titleTypeBtn.frame = CGRectMake(0, 0, 200, 40);
    [self.titleTypeBtn setTitle:self.titleStr forState:UIControlStateNormal];
    [self.titleTypeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//    [self.titleTypeBtn addTarget:self action:@selector(showListView) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:meBtn];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:addBtn];
    
    [self addNavigationWithTitle:nil leftItem:leftItem rightItem:rightItem titleView:self.titleTypeBtn];
}

- (void)setHeader {
    /*
     245-64     x
     --- = ------
     667   height
     */
    if (_headerview == nil) {
        _headerview = [[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:nil options:nil].firstObject;
        _headerview.frame = CGRectMake(0, 64, Screen_Width, 181*Screen_Height/667);
    }
    _headerview.delegate = self;
    [_headerview setDataWithModel:_viewModel.homeListArr.firstObject];
    
    [self.view addSubview:_headerview];
    [self.view sendSubviewToBack:_headerview];
}

#pragma mark - 事件
- (void)setting {
    SettingViewController *setVc = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:setVc animated:YES];
//    [self presentViewController:setVc animated:YES completion:nil];
}

- (void)addThings {
    AddThingsViewController *addVc = [[AddThingsViewController alloc] initWithModel:nil];
    [self.navigationController pushViewController:addVc animated:YES];
}

- (void)isChanged {
    _isChanged = YES;
}

- (void)showListView {
    NSLog(@"list click");
    NSArray *array = @[@"全部",@"生活",@"节日",@"工作日"];
    
    if(_listview == nil){
        _listview = [[ListView alloc] init];
        
        _listview.frame = CGRectMake(30, 70, Screen_Width - 60, array.count * 40);
        
        _listview.strArray = array;
        [_listview showList];
        
        [CurrentKeyWindow addSubview:_listview];
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeList:)];
//        [CurrentKeyWindow addGestureRecognizer:tap];
        
        @weakSelf(self);
        _listview.actionBlock = ^(NSInteger tag) {
            NSString *title = [NSString stringWithFormat:@"记忆 - %@", array[tag]];
            [weakSelf.titleTypeBtn setTitle:title forState:UIControlStateNormal];
        };
    }else{
        _listview.hidden = NO;
    }
}

- (void)removeList:(UITapGestureRecognizer *)tap {
    NSLog(@"window click");
    CGPoint point = [tap locationInView:_listview];
    BOOL hasPoint = CGRectContainsPoint(_listview.frame, point);
    if (!hasPoint) {//点击listview以外的点让picker消失
        [self removeView];
    }
}

- (void)removeView {
    [UIView animateWithDuration:0.5 animations:^{
        _listview.frame = CGRectMake(0, Screen_Height, Screen_Width, _listview.frame.size.height);
    } completion:^(BOOL finished) {
        [_listview removeFromSuperview];
    }];
}

#pragma mark - kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint point = [change[NSKeyValueChangeNewKey] CGPointValue];
        if (point.y > 181) {
            self.topPadding.constant = 64.0;
            _eBgView.frame = CGRectMake(0, 64, Screen_Width, Screen_Height-64);
        } else {
            self.topPadding.constant = 181-point.y;
            _eBgView.frame = CGRectMake(0, 245*Screen_Height/667-point.y, Screen_Width, Screen_Height-(245*Screen_Height/667-point.y));
        }
    }
}

#pragma mark - table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _viewModel.homeListArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeTableViewCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"HomeTableViewCell" owner:nil options:nil].firstObject;
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    HomeModel *model = _viewModel.homeListArr[indexPath.row];
    [cell setDataWithModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeModel *model = _viewModel.homeListArr[indexPath.row];
    DetailViewController *vc = [[DetailViewController alloc] initWithModel:model];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    ///配置 CATransform3D 动画内容
    CATransform3D transform; transform.m34 = 1.0/-800;
    //定义 Cell的初始化状态
    cell.layer.transform = transform;
    //定义Cell 最终状态 并且提交动画
    [UIView beginAnimations:@"transform" context:NULL];
    [UIView setAnimationDuration:1];
    cell.layer.transform = CATransform3DIdentity;
    cell.frame = CGRectMake(0, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
    [UIView commitAnimations];
    
//    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
//    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1)];
//    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
//    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
//    [cell.layer addAnimation:scaleAnimation forKey:@"transform"];
    
}

#pragma mark - dealloc
- (void)dealloc {
    [self.memoryTable removeObserver:self forKeyPath:@"distance"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _isChanged = NO;
}

@end

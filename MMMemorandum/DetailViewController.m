//
//  DetailViewController.m
//  MMMemorandum
//
//  Created by lijie on 2017/7/19.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import "DetailViewController.h"
#import "AddThingsViewController.h"

@interface DetailViewController () {
    HomeModel *_homeModel;
}

@property (weak, nonatomic) IBOutlet UILabel *dayLab;//天数
@property (weak, nonatomic) IBOutlet UILabel *overdueLab;//过去/未来
@property (weak, nonatomic) IBOutlet UILabel *titleLab;//标题
@property (weak, nonatomic) IBOutlet UILabel *dateLab;//时间

@end

@implementation DetailViewController

- (instancetype)initWithModel:(HomeModel *)model {
    if (self = [super init]) {
        _homeModel = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)initUIView {
    [self setBackButton:YES];
    
    self.dayLab.text = _homeModel.day;
    self.overdueLab.text = _homeModel.overdue;
    self.titleLab.text = _homeModel.title;
    self.dateLab.text = _homeModel.date;
    
    UIButton *amendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    amendBtn.frame = CGRectMake(0, 0, 50, 40);
    amendBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [amendBtn setTitle:@"修改" forState:UIControlStateNormal];
    [amendBtn setTitleColor:[UIColor hexStringToColor:@"#333333"] forState:UIControlStateNormal];
    [amendBtn addTarget:self action:@selector(amend) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:amendBtn];
    [self addNavigationWithTitle:@"详细" leftItem:nil rightItem:rightItem titleView:nil];
}

//修改数据
- (void)amend {
    AddThingsViewController *addVc = [[AddThingsViewController alloc] initWithModel:_homeModel];
    [self.navigationController pushViewController:addVc animated:YES];
}

@end

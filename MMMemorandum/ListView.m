//
//  ListView.m
//  MMMemorandum
//
//  Created by lijie on 2017/7/18.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import "ListView.h"

@implementation ListView

- (NSMutableArray *)imageArray {
    if(_imageArray == nil){
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (void)showList {
    self.number = 0;
    
    UIView *listview = [[UIView alloc] initWithFrame:self.bounds];
    listview.backgroundColor = [UIColor whiteColor];
    [self addSubview:listview];
    
    for (int i = 0; i < self.strArray.count; i++) {
        CGFloat width = self.bounds.size.width;
        CGRect btnFrame = CGRectMake(5, i*40, width-25, 40);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = btnFrame;
        button.tag = 100+i;
        NSString *titleStr = self.strArray[i];
        [button setTitle:titleStr forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        button.backgroundColor = [UIColor clearColor];
        button.selected = NO;
        
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [listview addSubview:button];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(width-20, 40*i+10, 13, 10)];
        imgView.image = [UIImage imageNamed:@"right"];
        imgView.tag = 200+i;
        imgView.hidden = YES;
        [listview addSubview:imgView];
        [self.imageArray addObject:imgView];
        
        if (i == 0) {
            button.selected = YES;
            imgView.hidden = NO;
        }
        
        if (i < self.strArray.count - 1) {
            UIView *linview = [[UIView alloc] initWithFrame:CGRectMake(0, 40*i+39, width, 1)];
            linview.backgroundColor = [UIColor lightGrayColor];
            [listview addSubview:linview];
        }
    }
}

- (void)buttonClick:(UIButton *)button {
    if (self.number == button.tag) {
        UIImageView *imageView = [self.imageArray objectAtIndex:button.tag-100];
        if (imageView.hidden) {
            imageView.hidden = NO;
            self.hidden = YES;
        } else {
            imageView.hidden = YES;
            self.hidden = NO;
        }
    } else {
        button.selected = !button.selected;
        for (UIImageView *imageView in self.imageArray) {
            if(imageView.tag == button.tag + 100){
                imageView.hidden = NO;
                button.selected = YES;
            }else{
                imageView.hidden = YES;
                button.selected = NO;
            }
        }
        self.hidden = YES;
    }
    
    if (self.actionBlock) {
        self.actionBlock(button.tag - 100);
    }
    self.number = button.tag;
}

@end

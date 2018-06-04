//
//  ViewController.m
//  NFC
//
//  Created by weiliang on 2018/6/1.
//  Copyright © 2018年 weiliang. All rights reserved.
//

#import "ViewController.h"
#import <CoreNFC/CoreNFC.h>
@interface ViewController ()<NFCNDEFReaderSessionDelegate>
@property (weak, nonatomic) IBOutlet UILabel *scanLable;
@property (weak, nonatomic) IBOutlet UIButton *scanButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [_scanButton addTarget:self action:@selector(scan:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scan:(id)sender{
    // 创建 NFCNDEFReaderSession 实例，开启NFCNDEFReaderSession
    // Tips：开启
    // 条件：iphone7/7plus运行iOS11
    if ([UIDevice currentDevice].systemVersion.floatValue >= 11.0) {
        // ReadingAvailable is YES if device supports NFC tag reading.
        if ([NFCNDEFReaderSession readingAvailable]) {
            // beginScanning
            // invalidateAfterFirstRead 属性表示是否需要识别多个NFC标签，如果是YES，则会话会在第一次识别成功后终止。否则会话会持续
            // 不过有一种例外情况，就是如果响应了-readerSession:didInvalidateWithError:方法，则是否为YES，会话都会被终止
            NFCNDEFReaderSession *session = [[NFCNDEFReaderSession alloc] initWithDelegate:self queue:nil invalidateAfterFirstRead:YES];
            
            [session beginSession];
        }
    }
}

// 处理协议回调方法
#pragma mark - NFCReaderSessionDelegate
// Check invalidation reason from the returned error. A new session instance is required to read new tags.
// 识别出现Error后会话会自动终止，此时就需要程序重新开启会话
- (void)readerSession:(NFCNDEFReaderSession *)session didInvalidateWithError:(NSError *)error {
    // error明细参考NFCError.h
    NSLog(@"%@",error);
}

// Process detected NFCNDEFMessage objects
- (void)readerSession:(NFCNDEFReaderSession *)session didDetectNDEFs:(NSArray<NFCNDEFMessage *> *)messages {
    // 数组messages中是NFCNDEFMessage对象
    // NFCNDEFMessage对象中有一个records数组，这个数组中是NFCNDEFPayload对象
    // 参考NFCNDEFMessage、NFCNDEFPayload类
    // 解析数据
    for (NFCNDEFMessage *message in messages) {
        for (NFCNDEFPayload *playLoad in message.records) {
            NSLog(@"typeNameFormat : %d", playLoad.typeNameFormat);
            NSLog(@"type : %@", playLoad.type);
            NSLog(@"identifier : %@", playLoad.identifier);
            NSLog(@"playload : %@", playLoad.payload);
        }
    }
}
 
@end

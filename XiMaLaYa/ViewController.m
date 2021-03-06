//
//  ViewController.m
//  XiMaLaYa
//
//  Created by soulghost on 3/9/2017.
//  Copyright © 2017 soulghost. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import <Masonry.h>


@interface ViewController () <WKNavigationDelegate, WKUIDelegate>

@property (weak) IBOutlet WKWebView *webView;

@end

@implementation ViewController





- (void)viewDidLoad {
    [super viewDidLoad];


    
    WKWebView *webView = [[WKWebView alloc] init];
    [self.view addSubview:webView];
    self.webView = webView;
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(play) name:@"play" object:nil];
    
    NSString *html = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.ximalaya.com/explore/"] encoding:NSUTF8StringEncoding error:nil];
    html = [html stringByReplacingOccurrencesOfString:@"<head>" withString:@"<head>\n\t<script src=\"http://code.jquery.com/jquery-1.11.0.min.js\"></script>"];
    [self.webView loadHTMLString:html baseURL:[NSURL URLWithString:@"http://www.ximalaya.com/explore/"]];

}

- (void)viewDidAppear {
    [super viewDidAppear];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {

}

- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    WKWebView *wb = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
    NSViewController *vc = [[NSStoryboard storyboardWithName:@"Main" bundle:nil] instantiateControllerWithIdentifier:@"TargetWindow"];
    [vc.view addSubview:wb];
    [wb loadRequest:navigationAction.request];
    [wb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(vc.view);
    }];
    [self presentViewControllerAsModalWindow:vc];
    return wb;
}

- (void)webViewDidClose:(WKWebView *)webView {
    [webView removeFromSuperview];
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
}

#pragma mark - Action
- (void)play {
    // playing
    [self.webView evaluateJavaScript:@"document.getElementsByClassName('play').length" completionHandler:^(id _Nullable ret, NSError * _Nullable error) {
        BOOL isPlaying = ![ret boolValue];
        if (isPlaying == YES) {
            [self.webView evaluateJavaScript:@"var swallow = document.getElementsByClassName('pause')[0].click();" completionHandler:^(id _Nullable sender, NSError * _Nullable error) {
                
            }];
        } else {
            [self.webView evaluateJavaScript:@"var swallow = document.getElementsByClassName('play')[0].click();" completionHandler:^(id _Nullable sender, NSError * _Nullable error) {
                
            }];
        }
    }];
    
    
}


@end

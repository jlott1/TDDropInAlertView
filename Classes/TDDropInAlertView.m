//
//  TDDropInAlertView.m
//  Tendigi
//
//  Created by Nick Lee on 1/12/16.
//
//

#import <UIKit/UIKit.h>
#import "TDDropInAlertView.h"

@interface TDDropInAlertView ()

- (void)handleButtonAtIndex:(NSUInteger)idx;

@end

@implementation TDDropInAlertView

@dynamic title;
@dynamic message;
@dynamic numberOfButtons;
@dynamic cancelButtonIndex;
@dynamic visible;
@dynamic firstOtherButtonIndex;

+ (NSMutableArray*)alertViewCollection {
    static NSMutableArray* alertViewCollection;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        alertViewCollection = [[NSMutableArray alloc] init];
    });
    return alertViewCollection;
}

+ (void)addShowingAlertView:(TDDropInAlertView*)alertView {
    @synchronized(self) {
        if(![[self alertViewCollection] containsObject:alertView]) {
            [[self alertViewCollection] addObject:alertView];
        }
    }
}

+ (void)removeAlertView:(TDDropInAlertView*)alertView {
    if([[self alertViewCollection] containsObject:alertView]) {
        [[self alertViewCollection] removeObject:alertView];
    }
}

#pragma mark - Initialization

- (nonnull instancetype)init
{
    return [self initWithTitle:nil message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
}

- (nonnull instancetype)initWithTitle:(nullable NSString *)title
                              message:(nullable NSString *)message
                             delegate:(nullable id<TDDropInAlertViewDelegate>)delegate
                    cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                    otherButtonTitles:(nullable NSString *)otherButtonTitles, ...
{
    if (self = [super init]) {
        
        _alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        _delegate = delegate;
        
        __weak typeof(self) weakSelf = self;
        
        if (cancelButtonTitle) {
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                __strong typeof(self) strongSelf = weakSelf;
                [strongSelf handleButtonAtIndex:strongSelf.cancelButtonIndex];
            }];
            [_alertController addAction:cancel];
        }
        
        va_list args;
        va_start(args, otherButtonTitles);
        for (NSString *buttonTitle = otherButtonTitles; buttonTitle != nil; buttonTitle = va_arg(args, NSString *)) {
            NSUInteger idx = _alertController.actions.count;
            UIAlertAction *action = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                __strong typeof(self) strongSelf = weakSelf;
                [strongSelf handleButtonAtIndex:idx];
            }];
            [_alertController addAction:action];
        }
        va_end(args);
        
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"TDDropInAlertView - dealloc");
}

#pragma mark - Properties

- (nullable NSString *)title
{
    return self.alertController.title;
}

- (void)setTitle:(nullable NSString *)title
{
    self.alertController.title = title;
}

- (nullable NSString *)message
{
    return self.alertController.message;
}

- (void)setMessage:(nullable NSString *)message
{
    self.alertController.message = message;
}

- (NSInteger)numberOfButtons
{
    return self.alertController.actions.count;
}

- (NSInteger)cancelButtonIndex
{
    __block NSInteger index = -1;
    [self.alertController.actions enumerateObjectsUsingBlock:^(UIAlertAction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.style == UIAlertActionStyleCancel) {
            index = idx;
            *stop = YES;
        }
    }];
    return index;
}

- (BOOL)isVisible
{
    return self.alertController.isViewLoaded && self.alertController.view.window;
}

- (NSInteger)firstOtherButtonIndex
{
    __block NSInteger index = -1;
    [self.alertController.actions enumerateObjectsUsingBlock:^(UIAlertAction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.style != UIAlertActionStyleCancel) {
            index = idx;
            *stop = YES;
        }
    }];
    return index;
}

#pragma mark - Buttons

- (void)handleButtonAtIndex:(NSUInteger)idx
{
    if ([self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        [self.delegate alertView:self clickedButtonAtIndex:idx];
    }
    [self dismissWithClickedButtonIndex:idx animated:YES];
}

- (NSInteger)addButtonWithTitle:(NSString *)title
{
    NSInteger idx = self.alertController.actions.count;
    
    __weak typeof(self) weakSelf = self;
    
    UIAlertAction *newAction = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf handleButtonAtIndex:idx];
    }];
    
    [self.alertController addAction:newAction];
    
    return idx;
}

- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex
{
    UIAlertAction *action = self.alertController.actions[buttonIndex];
    return action.title;
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
    
    if ([self.delegate respondsToSelector:@selector(alertView:willDismissWithButtonIndex:)]) {
        [self.delegate alertView:self willDismissWithButtonIndex:buttonIndex];
    }
    
    [self.alertController dismissViewControllerAnimated:animated completion:^{
        if ([self.delegate respondsToSelector:@selector(alertView:didDismissWithButtonIndex:)]) {
            [self.delegate alertView:self didDismissWithButtonIndex:buttonIndex];
            //must release self
            [TDDropInAlertView removeAlertView:self];
        }
    }];
    
}

#pragma mark - Display

- (void)show
{
    
    if ([self.delegate respondsToSelector:@selector(willPresentAlertView:)]) {
        [self.delegate willPresentAlertView:self];
    }
    
    UIViewController *viewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    if(viewController.presentedViewController) {
        viewController = viewController.presentedViewController;
    }
    [viewController presentViewController:self.alertController animated:true completion:^{
        if ([self.delegate respondsToSelector:@selector(didPresentAlertView:)]) {
            [self.delegate didPresentAlertView:self];
        }
    }];
    // must retain self
    [TDDropInAlertView addShowingAlertView:self];
}

@end
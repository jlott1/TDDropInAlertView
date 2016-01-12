//
//  TDDropInAlertView.h
//  Tendigi
//
//  Created by Nick Lee on 1/12/16.
//
//

#import <Foundation/Foundation.h>

@class TDDropInAlertView;

@protocol TDDropInAlertViewDelegate <NSObject>
@optional

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(nonnull TDDropInAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

- (void)willPresentAlertView:(nonnull TDDropInAlertView *)alertView;  // before animation and showing view
- (void)didPresentAlertView:(nonnull TDDropInAlertView *)alertView;  // after animation

- (void)alertView:(nonnull TDDropInAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex; // before animation and hiding view
- (void)alertView:(nonnull TDDropInAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;  // after animation

/*

 Not implemented
 
 // Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
 // If not defined in the delegate, we simulate a click in the cancel button
 - (void)alertViewCancel:(nonnull TDDropInAlertView *)alertView;
 
 // Called after edits in any of the default fields added by the style
 - (BOOL)alertViewShouldEnableFirstOtherButton:(nonnull TDDropInAlertView *)alertView NS_DEPRECATED_IOS(2_0, 9_0);

 */

@end

@interface TDDropInAlertView : NSObject 

@property (nonnull, nonatomic, strong, readonly) UIAlertController *alertController;

- (nonnull instancetype)initWithTitle:(nullable NSString *)title
                               message:(nullable NSString *)message
                              delegate:(nullable id /*<UIAlertViewDelegate>*/)delegate
                     cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                     otherButtonTitles:(nullable NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION NS_DESIGNATED_INITIALIZER;

@property (nullable, nonatomic, weak) id<TDDropInAlertViewDelegate> delegate;

@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *message;   // secondary explanation text
@property (nonatomic, readonly) NSInteger numberOfButtons;
@property (nonatomic, readonly) NSInteger cancelButtonIndex;      // if the delegate does not implement -alertViewCancel:, we pretend this button was clicked on. default is -1
@property (nonatomic, readonly, getter=isVisible) BOOL visible;
@property (nonatomic, readonly) NSInteger firstOtherButtonIndex;	// -1 if no otherButtonTitles or initWithTitle:... not used

//// adds a button with the title. returns the index (0 based) of where it was added. buttons are displayed in the order added except for the
//// cancel button which will be positioned based on HI requirements. buttons cannot be customized.
- (NSInteger)addButtonWithTitle:(nullable NSString *)title;    // returns index of button. 0 based.
- (nullable NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex;

//// shows popup alert animated.
- (void)show;

//// hides alert sheet or popup. use this method when you need to explicitly dismiss the alert.
//// it does not need to be called if the user presses on a button
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;

/*

 Text fields not currently implemented

 - (nullable UITextField *)textFieldAtIndex:(NSInteger)textFieldIndex NS_AVAILABLE_IOS(5_0);
 @property(nonatomic,assign) UIAlertViewStyle alertViewStyle NS_AVAILABLE_IOS(5_0);
 
*/

@end

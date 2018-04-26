////////////////////////////////////////////////////////////////////
//                          _ooOoo_                               //
//                         o8888888o                              //
//                         88" . "88                              //
//                         (| ^_^ |)                              //
//                         O\  =  /O                              //
//                      ____/`---'\____                           //
//                    .'  \\|     |//  `.                         //
//                   /  \\|||  :  |||//  \                        //
//                  /  _||||| -:- |||||-  \                       //
//                  |   | \\\  -  /// |   |                       //
//                  | \_|  ''\---/''  |   |                       //
//                  \  .-\__  `-`  ___/-. /                       //
//                ___`. .'  /--.--\  `. . ___                     //
//              ."" '<  `.___\_<|>_/___.'  >'"".                  //
//            | | :  `- \`.;`\ _ /`;.`/ - ` : | |                 //
//            \  \ `-.   \_ __\ /__ _/   .-` /  /                 //
//      ========`-.____`-.___\_____/___.-`____.-'========         //
//                           `=---='                              //
//      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        //
//         佛祖保佑            永无BUG              永不修改         //
////////////////////////////////////////////////////////////////////

import UIKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
     func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        let account = HMUserAccountViewModel.sharedAccountViewModel.loadUserInfo()
        print(account ?? "account == nil")
        SQLiteManager.sharedManager
        
        setNavBarThemeColor()
        registerNotification()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        
        //        window?.rootViewController = UINavigationController(rootViewController: HMPictureSelectorController())
        window?.rootViewController = defaultRootViewController()
        //window 可视化
        window?.makeKeyAndVisible()
        return true
    }

    
    //MARK: 通知监听的方法 
    @objc private func changeRootViewController(n: NSNotification) {
        print(n)
        //切换根视图控制器
        if n.object != nil {
            //从欢迎页面发出的通知
            window?.rootViewController = HMMainViewController()
        } else {
            //从授权页面发出的通知
            window?.rootViewController = HMWelcomeViewController()
        }
    }
    
    //MARK: 注册通知
    private func registerNotification() {
        // object: 监听那个对象发出的通知  一般设置为 nil 表示监听任意对象发出的通知
        NotificationCenter.default.addObserver(self, selector: #selector(changeRootViewController(n:)), name: NSNotification.Name(rawValue: HMSwitchRootViewController), object: nil)
    }
    
    //根据用户登录 来选择对应的根视图控制器
    private func defaultRootViewController() -> UIViewController{
        return HMUserAccountViewModel.sharedAccountViewModel.userLogin ? HMWelcomeViewController() : HMMainViewController()
    }
    
    private func setNavBarThemeColor() {
        //设置全局颜色
        //全局颜色的设置 必须在控件实例化之前
        UINavigationBar.appearance().tintColor = UIColor.orange
    }

    //MARK 移除通知  编码规范而已
    deinit {
        NotificationCenter.default.removeObserver(self)
    }


}


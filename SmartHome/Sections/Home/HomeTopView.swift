//
//  HomeTopView.swift
//  SmartHome
//
//  Created by sunzl on 15/12/24.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit

class HomeTopView: UIView ,UIScrollViewDelegate{
    
    @IBOutlet var playView: UIView!
    @IBOutlet var currentAddressLabel: UILabel!
    @IBOutlet var wind: UILabel!
    @IBOutlet var minTemp: UILabel!
    @IBOutlet var maxTemp: UILabel!
    @IBOutlet var weatherName: UILabel!
    @IBOutlet var weatherIcon: UIImageView!
    @IBOutlet var date: UILabel!
    @IBOutlet  var scrollView:UIScrollView!
    @IBOutlet  var pageControl:UIPageControl!
    var images=[]
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("----2")
      
        self.backgroundColor=UIColor.brownColor()
        //设置视图的背景颜色
  
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setWeatherModel(model:WeatherModel){
        self.currentAddressLabel.text="当前位置:"+(model.address)
        self.weatherName.text=(model.aWeather)
        self.wind.text=(model.aWind)
        self.maxTemp.text="最高"+(model.aMaxTemp)+"°C"
        self.minTemp.text="最低"+(model.aSmallTemp)+"°C"
        self.weatherIcon!.sd_setImageWithURL(NSURL(string: (model.nightPictureUrl)))
        
    }
    
    
    //改变滚动视图的方法实现
    func setupPage()
    {
        //设置委托
        self.scrollView.delegate = self
        //设置背景颜色
        self.scrollView.backgroundColor = UIColor.whiteColor()
        //设置取消触摸
        self.scrollView.canCancelContentTouches = false
        //设置滚动条类型
        self.scrollView.indicatorStyle = UIScrollViewIndicatorStyle.White
        //是否自动裁切超出部分
        self.scrollView.clipsToBounds = true
        //设置是否可以缩放
        self.scrollView.scrollEnabled = true
        //设置是否可以进行画面切换
        self.scrollView.pagingEnabled = true
        //设置在拖拽的时候是否锁定其在水平或者垂直的方向
        self.scrollView.directionalLockEnabled = true
        //隐藏滚动条设置（水平、跟垂直方向）
        self.scrollView.alwaysBounceHorizontal = false
        self.scrollView.alwaysBounceVertical = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        //用来记录页数
        var pages:Int = 0
        //用来记录scrollView的x坐标
        var originX:CGFloat = 0
        for image in self.images
        {
            //创建一个视图
            let  pImageView: UIImageView = UIImageView(frame: CGRectZero)
            //设置视图的背景色
            pImageView.backgroundColor = UIColor(red:0.6 ,green:0.6 ,blue:0.6, alpha:1.0)
            //设置imageView的背景图
            
            let picurl:String="TestImgUrl"+""
            pImageView.sd_setImageWithURL(NSURL(string: picurl), placeholderImage:image as! UIImage)
            
            
            //给imageView设置区域
            var rect:CGRect = self.scrollView.frame
            rect.origin.x = originX
            rect.origin.y = 0
            rect.size.width = ScreenWidth//self.scrollView.frame.size.width
            rect.size.height = ScreenWidth//self.scrollView.frame.size.height
            pImageView.frame = rect
            //设置图片内容的显示模式()
            pImageView.contentMode = UIViewContentMode.ScaleToFill
            //把视图添加到当前的滚动视图中
            pImageView.layer.masksToBounds=true
            self.scrollView.addSubview(pImageView)
            //下一张视图的x坐标:offset为:self.scrollView.frame.size.width.
            originX = originX + ScreenWidth
            //记录scrollView内imageView的个数
            pages++
        }
        //设置页码控制器的响应方法
        self.pageControl.addTarget(self, action: Selector("changePage:") , forControlEvents: UIControlEvents.ValueChanged)
        
        //设置总页数
        self.pageControl.numberOfPages = pages
        //默认当前页为第一页
        self.pageControl.currentPage = 0
        //为页码控制器设置标签
        self.pageControl.tag = 110
        //设置滚动视图的位置
        self.scrollView.contentSize=CGSizeMake(originX, 0)
    }
    //改变页码的方法实现
    func changePage(sender:AnyObject)
    {
        //NSLog(@"指示器的当前索引值为:%li",(long)self.pageControl.currentPage);
        //获取当前视图的页码
        var rect:CGRect  = self.scrollView.frame
        //设置视图的横坐标，一幅图为320*460，横坐标一次增加或减少320像素
        rect.origin.x = (CGFloat)(self.pageControl.currentPage) * (self.scrollView.frame.size.width)
        //设置视图纵坐标为0
        rect.origin.y = 0
        //scrollView可视区域
        self.scrollView.scrollRectToVisible(rect, animated: true)
        
    }
    //pragma mark-----UIScrollViewDelegate---------
    //实现协议UIScrollViewDelegate的方法，必须实现的
    func scrollViewDidEndDecelerating(scrollView:UIScrollView)
    {
        //获取当前视图的宽度
        let pageWith:CGFloat = scrollView.frame.size.width
        //根据scrolView的左右滑动,对pageCotrol的当前指示器进行切换(设置currentPage)
        let page = floor((scrollView.contentOffset.x - pageWith/2)/pageWith)+1;
        //切换改变页码，小圆点
        self.pageControl.currentPage =  Int(Float(page))
    }
    
}

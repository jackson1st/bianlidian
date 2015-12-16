//
//  EVATableViewCell.swift
//  webDemo
//
//  Created by Jason on 15/11/20.
//  Copyright © 2015年 jason. All rights reserved.
//

import UIKit

class EVATableViewCell: UITableViewCell {

    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var personLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
/*
$(document).ready(function(){
$.loadfirst();
$.loadsecond();
$.loadthird();
var scrollHandler=function(){
var winH=$(window).height();
var pageH=$(document.body).height();
var scrollT=$(window).scrollTop();
var aa = (pageH - winH - scrollT) / winH;

if(aa<0.02){
$.loadsecond();
$.loadthird();
}
}

$(window).scroll(scrollHandler);

$("#go").click(function(){
location.href="searchlist.html";
})
$("#sort").click(function(){
location.href="sort.html";
})
$(".col2").click(function(){
location.href="detail.html";
})
})

$.loadfirst=function(){
var json=[{"pic":"image/index_img_m1.png","name":"机械键盘","price":"￥398.0","count":"300件"},{"pic":"image/index_img_m2.png","name":"冬季外套","price":"￥288.0","count":"300件"},{"pic":"image/index_img_m3.png","name":"保暖手套","price":"￥95.0","count":"300件"},{"pic":"image/index_img_m4.png","name":"健身哑铃","price":"￥148.0","count":"300件"}];
var html='<div class="row bg" style="color: red"><h4 class="title">新品推荐</h4></div>';
html+='<div class="row bg">';
for(var i=0;i<json.length;i++)
{

html+='<div class="col-xs-5 col2">';
html+='<img src='+json[i].pic+' alt="" class="img-responsive img">';
html+=' <div class="row"><h>'+json[i].name+'</h></div>';
html+='<div class="row">';
html+='<div class="ll"><h style="color:red">'+json[i].price+'</h></div>';
html+='<div class="rr"><h style="color:red">'+json[i].count+'</h></div>';
html+='</div></div>';
}
html+='</div>';
$("#lists").append(html);
}

$.loadsecond=function(){
var json=[{"pic":"image/babaozhou.jpg","name":"银鹭八宝粥","price":"￥2.50","count":"500瓶"},{"pic":"image/paomian.jpg","name":"康师傅牛肉面","price":"￥3.50","count":"500盒"},{"pic":"image/shupian.jpg","name":"乐事薯片","price":"￥3.50","count":"500包"},{"pic":"image/huotuichang.jpg","name":"双汇火腿肠","price":"￥1.50","count":"500支"}];
var html='<div class="row bg" style="color: red"><h4 class="title">食品推荐</h4></div>';
html+='<div class="row bg">';
for(var i=0;i<json.length;i++)
{
html+='<div class="col-xs-5 col2">';
html+='<img src='+json[i].pic+' alt="" class="img-responsive img">';
html+=' <div class="row"><h>'+json[i].name+'</h></div>';
html+='<div class="row">';
html+='<div class="ll"><h style="color:red">'+json[i].price+'</h></div>';
html+='<div class="rr"><h style="color:red">'+json[i].count+'</h></div>';
html+='</div></div>';
}
html+='</div>';
$("#lists").append(html);
}

$.loadthird=function(){
var json=[{"pic":"image/yagao.jpg","name":"佳洁士牙膏","price":"￥3.50","count":"200支"},{"pic":"image/xifalu.jpg","name":"清扬洗发露","price":"￥23.0","count":"200瓶"},{"pic":"image/muyulu.jpg","name":"六神沐浴露","price":"￥25.0","count":"200瓶"},{"pic":"image/xishouye.jpg","name":"蓝月亮洗手液","price":"￥15.0","count":"200瓶"}];
var html='<div class="row bg" style="color: red"><h4 class="title">洗漱推荐</h4></div>';
html+='<div class="row bg">';
for(var i=0;i<json.length;i++)
{
html+='<div class="col-xs-5 col2">';
html+='<img src='+json[i].pic+' alt="" class="img-responsive img">';
html+=' <div class="row"><h>'+json[i].name+'</h></div>';
html+='<div class="row">';
html+='<div class="ll"><h style="color:red">'+json[i].price+'</h></div>';
html+='<div class="rr"><h style="color:red">'+json[i].count+'</h></div>';
html+='</div></div>';
}
html+='</div>';
$("#lists").append(html);
}
*/
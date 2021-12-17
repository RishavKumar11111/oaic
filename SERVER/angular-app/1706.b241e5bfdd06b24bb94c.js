"use strict";(self.webpackChunkangular_application=self.webpackChunkangular_application||[]).push([[1706],{1706:(k,d,i)=>{i.r(d),i.d(d,{StockModule:()=>x});var l=i(8583),g=i(6901),Z=i(4762),t=i(639),u=i(4495),p=i(5620),f=i(9344),s=i(665);function T(o,e){if(1&o&&(t.TgZ(0,"option",11),t._uU(1),t.qZA()),2&o){const n=e.$implicit;t.Q6J("ngValue",n),t.xp6(1),t.Oqu(n)}}function h(o,e){1&o&&t._UZ(0,"div",12)}function m(o,e){if(1&o&&(t.TgZ(0,"div",15),t._uU(1),t.qZA()),2&o){const n=t.oxw(2);t.xp6(1),t.hij(" No record found on financial year ",n.fin_year,". ")}}function v(o,e){if(1&o&&(t.TgZ(0,"tr"),t.TgZ(1,"td"),t._uU(2),t.qZA(),t.TgZ(3,"td"),t._uU(4,"F.M."),t.qZA(),t.TgZ(5,"td"),t._uU(6),t.qZA(),t.TgZ(7,"td"),t._uU(8),t.qZA(),t.TgZ(9,"td"),t._uU(10),t.qZA(),t.TgZ(11,"td"),t._uU(12),t.qZA(),t.TgZ(13,"td"),t._uU(14),t.qZA(),t.TgZ(15,"td"),t._uU(16),t.qZA(),t.TgZ(17,"td"),t._uU(18),t.qZA(),t.qZA()),2&o){const n=e.$implicit,a=e.index;t.xp6(2),t.Oqu(a+1),t.xp6(4),t.Oqu(n.implement),t.xp6(2),t.Oqu(n.make),t.xp6(2),t.Oqu(n.model),t.xp6(2),t.Oqu(n.engine_no||"-"),t.xp6(2),t.Oqu(n.chassic_no||"-"),t.xp6(2),t.Oqu(n.in||"-"),t.xp6(2),t.Oqu(n.out||"-")}}function _(o,e){if(1&o&&(t.TgZ(0,"div"),t.TgZ(1,"div",16),t.TgZ(2,"table",17),t._UZ(3,"caption"),t.TgZ(4,"thead"),t.TgZ(5,"tr"),t.TgZ(6,"th",18),t._uU(7,"SL."),t.qZA(),t.TgZ(8,"th",18),t._uU(9,"System"),t.qZA(),t.TgZ(10,"th",18),t._uU(11,"Implement"),t.qZA(),t.TgZ(12,"th",18),t._uU(13,"Make"),t.qZA(),t.TgZ(14,"th",18),t._uU(15,"Model"),t.qZA(),t.TgZ(16,"th",18),t._uU(17,"Engine no."),t.qZA(),t.TgZ(18,"th",18),t._uU(19,"Chassic no."),t.qZA(),t.TgZ(20,"th",18),t._uU(21,"In"),t.qZA(),t.TgZ(22,"th",18),t._uU(23,"Out"),t.qZA(),t.qZA(),t.qZA(),t.TgZ(24,"tbody"),t.YNc(25,v,19,8,"tr",19),t.qZA(),t.qZA(),t.qZA(),t.qZA()),2&o){const n=t.oxw(2);t.xp6(25),t.Q6J("ngForOf",n.stockData)}}function A(o,e){if(1&o&&(t.TgZ(0,"div",0),t.TgZ(1,"div",1),t.TgZ(2,"span"),t.TgZ(3,"strong"),t.TgZ(4,"label"),t._uU(5,"ITEMS"),t.qZA(),t.qZA(),t.qZA(),t.qZA(),t.TgZ(6,"div"),t.YNc(7,m,2,1,"div",13),t.YNc(8,_,26,1,"div",14),t.qZA(),t.qZA()),2&o){const n=t.oxw();t.xp6(7),t.Q6J("ngIf",0==n.stockData.length),t.xp6(1),t.Q6J("ngIf",0!=n.stockData.length)}}const q=[{path:"",component:(()=>{class o{constructor(n,a,r){this.layoutService=n,this.service=a,this.toastr=r,this.showDetails=!1,this.loader=!1,this.fin_year="",this.fin_year_list=[],this.stockData=[],this.loadFinYear=()=>(0,Z.mG)(this,void 0,void 0,function*(){this.fin_year_list=yield this.service.get("/api/getFinYear"),this.loadStock()}),this.loadStock=()=>(0,Z.mG)(this,void 0,void 0,function*(){this.loader=!0,this.stockData=yield this.service.get("/accountant/getAllStocks?fin_year="+this.fin_year),this.showDetails=!0,this.stockData.forEach(c=>{"delivered_to_customer"==c.status?c.out="OUT":c.in="IN"}),this.loader=!1}),this.layoutService.setBreadcrumb("Miscellaneous expences"),this.loadFinYear()}ngOnInit(){}}return o.\u0275fac=function(n){return new(n||o)(t.Y36(u.P),t.Y36(p.v),t.Y36(f._W))},o.\u0275cmp=t.Xpm({type:o,selectors:[["app-stock"]],decls:18,vars:4,consts:[[1,"mybox"],[1,"mybox-header"],[1,"middle"],[1,"row"],[1,"col-lg-4"],[1,"form-control",3,"ngModel","ngModelChange","change"],["value","","disabled",""],[3,"ngValue",4,"ngFor","ngForOf"],[1,"loader"],["class","spinner-border text-info",4,"ngIf"],["class","mybox",4,"ngIf"],[3,"ngValue"],[1,"spinner-border","text-info"],["class","no-record",4,"ngIf"],[4,"ngIf"],[1,"no-record"],[1,"table-responsive"],["id","orderListTable",1,"table","table-striped","table-bordered","table-hover",2,"text-align","center"],["scope","col"],[4,"ngFor","ngForOf"]],template:function(n,a){1&n&&(t.TgZ(0,"div",0),t.TgZ(1,"div",1),t.TgZ(2,"span"),t.TgZ(3,"strong"),t.TgZ(4,"label"),t._uU(5,"STOCK"),t.qZA(),t.qZA(),t.qZA(),t.qZA(),t.TgZ(6,"div",2),t.TgZ(7,"div",3),t.TgZ(8,"div",4),t.TgZ(9,"label"),t._uU(10,"Financial year :"),t.qZA(),t.TgZ(11,"select",5),t.NdJ("ngModelChange",function(c){return a.fin_year=c})("change",function(){return a.loadStock()}),t.TgZ(12,"option",6),t._uU(13,"--Select--"),t.qZA(),t.YNc(14,T,2,2,"option",7),t.qZA(),t.qZA(),t.qZA(),t.qZA(),t.qZA(),t.TgZ(15,"div",8),t.YNc(16,h,1,0,"div",9),t.qZA(),t.YNc(17,A,9,2,"div",10)),2&n&&(t.xp6(11),t.Q6J("ngModel",a.fin_year),t.xp6(3),t.Q6J("ngForOf",a.fin_year_list),t.xp6(2),t.Q6J("ngIf",a.loader),t.xp6(1),t.Q6J("ngIf",a.showDetails))},directives:[s.EJ,s.JJ,s.On,s.YN,s.Kr,l.sg,l.O5],styles:[""]}),o})()}];let S=(()=>{class o{}return o.\u0275fac=function(n){return new(n||o)},o.\u0275mod=t.oAB({type:o}),o.\u0275inj=t.cJS({imports:[[g.Bz.forChild(q)],g.Bz]}),o})(),x=(()=>{class o{}return o.\u0275fac=function(n){return new(n||o)},o.\u0275mod=t.oAB({type:o}),o.\u0275inj=t.cJS({imports:[[l.ez,S,s.u5]]}),o})()}}]);
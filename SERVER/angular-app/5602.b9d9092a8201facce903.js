"use strict";(self.webpackChunkangular_application=self.webpackChunkangular_application||[]).push([[5602],{5913:(T,p,l)=>{l.d(p,{I:()=>o,K:()=>_});var u=l(639);let o=(()=>{class c{constructor(){this._printStyle=[],this.useExistingCss=!1,this.printDelay=0,this._styleSheetFile=""}set printStyle(n){for(let e in n)n.hasOwnProperty(e)&&this._printStyle.push((e+JSON.stringify(n[e])).replace(/['"]+/g,""));this.returnStyleValues()}returnStyleValues(){return`<style> ${this._printStyle.join(" ").replace(/,/g,";")} </style>`}set styleSheetFile(n){let e=function(r){return`<link rel="stylesheet" type="text/css" href="${r}">`};if(-1!==n.indexOf(",")){const r=n.split(",");for(let g of r)this._styleSheetFile=this._styleSheetFile+e(g)}else this._styleSheetFile=e(n)}returnStyleSheetLinkTags(){return this._styleSheetFile}getElementTag(n){const e=[],r=document.getElementsByTagName(n);for(let g=0;g<r.length;g++)e.push(r[g].outerHTML);return e.join("\r\n")}getFormData(n){for(var e=0;e<n.length;e++)n[e].defaultValue=n[e].value,n[e].checked&&(n[e].defaultChecked=!0)}getHtmlContents(){let n=document.getElementById(this.printSectionId),e=n.getElementsByTagName("input");this.getFormData(e);let r=n.getElementsByTagName("textarea");return this.getFormData(r),n.innerHTML}print(){let n,e,r="",g="";const h=this.getElementTag("base");this.useExistingCss&&(r=this.getElementTag("style"),g=this.getElementTag("link")),n=this.getHtmlContents(),e=window.open("","_blank","top=0,left=0,height=auto,width=auto"),e.document.open(),e.document.write(`\n      <html>\n        <head>\n          <title>${this.printTitle?this.printTitle:""}</title>\n          ${h}\n          ${this.returnStyleValues()}\n          ${this.returnStyleSheetLinkTags()}\n          ${r}\n          ${g}\n        </head>\n        <body>\n          ${n}\n          <script defer>\n            function triggerPrint(event) {\n              window.removeEventListener('load', triggerPrint, false);\n              setTimeout(function() {\n                closeWindow(window.print());\n              }, ${this.printDelay});\n            }\n            function closeWindow(){\n                window.close();\n            }\n            window.addEventListener('load', triggerPrint, false);\n          <\/script>\n        </body>\n      </html>`),e.document.close()}}return c.\u0275fac=function(n){return new(n||c)},c.\u0275dir=u.lG2({type:c,selectors:[["button","ngxPrint",""]],hostBindings:function(n,e){1&n&&u.NdJ("click",function(){return e.print()})},inputs:{useExistingCss:"useExistingCss",printDelay:"printDelay",printStyle:"printStyle",styleSheetFile:"styleSheetFile",printSectionId:"printSectionId",printTitle:"printTitle"}}),c})(),_=(()=>{class c{}return c.\u0275fac=function(n){return new(n||c)},c.\u0275mod=u.oAB({type:c}),c.\u0275inj=u.cJS({imports:[[]]}),c})()},5602:(T,p,l)=>{l.r(p),l.d(p,{PaymentsModule:()=>b});var u=l(8583),o=l(4466),_=l(665),c=l(5913),d=l(6901),n=l(4762),e=l(639),r=l(4495),g=l(5620),h=l(1841),Z=l(1879);function v(i,m){1&i&&e._UZ(0,"div",9)}function A(i,m){if(1&i&&(e.TgZ(0,"div",13),e._uU(1),e.qZA()),2&i){const s=e.oxw(2);e.xp6(1),e.hij(" No record found on financial year ",s.fin_year,". ")}}function x(i,m){if(1&i&&(e.TgZ(0,"tr"),e.TgZ(1,"td"),e._uU(2),e.qZA(),e.TgZ(3,"td"),e._uU(4),e.ALo(5,"date"),e.qZA(),e.TgZ(6,"td"),e._uU(7),e.qZA(),e.TgZ(8,"td"),e._uU(9),e.qZA(),e.TgZ(10,"td"),e._uU(11),e.qZA(),e.TgZ(12,"td"),e._uU(13),e.qZA(),e.TgZ(14,"td"),e._uU(15),e.ALo(16,"number"),e.qZA(),e.TgZ(17,"td"),e._uU(18),e.ALo(19,"number"),e.qZA(),e.qZA()),2&i){const s=m.$implicit,f=m.index;e.xp6(2),e.Oqu(f+1),e.xp6(2),e.Oqu(e.xi3(5,8,s.date,"dd-MM-y")),e.xp6(3),e.Oqu(s.system),e.xp6(2),e.Oqu(s.reference_no),e.xp6(2),e.Oqu(s.perticulars),e.xp6(2),e.Oqu(s.to),e.xp6(2),e.Oqu(e.lcZ(16,11,s.debit)),e.xp6(3),e.Oqu(e.lcZ(19,13,s.balance))}}function C(i,m){if(1&i&&(e.TgZ(0,"div"),e.TgZ(1,"div",14),e.TgZ(2,"table",15),e._UZ(3,"caption"),e.TgZ(4,"thead"),e.TgZ(5,"tr"),e.TgZ(6,"th",16),e._uU(7,"SL."),e.qZA(),e.TgZ(8,"th",17),e._uU(9,"Date"),e.qZA(),e.TgZ(10,"th",16),e._uU(11,"System"),e.qZA(),e.TgZ(12,"th",16),e._uU(13,"Reference no."),e.qZA(),e.TgZ(14,"th",16),e._uU(15,"Particulars"),e.qZA(),e.TgZ(16,"th",16),e._uU(17,"To"),e.qZA(),e.TgZ(18,"th",16),e._uU(19,"Debit(\u20b9)"),e.qZA(),e.TgZ(20,"th",16),e._uU(21,"Balance(\u20b9)"),e.qZA(),e.qZA(),e.qZA(),e.TgZ(22,"tbody"),e.YNc(23,x,20,15,"tr",18),e.TgZ(24,"tr"),e._UZ(25,"td"),e._UZ(26,"td"),e._UZ(27,"td"),e._UZ(28,"td"),e._UZ(29,"td"),e.TgZ(30,"td",19),e.TgZ(31,"strong"),e._uU(32,"Total (\u20b9)"),e.qZA(),e.qZA(),e.TgZ(33,"td",20),e._uU(34),e.ALo(35,"number"),e.qZA(),e._UZ(36,"td"),e.qZA(),e.qZA(),e.qZA(),e.qZA(),e.qZA()),2&i){const s=e.oxw(2);e.xp6(23),e.Q6J("ngForOf",s.ledgers),e.xp6(11),e.Oqu(e.lcZ(35,2,s.totalDebit))}}function E(i,m){if(1&i&&(e.TgZ(0,"div",0),e.TgZ(1,"div",1),e.TgZ(2,"div",3),e._UZ(3,"div",10),e.TgZ(4,"div",10),e.TgZ(5,"strong"),e.TgZ(6,"label"),e._uU(7,"PAYMENTS"),e.qZA(),e.qZA(),e.qZA(),e._UZ(8,"div",10),e.qZA(),e.qZA(),e.TgZ(9,"div"),e.YNc(10,A,2,1,"div",11),e.YNc(11,C,37,4,"div",12),e.qZA(),e.qZA()),2&i){const s=e.oxw();e.xp6(10),e.Q6J("ngIf",0==s.ledgers.length),e.xp6(1),e.Q6J("ngIf",0!=s.ledgers.length)}}const M=[{path:"",component:(()=>{class i{constructor(s,f,P){this.layoutService=s,this.service=f,this.http=P,this.showTable=!1,this.loader=!1,this.ledgers=[],this.loadTable=()=>(0,n.mG)(this,void 0,void 0,function*(){this.loader=!0;let y=yield this.service.get("/accountant/getAllDebitLedgersForPayments?dist_id="+this.dist_id+"&fin_year="+this.fin_year);this.loader=!1,this.showTable=!0,this.ledgers=y;let a=y;this.totalCredit=0,this.totalDebit=0,a.filter(t=>t.date=new Date(t.date)),a.sort((t,U)=>U.date-t.date);for(let t=0;t<a.length;t++)switch(a[t].debit=a[t].ammount,this.totalDebit+=parseInt(a[t].debit),a[t].balance=0==t?a[t].ammount:parseInt(a[t-1].balance)+parseInt(a[t].debit),a[t].purpose){case"pay_against_expenditure":a[t].perticulars=`Pay against ${a[t].schem_name}\n                            on ${a[t].head_name}\n                            on ${a[t].subhead_name}`,a[t].links=!1;break;case"pay_against_expenditure_jn":a[t].perticulars=`\n                            Head : ${a[t].head_name},\n                            Sub_head : ${a[t].subhead_name} \n                             JALANIDHHI`,a[t].links=!1;break;case"pay_against_bill":a[t].perticulars=`Pay against bill to ${a[t].to}, FARM MECHANISATION`,a[t].links=!1;break;case"pay_against_bill_jn":a[t].perticulars=`Pay against bill to ${a[t].to}, JALANIDHI`,a[t].links=!1;break;case"paid_opening_balance":a[t].perticulars=`Pay against ${a[t].system}\n                            on ${a[t].head}\n                            on ${a[t].subhead}\n                            (Backlog money)`,a[t].links=!1}}),this.layoutService.setBreadcrumb("Cashbook / Payments"),this.dist_id=s.getDistrictID()}ngOnInit(){}changeFinancialYear(s){this.fin_year=s,this.loadTable(),this.header=!0}}return i.\u0275fac=function(s){return new(s||i)(e.Y36(r.P),e.Y36(g.v),e.Y36(h.eN))},i.\u0275cmp=e.Xpm({type:i,selectors:[["app-cash-book-payments"]],decls:13,vars:2,consts:[[1,"mybox"],[1,"mybox-header"],[1,"middle"],[1,"row"],[1,"col-lg-3"],[3,"newItemEvent"],[1,"loader"],["class","spinner-border text-info",4,"ngIf"],["class","mybox",4,"ngIf"],[1,"spinner-border","text-info"],[1,"col-lg-4","col-md-4","col-sm-4","col-xs-4"],["class","no-record",4,"ngIf"],[4,"ngIf"],[1,"no-record"],[1,"table-responsive"],["id","orderListTable",1,"table","table-striped","table-bordered","table-hover",2,"text-align","center"],["scope","col"],["scope","col",2,"width","10%"],[4,"ngFor","ngForOf"],[2,"text-align","right"],[2,"width","20%"]],template:function(s,f){1&s&&(e.TgZ(0,"div",0),e.TgZ(1,"div",1),e.TgZ(2,"span"),e.TgZ(3,"strong"),e.TgZ(4,"label"),e._uU(5,"ALL PAYMENTS"),e.qZA(),e.qZA(),e.qZA(),e.qZA(),e.TgZ(6,"div",2),e.TgZ(7,"div",3),e.TgZ(8,"div",4),e.TgZ(9,"app-financial-year",5),e.NdJ("newItemEvent",function(y){return f.changeFinancialYear(y)}),e.qZA(),e.qZA(),e.qZA(),e.qZA(),e.qZA(),e.TgZ(10,"div",6),e.YNc(11,v,1,0,"div",7),e.qZA(),e.YNc(12,E,12,2,"div",8)),2&s&&(e.xp6(11),e.Q6J("ngIf",f.loader),e.xp6(1),e.Q6J("ngIf",f.showTable))},directives:[Z.L,u.O5,u.sg],pipes:[u.JJ,u.uU],styles:[""]}),i})()}];let D=(()=>{class i{}return i.\u0275fac=function(s){return new(s||i)},i.\u0275mod=e.oAB({type:i}),i.\u0275inj=e.cJS({imports:[[d.Bz.forChild(M)],d.Bz]}),i})(),b=(()=>{class i{}return i.\u0275fac=function(s){return new(s||i)},i.\u0275mod=e.oAB({type:i}),i.\u0275inj=e.cJS({imports:[[u.ez,o.m,_.u5,c.K,D]]}),i})()},1879:(T,p,l)=>{l.d(p,{L:()=>e});var u=l(4762),o=l(639),_=l(5620),c=l(665),d=l(8583);function n(r,g){if(1&r&&(o.TgZ(0,"option",3),o._uU(1),o.qZA()),2&r){const h=g.$implicit;o.Q6J("ngValue",h),o.xp6(1),o.Oqu(h)}}let e=(()=>{class r{constructor(h){this.service=h,this.financialYear="",this.financialYearList=[],this.newItemEvent=new o.vpe,this.loadFinancialYear=()=>(0,u.mG)(this,void 0,void 0,function*(){this.financialYearList=yield this.service.get("/api/getFinYear"),this.financialYear=this.financialYearList[0],this.changeFinancialYear()}),this.loadFinancialYear()}ngOnInit(){}changeFinancialYear(){this.newItemEvent.emit(this.financialYear)}}return r.\u0275fac=function(h){return new(h||r)(o.Y36(_.v))},r.\u0275cmp=o.Xpm({type:r,selectors:[["app-financial-year"]],outputs:{newItemEvent:"newItemEvent"},decls:6,vars:2,consts:[[1,"form-control",3,"ngModel","ngModelChange","change"],["value","","disabled",""],[3,"ngValue",4,"ngFor","ngForOf"],[3,"ngValue"]],template:function(h,Z){1&h&&(o.TgZ(0,"label"),o._uU(1,"Financial year :"),o.qZA(),o.TgZ(2,"select",0),o.NdJ("ngModelChange",function(A){return Z.financialYear=A})("change",function(){return Z.changeFinancialYear()}),o.TgZ(3,"option",1),o._uU(4,"--Select--"),o.qZA(),o.YNc(5,n,2,2,"option",2),o.qZA()),2&h&&(o.xp6(2),o.Q6J("ngModel",Z.financialYear),o.xp6(3),o.Q6J("ngForOf",Z.financialYearList))},directives:[c.EJ,c.JJ,c.On,c.YN,c.Kr,d.sg],styles:[""]}),r})()},4466:(T,p,l)=>{l.d(p,{m:()=>c});var u=l(8583),o=l(665),_=l(639);let c=(()=>{class d{}return d.\u0275fac=function(e){return new(e||d)},d.\u0275mod=_.oAB({type:d}),d.\u0275inj=_.cJS({imports:[[u.ez,o.u5]]}),d})()}}]);
"use strict";(self.webpackChunkangular_application=self.webpackChunkangular_application||[]).push([[8654],{5913:(A,f,a)=>{a.d(f,{I:()=>e,K:()=>_});var Z=a(639);let e=(()=>{class u{constructor(){this._printStyle=[],this.useExistingCss=!1,this.printDelay=0,this._styleSheetFile=""}set printStyle(o){for(let i in o)o.hasOwnProperty(i)&&this._printStyle.push((i+JSON.stringify(o[i])).replace(/['"]+/g,""));this.returnStyleValues()}returnStyleValues(){return`<style> ${this._printStyle.join(" ").replace(/,/g,";")} </style>`}set styleSheetFile(o){let i=function(l){return`<link rel="stylesheet" type="text/css" href="${l}">`};if(-1!==o.indexOf(",")){const l=o.split(",");for(let r of l)this._styleSheetFile=this._styleSheetFile+i(r)}else this._styleSheetFile=i(o)}returnStyleSheetLinkTags(){return this._styleSheetFile}getElementTag(o){const i=[],l=document.getElementsByTagName(o);for(let r=0;r<l.length;r++)i.push(l[r].outerHTML);return i.join("\r\n")}getFormData(o){for(var i=0;i<o.length;i++)o[i].defaultValue=o[i].value,o[i].checked&&(o[i].defaultChecked=!0)}getHtmlContents(){let o=document.getElementById(this.printSectionId),i=o.getElementsByTagName("input");this.getFormData(i);let l=o.getElementsByTagName("textarea");return this.getFormData(l),o.innerHTML}print(){let o,i,l="",r="";const h=this.getElementTag("base");this.useExistingCss&&(l=this.getElementTag("style"),r=this.getElementTag("link")),o=this.getHtmlContents(),i=window.open("","_blank","top=0,left=0,height=auto,width=auto"),i.document.open(),i.document.write(`\n      <html>\n        <head>\n          <title>${this.printTitle?this.printTitle:""}</title>\n          ${h}\n          ${this.returnStyleValues()}\n          ${this.returnStyleSheetLinkTags()}\n          ${l}\n          ${r}\n        </head>\n        <body>\n          ${o}\n          <script defer>\n            function triggerPrint(event) {\n              window.removeEventListener('load', triggerPrint, false);\n              setTimeout(function() {\n                closeWindow(window.print());\n              }, ${this.printDelay});\n            }\n            function closeWindow(){\n                window.close();\n            }\n            window.addEventListener('load', triggerPrint, false);\n          <\/script>\n        </body>\n      </html>`),i.document.close()}}return u.\u0275fac=function(o){return new(o||u)},u.\u0275dir=Z.lG2({type:u,selectors:[["button","ngxPrint",""]],hostBindings:function(o,i){1&o&&Z.NdJ("click",function(){return i.print()})},inputs:{useExistingCss:"useExistingCss",printDelay:"printDelay",printStyle:"printStyle",styleSheetFile:"styleSheetFile",printSectionId:"printSectionId",printTitle:"printTitle"}}),u})(),_=(()=>{class u{}return u.\u0275fac=function(o){return new(o||u)},u.\u0275mod=Z.oAB({type:u}),u.\u0275inj=Z.cJS({imports:[[]]}),u})()},7543:(A,f,a)=>{a.d(f,{b:()=>l});var Z=a(8583),e=a(6901),_=a(639);const u=[];let c=(()=>{class r{}return r.\u0275fac=function(d){return new(d||r)},r.\u0275mod=_.oAB({type:r}),r.\u0275inj=_.cJS({imports:[[e.Bz.forChild(u)],e.Bz]}),r})();var o=a(5913),i=a(4466);let l=(()=>{class r{}return r.\u0275fac=function(d){return new(d||r)},r.\u0275mod=_.oAB({type:r}),r.\u0275inj=_.cJS({imports:[[Z.ez,c,o.K,i.m]]}),r})()},231:(A,f,a)=>{a.d(f,{P:()=>s});var Z=a(4762),e=a(639),_=a(5620),u=a(9344),c=a(8583),o=a(6661);function i(n,m){if(1&n&&(e.TgZ(0,"div",24),e._uU(1),e._UZ(2,"br"),e._uU(3),e._UZ(4,"br"),e._uU(5),e._UZ(6,"br"),e.qZA()),2&n){const t=e.oxw();e.xp6(1),e.hij(" ",t.paymentDetails[0].farmer_name," "),e.xp6(2),e.hij(" FARMER ID: ",t.paymentDetails[0].farmer_id,", "),e.xp6(2),e.HOy(" ",t.paymentDetails[0].dist_name,", ",t.paymentDetails[0].block_name,", ",t.paymentDetails[0].gp_name,", ",t.paymentDetails[0].village_name," ")}}function l(n,m){if(1&n&&(e.TgZ(0,"div",24),e._uU(1),e._UZ(2,"br"),e._uU(3),e._UZ(4,"br"),e._uU(5),e._UZ(6,"br"),e._uU(7),e.qZA()),2&n){const t=e.oxw();e.xp6(1),e.hij(" Legal Name of Customer: ",t.CustomerDetails.LegalCustomerName," "),e.xp6(2),e.hij(" Trade Name: ",t.CustomerDetails.TradeName," "),e.xp6(2),e.hij(" Contact Number: ",t.CustomerDetails.ContactNumber," "),e.xp6(2),e.hij(" E-MailID: ",t.CustomerDetails.EmailID," ")}}function r(n,m){if(1&n&&(e.TgZ(0,"div",24),e._uU(1),e._UZ(2,"br"),e._uU(3),e._UZ(4,"br"),e._uU(5),e._UZ(6,"br"),e.qZA()),2&n){const t=e.oxw();e.xp6(1),e.hij(" ",t.paymentDetails[0].farmer_name," "),e.xp6(2),e.hij(" FARMER ID: ",t.paymentDetails[0].farmer_id,", "),e.xp6(2),e.HOy(" ",t.paymentDetails[0].dist_name,", ",t.paymentDetails[0].block_name,", ",t.paymentDetails[0].gp_name,", ",t.paymentDetails[0].village_name," ")}}function h(n,m){if(1&n&&(e.TgZ(0,"div",24),e._uU(1),e._UZ(2,"br"),e._uU(3),e._UZ(4,"br"),e._uU(5),e._UZ(6,"br"),e._uU(7),e.qZA()),2&n){const t=e.oxw();e.xp6(1),e.hij(" Legal Name of Customer: ",t.CustomerDetails.LegalCustomerName," "),e.xp6(2),e.hij(" Trade Name: ",t.CustomerDetails.TradeName," "),e.xp6(2),e.hij(" Contact Number: ",t.CustomerDetails.ContactNumber," "),e.xp6(2),e.hij(" E-MailID: ",t.CustomerDetails.EmailID," ")}}function d(n,m){if(1&n&&(e.ynx(0),e._uU(1),e._UZ(2,"br"),e._uU(3),e.BQk()),2&n){const t=e.oxw().$implicit;e.xp6(1),e.hij(" Engine No.: ",t.EngineNumber," "),e.xp6(2),e.hij(" Chasis No.: ",t.ChassicNumber," ")}}function T(n,m){if(1&n&&(e.TgZ(0,"tr"),e.TgZ(1,"td"),e._uU(2),e.qZA(),e.TgZ(3,"td"),e._uU(4),e.qZA(),e.TgZ(5,"td",27),e._uU(6),e._UZ(7,"br"),e._uU(8),e._UZ(9,"br"),e._uU(10),e._UZ(11,"br"),e.YNc(12,d,4,2,"ng-container",28),e.qZA(),e.TgZ(13,"td"),e._uU(14),e.qZA(),e._UZ(15,"td"),e.TgZ(16,"td"),e._uU(17),e.ALo(18,"number"),e.qZA(),e.TgZ(19,"td"),e._uU(20),e.qZA(),e.TgZ(21,"td"),e._uU(22),e.ALo(23,"number"),e.qZA(),e.TgZ(24,"td"),e._uU(25),e.ALo(26,"number"),e.qZA(),e.TgZ(27,"td"),e._uU(28),e.ALo(29,"number"),e.qZA(),e.qZA()),2&n){const t=m.$implicit,p=m.index;e.xp6(2),e.hij(" ",p+1," "),e.xp6(2),e.hij(" ",t.MRRNo," "),e.xp6(2),e.hij(" Product Category: ",t.Implement,""),e.xp6(2),e.hij(" Manufacturer: ",t.Make,""),e.xp6(2),e.hij(" Model/Item: ",t.Model,""),e.xp6(2),e.Q6J("ngIf",t.EngineNumber),e.xp6(2),e.hij(" ",t.ItemQuantity," "),e.xp6(3),e.hij(" ",e.xi3(18,12,t.TotalSellTaxableValue,"1.2-2")," "),e.xp6(3),e.hij(" ",t.TaxRate,"% "),e.xp6(2),e.hij(" ",e.xi3(23,15,t.TotalSellCGST,"1.2-2")," "),e.xp6(3),e.hij(" ",e.xi3(26,18,t.TotalSellSGST,"1.2-2")," "),e.xp6(3),e.hij(" ",e.xi3(29,21,t.TotalSellInvoiceValue,"1.2-2")," ")}}let s=(()=>{class n{constructor(t,p){this.service=t,this.toastr=p,this.invoice_list=[],this.payList={},this.indent_no="",this.indent_date="",this.invoice_no="",this.invoice_date="",this.indent_amount="",this.invoice_amount="",this.remark="",this.subTotal="",this.paid_amount="",this.deduction_amount="",this.pay_now=0,this.dl={},this.less_cgst="",this.less_sgst="",this.invoice_items=[],this.gst_rate="",this.paymentDetails=[],this.DMDetails=[],this.AccountantDetails=[],this.CustomerDetails=[],this.showIndent=()=>(0,Z.mG)(this,void 0,void 0,function*(){try{this.paymentDetails=this.payList,this.quantity=this.paymentDetails[0].ItemQuantity,this.POType=this.paymentDetails[0].POType,this.AccountantDetails=yield this.service.get("/accountant/getAccName"),this.DMDetails=yield this.service.get("/accountant/getDMDetails"),this.CustomerDetails=yield this.service.get(`/accountant/getCustomerDetailsForInvoice?CustomerID=${this.paymentDetails[0].CustomerID}`)}catch(U){console.error(U)}}),this.showInvoice=()=>(0,Z.mG)(this,void 0,void 0,function*(){})}ngOnInit(){this.showIndent()}}return n.\u0275fac=function(t){return new(t||n)(e.Y36(_.v),e.Y36(u._W))},n.\u0275cmp=e.Xpm({type:n,selectors:[["app-vendor-payment-approval"]],inputs:{invoice_list:"invoice_list",payList:"payList",selectedApproval:"selectedApproval"},decls:129,vars:19,consts:[["id","invoice"],[1,"card"],[1,"card-body"],["align","center",1,"card-title"],[1,"card-text"],[1,"row",2,"border","1px solid","margin-bottom","0"],[1,"col-8",2,"border-right","1px solid"],[1,"row"],[1,"col-3"],["src","assets/images/oaic-new-logo.png","alt","",2,"width","100%"],[1,"col-9"],[2,"text-align","center","font-weight","bold","white-space","nowrap","margin-left","-6%"],[2,"text-align","center"],[1,"col-4"],[2,"border-bottom","1px solid","height","80px"],[2,"padding","2%"],[1,"row",2,"border-left","1px solid","border-bottom","1px solid","border-right","1px solid","margin-bottom","0"],[1,"col-6",2,"border-right","1px solid"],[1,"heading"],["class","body",4,"ngIf"],[1,"col-6"],["id","indentListTable",1,"table","table-bordered","table-hover"],["scope","col"],[4,"ngFor","ngForOf"],[1,"body"],[2,"font-weight","bold"],[2,"font-size","large"],[2,"text-align","left"],[4,"ngIf"]],template:function(t,p){1&t&&(e.TgZ(0,"div",0),e.TgZ(1,"div",1),e.TgZ(2,"div",2),e._UZ(3,"h5",3),e.TgZ(4,"div",4),e.TgZ(5,"div"),e.TgZ(6,"div",5),e.TgZ(7,"div",6),e.TgZ(8,"div",7),e.TgZ(9,"div",8),e._UZ(10,"img",9),e.qZA(),e.TgZ(11,"div",10),e.TgZ(12,"h5",11),e._uU(13,"THE ODISHA AGRO INDUSTRIES CORPORATION LTD"),e.qZA(),e.TgZ(14,"p",12),e._uU(15,"(A Government of Odisha Undertaking) Regd. Office: 95, Satyanagar, Bhubaneswar-751007 "),e._UZ(16,"br"),e._uU(17," www.orissaagro.com "),e.qZA(),e._UZ(18,"br"),e.TgZ(19,"h6",12),e._uU(20,"OFFICE OF THE DISTRICT MANAGER, "),e.qZA(),e.TgZ(21,"p",12),e._UZ(22,"br"),e._uU(23),e.qZA(),e.qZA(),e.qZA(),e.qZA(),e.TgZ(24,"div",13),e.TgZ(25,"div",14),e.TgZ(26,"h3",12),e._uU(27,"VENDOR PAYMENT APPROVAL"),e.qZA(),e.qZA(),e.TgZ(28,"div",15),e._UZ(29,"br"),e.TgZ(30,"h6"),e._uU(31,"Approval No. : "),e._UZ(32,"br"),e._uU(33," Approval Date: "),e.qZA(),e.qZA(),e.qZA(),e.qZA(),e.TgZ(34,"div",16),e.TgZ(35,"div",17),e.TgZ(36,"div",18),e.TgZ(37,"h6"),e._uU(38,"BUYER/BILL TO"),e.qZA(),e.qZA(),e.YNc(39,i,7,6,"div",19),e.YNc(40,l,8,4,"div",19),e.qZA(),e.TgZ(41,"div",20),e.TgZ(42,"div",18),e.TgZ(43,"h6"),e._uU(44,"CONSIGNEE/SHIP TO"),e.qZA(),e.qZA(),e.YNc(45,r,7,6,"div",19),e.YNc(46,h,8,4,"div",19),e.qZA(),e.qZA(),e.TgZ(47,"div",16),e.TgZ(48,"table",21),e._UZ(49,"caption"),e.TgZ(50,"thead"),e.TgZ(51,"tr"),e.TgZ(52,"th",22),e._uU(53,"Sl No"),e.qZA(),e.TgZ(54,"th",22),e._uU(55,"MRR No."),e.qZA(),e.TgZ(56,"th",22),e._uU(57,"Description of Goods"),e.qZA(),e.TgZ(58,"th",22),e._uU(59,"Quantity"),e.qZA(),e._UZ(60,"th",22),e.TgZ(61,"th",22),e._uU(62,"Taxable Value (\u20b9)"),e.qZA(),e.TgZ(63,"th",22),e._uU(64,"GST Rate"),e.qZA(),e.TgZ(65,"th",22),e._uU(66,"CGST (\u20b9)"),e.qZA(),e.TgZ(67,"th",22),e._uU(68,"SGST (\u20b9)"),e.qZA(),e.TgZ(69,"th",22),e._uU(70,"Invoice Value (\u20b9)"),e.qZA(),e.qZA(),e.qZA(),e.TgZ(71,"tbody"),e.YNc(72,T,30,24,"tr",23),e.TgZ(73,"tr"),e._UZ(74,"td"),e._UZ(75,"td"),e._UZ(76,"td"),e.TgZ(77,"td"),e.TgZ(78,"strong"),e._uU(79,"Total(\u20b9)"),e.qZA(),e.qZA(),e._UZ(80,"td"),e._UZ(81,"td"),e._UZ(82,"td"),e._UZ(83,"td"),e._UZ(84,"td"),e.TgZ(85,"td"),e._uU(86),e.ALo(87,"number"),e.qZA(),e.qZA(),e.qZA(),e.qZA(),e.qZA(),e.TgZ(88,"div",16),e.TgZ(89,"div",17),e.TgZ(90,"div"),e.TgZ(91,"h6"),e._uU(92,"BANK DETAILS"),e.qZA(),e.qZA(),e.TgZ(93,"div",24),e._uU(94),e._UZ(95,"br"),e._uU(96),e._UZ(97,"br"),e._uU(98),e._UZ(99,"br"),e._uU(100),e._UZ(101,"br"),e.qZA(),e.qZA(),e.TgZ(102,"div",20),e.TgZ(103,"div"),e.TgZ(104,"h5",25),e._uU(105),e.ALo(106,"amountToWord"),e.qZA(),e.qZA(),e.qZA(),e.qZA(),e.TgZ(107,"div",16),e.TgZ(108,"h5"),e._uU(109,"Terms & Conditions."),e.qZA(),e.TgZ(110,"ol",26),e.TgZ(111,"li"),e._uU(112,"Title and Risk to Goods shall pass on to the Buyer upon Delivery at Delivery Point."),e.qZA(),e.TgZ(113,"li"),e._uU(114,"The Seller shall not be responsible for delay in dispatch of the goods on account of any reason whatsoever unless otherwise confirmed by the authorised officer of the seller in writing."),e.qZA(),e.TgZ(115,"li"),e._uU(116,"The seller shall not be liable to the original purchaser or any third party for incidental, indirect, consequential or special damages due to the failure on the part of the Buyer."),e.qZA(),e.TgZ(117,"li"),e._uU(118,"No guarantee, express or implied is given that the materials supplied is suitable for use under any specified conditions or for any specific purposes although such conditions or such purpose may be known to the Seller nor is any guarantee given as to the life or wear of the materials."),e.qZA(),e.TgZ(119,"li"),e._uU(120,"No cancellation, suspension or modification of orders by the Buyer can be accepted unless special circumstances exist."),e.qZA(),e.TgZ(121,"li"),e._uU(122,"The Buyer shall be deemed to have accepted Goods on Delivery and it shall not reject the Goods thereafter. Provided it shall be duty of the Buyer to inform to the Seller about the defects in the delivered Goods within three days from the Delivery, else the Seller shall be discharged from all liabilities related to supply of the Goods."),e.qZA(),e.TgZ(123,"li"),e._uU(124,"The Buyer shall pay to the Seller by means of Cheques / Demand Drafts /Pay Orders or by electronic transfer of funds."),e.qZA(),e.TgZ(125,"li"),e._uU(126,"The Buyer shall be held responsible for all expenses, loss, damages or any other expenses, whatsoever incurred by the Seller due to the failure on the part of the Buyer to clear the documents forwarded through bank or take delivery of the goods from the carriers or failure to perform any of the terms or the order."),e.qZA(),e.qZA(),e.qZA(),e.qZA(),e.qZA(),e.qZA(),e.qZA(),e._UZ(127,"br"),e._UZ(128,"br"),e.qZA()),2&t&&(e.xp6(23),e.lnq(" Email-ID: ",p.DMDetails.EmailID," , Contact Number: ",p.DMDetails.dm_mobile_no," / ",p.AccountantDetails.acc_mobile_no," "),e.xp6(16),e.Q6J("ngIf","Subsidy"==p.POType),e.xp6(1),e.Q6J("ngIf","NonSubsidy"==p.POType),e.xp6(5),e.Q6J("ngIf","Subsidy"==p.POType),e.xp6(1),e.Q6J("ngIf","NonSubsidy"==p.POType),e.xp6(26),e.Q6J("ngForOf",p.paymentDetails),e.xp6(14),e.Oqu(e.xi3(87,14,p.paymentDetails[0].TotalSellInvoiceValue,"1.2-2")),e.xp6(8),e.hij(" Account No.: ",p.DMDetails.AccountNumber," "),e.xp6(2),e.hij(" Bank Name: ",p.DMDetails.BankName," "),e.xp6(2),e.hij(" Branch: ",p.DMDetails.BranchName," "),e.xp6(2),e.hij(" IFSC: ",p.DMDetails.IFSCCode," "),e.xp6(5),e.hij(" ",e.lcZ(106,17,p.paymentDetails[0].TotalSellInvoiceValue)," Only /-"))},directives:[c.O5,c.sg],pipes:[c.JJ,o.z],styles:[""]}),n})()},1879:(A,f,a)=>{a.d(f,{L:()=>i});var Z=a(4762),e=a(639),_=a(5620),u=a(665),c=a(8583);function o(l,r){if(1&l&&(e.TgZ(0,"option",3),e._uU(1),e.qZA()),2&l){const h=r.$implicit;e.Q6J("ngValue",h),e.xp6(1),e.Oqu(h)}}let i=(()=>{class l{constructor(h){this.service=h,this.financialYear="",this.financialYearList=[],this.newItemEvent=new e.vpe,this.loadFinancialYear=()=>(0,Z.mG)(this,void 0,void 0,function*(){this.financialYearList=yield this.service.get("/api/getFinYear"),this.financialYear=this.financialYearList[0],this.changeFinancialYear()}),this.loadFinancialYear()}ngOnInit(){}changeFinancialYear(){this.newItemEvent.emit(this.financialYear)}}return l.\u0275fac=function(h){return new(h||l)(e.Y36(_.v))},l.\u0275cmp=e.Xpm({type:l,selectors:[["app-financial-year"]],outputs:{newItemEvent:"newItemEvent"},decls:6,vars:2,consts:[[1,"form-control",3,"ngModel","ngModelChange","change"],["value","","disabled",""],[3,"ngValue",4,"ngFor","ngForOf"],[3,"ngValue"]],template:function(h,d){1&h&&(e.TgZ(0,"label"),e._uU(1,"Financial year :"),e.qZA(),e.TgZ(2,"select",0),e.NdJ("ngModelChange",function(s){return d.financialYear=s})("change",function(){return d.changeFinancialYear()}),e.TgZ(3,"option",1),e._uU(4,"--Select--"),e.qZA(),e.YNc(5,o,2,2,"option",2),e.qZA()),2&h&&(e.xp6(2),e.Q6J("ngModel",d.financialYear),e.xp6(3),e.Q6J("ngForOf",d.financialYearList))},directives:[u.EJ,u.JJ,u.On,u.YN,u.Kr,c.sg],styles:[""]}),l})()},6661:(A,f,a)=>{a.d(f,{z:()=>e});var Z=a(639);let e=(()=>{class _{transform(c,o){if(c){let b=(c=parseFloat(c).toFixed(2)).toString().split("."),g=b[0],v=b.length>0?b[1]:null;var i=["Zero","One","Two","Three","Four","Five","Six","Seven","Eight","Nine"],l=["Ten","Eleven","Twelve","Thirteen","Fourteen","Fifteen","Sixteen","Seventeen","Eighteen","Nineteen"],r=["","Ten","Twenty","Thirty","Forty","Fifty","Sixty","Seventy","Eighty","Ninety"],h=function(y,D){return 0==y?"":" "+(1==y?l[D]:r[y])},d=function(y,D,E){return(0!=y&&1!=D?" "+i[y]:"")+(0!=D||y>0?" "+E:"")},T="",s=0,n=0,m=0,t=[],p=[],U="";if(g+="",isNaN(parseFloat(g)))T="";else if(parseFloat(g)>0&&g.length<=10){for(s=g.length-1;s>=0;s--)switch(n=g[s]-0,m=s>0?g[s-1]-0:0,g.length-s-1){case 0:t.push(d(n,m,""));break;case 1:t.push(h(n,g[s+1]));break;case 2:t.push(0!=n?" "+i[n]+" Hundred"+(0!=g[s+1]&&0!=g[s+2]?" and":""):"");break;case 3:t.push(d(n,m,"Thousand"));break;case 4:t.push(h(n,g[s+1]));break;case 5:t.push(d(n,m,"Lakh"));break;case 6:t.push(h(n,g[s+1]));break;case 7:t.push(d(n,m,"Crore"));break;case 8:t.push(h(n,g[s+1]));break;case 9:t.push(0!=n?" "+i[n]+" Hundred"+(0!=g[s+1]||0!=g[s+2]?" and":" Crore"):"")}T=t.reverse().join("")}else T="";if(T&&(T=`${T} Rupees`),"00"!=v){for(s=0,n=0,m=0,s=v.length-1;s>=0;s--)switch(n=v[s]-0,m=s>0?v[s-1]-0:0,v.length-s-1){case 0:p.push(d(n,m,""));break;case 1:p.push(h(n,v[s+1]))}U=p.reverse().join(""),T=T?`${T} and ${U} Paisa`:`${U} Paisa`}return T}}}return _.\u0275fac=function(c){return new(c||_)},_.\u0275pipe=Z.Yjl({name:"amountToWord",type:_,pure:!0}),_})()},4466:(A,f,a)=>{a.d(f,{m:()=>u});var Z=a(8583),e=a(665),_=a(639);let u=(()=>{class c{}return c.\u0275fac=function(i){return new(i||c)},c.\u0275mod=_.oAB({type:c}),c.\u0275inj=_.cJS({imports:[[Z.ez,e.u5]]}),c})()}}]);
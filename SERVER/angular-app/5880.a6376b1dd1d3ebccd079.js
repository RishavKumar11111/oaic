"use strict";(self.webpackChunkangular_application=self.webpackChunkangular_application||[]).push([[5880],{1879:(w,U,l)=>{l.d(U,{L:()=>q});var Z=l(4762),s=l(639),d=l(5620),v=l(665),c=l(8583);function e(f,P){if(1&f&&(s.TgZ(0,"option",3),s._uU(1),s.qZA()),2&f){const h=P.$implicit;s.Q6J("ngValue",h),s.xp6(1),s.Oqu(h)}}let q=(()=>{class f{constructor(h){this.service=h,this.financialYear="",this.financialYearList=[],this.newItemEvent=new s.vpe,this.loadFinancialYear=()=>(0,Z.mG)(this,void 0,void 0,function*(){this.financialYearList=yield this.service.get("/api/getFinYear"),this.financialYear=this.financialYearList[0],this.changeFinancialYear()}),this.loadFinancialYear()}ngOnInit(){}changeFinancialYear(){this.newItemEvent.emit(this.financialYear)}}return f.\u0275fac=function(h){return new(h||f)(s.Y36(d.v))},f.\u0275cmp=s.Xpm({type:f,selectors:[["app-financial-year"]],outputs:{newItemEvent:"newItemEvent"},decls:6,vars:2,consts:[[1,"form-control",3,"ngModel","ngModelChange","change"],["value","","disabled",""],[3,"ngValue",4,"ngFor","ngForOf"],[3,"ngValue"]],template:function(h,A){1&h&&(s.TgZ(0,"label"),s._uU(1,"Financial year :"),s.qZA(),s.TgZ(2,"select",0),s.NdJ("ngModelChange",function(_){return A.financialYear=_})("change",function(){return A.changeFinancialYear()}),s.TgZ(3,"option",1),s._uU(4,"--Select--"),s.qZA(),s.YNc(5,e,2,2,"option",2),s.qZA()),2&h&&(s.xp6(2),s.Q6J("ngModel",A.financialYear),s.xp6(3),s.Q6J("ngForOf",A.financialYearList))},directives:[v.EJ,v.JJ,v.On,v.YN,v.Kr,c.sg],styles:[""]}),f})()},6661:(w,U,l)=>{l.d(U,{z:()=>s});var Z=l(639);let s=(()=>{class d{transform(c,e){if(c){let Q=(c=parseFloat(c).toFixed(2)).toString().split("."),p=Q[0],M=Q.length>0?Q[1]:null;var q=["Zero","One","Two","Three","Four","Five","Six","Seven","Eight","Nine"],f=["Ten","Eleven","Twelve","Thirteen","Fourteen","Fifteen","Sixteen","Seventeen","Eighteen","Nineteen"],P=["","Ten","Twenty","Thirty","Forty","Fifty","Sixty","Seventy","Eighty","Ninety"],h=function(b,D){return 0==b?"":" "+(1==b?f[D]:P[b])},A=function(b,D,S){return(0!=b&&1!=D?" "+q[b]:"")+(0!=D||b>0?" "+S:"")},T="",_=0,u=0,O=0,g=[],k=[],N="";if(p+="",isNaN(parseFloat(p)))T="";else if(parseFloat(p)>0&&p.length<=10){for(_=p.length-1;_>=0;_--)switch(u=p[_]-0,O=_>0?p[_-1]-0:0,p.length-_-1){case 0:g.push(A(u,O,""));break;case 1:g.push(h(u,p[_+1]));break;case 2:g.push(0!=u?" "+q[u]+" Hundred"+(0!=p[_+1]&&0!=p[_+2]?" and":""):"");break;case 3:g.push(A(u,O,"Thousand"));break;case 4:g.push(h(u,p[_+1]));break;case 5:g.push(A(u,O,"Lakh"));break;case 6:g.push(h(u,p[_+1]));break;case 7:g.push(A(u,O,"Crore"));break;case 8:g.push(h(u,p[_+1]));break;case 9:g.push(0!=u?" "+q[u]+" Hundred"+(0!=p[_+1]||0!=p[_+2]?" and":" Crore"):"")}T=g.reverse().join("")}else T="";if(T&&(T=`${T} Rupees`),"00"!=M){for(_=0,u=0,O=0,_=M.length-1;_>=0;_--)switch(u=M[_]-0,O=_>0?M[_-1]-0:0,M.length-_-1){case 0:k.push(A(u,O,""));break;case 1:k.push(h(u,M[_+1]))}N=k.reverse().join(""),T=T?`${T} and ${N} Paisa`:`${N} Paisa`}return T}}}return d.\u0275fac=function(c){return new(c||d)},d.\u0275pipe=Z.Yjl({name:"amountToWord",type:d,pure:!0}),d})()},1410:(w,U,l)=>{l.d(U,{G:()=>s});var Z=l(639);let s=(()=>{class d{transform(c,e){return c?e?(e=e.toLowerCase(),c.filter(function(q){return JSON.stringify(q).toLowerCase().includes(e)})):c:null}}return d.\u0275fac=function(c){return new(c||d)},d.\u0275pipe=Z.Yjl({name:"search",type:d,pure:!0}),d})()},4466:(w,U,l)=>{l.d(U,{m:()=>v});var Z=l(8583),s=l(665),d=l(639);let v=(()=>{class c{}return c.\u0275fac=function(q){return new(q||c)},c.\u0275mod=d.oAB({type:c}),c.\u0275inj=d.cJS({imports:[[Z.ez,s.u5]]}),c})()},5880:(w,U,l)=>{l.r(U),l.d(U,{DeliverOrderModule:()=>ce});var Z=l(665),s=l(4466),d=l(8583),v=l(6901),c=l(4762),e=l(639),q=l(4495),f=l(5620),P=l(9344),h=l(5638),A=l(1879),T=l(4216),_=l(1410),u=l(6661);function O(n,a){if(1&n&&(e.TgZ(0,"option",26),e._uU(1),e.qZA()),2&n){const t=a.$implicit;e.Q6J("ngValue",t),e.xp6(1),e.Oqu(t.dist_name)}}const g=function(){return{standalone:!0}};function k(n,a){if(1&n){const t=e.EpF();e.TgZ(0,"app-normal-card"),e.ynx(1,17),e._uU(2,"Deliver Against Purchase Order(P.O.)"),e.BQk(),e.ynx(3,18),e.TgZ(4,"div",11),e.TgZ(5,"div",19),e.TgZ(6,"app-financial-year",20),e.NdJ("newItemEvent",function(o){return e.CHM(t),e.oxw().changeFinancialYear(o)}),e.qZA(),e.qZA(),e.TgZ(7,"div",21),e.TgZ(8,"label"),e._uU(9,"District :"),e.qZA(),e._UZ(10,"br"),e.TgZ(11,"select",22),e.NdJ("ngModelChange",function(o){return e.CHM(t),e.oxw().dist=o}),e.TgZ(12,"option",23),e._uU(13,"ALL"),e.qZA(),e.YNc(14,O,2,2,"option",24),e.qZA(),e.qZA(),e.TgZ(15,"div",21),e.TgZ(16,"label"),e._uU(17,"Search P.O. Number :"),e.qZA(),e.TgZ(18,"input",25),e.NdJ("ngModelChange",function(o){return e.CHM(t),e.oxw().searchPONo=o}),e.qZA(),e.qZA(),e.qZA(),e.BQk(),e.qZA()}if(2&n){const t=e.oxw();e.xp6(11),e.Q6J("ngModel",t.dist),e.xp6(3),e.Q6J("ngForOf",t.districts),e.xp6(4),e.Q6J("ngModel",t.searchPONo)("ngModelOptions",e.DdM(4,g))}}function N(n,a){1&n&&e._UZ(0,"div",27)}function Q(n,a){if(1&n&&(e.ynx(0,30),e._uU(1),e.BQk()),2&n){const t=e.oxw(2);e.xp6(1),e.hij("No record found on financial year ",t.fin_year,".")}}function p(n,a){if(1&n){const t=e.EpF();e.TgZ(0,"tr"),e.TgZ(1,"td"),e._uU(2),e.qZA(),e.TgZ(3,"td"),e._uU(4),e.ALo(5,"date"),e.qZA(),e.TgZ(6,"td"),e._uU(7),e.qZA(),e.TgZ(8,"td"),e._uU(9),e.qZA(),e.TgZ(10,"td"),e._uU(11),e.ALo(12,"number"),e.qZA(),e.TgZ(13,"td"),e.TgZ(14,"button",34),e.NdJ("click",function(){const r=e.CHM(t).$implicit;return e.oxw(3).loadList(r)}),e._UZ(15,"i",35),e.qZA(),e.qZA(),e.qZA()}if(2&n){const t=a.$implicit,i=a.index;e.xp6(2),e.Oqu(i+1),e.xp6(2),e.Oqu(e.xi3(5,5,t.ApprovedDate,"dd-MM-y")),e.xp6(3),e.Oqu(t.PONo),e.xp6(2),e.Oqu(t.NoOfItemsInPO),e.xp6(2),e.Oqu(e.xi3(12,8,t.POAmount,"1.2-2"))}}function M(n,a){if(1&n&&(e.ynx(0,18),e.TgZ(1,"table",31),e._UZ(2,"caption"),e.TgZ(3,"thead"),e.TgZ(4,"tr"),e.TgZ(5,"th",32),e._uU(6,"SL."),e.qZA(),e.TgZ(7,"th",32),e._uU(8,"Date"),e.qZA(),e.TgZ(9,"th",32),e._uU(10,"P.O. Number"),e.qZA(),e.TgZ(11,"th",32),e._uU(12,"No. of Items"),e.qZA(),e.TgZ(13,"th",32),e._uU(14,"Cost Involved"),e.qZA(),e.TgZ(15,"th",32),e._uU(16,"Action"),e.qZA(),e.qZA(),e.qZA(),e.TgZ(17,"tbody"),e.YNc(18,p,16,11,"tr",33),e.ALo(19,"search"),e.ALo(20,"search"),e.qZA(),e.qZA(),e.BQk()),2&n){const t=e.oxw(2);e.xp6(18),e.Q6J("ngForOf",e.xi3(19,1,e.xi3(20,4,t.indent_list,t.dist.dist_id),t.searchPONo))}}function b(n,a){if(1&n&&(e.TgZ(0,"app-table-card"),e.ynx(1,17),e._uU(2,"Purchase Order List"),e.BQk(),e.YNc(3,Q,2,1,"ng-container",28),e.YNc(4,M,21,7,"ng-container",29),e.qZA()),2&n){const t=e.oxw();e.xp6(3),e.Q6J("ngIf",0==t.indent_list.length),e.xp6(1),e.Q6J("ngIf",0!=t.indent_list.length)}}function D(n,a){if(1&n&&(e.ynx(0),e._uU(1),e.BQk()),2&n){const t=e.oxw(2).$implicit;e.xp6(1),e.lnq("( ",t.PackageSize," ",t.PackageUnitOfMeasurement," * ",t.PackageQuantity," )")}}function S(n,a){if(1&n&&(e.ynx(0),e.YNc(1,D,2,3,"ng-container",0),e.BQk()),2&n){const t=e.oxw().$implicit;e.xp6(1),e.Q6J("ngIf",t.PackageSize)}}function F(n,a){if(1&n&&(e.ynx(0),e._uU(1),e.BQk()),2&n){const t=e.oxw(2).$implicit;e.xp6(1),e.lnq("( ",t.PackageSize," ",t.PackageUnitOfMeasurement," * ",t.SupplyPackageQuantity," )")}}function E(n,a){if(1&n&&(e.ynx(0),e._uU(1),e._UZ(2,"br"),e._uU(3),e._UZ(4,"br"),e.YNc(5,F,2,3,"ng-container",0),e.BQk()),2&n){const t=e.oxw().$implicit;e.xp6(1),e.AsE(" Pending: ",t.PendingQuantity," ",t.UnitOfMeasurement," "),e.xp6(2),e.AsE(" Delivered: ",t.SupplyQuantity," ",t.UnitOfMeasurement,""),e.xp6(2),e.Q6J("ngIf",t.SupplyPackageQuantity)}}function J(n,a){if(1&n&&(e.ynx(0),e._uU(1),e.BQk()),2&n){const t=e.oxw().$implicit;e.xp6(1),e.AsE(" ",t.ItemQuantity," ",t.UnitOfMeasurement," ")}}function B(n,a){if(1&n){const t=e.EpF();e.TgZ(0,"tr",46),e.TgZ(1,"td"),e._uU(2),e.qZA(),e.TgZ(3,"td"),e._uU(4),e._UZ(5,"br"),e._uU(6),e._UZ(7,"br"),e._uU(8),e.qZA(),e.TgZ(9,"td"),e._uU(10),e._UZ(11,"br"),e.YNc(12,S,2,1,"ng-container",0),e.qZA(),e.TgZ(13,"td"),e.YNc(14,E,6,5,"ng-container",0),e.YNc(15,J,2,2,"ng-container",0),e.qZA(),e.TgZ(16,"td"),e._uU(17),e.ALo(18,"number"),e.qZA(),e.TgZ(19,"td"),e._uU(20),e._UZ(21,"br"),e._uU(22),e.ALo(23,"number"),e._UZ(24,"br"),e._uU(25),e.ALo(26,"number"),e.qZA(),e.TgZ(27,"td"),e._uU(28),e.ALo(29,"number"),e.qZA(),e.TgZ(30,"td"),e.TgZ(31,"button",47),e.NdJ("click",function(){const r=e.CHM(t).$implicit;return e.oxw(2).deliveryDetails(r)}),e._uU(32,"Deliver"),e.qZA(),e.qZA(),e.qZA()}if(2&n){const t=a.$implicit,i=a.index;e.Q6J("ngStyle",t.isDeliveredClass),e.xp6(2),e.Oqu(i+1),e.xp6(2),e.hij(" Product Category: ",t.Implement," "),e.xp6(2),e.hij(" Manufacturer: ",t.Make," "),e.xp6(2),e.hij(" Model/Item: ",t.Model,""),e.xp6(2),e.AsE("",t.ItemQuantity," ",t.UnitOfMeasurement,""),e.xp6(2),e.Q6J("ngIf",!("Tractor"==t.Implement||"Power tiller"==t.Implement)),e.xp6(2),e.Q6J("ngIf",!("Tractor"==t.Implement||"Power tiller"==t.Implement)),e.xp6(1),e.Q6J("ngIf","Tractor"==t.Implement||"Power tiller"==t.Implement),e.xp6(2),e.Oqu(e.xi3(18,16,t.TotalPurchaseTaxableValue,"1.2-2")),e.xp6(3),e.hij(" Tax Rate: ",t.TaxRate,"% "),e.xp6(2),e.hij(" CGST: ",e.xi3(23,19,t.TotalPurchaseCGST,"1.2-2")," "),e.xp6(3),e.hij(" SGST: ",e.xi3(26,22,t.TotalPurchaseSGST,"1.2-2")," "),e.xp6(3),e.Oqu(e.xi3(29,25,t.TotalPurchaseInvoiceValue,"1.2-2")),e.xp6(3),e.Q6J("disabled",t.isDelivered)}}function Y(n,a){if(1&n){const t=e.EpF();e.TgZ(0,"button",44),e.NdJ("click",function(){return e.CHM(t),e.oxw(2).fillExtraFields()}),e._uU(1,"Next "),e._UZ(2,"i",35),e.qZA()}}function L(n,a){if(1&n){const t=e.EpF();e.TgZ(0,"div"),e.TgZ(1,"button",36),e.NdJ("click",function(){e.CHM(t);const o=e.oxw();return o.back1(),o.matchByPermitNo="",o.matchByFarmerName=""}),e._UZ(2,"i",37),e._uU(3," Back"),e.qZA(),e.TgZ(4,"strong",38),e._uU(5),e.qZA(),e.TgZ(6,"app-table-card"),e.ynx(7,17),e._uU(8,"Orders for Deliver"),e.BQk(),e.ynx(9,18),e.TgZ(10,"table",39),e._UZ(11,"caption"),e.TgZ(12,"thead"),e.TgZ(13,"tr"),e.TgZ(14,"th",32),e._uU(15,"SL."),e.qZA(),e.TgZ(16,"th",32),e._uU(17,"Goods"),e.qZA(),e.TgZ(18,"th",32),e._uU(19,"P.O. Details"),e.qZA(),e.TgZ(20,"th",32),e._uU(21,"Supply Details"),e.qZA(),e.TgZ(22,"th",32),e._uU(23,"Taxable Value(\u20b9)"),e.qZA(),e.TgZ(24,"th",32),e._uU(25,"GST(\u20b9)"),e.qZA(),e.TgZ(26,"th",32),e._uU(27,"Invoice Value (\u20b9)"),e.qZA(),e.TgZ(28,"th",32),e._uU(29,"Action"),e.qZA(),e.qZA(),e.qZA(),e.TgZ(30,"tbody"),e.YNc(31,B,33,28,"tr",40),e.ALo(32,"search"),e.ALo(33,"search"),e.TgZ(34,"tr"),e._UZ(35,"td"),e.TgZ(36,"td",41),e.TgZ(37,"strong"),e._uU(38,"Total P.O. Amount(\u20b9):"),e.qZA(),e.qZA(),e.TgZ(39,"td",42),e.TgZ(40,"strong"),e._uU(41),e.ALo(42,"number"),e.qZA(),e.qZA(),e._UZ(43,"td"),e.qZA(),e.TgZ(44,"tr"),e._UZ(45,"td"),e.TgZ(46,"td",41),e.TgZ(47,"strong"),e._uU(48,"My Bill Amount(\u20b9):"),e.qZA(),e.qZA(),e.TgZ(49,"td",42),e.TgZ(50,"strong"),e._uU(51),e.ALo(52,"number"),e.qZA(),e.qZA(),e._UZ(53,"td"),e.qZA(),e.qZA(),e.qZA(),e.BQk(),e.ynx(54,43),e.TgZ(55,"button",44),e.NdJ("click",function(){e.CHM(t);const o=e.oxw();return o.back1(),o.matchByPermitNo="",o.matchByFarmerName=""}),e._UZ(56,"i",37),e._uU(57," Back"),e.qZA(),e.YNc(58,Y,3,0,"button",45),e.BQk(),e.qZA(),e.qZA()}if(2&n){const t=e.oxw();e.xp6(5),e.hij("Purchase Order number (P.O.): ",t.selected_indent,""),e.xp6(26),e.Q6J("ngForOf",e.xi3(32,5,e.xi3(33,8,t.allData,t.searchPermitNo),t.searchFarmerName)),e.xp6(10),e.Oqu(e.xi3(42,11,t.POAmount,"1.2-2")),e.xp6(10),e.Oqu(e.xi3(52,14,t.my_bill_ammout,"1.2-2")),e.xp6(7),e.Q6J("ngIf",0!=t.itemsForDeliver.length)}}function G(n,a){1&n&&(e.TgZ(0,"span",53),e._uU(1,"This invoice no is already generated."),e.qZA())}function j(n,a){if(1&n){const t=e.EpF();e.TgZ(0,"div"),e.TgZ(1,"button",36),e.NdJ("click",function(){return e.CHM(t),e.oxw().back2()}),e._UZ(2,"i",37),e._uU(3," Back"),e.qZA(),e.TgZ(4,"app-normal-card"),e.ynx(5,17),e._uU(6,"Enter Invoice Information"),e.BQk(),e.ynx(7,18),e.TgZ(8,"div",11),e.TgZ(9,"div",48),e.TgZ(10,"div",11),e.TgZ(11,"label",49),e._uU(12,"Invoice amount(\u20b9) :"),e.qZA(),e.TgZ(13,"div",49),e.TgZ(14,"strong"),e._uU(15),e.ALo(16,"number"),e.qZA(),e.qZA(),e.qZA(),e.qZA(),e.TgZ(17,"div",48),e.TgZ(18,"div",11),e.TgZ(19,"label",49),e._uU(20,"Purchase Order number :"),e.qZA(),e.TgZ(21,"div",49),e.TgZ(22,"strong"),e._uU(23),e.qZA(),e.qZA(),e.qZA(),e.qZA(),e.TgZ(24,"div",48),e.TgZ(25,"div",11),e.TgZ(26,"label",50),e._uU(27,"Discount / TPTN Rebate / Rebate of Loss or Gain:"),e.qZA(),e.TgZ(28,"input",51),e.NdJ("keyup",function(){return e.CHM(t),e.oxw().calculateFinalInvoiceAmount()})("ngModelChange",function(o){return e.CHM(t),e.oxw().discount=o}),e.qZA(),e.qZA(),e.qZA(),e.TgZ(29,"div",48),e.TgZ(30,"div",11),e.TgZ(31,"label",49),e._uU(32,"Purchase Order amount :"),e.qZA(),e.TgZ(33,"div",49),e.TgZ(34,"strong"),e._uU(35),e.ALo(36,"number"),e.qZA(),e.qZA(),e.qZA(),e.qZA(),e.TgZ(37,"div",48),e.TgZ(38,"div",11),e.TgZ(39,"label",49),e._uU(40,"Final Invoice amount(\u20b9) :"),e.qZA(),e.TgZ(41,"div",49),e.TgZ(42,"strong"),e._uU(43),e.ALo(44,"number"),e.qZA(),e.qZA(),e.qZA(),e.qZA(),e.qZA(),e.BQk(),e.qZA(),e.TgZ(45,"app-normal-card"),e.ynx(46,17),e._uU(47,"Enter Invoice Information"),e.BQk(),e.ynx(48,18),e.TgZ(49,"div",11),e.TgZ(50,"div",12),e.TgZ(51,"label",52),e._uU(52,"Invoice no."),e.TgZ(53,"span",53),e._uU(54,"*"),e.qZA(),e._uU(55," :"),e.qZA(),e.TgZ(56,"input",54),e.NdJ("ngModelChange",function(o){return e.CHM(t),e.oxw().invoice_no=o})("keyup",function(){return e.CHM(t),e.oxw().checkInvoiceNo()}),e.qZA(),e.YNc(57,G,2,0,"span",55),e.qZA(),e.TgZ(58,"div",12),e.TgZ(59,"label",56),e._uU(60,"Invoice date"),e.TgZ(61,"span",53),e._uU(62,"*"),e.qZA(),e._uU(63," :"),e.qZA(),e.TgZ(64,"input",57),e.NdJ("ngModelChange",function(o){return e.CHM(t),e.oxw().invoice_date=o}),e.ALo(65,"date"),e.qZA(),e.qZA(),e.TgZ(66,"div",12),e.TgZ(67,"label",58),e._uU(68,"Upload Invoice"),e.TgZ(69,"span",53),e._uU(70,"*"),e.qZA(),e._uU(71," :"),e.qZA(),e._UZ(72,"input",59),e.qZA(),e.TgZ(73,"div",12),e.TgZ(74,"label",60),e._uU(75,"Way bill no.:"),e.qZA(),e.TgZ(76,"input",61),e.NdJ("ngModelChange",function(o){return e.CHM(t),e.oxw().rr_way_bill_no=o}),e.qZA(),e.qZA(),e.TgZ(77,"div",12),e.TgZ(78,"label",62),e._uU(79,"Way bill date:"),e.qZA(),e.TgZ(80,"input",63),e.NdJ("ngModelChange",function(o){return e.CHM(t),e.oxw().rr_way_bill_date=o}),e.ALo(81,"date"),e.qZA(),e.qZA(),e.qZA(),e.BQk(),e.ynx(82,43),e.TgZ(83,"button",44),e.NdJ("click",function(){return e.CHM(t),e.oxw().back2()}),e._UZ(84,"i",37),e._uU(85," Back"),e.qZA(),e.TgZ(86,"button",44),e.NdJ("click",function(){return e.CHM(t),e.oxw().invoicePreview()}),e._uU(87,"Confirm"),e.qZA(),e.BQk(),e.qZA(),e.qZA()}if(2&n){const t=e.oxw();e.xp6(15),e.Oqu(e.xi3(16,17,t.my_bill_ammout,"1.2-2")),e.xp6(8),e.Oqu(t.selected_indent),e.xp6(5),e.Q6J("ngModel",t.discount)("ngModelOptions",e.DdM(32,g)),e.xp6(7),e.hij(" \u20b9 ",e.xi3(36,20,t.POAmount,"1.2-2"),""),e.xp6(8),e.Oqu(e.xi3(44,23,t.finalInvoiceAmount,"1.2-2")),e.xp6(13),e.Q6J("ngModel",t.invoice_no)("ngModelOptions",e.DdM(33,g)),e.xp6(1),e.Q6J("ngIf",t.check_invoice_no),e.xp6(7),e.s9C("max",e.xi3(65,26,t.c_date,"y-MM-dd")),e.Q6J("ngModel",t.invoice_date)("ngModelOptions",e.DdM(34,g)),e.xp6(12),e.Q6J("ngModel",t.rr_way_bill_no)("ngModelOptions",e.DdM(35,g)),e.xp6(4),e.s9C("max",e.xi3(81,29,t.c_date,"y-MM-dd")),e.Q6J("ngModel",t.rr_way_bill_date)("ngModelOptions",e.DdM(36,g))}}function R(n,a){if(1&n&&(e.ynx(0),e._uU(1),e._UZ(2,"br"),e._uU(3),e.BQk()),2&n){const t=e.oxw().$implicit;e.xp6(1),e.hij(" Engine No: ",t.EngineNumber," "),e.xp6(2),e.hij(" Chassic No: ",t.ChassicNumber," ")}}function V(n,a){if(1&n&&(e.ynx(0),e._uU(1),e.BQk()),2&n){const t=e.oxw(2).$implicit;e.xp6(1),e.lnq("( ",t.PackageSize," ",t.PackageUnitOfMeasurement," * ",t.PackageQuantity," )")}}function $(n,a){if(1&n&&(e.ynx(0),e.YNc(1,V,2,3,"ng-container",0),e.BQk()),2&n){const t=e.oxw().$implicit;e.xp6(1),e.Q6J("ngIf",t.PackageSize)}}function H(n,a){if(1&n&&(e.ynx(0),e._uU(1),e.BQk()),2&n){const t=e.oxw(2).$implicit;e.xp6(1),e.lnq("( ",t.PackageSize," ",t.PackageUnitOfMeasurement," * ",t.SupplyPackageQuantity," )")}}function W(n,a){if(1&n&&(e.ynx(0),e._uU(1),e._UZ(2,"br"),e._uU(3),e._UZ(4,"br"),e.YNc(5,H,2,3,"ng-container",0),e.BQk()),2&n){const t=e.oxw().$implicit;e.xp6(1),e.AsE(" Pending: ",t.PendingQuantity," ",t.UnitOfMeasurement," "),e.xp6(2),e.AsE(" Delivered: ",t.SupplyQuantity," ",t.UnitOfMeasurement,""),e.xp6(2),e.Q6J("ngIf",t.PackageSize)}}function z(n,a){if(1&n&&(e.ynx(0),e._uU(1),e.BQk()),2&n){const t=e.oxw().$implicit;e.xp6(1),e.hij(" ",t.ItemQuantity," ")}}function K(n,a){if(1&n&&(e.TgZ(0,"tr"),e.TgZ(1,"td"),e._uU(2),e.qZA(),e.TgZ(3,"td",70),e._uU(4),e._UZ(5,"br"),e._uU(6),e._UZ(7,"br"),e._uU(8),e._UZ(9,"br"),e.YNc(10,R,4,2,"ng-container",0),e.qZA(),e.TgZ(11,"td"),e._uU(12),e._UZ(13,"br"),e.YNc(14,$,2,1,"ng-container",0),e.qZA(),e.TgZ(15,"td"),e.YNc(16,W,6,5,"ng-container",0),e.YNc(17,z,2,1,"ng-container",0),e.qZA(),e.TgZ(18,"td"),e._uU(19),e.ALo(20,"number"),e.qZA(),e.TgZ(21,"td"),e._uU(22),e._UZ(23,"br"),e._uU(24),e.ALo(25,"number"),e._UZ(26,"br"),e._uU(27),e.ALo(28,"number"),e.qZA(),e.TgZ(29,"td"),e._uU(30),e.ALo(31,"number"),e.qZA(),e.qZA()),2&n){const t=a.$implicit,i=a.index,o=e.oxw(2);e.xp6(2),e.Oqu(i+1),e.xp6(2),e.hij(" Implement: ",t.Implement," "),e.xp6(2),e.hij(" Make: ",t.Make," "),e.xp6(2),e.hij(" Model: ",t.Model," "),e.xp6(2),e.Q6J("ngIf","Tractor"==o.order.Implement||"Power tiller"==o.order.Implement),e.xp6(2),e.AsE("",t.ItemQuantity," ",t.UnitOfMeasurement,""),e.xp6(2),e.Q6J("ngIf",!("Tractor"==t.Implement||"Power tiller"==t.Implement)),e.xp6(2),e.Q6J("ngIf",!("Tractor"==t.Implement||"Power tiller"==t.Implement)),e.xp6(1),e.Q6J("ngIf","Tractor"==t.Implement||"Power tiller"==t.Implement),e.xp6(2),e.Oqu(e.xi3(20,15,t.TotalPurchaseTaxableValue,"1.2-2")),e.xp6(3),e.hij(" Tax Rate: ",t.TaxRate,"% "),e.xp6(2),e.hij(" CGST: ",e.xi3(25,18,t.TotalPurchaseCGST,"1.2-2")," "),e.xp6(3),e.hij(" SGST: ",e.xi3(28,21,t.TotalPurchaseSGST,"1.2-2")," "),e.xp6(3),e.Oqu(e.xi3(31,24,t.TotalPurchaseInvoiceValue,"1.2-2"))}}function X(n,a){if(1&n){const t=e.EpF();e.TgZ(0,"div"),e.TgZ(1,"button",36),e.NdJ("click",function(){return e.CHM(t),e.oxw().back3()}),e._UZ(2,"i",37),e._uU(3," Back"),e.qZA(),e.TgZ(4,"div",11),e.TgZ(5,"div",49),e.TgZ(6,"app-table-card"),e.ynx(7,17),e._uU(8,"Invoice Detail"),e.BQk(),e.ynx(9,18),e.TgZ(10,"table",31),e._UZ(11,"thead"),e.TgZ(12,"tbody"),e.TgZ(13,"tr"),e.TgZ(14,"td"),e._uU(15,"P.O. No."),e.qZA(),e.TgZ(16,"td"),e._uU(17),e.qZA(),e.qZA(),e.TgZ(18,"tr"),e.TgZ(19,"td"),e._uU(20,"Invoice No"),e.qZA(),e.TgZ(21,"td"),e._uU(22),e.qZA(),e.qZA(),e.TgZ(23,"tr"),e.TgZ(24,"td"),e._uU(25,"Invoice Date"),e.qZA(),e.TgZ(26,"td"),e._uU(27),e.ALo(28,"date"),e.qZA(),e.qZA(),e.TgZ(29,"tr"),e.TgZ(30,"td"),e._uU(31,"Way Bill No"),e.qZA(),e.TgZ(32,"td"),e._uU(33),e.qZA(),e.qZA(),e.TgZ(34,"tr"),e.TgZ(35,"td"),e._uU(36,"Way Bill Date"),e.qZA(),e.TgZ(37,"td"),e._uU(38),e.ALo(39,"date"),e.qZA(),e.qZA(),e.qZA(),e.qZA(),e.BQk(),e.qZA(),e.qZA(),e.TgZ(40,"div",49),e.TgZ(41,"app-table-card"),e.ynx(42,17),e._uU(43,"Receiver Detail (Bill To)"),e.BQk(),e.ynx(44,18),e.TgZ(45,"table",31),e._UZ(46,"thead"),e.TgZ(47,"tbody"),e.TgZ(48,"tr"),e.TgZ(49,"td"),e._uU(50,"District:"),e.qZA(),e.TgZ(51,"td"),e._uU(52),e.qZA(),e.qZA(),e.TgZ(53,"tr"),e.TgZ(54,"td"),e._uU(55,"DM:"),e.qZA(),e.TgZ(56,"td"),e._uU(57),e.qZA(),e.qZA(),e.TgZ(58,"tr"),e.TgZ(59,"td"),e._uU(60,"Address:"),e.qZA(),e.TgZ(61,"td"),e._uU(62),e.qZA(),e.qZA(),e.TgZ(63,"tr"),e.TgZ(64,"td"),e._uU(65,"Mobile no.:"),e.qZA(),e.TgZ(66,"td"),e._uU(67),e.qZA(),e.qZA(),e.qZA(),e.qZA(),e.BQk(),e.qZA(),e.qZA(),e.TgZ(68,"div",64),e.TgZ(69,"app-table-card"),e.ynx(70,17),e._uU(71,"Item Detail"),e.BQk(),e.ynx(72,18),e.TgZ(73,"table",65),e._UZ(74,"caption"),e.TgZ(75,"thead"),e.TgZ(76,"tr"),e.TgZ(77,"th",32),e._uU(78,"SL."),e.qZA(),e.TgZ(79,"th",32),e._uU(80,"Description of goods and service"),e.qZA(),e.TgZ(81,"th",32),e._uU(82,"P.O. Details"),e.qZA(),e.TgZ(83,"th",32),e._uU(84,"Supply Details"),e.qZA(),e.TgZ(85,"th",32),e._uU(86,"Taxable Value(\u20b9)"),e.qZA(),e.TgZ(87,"th",32),e._uU(88,"GST(\u20b9)"),e.qZA(),e.TgZ(89,"th",32),e._uU(90,"Invoice value (\u20b9)"),e.qZA(),e.qZA(),e.qZA(),e.TgZ(91,"tbody"),e.YNc(92,K,32,27,"tr",33),e.TgZ(93,"tr"),e.TgZ(94,"td",66),e._uU(95,"Bill amount (\u20b9) "),e.qZA(),e.TgZ(96,"td",67),e.TgZ(97,"strong"),e._uU(98),e.ALo(99,"number"),e.qZA(),e.qZA(),e.qZA(),e.TgZ(100,"tr"),e.TgZ(101,"td",66),e._uU(102,"Discount / TPTN Rebate / Rebate of Loss or Gain "),e.qZA(),e.TgZ(103,"td",67),e.TgZ(104,"strong"),e._uU(105),e.ALo(106,"number"),e.qZA(),e.qZA(),e.qZA(),e.TgZ(107,"tr"),e.TgZ(108,"td",66),e._uU(109,"Final Invoice Amount "),e.qZA(),e.TgZ(110,"td",67),e.TgZ(111,"strong"),e._uU(112),e.ALo(113,"number"),e.qZA(),e.qZA(),e.qZA(),e.TgZ(114,"tr"),e.TgZ(115,"td",68),e.TgZ(116,"strong"),e._uU(117),e.ALo(118,"amountToWord"),e.qZA(),e.qZA(),e.qZA(),e.qZA(),e.qZA(),e.BQk(),e.ynx(119,43),e.TgZ(120,"button",44),e.NdJ("click",function(){return e.CHM(t),e.oxw().back3()}),e._UZ(121,"i",37),e._uU(122," Back"),e.qZA(),e.TgZ(123,"button",69),e.NdJ("click",function(){e.CHM(t);const o=e.oxw();return o.generateInvoice(),o.clicked=!0}),e._uU(124,"Confirm"),e.qZA(),e.BQk(),e.qZA(),e.qZA(),e.qZA(),e.qZA()}if(2&n){const t=e.oxw();e.xp6(17),e.Oqu(t.selected_indent),e.xp6(5),e.Oqu(t.invoice_no),e.xp6(5),e.Oqu(e.xi3(28,15,t.invoice_date,"dd/MM/y")),e.xp6(6),e.Oqu(t.rr_way_bill_no||"--"),e.xp6(5),e.Oqu(e.xi3(39,18,t.rr_way_bill_date,"dd-MM-y")),e.xp6(14),e.Oqu(t.dmDetails.dist_name),e.xp6(5),e.Oqu(t.dmDetails.dm_name),e.xp6(5),e.Oqu(t.dmDetails.dm_address||"--"),e.xp6(5),e.Oqu(t.dmDetails.dm_mobile_no||"--"),e.xp6(25),e.Q6J("ngForOf",t.invoiceItems),e.xp6(6),e.Oqu(e.xi3(99,21,t.my_bill_ammout,"1.2-2")),e.xp6(7),e.Oqu(e.xi3(106,24,t.discount,"1.2-2")),e.xp6(7),e.Oqu(e.xi3(113,27,t.finalInvoiceAmount,"1.2-2")),e.xp6(5),e.hij("",e.lcZ(118,30,t.finalInvoiceAmount)," rupees only /-"),e.xp6(6),e.Q6J("disabled",t.clicked)}}function ee(n,a){if(1&n&&(e.TgZ(0,"div",11),e.TgZ(1,"div",12),e._uU(2,"Delivered Quantity:"),e.qZA(),e.TgZ(3,"div",13),e._uU(4),e.qZA(),e.qZA()),2&n){const t=e.oxw();e.xp6(4),e.Oqu(t.order.DeliveredQuantity)}}function te(n,a){if(1&n&&(e.TgZ(0,"div",11),e.TgZ(1,"div",12),e._uU(2,"Pending Quantity :"),e.qZA(),e.TgZ(3,"div",13),e._uU(4),e.qZA(),e.qZA()),2&n){const t=e.oxw();e.xp6(4),e.Oqu(t.order.PendingQuantity)}}function ne(n,a){if(1&n){const t=e.EpF();e.TgZ(0,"div",11),e.TgZ(1,"div",12),e._uU(2,"Deliver Quantity :"),e.qZA(),e.TgZ(3,"div",13),e.TgZ(4,"input",71),e.NdJ("ngModelChange",function(o){return e.CHM(t),e.oxw().deliver_quantity=o}),e.qZA(),e.TgZ(5,"small",72),e._uU(6),e._UZ(7,"br"),e._uU(8),e.qZA(),e.qZA(),e.qZA()}if(2&n){const t=e.oxw();e.xp6(4),e.Q6J("ngModel",t.deliver_quantity),e.xp6(2),e.hij(" Ordered package size is ",t.order.PackageSize," "),e.xp6(2),e.hij(" Enter a valid qunaitity which is divisible by ",t.order.PackageSize," ")}}function ie(n,a){if(1&n){const t=e.EpF();e.TgZ(0,"div",11),e.TgZ(1,"div",12),e._uU(2,"Engine no."),e.TgZ(3,"span",53),e._uU(4,"*"),e.qZA(),e._uU(5," :"),e.qZA(),e.TgZ(6,"div",13),e.TgZ(7,"input",73),e.NdJ("ngModelChange",function(o){return e.CHM(t),e.oxw().engine_no=o}),e.qZA(),e.qZA(),e.qZA()}if(2&n){const t=e.oxw();e.xp6(7),e.Q6J("ngModel",t.engine_no)}}function re(n,a){if(1&n){const t=e.EpF();e.TgZ(0,"div",11),e.TgZ(1,"div",12),e._uU(2,"Chassic no."),e.TgZ(3,"span",53),e._uU(4,"*"),e.qZA(),e._uU(5," :"),e.qZA(),e.TgZ(6,"div",13),e.TgZ(7,"input",74),e.NdJ("ngModelChange",function(o){return e.CHM(t),e.oxw().chassic_no=o}),e.qZA(),e.qZA(),e.qZA()}if(2&n){const t=e.oxw();e.xp6(7),e.Q6J("ngModel",t.chassic_no)}}const oe=[{path:"",component:(()=>{class n{constructor(t,i,o){this.layoutService=t,this.service=i,this.toastr=o,this.discount=0,this.finalInvoiceAmount=0,this.clicked=!1,this.dl_id="document.querySelector('meta[name=\"dl_id\"]').getAttribute('content')",this.c_date=new Date,this.fin_year="",this.first_box=!0,this.show_indent_list=!1,this.show_order_list=!1,this.show_print_page=!1,this.show_extra_fields=!1,this.loader=!1,this.generateInvoiceStatus=!0,this.itemsForDeliver=[],this.my_bill_ammout=0,this.dmDetails={},this.order={},this.allData=[],this.hideRows=[],this.invoiceItems=[],this.searchPONo="",this.searchFarmerName="",this.searchPermitNo="",this.dist="",this.districts=[],this.indent_list=[],this.loadDists=()=>(0,c.mG)(this,void 0,void 0,function*(){this.show_indent_list=!1,this.show_order_list=!1,this.show_print_page=!1,this.show_extra_fields=!1,this.districts=yield this.service.get(`/dl/getDealerDists?fin_year=${this.fin_year}`)}),this.loadAllIndents=()=>(0,c.mG)(this,void 0,void 0,function*(){this.show_indent_list=!1,this.loader=!0,this.indent_list=yield this.service.get(`/dl/getAllDistIndent?fin_year=${this.fin_year}`),this.show_indent_list=!0,this.loader=!1}),this.fillExtraFields=()=>{this.show_order_list=!1,this.show_extra_fields=!0},this.checkInvoiceNo=()=>(0,c.mG)(this,void 0,void 0,function*(){this.check_invoice_no=yield this.service.get(`/dl/checkInvoiceNoIsExist?invoice_no=${this.invoice_no}`)}),this.back1=()=>{this.show_order_list=!1,this.show_indent_list=!0,this.first_box=!0,this.itemsForDeliver=[]},this.back2=()=>{this.show_extra_fields=!1,this.show_order_list=!0},this.back3=()=>{this.show_print_page=!1,this.show_extra_fields=!0},this.selectedPO={},this.loadList=r=>(0,c.mG)(this,void 0,void 0,function*(){this.selectedPO=r,this.DistrictID=r.DistrictID,this.show_indent_list=!1,this.loader=!0,this.my_bill_ammout=0,this.selected_indent=r.PONo,this.POAmount=r.POAmount,this.POType=r.POType,this.dmDetails=yield this.service.get("/dl/getDMDetails?dist_id="+this.DistrictID);const x=yield this.service.get("/dl/getIndentOrdersForDeliver?PONo="+r.PONo);this.show_order_list=!0,this.loader=!1,this.first_box=!1,this.itemsForDeliver=[],this.invoiceItems=[],this.noOfIndent=0,this.noOfInvoice=0,this.allData=x.filter((m,y)=>(m.SupplyQuantity=m.DeliveredQuantity,m.IsDelivered?(m.isDelivered=!0,m.isDeliveredClass={"background-color":"aquamarine"}):this.noOfIndent++,m))}),this.deliveryDetails=r=>{this.order=r,this.deliver_quantity=this.order.PendingQuantity},this.addDeliverItem=()=>{"Tractor"!=this.order.Implement&&"Power tiller"!=this.order.Implement||this.engine_no&&this.chassic_no?+this.deliver_quantity<=+this.order.PendingQuantity&&+this.deliver_quantity>0?(this.order.PendingQuantity=this.order.PendingQuantity-this.deliver_quantity,this.deliver_quantity==this.order.ItemQuantity?this.pushItem():this.order.PackageSize?this.calculatePackageQuantity():this.calculateItemWiseTax()):this.toastr.error(`Enter Quantity within ${this.order.PendingQuantity}`,"Quantity Exceed"):this.toastr.error("Please enter valid Engine No. & Chassic No.")},this.calculatePackageQuantity=()=>{const r=this.deliver_quantity,x=this.order.PackageSize,m=this.order.UnitOfMeasurement,y=this.order.PackageUnitOfMeasurement;let C=1;m==y?C=1:"Kilograms"==m&&"Gram"==y?C=1e3:"Metric Ton"==m&&"Gram"==y?C=1e6:"Metric Ton"==m&&"Kilograms"==y?C=1e3:"Tonnes"==m&&"Gram"==y?C=1e6:"Tonnes"==m&&"Kilograms"==y||"Liter"==m&&"Mililiter"==y?C=1e3:this.toastr.error("Selected unit not Mapped");const I=r*C/x;r*C%x==0?(this.order.SupplyPackageQuantity=I,this.order.TotalPurchaseTaxableValue=(this.order.PurchaseTaxableValue*I).toFixed(2),this.order.TotalPurchaseInvoiceValue=(this.order.PurchaseInvoiceValue*I).toFixed(2),this.order.TotalPurchaseCGST=(this.order.PurchaseCGST*I).toFixed(2),this.order.TotalPurchaseSGST=(this.order.PurchaseSGST*I).toFixed(2),this.order.TotalPurchaseIGST=(this.order.PurchaseIGST*I).toFixed(2),this.pushItem()):(this.toastr.error("Sorry, Please enter valid Quantity"),this.deliver_quantity=this.order.ItemQuantity)},this.calculateItemWiseTax=()=>{const r=this.deliver_quantity;this.order.SupplyPackageQuantity=0,this.order.TotalPurchaseTaxableValue=(this.order.PurchaseTaxableValue*r).toFixed(2),this.order.TotalPurchaseInvoiceValue=(this.order.PurchaseInvoiceValue*r).toFixed(2),this.order.TotalPurchaseCGST=(this.order.PurchaseCGST*r).toFixed(2),this.order.TotalPurchaseSGST=(this.order.PurchaseSGST*r).toFixed(2),this.order.TotalPurchaseIGST=(this.order.PurchaseIGST*r).toFixed(2),this.pushItem()},this.pushItem=()=>{this.finalInvoiceAmount=this.my_bill_ammout=this.my_bill_ammout+ +this.order.TotalPurchaseInvoiceValue;const r=this.allData.findIndex(x=>x.OrderReferenceNo==this.order.OrderReferenceNo);this.allData[r].isDelivered=!0,this.allData[r].isDeliveredClass={"background-color":"aquamarine"},this.allData[r].SupplyQuantity=this.deliver_quantity,this.itemsForDeliver.push({PONo:this.order.PONo,OrderReferenceNo:this.order.OrderReferenceNo,EngineNumber:this.engine_no,ChassicNumber:this.chassic_no,TotalPurchaseTaxableValue:this.order.TotalPurchaseTaxableValue,TotalPurchaseInvoiceValue:this.order.TotalPurchaseInvoiceValue,TotalPurchaseCGST:this.order.TotalPurchaseCGST,TotalPurchaseSGST:this.order.TotalPurchaseSGST,TotalPurchaseIGST:this.order.TotalPurchaseIGST,SupplyQuantity:this.deliver_quantity,SupplyPackageQuantity:this.order.SupplyPackageQuantity}),this.order.EngineNumber=this.engine_no,this.order.ChassicNumber=this.chassic_no,this.invoiceItems.push(this.order),this.engine_no="",this.chassic_no="",this.noOfInvoice++},this.calculateFinalInvoiceAmount=()=>{this.my_bill_ammout>this.discount?this.finalInvoiceAmount=this.my_bill_ammout-this.discount:(this.toastr.error(`Discount must be within ${this.my_bill_ammout}`,"Discount exceed"),this.discount=0)},this.invoicePreview=()=>(0,c.mG)(this,void 0,void 0,function*(){this.invoice_file=document.querySelector("#invoice").files[0];const r=this.invoice_file;null!=r?"application/pdf"==r.type?this.check_invoice_no?window.alert("Enter valid invoice no."):(this.show_extra_fields=!1,this.show_print_page=!0):window.alert("Choose PDF File !!"):window.alert("Upload Invoice")}),this.generateInvoice=()=>(0,c.mG)(this,void 0,void 0,function*(){try{let m={invoice:{InvoiceNo:this.invoice_no,PONo:this.selected_indent,DistrictID:this.DistrictID,WayBillNo:this.rr_way_bill_no,WayBillDate:this.rr_way_bill_date,InvoiceDate:this.invoice_date,NoOfOrderInPO:this.selectedPO.NoOfItemsInPO,NoOfOrderDeliver:this.itemsForDeliver.length,InvoiceAmount:this.finalInvoiceAmount,Discount:this.discount,POType:this.POType},items_for_deliver:this.itemsForDeliver};var r=new FormData;r.append("invoice",this.invoice_file),r.append("Name1",JSON.stringify(m));const y=yield this.service.post("/dl/addInvoice",r);"true"==y||1==y?(this.toastr.success("Invoice generated and successfully submitted to OAIC."),this.loadAllIndents(),this.back1(),this.invoice_no="",this.rr_way_bill_no="",this.rr_way_bill_date="",this.invoice_date=""):this.toastr.error("Failed to generate invoice. Try again.")}catch(x){console.error(x),this.toastr.error("Network Problem")}finally{this.clicked=!1}}),this.layoutService.setBreadcrumb("Deliver Order")}ngOnInit(){}changeFinancialYear(t){this.fin_year=t,this.loadAllIndents(),this.loadDists()}}return n.\u0275fac=function(t){return new(t||n)(e.Y36(q.P),e.Y36(f.v),e.Y36(P._W))},n.\u0275cmp=e.Xpm({type:n,selectors:[["app-deliver-order"]],decls:56,vars:20,consts:[[4,"ngIf"],[1,"loader"],["class","spinner-border text-info",4,"ngIf"],[1,"container"],["id","deliver",1,"modal","fade"],[1,"modal-dialog"],[1,"modal-content"],[1,"modal-header"],[1,"modal-title","center"],["type","button","data-dismiss","modal",1,"close"],[1,"modal-body"],[1,"row"],[1,"col-lg-4"],[1,"col-lg-8"],["class","row",4,"ngIf"],[1,"modal-footer"],["data-dismiss","modal",1,"btn","btn-info","btn-sm",3,"click"],[1,"card-head"],[1,"card-body"],[1,"col-lg-4","col-sm-12","col-xs-12"],[3,"newItemEvent"],[1,"col-lg-3"],[1,"form-control",3,"ngModel","ngModelChange"],["value",""],[3,"ngValue",4,"ngFor","ngForOf"],["type","text","placeholder","Enter P.O. Number",1,"form-control",3,"ngModel","ngModelOptions","ngModelChange"],[3,"ngValue"],[1,"spinner-border","text-info"],["class","no-record",4,"ngIf"],["class","card-body",4,"ngIf"],[1,"no-record"],[1,"table","table-striped","table-bordered","table-hover"],["scope","col"],[4,"ngFor","ngForOf"],[1,"btn","btn-outline-info","round",3,"click"],["aria-hidden","true",1,"fas","fa-arrow-right"],[1,"btn","btn-info","btn-sm","topBack",3,"click"],["aria-hidden","true",1,"fas","fa-arrow-left"],[2,"float","right"],["id","itemsTable",1,"table","table-striped","table-bordered","table-hover","text-left"],[3,"ngStyle",4,"ngFor","ngForOf"],["colspan","5",2,"text-align","right"],[2,"text-align","right"],[1,"card-footer"],[1,"btn","btn-info","btn-sm",3,"click"],["class","btn btn-info btn-sm",3,"click",4,"ngIf"],[3,"ngStyle"],["data-toggle","modal","data-target","#deliver",1,"btn","btn-outline-info","round",3,"disabled","click"],[1,"col-md-6"],[1,"col-lg-6"],["for","discount",1,"col-lg-6"],["type","number","placeholder","Enter discount money","id","discount",1,"col-lg-6","form-control",3,"ngModel","ngModelOptions","keyup","ngModelChange"],["for","invoice_no"],[1,"asterisk-mark"],["type","text","id","invoice_no","placeholder","Enter invoice no.","required","",1,"form-control",3,"ngModel","ngModelOptions","ngModelChange","keyup"],["class","asterisk-mark",4,"ngIf"],["for","invoice_date"],["type","date","if","invoice_date","required","",1,"form-control",3,"ngModel","ngModelOptions","max","ngModelChange"],["for","invoice"],["type","file","id","invoice","accept","application/pdf","name","invoice_file",1,"form-control"],["for","rr_way_bill_no"],["type","text","placeholder","Enter way bill no.","id","rr_way_bill_no",1,"form-control",3,"ngModel","ngModelOptions","ngModelChange"],["for","rr_way_bill_date"],["type","date","id","rr_way_bill_date","required","",1,"form-control",3,"ngModel","ngModelOptions","max","ngModelChange"],[1,"col-lg-12"],[1,"table","table-striped","table-bordered","text-left"],["colspan","6",2,"text-align","right"],["colspan","2",2,"text-align","right"],["colspan","8",2,"text-align","right"],[1,"btn","btn-info","btn-sm",3,"disabled","click"],[2,"text-align","left"],["type","text","name","deliver_qty",1,"form-control",3,"ngModel","ngModelChange"],[1,"points"],["type","text","placeholder","Enter engine no.","name","engine_no","required","",1,"form-control",3,"ngModel","ngModelChange"],["type","text","placeholder","Enter chassic no.","name","chassic_no","required","",1,"form-control",3,"ngModel","ngModelChange"]],template:function(t,i){1&t&&(e.YNc(0,k,19,5,"app-normal-card",0),e.TgZ(1,"div",1),e.YNc(2,N,1,0,"div",2),e.qZA(),e.YNc(3,b,5,2,"app-table-card",0),e.YNc(4,L,59,17,"div",0),e.YNc(5,j,88,37,"div",0),e.YNc(6,X,125,32,"div",0),e.TgZ(7,"div",3),e.TgZ(8,"div",4),e.TgZ(9,"div",5),e.TgZ(10,"div",6),e.TgZ(11,"div",7),e.TgZ(12,"h4",8),e._uU(13,"Enter item details"),e.qZA(),e.TgZ(14,"button",9),e._uU(15,"\xd7"),e.qZA(),e.qZA(),e.TgZ(16,"div",10),e.TgZ(17,"div",11),e.TgZ(18,"div",12),e._uU(19,"Total amount :"),e.qZA(),e.TgZ(20,"div",13),e._uU(21),e.ALo(22,"number"),e.qZA(),e.qZA(),e.TgZ(23,"div",11),e.TgZ(24,"div",12),e._uU(25,"Product Category :"),e.qZA(),e.TgZ(26,"div",13),e._uU(27),e.qZA(),e.qZA(),e.TgZ(28,"div",11),e.TgZ(29,"div",12),e._uU(30,"Manufacturer :"),e.qZA(),e.TgZ(31,"div",13),e._uU(32),e.qZA(),e.qZA(),e.TgZ(33,"div",11),e.TgZ(34,"div",12),e._uU(35,"Model / Item :"),e.qZA(),e.TgZ(36,"div",13),e._uU(37),e.qZA(),e.qZA(),e.TgZ(38,"div",11),e.TgZ(39,"div",12),e._uU(40,"Unit :"),e.qZA(),e.TgZ(41,"div",13),e._uU(42),e.qZA(),e.qZA(),e.TgZ(43,"div",11),e.TgZ(44,"div",12),e._uU(45,"Total Quantity :"),e.qZA(),e.TgZ(46,"div",13),e._uU(47),e.qZA(),e.qZA(),e.YNc(48,ee,5,1,"div",14),e.YNc(49,te,5,1,"div",14),e.YNc(50,ne,9,3,"div",14),e.YNc(51,ie,8,1,"div",14),e.YNc(52,re,8,1,"div",14),e.qZA(),e.TgZ(53,"div",15),e.TgZ(54,"button",16),e.NdJ("click",function(){return i.addDeliverItem()}),e._uU(55,"Deliver"),e.qZA(),e.qZA(),e.qZA(),e.qZA(),e.qZA(),e.qZA()),2&t&&(e.Q6J("ngIf",i.first_box),e.xp6(2),e.Q6J("ngIf",i.loader),e.xp6(1),e.Q6J("ngIf",i.show_indent_list),e.xp6(1),e.Q6J("ngIf",i.show_order_list),e.xp6(1),e.Q6J("ngIf",i.show_extra_fields),e.xp6(1),e.Q6J("ngIf",i.show_print_page),e.xp6(15),e.hij("\u20b9 ",e.xi3(22,17,i.order.TotalPurchaseInvoiceValue,"1.2-2"),""),e.xp6(6),e.Oqu(i.order.Implement),e.xp6(5),e.Oqu(i.order.Make),e.xp6(5),e.Oqu(i.order.Model),e.xp6(5),e.Oqu(i.order.UnitOfMeasurement),e.xp6(5),e.Oqu(i.order.ItemQuantity),e.xp6(1),e.Q6J("ngIf",!("Tractor"==i.order.Implement||"Power tiller"==i.order.Implement)),e.xp6(1),e.Q6J("ngIf",!("Tractor"==i.order.Implement||"Power tiller"==i.order.Implement)),e.xp6(1),e.Q6J("ngIf",!("Tractor"==i.order.Implement||"Power tiller"==i.order.Implement)),e.xp6(1),e.Q6J("ngIf","Tractor"==i.order.Implement||"Power tiller"==i.order.Implement),e.xp6(1),e.Q6J("ngIf","Tractor"==i.order.Implement||"Power tiller"==i.order.Implement))},directives:[d.O5,h.w,A.L,Z.EJ,Z.JJ,Z.On,Z.YN,Z.Kr,d.sg,Z.Fj,T.r,d.PC,Z.wV,Z.Q7],pipes:[d.JJ,_.G,d.uU,u.z],styles:[".points[_ngcontent-%COMP%]{font-weight:600;color:#ff4500}"]}),n})()}];let ae=(()=>{class n{}return n.\u0275fac=function(t){return new(t||n)},n.\u0275mod=e.oAB({type:n}),n.\u0275inj=e.cJS({imports:[[v.Bz.forChild(oe)],v.Bz]}),n})();var le=l(2582),se=l(9352);let ce=(()=>{class n{}return n.\u0275fac=function(t){return new(t||n)},n.\u0275mod=e.oAB({type:n}),n.\u0275inj=e.cJS({imports:[[d.ez,ae,s.m,Z.u5,le.d,se.j]]}),n})()}}]);
"use strict";(self.webpackChunkangular_application=self.webpackChunkangular_application||[]).push([[2897],{2897:(T,A,a)=>{a.r(A),a.d(A,{ApprovePurchaseOrderModule:()=>Y});var h=a(8583),m=a(6901),p=a(4762),_=a(665),e=a(639),x=a(4495),O=a(5620),v=a(9344),d=a(5638),f=a(1879),Z=a(4216),P=a(8065);function y(n,s){if(1&n){const t=e.EpF();e.TgZ(0,"app-normal-card"),e.ynx(1,1),e._uU(2,"Purchase Order (PO)"),e.BQk(),e.ynx(3,2),e.TgZ(4,"div",3),e.TgZ(5,"div",4),e.TgZ(6,"app-financial-year",5),e.NdJ("newItemEvent",function(l){return e.CHM(t),e.oxw().changeFinancialYear(l)}),e.qZA(),e.qZA(),e.TgZ(7,"div",4),e.TgZ(8,"label"),e._uU(9,"Type Of Order :"),e.qZA(),e.TgZ(10,"select",6),e.NdJ("ngModelChange",function(l){return e.CHM(t),e.oxw().indent_type=l})("change",function(){return e.CHM(t),e.oxw().loadlist()}),e.TgZ(11,"option",7),e._uU(12,"--Select--"),e.qZA(),e.TgZ(13,"option",8),e._uU(14,"Generate Purchase Order"),e.qZA(),e.TgZ(15,"option",9),e._uU(16,"Cancel Purchase Order"),e.qZA(),e.qZA(),e.qZA(),e.qZA(),e.BQk(),e.qZA()}if(2&n){const t=e.oxw();e.xp6(10),e.Q6J("ngModel",t.indent_type)}}function C(n,s){if(1&n&&(e.ynx(0,12),e._uU(1),e.BQk()),2&n){const t=e.oxw(2);e.xp6(1),e.hij("No record found on financial year ",t.fin_year,".")}}function b(n,s){if(1&n){const t=e.EpF();e.TgZ(0,"tr"),e.TgZ(1,"td"),e._uU(2),e.qZA(),e.TgZ(3,"td"),e._uU(4),e.qZA(),e.TgZ(5,"td"),e._uU(6),e.ALo(7,"date"),e.qZA(),e.TgZ(8,"td"),e._uU(9),e.qZA(),e.TgZ(10,"td"),e._uU(11),e.qZA(),e.TgZ(12,"td"),e._uU(13),e.ALo(14,"number"),e.qZA(),e.TgZ(15,"td"),e.TgZ(16,"button",21),e.NdJ("click",function(){const u=e.CHM(t).$implicit;return e.oxw(3).viewPurchaseOrder(u.PONo)}),e._UZ(17,"i",22),e.qZA(),e.qZA(),e.TgZ(18,"td"),e.TgZ(19,"input",23),e.NdJ("ngModelChange",function(l){return e.CHM(t).$implicit.status=l}),e.qZA(),e.qZA(),e.qZA()}if(2&n){const t=s.$implicit,o=s.index;e.xp6(2),e.Oqu(o+1),e.xp6(2),e.Oqu(t.PONo),e.xp6(2),e.Oqu(e.xi3(7,7,t.InsertedDate,"dd-MM-yyyy")),e.xp6(3),e.Oqu(t.LegalBussinessName),e.xp6(2),e.Oqu(t.NoOfItemsInPO),e.xp6(2),e.Oqu(e.lcZ(14,10,t.POAmount)),e.xp6(6),e.Q6J("ngModel",t.status)}}function I(n,s){if(1&n){const t=e.EpF();e.ynx(0,2),e.TgZ(1,"table",13),e._UZ(2,"caption"),e.TgZ(3,"thead"),e.TgZ(4,"tr"),e.TgZ(5,"th",14),e._uU(6,"SL"),e.qZA(),e.TgZ(7,"th",14),e._uU(8,"P.O. Number"),e.qZA(),e.TgZ(9,"th",14),e._uU(10,"Initiated Date"),e.qZA(),e.TgZ(11,"th",14),e._uU(12,"Vendor"),e.qZA(),e.TgZ(13,"th",14),e._uU(14,"No. of Items"),e.qZA(),e.TgZ(15,"th",14),e._uU(16,"P.O. Amount"),e.qZA(),e.TgZ(17,"th",14),e._uU(18,"View"),e.qZA(),e.TgZ(19,"th",14),e._uU(20,"Select"),e.qZA(),e.qZA(),e.qZA(),e.TgZ(21,"tbody"),e.YNc(22,b,20,12,"tr",15),e.qZA(),e.qZA(),e.TgZ(23,"div",16),e.TgZ(24,"button",17),e.NdJ("click",function(){return e.CHM(t),e.oxw(2).cancelindent()}),e._UZ(25,"i",18),e._uU(26,"\xa0Reject"),e.qZA(),e._uU(27,"\xa0 "),e.TgZ(28,"button",19),e.NdJ("click",function(){return e.CHM(t),e.oxw(2).approveindent()}),e._UZ(29,"i",20),e._uU(30," Approve"),e.qZA(),e.qZA(),e._UZ(31,"br"),e.BQk()}if(2&n){const t=e.oxw(2);e.xp6(22),e.Q6J("ngForOf",t.generated_indent_status)}}function U(n,s){if(1&n&&(e.TgZ(0,"app-table-card"),e.ynx(1,1),e._uU(2,"Generate Orders List"),e.BQk(),e.YNc(3,C,2,1,"ng-container",10),e.YNc(4,I,32,1,"ng-container",11),e.qZA()),2&n){const t=e.oxw();e.xp6(3),e.Q6J("ngIf",0==t.generated_indent_status.length),e.xp6(1),e.Q6J("ngIf",0!=t.generated_indent_status.length)}}function q(n,s){if(1&n&&(e.ynx(0,12),e._uU(1),e.BQk()),2&n){const t=e.oxw(2);e.xp6(1),e.hij("No record found on financial year ",t.fin_year,".")}}function N(n,s){if(1&n){const t=e.EpF();e.TgZ(0,"tr"),e.TgZ(1,"td"),e._uU(2),e.qZA(),e.TgZ(3,"td"),e._uU(4),e.qZA(),e.TgZ(5,"td"),e._uU(6),e.ALo(7,"date"),e.qZA(),e.TgZ(8,"td"),e._uU(9),e.qZA(),e.TgZ(10,"td"),e._uU(11),e.qZA(),e.TgZ(12,"td"),e._uU(13),e.ALo(14,"number"),e.qZA(),e.TgZ(15,"td"),e.TgZ(16,"button",21),e.NdJ("click",function(){const u=e.CHM(t).$implicit;return e.oxw(3).viewPurchaseOrder(u.PONo)}),e._UZ(17,"i",22),e.qZA(),e.qZA(),e.TgZ(18,"td"),e.TgZ(19,"input",23),e.NdJ("ngModelChange",function(l){return e.CHM(t).$implicit.status=l}),e.qZA(),e.qZA(),e.qZA()}if(2&n){const t=s.$implicit,o=s.index;e.xp6(2),e.Oqu(o+1),e.xp6(2),e.Oqu(t.PONo),e.xp6(2),e.Oqu(e.xi3(7,7,t.InsertedDate,"dd-MM-yyyy")),e.xp6(3),e.Oqu(t.LegalBussinessName),e.xp6(2),e.Oqu(t.NoOfItemsInPO),e.xp6(2),e.Oqu(e.lcZ(14,10,t.POAmount)),e.xp6(6),e.Q6J("ngModel",t.status)}}function M(n,s){if(1&n){const t=e.EpF();e.ynx(0,2),e.TgZ(1,"table",13),e._UZ(2,"caption"),e.TgZ(3,"thead"),e.TgZ(4,"tr"),e.TgZ(5,"th",14),e._uU(6,"SL"),e.qZA(),e.TgZ(7,"th",14),e._uU(8,"P.O. Number"),e.qZA(),e.TgZ(9,"th",14),e._uU(10,"Initiated Date"),e.qZA(),e.TgZ(11,"th",14),e._uU(12,"Vendor"),e.qZA(),e.TgZ(13,"th",14),e._uU(14,"No. of Items"),e.qZA(),e.TgZ(15,"th",14),e._uU(16,"P.O. Amount"),e.qZA(),e.TgZ(17,"th",14),e._uU(18,"View"),e.qZA(),e.TgZ(19,"th",14),e._uU(20,"Select"),e.qZA(),e.qZA(),e.qZA(),e.TgZ(21,"tbody"),e.YNc(22,N,20,12,"tr",15),e.qZA(),e.qZA(),e.TgZ(23,"div",16),e.TgZ(24,"button",19),e.NdJ("click",function(){return e.CHM(t),e.oxw(2).cancelindent()}),e._UZ(25,"i",20),e._uU(26," Approve Cancellation"),e.qZA(),e.qZA(),e.BQk()}if(2&n){const t=e.oxw(2);e.xp6(22),e.Q6J("ngForOf",t.cancelled_indent_status)}}function w(n,s){if(1&n&&(e.TgZ(0,"app-normal-card"),e.ynx(1,1),e._uU(2,"Cancel Order List"),e.BQk(),e.YNc(3,q,2,1,"ng-container",10),e.YNc(4,M,27,1,"ng-container",11),e.qZA()),2&n){const t=e.oxw();e.xp6(3),e.Q6J("ngIf",0==t.cancelled_indent_status.length),e.xp6(1),e.Q6J("ngIf",0!=t.cancelled_indent_status.length)}}function J(n,s){if(1&n){const t=e.EpF();e.ynx(0),e.TgZ(1,"button",24),e.NdJ("click",function(){return e.CHM(t),e.oxw().back()}),e._UZ(2,"i",25),e._uU(3," Back"),e.qZA(),e.TgZ(4,"app-normal-card"),e.ynx(5,1),e._uU(6,"Purchase Order"),e.BQk(),e.ynx(7,2),e._UZ(8,"app-po",26),e.BQk(),e.ynx(9,27),e.TgZ(10,"button",19),e.NdJ("click",function(){return e.CHM(t),e.oxw().back()}),e._UZ(11,"i",25),e._uU(12," Back"),e.qZA(),e.BQk(),e.qZA(),e.BQk()}if(2&n){const t=e.oxw();e.xp6(8),e.Q6J("PODetails",t.PODetails)("PONo",t.PONo)}}const L=[{path:"",component:(()=>{class n{constructor(t,o,l,u){this.layoutService=t,this.service=o,this.toastr=l,this.router=u,this.showTable=!0,this.show_generateindent_listtable=!1,this.show_cancelindent_listtable=!1,this.paymentInvoice=!1,this.approve=!1,this.loadingData=!1,this.showPO=!1,this.fin_year="",this.generateIndentList=[],this.cancelledIndentList=[],this.generated_indent_status=[],this.cancelled_indent_status=[],this.indent_type="Generate_Indent",this.loadlist=()=>{"Generate_Indent"==this.indent_type?this.loadPendinglistOfGenerateIndent():this.loadPendinglistOfCancelIndent()},this.loadPendinglistOfGenerateIndent=()=>(0,p.mG)(this,void 0,void 0,function*(){this.loadingData=!0;let r=yield this.service.get(`/dm/getPendinglistOfGenerateIndent?fin_year=${this.fin_year}`);this.generated_indent_status=r.filter(i=>(i.approval_date=new Date(i.approval_date),i.status=!1,i)),this.show_generateindent_listtable=!0,this.show_cancelindent_listtable=!1,this.loadingData=!1}),this.loadPendinglistOfCancelIndent=()=>(0,p.mG)(this,void 0,void 0,function*(){this.loadingData=!0;let r=yield this.service.get(`/dm/getPendinglistOfCancelIndent?fin_year=${this.fin_year}`);this.cancelled_indent_status=r.filter(i=>(i.approval_date=new Date(i.approval_date),i.status=!1,i)),this.show_cancelindent_listtable=!0,this.show_generateindent_listtable=!1,this.loadingData=!1}),this.approveindent=()=>(0,p.mG)(this,void 0,void 0,function*(){this.loadingData=!0;const r=this.generated_indent_status.filter(c=>{if(c.status)return c});console.log(r,"hi");const i=r.map(c=>c.PONo),g=r.map(c=>c.PermitNumber);try{yield this.service.post("/dm/generateIndents",{PONoList:i,PermitNoList:g}),this.toastr.success("Successfully Purchase Order generated."),this.loadlist(),this.loadingData=!1}catch(c){this.toastr.error("Server problem. Please try again."),console.error(c),this.loadingData=!1}}),this.cancelindent=()=>(0,p.mG)(this,void 0,void 0,function*(){this.loadingData=!0;let r=this.generated_indent_status.filter(c=>{if(c.status)return c;console.log(c.status),console.log(c)}),i=r.map(c=>c.PONo),g=r.map(c=>c.PermitNumber);try{yield this.service.post("/dm/cancelIndents",{PONoList:i,PermitNoList:g}),this.toastr.success("Successfully Purchase Order Cancelled."),this.loadlist(),this.loadingData=!1}catch(c){this.toastr.error("Server problem. Please try again."),console.error(c),this.loadingData=!1}}),this.addCancelIndent=r=>{if(this.cancelledIndentList.includes(r)){let i=this.cancelledIndentList.findIndex(g=>g==r);this.cancelledIndentList.splice(i,1)}else this.cancelledIndentList.push(r)},this.addGenerateIndent=r=>{if(this.generateIndentList.includes(r)){let i=this.generateIndentList.findIndex(g=>g==r);this.generateIndentList.splice(i,1)}else this.generateIndentList.push(r)},this.PONo=new _.NI(""),this.PODetails={},this.viewPurchaseOrder=r=>(0,p.mG)(this,void 0,void 0,function*(){this.loadingData=!0,this.selectedPONo=r,this.PONo.setValue(r);const i=yield this.service.get("/api/getPODetails?PONumber="+r);this.PODetails=i,this.showTable=!1,this.show_generateindent_listtable=!1,this.show_cancelindent_listtable=!1,this.loadingData=!1,this.showPO=!0}),this.back=()=>{this.showPO=!1,this.showTable=!0,this.show_generateindent_listtable="Generate_Indent"==this.indent_type,this.show_cancelindent_listtable="Generate_Indent"!=this.indent_type},this.layoutService.setBreadcrumb("Approve Generated P.O. or Cancelled P.O.")}ngOnInit(){}changeFinancialYear(t){this.fin_year=t,this.loadlist()}}return n.\u0275fac=function(t){return new(t||n)(e.Y36(x.P),e.Y36(O.v),e.Y36(v._W),e.Y36(m.F0))},n.\u0275cmp=e.Xpm({type:n,selectors:[["app-approve-purchase-order"]],decls:4,vars:4,consts:[[4,"ngIf"],[1,"card-head"],[1,"card-body"],[1,"row"],[1,"col-lg-4","col-sm-12","col-xs-12"],[3,"newItemEvent"],[1,"form-control",3,"ngModel","ngModelChange","change"],["value","","disabled",""],["value","Generate_Indent"],["value","Cancel_Indent"],["class","no-record",4,"ngIf"],["class","card-body",4,"ngIf"],[1,"no-record"],["id","itemListTable",1,"table","table-striped","table-bordered","table-hover"],["scope","col"],[4,"ngFor","ngForOf"],[1,"rightSubmit"],[1,"btn","btn-danger","btn-sm",3,"click"],["aria-hidden","true",1,"fas","fa-times"],[1,"btn","btn-info","btn-sm",3,"click"],["aria-hidden","true",1,"fas","fa-check"],[1,"btn","btn-outline-info",3,"click"],[1,"fas","fa-bars"],["type","checkbox",1,"form-control",3,"ngModel","ngModelChange"],[1,"btn","btn-info","btn-sm","topBack",3,"click"],["aria-hidden","true",1,"fas","fa-arrow-left"],["id","printPage",3,"PODetails","PONo"],[1,"card-footer"]],template:function(t,o){1&t&&(e.YNc(0,y,17,1,"app-normal-card",0),e.YNc(1,U,5,2,"app-table-card",0),e.YNc(2,w,5,2,"app-normal-card",0),e.YNc(3,J,13,2,"ng-container",0)),2&t&&(e.Q6J("ngIf",o.showTable),e.xp6(1),e.Q6J("ngIf",o.show_generateindent_listtable),e.xp6(1),e.Q6J("ngIf",o.show_cancelindent_listtable),e.xp6(1),e.Q6J("ngIf",o.showPO))},directives:[h.O5,d.w,f.L,_.EJ,_.JJ,_.On,_.YN,_.Kr,Z.r,h.sg,_.Wl,P.K],pipes:[h.uU,h.JJ],styles:[""]}),n})()}];let B=(()=>{class n{}return n.\u0275fac=function(t){return new(t||n)},n.\u0275mod=e.oAB({type:n}),n.\u0275inj=e.cJS({imports:[[m.Bz.forChild(L)],m.Bz]}),n})();var Q=a(4466),D=a(7543),k=a(7335),F=a(2582),G=a(9352);let Y=(()=>{class n{constructor(){console.log("Approve Purchase Order Module called")}}return n.\u0275fac=function(t){return new(t||n)},n.\u0275mod=e.oAB({type:n}),n.\u0275inj=e.cJS({imports:[[h.ez,B,Q.m,_.u5,D.b,k.J,F.d,G.j]]}),n})()},7543:(T,A,a)=>{a.d(A,{b:()=>v});var h=a(8583),m=a(6901),p=a(639);const _=[];let e=(()=>{class d{}return d.\u0275fac=function(Z){return new(Z||d)},d.\u0275mod=p.oAB({type:d}),d.\u0275inj=p.cJS({imports:[[m.Bz.forChild(_)],m.Bz]}),d})();var x=a(5913),O=a(4466);let v=(()=>{class d{}return d.\u0275fac=function(Z){return new(Z||d)},d.\u0275mod=p.oAB({type:d}),d.\u0275inj=p.cJS({imports:[[h.ez,e,x.K,O.m]]}),d})()}}]);
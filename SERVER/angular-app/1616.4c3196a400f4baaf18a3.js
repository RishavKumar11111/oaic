"use strict";(self.webpackChunkangular_application=self.webpackChunkangular_application||[]).push([[1616],{1410:(Z,_,o)=>{o.d(_,{G:()=>u});var a=o(639);let u=(()=>{class r{transform(c,t){return c?t?(t=t.toLowerCase(),c.filter(function(g){return JSON.stringify(g).toLowerCase().includes(t)})):c:null}}return r.\u0275fac=function(c){return new(c||r)},r.\u0275pipe=a.Yjl({name:"search",type:r,pure:!0}),r})()},1616:(Z,_,o)=>{o.r(_),o.d(_,{AllPoListModule:()=>F});var a=o(665),u=o(4466),r=o(8583),p=o(6901),c=o(4762),t=o(639),g=o(4495),m=o(5620),A=o(5638),x=o(1879),P=o(4216),h=o(5913),T=o(8065),v=o(1410);function O(e,i){if(1&e&&(t.TgZ(0,"option",12),t._uU(1),t.qZA()),2&e){const n=i.$implicit;t.Q6J("ngValue",n.dist_id),t.xp6(1),t.Oqu(n.dist_name)}}const f=function(){return{standalone:!0}};function C(e,i){if(1&e){const n=t.EpF();t.TgZ(0,"app-normal-card"),t.ynx(1,3),t._uU(2,"All Purchase Orders"),t.BQk(),t.ynx(3,4),t.TgZ(4,"div",5),t.TgZ(5,"div",6),t.TgZ(6,"app-financial-year",7),t.NdJ("newItemEvent",function(l){return t.CHM(n),t.oxw().changeFinancialYear(l)}),t.qZA(),t.qZA(),t.TgZ(7,"div",6),t.TgZ(8,"label"),t._uU(9,"District :"),t.qZA(),t._UZ(10,"br"),t.TgZ(11,"select",8),t.NdJ("ngModelChange",function(l){return t.CHM(n),t.oxw().dist=l})("change",function(){return t.CHM(n),t.oxw().matchByIndentNo=""}),t.TgZ(12,"option",9),t._uU(13,"ALL"),t.qZA(),t.YNc(14,O,2,2,"option",10),t.qZA(),t.qZA(),t.TgZ(15,"div",6),t.TgZ(16,"label"),t._uU(17,"P.O. number:"),t.qZA(),t._UZ(18,"br"),t.TgZ(19,"input",11),t.NdJ("ngModelChange",function(l){return t.CHM(n),t.oxw().searchPONo=l}),t.qZA(),t.qZA(),t.qZA(),t.BQk(),t.qZA()}if(2&e){const n=t.oxw();t.xp6(11),t.Q6J("ngModel",n.dist)("ngModelOptions",t.DdM(5,f)),t.xp6(3),t.Q6J("ngForOf",n.districts),t.xp6(5),t.Q6J("ngModel",n.searchPONo)("ngModelOptions",t.DdM(6,f))}}function U(e,i){1&e&&t._UZ(0,"div",13)}function b(e,i){if(1&e&&(t.ynx(0,19),t._uU(1),t.BQk()),2&e){const n=t.oxw(2);t.xp6(1),t.hij("No record found on financial year ",n.fin_year,".")}}function L(e,i){1&e&&(t.TgZ(0,"td"),t._uU(1,"Delivered"),t.qZA())}function N(e,i){1&e&&(t.TgZ(0,"td"),t._uU(1,"Not Delivered"),t.qZA())}function y(e,i){if(1&e){const n=t.EpF();t.TgZ(0,"tr"),t.TgZ(1,"td"),t._uU(2),t.qZA(),t.TgZ(3,"td"),t._uU(4),t.qZA(),t.TgZ(5,"td"),t._uU(6),t.ALo(7,"date"),t.qZA(),t.TgZ(8,"td"),t._uU(9),t.qZA(),t.TgZ(10,"td"),t._uU(11),t.qZA(),t.TgZ(12,"td"),t._uU(13),t._UZ(14,"br"),t._uU(15),t._UZ(16,"br"),t._uU(17),t._UZ(18,"br"),t.qZA(),t.TgZ(19,"td"),t._uU(20),t.ALo(21,"number"),t.qZA(),t.YNc(22,L,2,0,"td",0),t.YNc(23,N,2,0,"td",0),t.TgZ(24,"td"),t.TgZ(25,"button",23),t.NdJ("click",function(){const d=t.CHM(n).$implicit;return t.oxw(3).viewIndent(d)}),t._UZ(26,"i",24),t.qZA(),t.qZA(),t.qZA()}if(2&e){const n=i.$implicit,s=i.index;t.xp6(2),t.Oqu(s+1),t.xp6(2),t.Oqu(n.DistrictName),t.xp6(2),t.Oqu(t.xi3(7,11,n.ApprovedDate,"dd-MM-y")),t.xp6(3),t.Oqu(n.PONo),t.xp6(2),t.Oqu(n.NoOfItemsInPO),t.xp6(2),t.hij("Product Category- ",n.Implement," "),t.xp6(2),t.hij(" Manufacturer- ",n.Make," "),t.xp6(2),t.hij(" Model/Item- ",n.Model," "),t.xp6(3),t.Oqu(t.lcZ(21,14,n.POAmount)),t.xp6(2),t.Q6J("ngIf",1==n.IsDelivered),t.xp6(1),t.Q6J("ngIf",0==n.IsDelivered)}}function q(e,i){if(1&e&&(t.ynx(0,4),t.TgZ(1,"table",20),t._UZ(2,"caption"),t.TgZ(3,"thead"),t.TgZ(4,"tr"),t.TgZ(5,"th",21),t._uU(6,"SL."),t.qZA(),t.TgZ(7,"th",21),t._uU(8,"District"),t.qZA(),t.TgZ(9,"th",21),t._uU(10,"Date"),t.qZA(),t.TgZ(11,"th",21),t._uU(12,"P.O. Number"),t.qZA(),t.TgZ(13,"th",21),t._uU(14,"No. of items"),t.qZA(),t.TgZ(15,"th",21),t._uU(16,"Description of Goods"),t.qZA(),t.TgZ(17,"th",21),t._uU(18,"Cost Involved(\u20b9)"),t.qZA(),t.TgZ(19,"th",21),t._uU(20,"Status"),t.qZA(),t.TgZ(21,"th",21),t._uU(22,"View"),t.qZA(),t.qZA(),t.qZA(),t.TgZ(23,"tbody"),t.YNc(24,y,27,16,"tr",22),t.ALo(25,"search"),t.ALo(26,"search"),t.qZA(),t.qZA(),t.BQk()),2&e){const n=t.oxw(2);t.xp6(24),t.Q6J("ngForOf",t.xi3(25,1,t.xi3(26,4,n.indent_list,n.searchPONo),n.dist))}}function M(e,i){if(1&e&&(t.TgZ(0,"app-table-card"),t.ynx(1,3),t._uU(2,"P.O. List"),t.BQk(),t.YNc(3,b,2,1,"ng-container",14),t.YNc(4,q,27,7,"ng-container",15),t.ynx(5,16),t.TgZ(6,"button",17),t._UZ(7,"i",18),t._uU(8," Print "),t._UZ(9,"i",18),t.qZA(),t.BQk(),t.qZA()),2&e){const n=t.oxw();t.xp6(3),t.Q6J("ngIf",0==n.indent_list.length),t.xp6(1),t.Q6J("ngIf",0!=n.indent_list.length),t.xp6(2),t.Q6J("useExistingCss",!0)}}function I(e,i){if(1&e){const n=t.EpF();t.TgZ(0,"div"),t.TgZ(1,"button",25),t.NdJ("click",function(){return t.CHM(n),t.oxw().back()}),t._UZ(2,"i",26),t._uU(3," BACK"),t.qZA(),t.TgZ(4,"div",27),t.TgZ(5,"div",28),t.TgZ(6,"span"),t.TgZ(7,"strong"),t.TgZ(8,"label"),t._uU(9,"Purchase Order"),t.qZA(),t.qZA(),t.qZA(),t.qZA(),t.TgZ(10,"div"),t._UZ(11,"app-po",29),t.qZA(),t.TgZ(12,"div",30),t.TgZ(13,"button",31),t.NdJ("click",function(){return t.CHM(n),t.oxw().back()}),t._UZ(14,"i",26),t._uU(15," Back"),t.qZA(),t.qZA(),t.qZA(),t.qZA()}if(2&e){const n=t.oxw();t.xp6(11),t.Q6J("PODetails",n.PODetails)("PONo",n.PONo)}}const J=[{path:"",component:(()=>{class e{constructor(n,s){this.layoutService=n,this.service=s,this.selectedPONo="",this.show_indent_list=!1,this.show_single_indent=!1,this.loader=!1,this.first_card=!0,this.fin_year="",this.show_print_page=!1,this.dist="",this.indent_list=[],this.districts=[],this.searchPONo="",this.matchByIndentNo="",this.loadDists=()=>(0,c.mG)(this,void 0,void 0,function*(){this.show_print_page=!1,this.districts=yield this.service.get("/dl/getDealerDists")}),this.loadAllIndents=()=>(0,c.mG)(this,void 0,void 0,function*(){this.show_indent_list=!1,this.loader=!0,this.indent_list=yield this.service.get(`/dl/getAllDistIndent?fin_year=${this.fin_year}`),this.show_indent_list=!0,this.loader=!1}),this.PONo=new a.NI(""),this.PODetails={},this.viewIndent=l=>(0,c.mG)(this,void 0,void 0,function*(){this.selectedPONo=l.PONo,this.show_indent_list=!1,this.PONo.setValue(l.PONo);const d=yield this.service.get("/api/getPODetails?PONumber="+l.PONo);this.PODetails=d,this.show_single_indent=!0,this.first_card=!1}),this.printSingleIndent=()=>{},this.printAllIndentList=()=>{},this.back=()=>{this.show_single_indent=!1,this.show_indent_list=!0,this.first_card=!0},this.layoutService.setBreadcrumb("All Purchase Orders List"),this.loadDists()}ngOnInit(){}changeFinancialYear(n){this.fin_year=n,this.loadAllIndents()}}return e.\u0275fac=function(n){return new(n||e)(t.Y36(g.P),t.Y36(m.v))},e.\u0275cmp=t.Xpm({type:e,selectors:[["app-all-po-list"]],decls:5,vars:4,consts:[[4,"ngIf"],[1,"loader"],["class","spinner-border text-info",4,"ngIf"],[1,"card-head"],[1,"card-body"],[1,"row"],[1,"col-md-4"],[3,"newItemEvent"],[1,"form-control",3,"ngModel","ngModelOptions","ngModelChange","change"],["value",""],[3,"ngValue",4,"ngFor","ngForOf"],["type","text","placeholder","Search",1,"form-control",3,"ngModel","ngModelOptions","ngModelChange"],[3,"ngValue"],[1,"spinner-border","text-info"],["class","no-record",4,"ngIf"],["class","card-body",4,"ngIf"],[1,"card-footer"],["printTitle","Purchase Order List","printSectionId","print","ngxPrint","",1,"btn","btn-info","btn-sm",3,"useExistingCss"],["aria-hidden","true",1,"fas","fa-print"],[1,"no-record"],[1,"table","table-striped","table-bordered","table-hover",2,"text-align","center"],["scope","col"],[4,"ngFor","ngForOf"],[1,"btn","btn-outline-info","round",3,"click"],["aria-hidden","true",1,"fas","fa-bars"],[1,"btn","btn-info","btn-sm","topBack",3,"click"],["aria-hidden","true",1,"fas","fa-arrow-left"],[1,"mybox"],[1,"mybox-header"],["id","printPage",3,"PODetails","PONo"],[1,"bottomBack"],[1,"btn","btn-info","btn-sm",3,"click"]],template:function(n,s){1&n&&(t.YNc(0,C,20,7,"app-normal-card",0),t.TgZ(1,"div",1),t.YNc(2,U,1,0,"div",2),t.qZA(),t.YNc(3,M,10,3,"app-table-card",0),t.YNc(4,I,16,2,"div",0)),2&n&&(t.Q6J("ngIf",s.first_card),t.xp6(2),t.Q6J("ngIf",s.loader),t.xp6(1),t.Q6J("ngIf",s.show_indent_list),t.xp6(1),t.Q6J("ngIf",s.show_single_indent))},directives:[r.O5,A.w,x.L,a.EJ,a.JJ,a.On,a.YN,a.Kr,r.sg,a.Fj,P.r,h.I,T.K],pipes:[v.G,r.uU,r.JJ],styles:[""]}),e})()}];let D=(()=>{class e{}return e.\u0275fac=function(n){return new(n||e)},e.\u0275mod=t.oAB({type:e}),e.\u0275inj=t.cJS({imports:[[p.Bz.forChild(J)],p.Bz]}),e})();var w=o(7335),Q=o(2582),B=o(9352);let F=(()=>{class e{}return e.\u0275fac=function(n){return new(n||e)},e.\u0275mod=t.oAB({type:e}),e.\u0275inj=t.cJS({imports:[[r.ez,D,u.m,a.u5,w.J,h.K,Q.d,B.j]]}),e})()}}]);
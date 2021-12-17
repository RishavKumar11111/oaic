"use strict";(self.webpackChunkangular_application=self.webpackChunkangular_application||[]).push([[982],{982:(C,c,d)=>{d.r(c),d.d(c,{MiscellaneousExpensesModule:()=>q});var g=d(8583),p=d(6901),r=d(4762),e=d(639),h=d(4495),m=d(5620),Z=d(9344),i=d(665);function _(n,l){if(1&n&&(e.TgZ(0,"option",21),e._uU(1),e.qZA()),2&n){const t=l.$implicit;e.Q6J("ngValue",t),e.xp6(1),e.Oqu(t.schem_name)}}function M(n,l){if(1&n&&(e.TgZ(0,"option",21),e._uU(1),e.qZA()),2&n){const t=l.$implicit;e.Q6J("ngValue",t),e.xp6(1),e.Oqu(t.reference_no)}}function T(n,l){if(1&n&&(e.TgZ(0,"option",22),e._uU(1),e.qZA()),2&n){const t=l.$implicit;e.s9C("value",t.head_id),e.xp6(1),e.hij(" ",t.head_name,"")}}function v(n,l){if(1&n&&(e.TgZ(0,"option",22),e._uU(1),e.qZA()),2&n){const t=l.$implicit;e.s9C("value",t.subhead_id),e.xp6(1),e.hij(" ",t.subhead_name," ")}}const u=function(){return{standalone:!0}},A=[{path:"",component:(()=>{class n{constructor(t,o,a){this.layoutService=t,this.service=o,this.toastr=a,this.schem="",this.head="",this.subheads="",this.ref_no="",this.subhead="",this.loadAllDetails=()=>(0,r.mG)(this,void 0,void 0,function*(){this.schem_list=yield this.service.get("/accountant/getAllSchema"),this.heads=yield this.service.get("/accountant/getAllHeads")}),this.loadReferenceNos=()=>(0,r.mG)(this,void 0,void 0,function*(){switch(this.schem.schem_id){case"1":{let s=yield this.service.get("/accountant/getAllPermitNos");this.ref_no_list=s.data;break}case"2":{let s=yield this.service.get("/accountant/getAllClusterIdsForExpenditure");this.ref_no_list=s.data;break}}}),this.loadSubheads=()=>(0,r.mG)(this,void 0,void 0,function*(){this.subheads=yield this.service.get("/accountant/getAllSubheads?headId="+this.head)}),this.Pay=()=>(0,r.mG)(this,void 0,void 0,function*(){try{const s={schem_id:this.schem.schem_id,ref_no:this.ref_no.reference_no,head_id:this.head,subhead_id:this.subhead,payment_no:this.voucherNo,ammount:this.ammount,payment_mode:"cash",remark:this.remark,dist_id:this.distcode,to:this.to};yield this.service.post("/accountant/addExpenditurePayment",s),this.toastr.success("Payment Succefully Received"),this.loadAllDetails()}catch(s){this.toastr.error("Server error. Please try again."),console.error(s)}}),this.layoutService.setBreadcrumb("Miscellaneous expences")}ngOnInit(){}}return n.\u0275fac=function(t){return new(t||n)(e.Y36(h.P),e.Y36(m.v),e.Y36(Z._W))},n.\u0275cmp=e.Xpm({type:n,selectors:[["app-miscellaneous-expenses"]],decls:88,vars:28,consts:[[1,"mybox"],[1,"mybox-header"],[1,"middle"],["name","myForm"],[1,"row"],[1,"col-lg-2"],[1,"asterisk-mark"],[1,"col-lg-10"],["required","",1,"form-control",3,"ngModel","ngModelOptions","ngModelChange","change"],["value","","disabled",""],[3,"ngValue",4,"ngFor","ngForOf"],[1,"col-lg-4"],["required","",1,"form-control",3,"ngModel","ngModelOptions","ngModelChange"],["type","file","id","supportiveDoc","accept","application/pdf","required","",1,"form-control"],[3,"value",4,"ngFor","ngForOf"],["type","number","min","0","maxlength","10","placeholder","Enter Amount","required","",1,"form-control",3,"ngModel","ngModelOptions","ngModelChange"],["type","text","placeholder","Voucher No...","required","",1,"form-control",3,"ngModel","ngModelOptions","ngModelChange"],["type","text","placeholder","To...","required","",1,"form-control",3,"ngModel","ngModelOptions","ngModelChange"],["type","text","placeholder","Remark...","required","",1,"form-control",3,"ngModel","ngModelOptions","ngModelChange"],[1,"rightSubmit"],[1,"btn","btn-outline-info","round",3,"click"],[3,"ngValue"],[3,"value"]],template:function(t,o){1&t&&(e.TgZ(0,"div",0),e.TgZ(1,"div",1),e.TgZ(2,"span"),e.TgZ(3,"strong"),e.TgZ(4,"label"),e._uU(5,"Expenditure On Additional Head"),e.qZA(),e.qZA(),e.qZA(),e.qZA(),e.TgZ(6,"div",2),e.TgZ(7,"form",3),e.TgZ(8,"div",4),e.TgZ(9,"div",5),e._uU(10,"Scheme"),e.TgZ(11,"span",6),e._uU(12,"*"),e.qZA(),e._uU(13," :"),e.qZA(),e.TgZ(14,"div",7),e.TgZ(15,"select",8),e.NdJ("ngModelChange",function(s){return o.schem=s})("change",function(){return o.loadReferenceNos()}),e.TgZ(16,"option",9),e._uU(17,"--select--"),e.qZA(),e.YNc(18,_,2,2,"option",10),e.qZA(),e.qZA(),e.qZA(),e.TgZ(19,"div",4),e.TgZ(20,"div",5),e._uU(21,"Reference no"),e.TgZ(22,"span",6),e._uU(23,"*"),e.qZA(),e._uU(24," :"),e.qZA(),e.TgZ(25,"div",11),e.TgZ(26,"select",12),e.NdJ("ngModelChange",function(s){return o.ref_no=s}),e.TgZ(27,"option",9),e._uU(28,"--select--"),e.qZA(),e.YNc(29,M,2,2,"option",10),e.qZA(),e.qZA(),e.TgZ(30,"div",5),e._uU(31,"Upload supportive document"),e.TgZ(32,"span",6),e._uU(33,"*"),e.qZA(),e._uU(34," :"),e.qZA(),e.TgZ(35,"div",11),e._UZ(36,"input",13),e.qZA(),e.qZA(),e.TgZ(37,"div",4),e.TgZ(38,"div",5),e._uU(39,"Head"),e.TgZ(40,"span",6),e._uU(41,"*"),e.qZA(),e._uU(42," :"),e.qZA(),e.TgZ(43,"div",11),e.TgZ(44,"select",8),e.NdJ("ngModelChange",function(s){return o.head=s})("change",function(){return o.loadSubheads()}),e.TgZ(45,"option",9),e._uU(46,"--select--"),e.qZA(),e.YNc(47,T,2,2,"option",14),e.qZA(),e.qZA(),e.TgZ(48,"div",5),e._uU(49,"Sub Head"),e.TgZ(50,"span",6),e._uU(51,"*"),e.qZA(),e._uU(52," :"),e.qZA(),e.TgZ(53,"div",11),e.TgZ(54,"select",12),e.NdJ("ngModelChange",function(s){return o.subhead=s}),e.TgZ(55,"option",9),e._uU(56,"--select--"),e.qZA(),e.YNc(57,v,2,2,"option",14),e.qZA(),e.qZA(),e.qZA(),e.TgZ(58,"div",4),e.TgZ(59,"div",5),e._uU(60,"Amount"),e.TgZ(61,"span",6),e._uU(62,"*"),e.qZA(),e._uU(63," :"),e.qZA(),e.TgZ(64,"div",11),e.TgZ(65,"input",15),e.NdJ("ngModelChange",function(s){return o.ammount=s}),e.qZA(),e.qZA(),e.TgZ(66,"div",5),e._uU(67,"Voucher no :"),e.qZA(),e.TgZ(68,"div",11),e.TgZ(69,"input",16),e.NdJ("ngModelChange",function(s){return o.voucherNo=s}),e.qZA(),e.qZA(),e.qZA(),e.TgZ(70,"div",4),e.TgZ(71,"div",5),e._uU(72,"To"),e.TgZ(73,"span",6),e._uU(74,"*"),e.qZA(),e._uU(75," :"),e.qZA(),e.TgZ(76,"div",11),e.TgZ(77,"input",17),e.NdJ("ngModelChange",function(s){return o.to=s}),e.qZA(),e.qZA(),e.TgZ(78,"div",5),e._uU(79,"Remark"),e.TgZ(80,"span",6),e._uU(81,"*"),e.qZA(),e._uU(82," :"),e.qZA(),e.TgZ(83,"div",11),e.TgZ(84,"input",18),e.NdJ("ngModelChange",function(s){return o.remark=s}),e.qZA(),e.qZA(),e.qZA(),e.TgZ(85,"div",19),e.TgZ(86,"button",20),e.NdJ("click",function(){return o.Pay()}),e._uU(87,"ADD"),e.qZA(),e.qZA(),e.qZA(),e.qZA(),e.qZA()),2&t&&(e.xp6(15),e.Q6J("ngModel",o.schem)("ngModelOptions",e.DdM(20,u)),e.xp6(3),e.Q6J("ngForOf",o.schem_list),e.xp6(8),e.Q6J("ngModel",o.ref_no)("ngModelOptions",e.DdM(21,u)),e.xp6(3),e.Q6J("ngForOf",o.ref_no_list),e.xp6(15),e.Q6J("ngModel",o.head)("ngModelOptions",e.DdM(22,u)),e.xp6(3),e.Q6J("ngForOf",o.heads),e.xp6(7),e.Q6J("ngModel",o.subhead)("ngModelOptions",e.DdM(23,u)),e.xp6(3),e.Q6J("ngForOf",o.subheads),e.xp6(8),e.Q6J("ngModel",o.ammount)("ngModelOptions",e.DdM(24,u)),e.xp6(4),e.Q6J("ngModel",o.voucherNo)("ngModelOptions",e.DdM(25,u)),e.xp6(8),e.Q6J("ngModel",o.to)("ngModelOptions",e.DdM(26,u)),e.xp6(7),e.Q6J("ngModel",o.remark)("ngModelOptions",e.DdM(27,u)))},directives:[i._Y,i.JL,i.F,i.EJ,i.Q7,i.JJ,i.On,i.YN,i.Kr,g.sg,i.qQ,i.wV,i.Fj,i.nD],styles:[""]}),n})()}];let f=(()=>{class n{}return n.\u0275fac=function(t){return new(t||n)},n.\u0275mod=e.oAB({type:n}),n.\u0275inj=e.cJS({imports:[[p.Bz.forChild(A)],p.Bz]}),n})(),q=(()=>{class n{}return n.\u0275fac=function(t){return new(t||n)},n.\u0275mod=e.oAB({type:n}),n.\u0275inj=e.cJS({imports:[[g.ez,f,i.u5]]}),n})()}}]);
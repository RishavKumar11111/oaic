import { Component, OnInit } from '@angular/core';
import { ToastrService } from 'ngx-toastr';
import { CommonService } from 'src/app/services/common.service';
import { LayoutService } from 'src/app/services/layout/layout.service';

@Component({
  selector: 'app-miscellaneous-expenses',
  templateUrl: './miscellaneous-expenses.component.html',
  styleUrls: ['./miscellaneous-expenses.component.css']
})
export class MiscellaneousExpensesComponent implements OnInit {

  constructor(
    private layoutService: LayoutService,
    private service: CommonService,
    private toastr: ToastrService
  ) { 
    this.layoutService.setBreadcrumb('Miscellaneous expences');
  }
  ngOnInit(): void {
  }



  
  schem_list: any;
  heads: any;
  schem: any = '';
  ref_no_list: any;
  head: any = '';
  subheads: any = '';

  ref_no: any = '';
  subhead: any = '';
  voucherNo: any;
  ammount: any;
  remark: any;
  distcode: any;
  to: any;
  loadAllDetails = async () => {
      this.schem_list = await this.service.get('/accountant/getAllSchema');
      this.heads = await this.service.get('/accountant/getAllHeads');
  }
  loadReferenceNos = async() => {
      switch (this.schem.schem_id) {
          case "1":
              {
                  let response = await this.service.get('/accountant/getAllPermitNos');
                  this.ref_no_list = response.data;
                  break;
              }
          case "2":
              {
                  let response2 = await this.service.get('/accountant/getAllClusterIdsForExpenditure');
                  this.ref_no_list = response2.data;
                  break;
              }
      }
  }
  loadSubheads = async () => {
    this.subheads = await this.service.get('/accountant/getAllSubheads?headId=' + this.head);
  }
  Pay = async() => {
      try {
        const data = {
            schem_id: this.schem.schem_id,
            ref_no: this.ref_no.reference_no,
            head_id: this.head,
            subhead_id: this.subhead,
            payment_no: this.voucherNo,
            ammount: this.ammount,
            payment_mode: 'cash',
            remark: this.remark,
            dist_id: this.distcode,
            to: this.to
        }
          await this.service.post(`/accountant/addExpenditurePayment`, data);
          this.toastr.success('Payment Succefully Received');
          this.loadAllDetails();
      } catch (e) {
          this.toastr.error('Server error. Please try again.');
          console.error(e);
      }

  }





}

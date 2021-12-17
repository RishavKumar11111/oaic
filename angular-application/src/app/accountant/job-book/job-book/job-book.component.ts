import { Component, OnInit } from '@angular/core';
import { ToastrService } from 'ngx-toastr';
import { CommonService } from 'src/app/services/common.service';
import { LayoutService } from 'src/app/services/layout/layout.service';

@Component({
  selector: 'app-job-book',
  templateUrl: './job-book.component.html',
  styleUrls: ['./job-book.component.css']
})
export class JobBookComponent implements OnInit {

  constructor(
    private layoutService: LayoutService,
    private service: CommonService,
    private toastr: ToastrService
  ) { 
    this.layoutService.setBreadcrumb('Job-Book');
  }
  ngOnInit(): void {
  }



  show_farmers_list = false;
  PayDetailes = false;
  itemsList = false;
  show_invoice_list = false;
  paymentInvoice = false;
  showPrintIndent = false;
  loader = false;
  fin_year: string = '';
  cluster_id_list: any = [];
  total_receive_balance: any;
  debit_balance: any;
  cluster_id: any;
  farmer_list: any;
  expenditure_ammount_list: any;
  miscellaneous_payments: any;
  gs_ammount: any;


  changeFinancialYear(financialYear: string) {
    this.fin_year = financialYear;
    this.loadClusterIds();
  }
  loadClusterIds = async () => {
      this.loader = true;
      let gsResponce = this.service.get('/accountant/getJalanidhiGovtShare?fin_year=' + this.fin_year);
      this.cluster_id_list = await this.service.get('/accountant/getAllClusterIds?fin_year=' + this.fin_year);
      this.loader = false;

      let response1 = await this.service.get('/accountant/getAvailableBalanceDetail?fin_year=' + this.fin_year);
      let gsRData = await gsResponce;
      let govtShare = gsRData;
      this.total_receive_balance = response1.total_receive_balance;
      this.debit_balance = '29000';
      this.debit_balance = parseInt(response1.paid_farmers) * parseInt(govtShare[0].govt_share_ammount);
  }
  loadFarmerPayments = async () => {
      this.loader = true;
      let gsResponce = this.service.get('/accountant/getJalanidhiGovtShare?fin_year=' + this.fin_year);
      let ex_am_response = this.service.get('/accountant/getAllExpenditueAmmountsForJobBook?fin_year=' + this.fin_year + '&cluster_id=' + this.cluster_id.cluster_id);
      let mis_response = this.service.get('/accountant/getAllMiscellaneousAmmountsForJobBook?fin_year=' + this.fin_year + '&cluster_id=' + this.cluster_id.cluster_id);
      const response = await this.service.get('/accountant/getFarmerPayments?cluster_id=' + this.cluster_id.cluster_id);
              this.farmer_list = response;
              let gsRData = await gsResponce;
              let govtShare = gsRData;
              let expnd_res = await ex_am_response;
              this.expenditure_ammount_list = expnd_res;
              let mls_res = await mis_response;
              this.miscellaneous_payments = mls_res;
              this.gs_ammount = govtShare[0].govt_share_ammount;
              this.loader = false;
              this.show_farmers_list = true;
  }




}

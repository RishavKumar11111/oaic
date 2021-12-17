import { Component, OnInit } from '@angular/core';
import { CommonService } from 'src/app/services/common.service';
import { LayoutService } from 'src/app/services/layout/layout.service';


@Component({
  selector: 'app-confirmed-payments-list',
  templateUrl: './confirmed-payments-list.component.html',
  styleUrls: ['./confirmed-payments-list.component.css']
})
export class ConfirmedPaymentsListComponent implements OnInit {

  selectedApproval: any = {};
  constructor(private service: CommonService,
    private layoutService: LayoutService) {
      this.layoutService.setBreadcrumb('Confirmed Payments Report');
  }

  ngOnInit(): void {
  }



  token = `document.querySelector('meta[name="csrf-token"]').getAttribute('content')`;
  loadingData: boolean = false;
  showTable: boolean = true;
  paymentInvoice: boolean = false;
  approve: boolean = false;
  fin_year: string = '';
  fin_year_list: any = [];
  approvedPaymentList: any = [];

  changeFinancialYear(financialYear: string) {
    this.fin_year = financialYear;
    this.showPendingPayments();
  }
  showPendingPayments = async () => {
    this.loadingData = true;
    let response = await this.service.get('/bank/getApprovedPayments?fin_year=' + this.fin_year);
    this.loadingData = false;
    this.showTable = true;
    this.approvedPaymentList = response;
  }
  viewDetails = (x: any) => {
    this.selectedApproval = x;
    this.loadingData = true;
    this.paymentInvoice = true;
    this.showTable = false;
    this.loadingData = false;
  }
  back = () => {
      this.paymentInvoice = false;
      this.showTable = true;
      this.approve = false;
  }

}

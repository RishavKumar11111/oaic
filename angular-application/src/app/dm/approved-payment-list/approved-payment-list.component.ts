import { Component, OnInit } from '@angular/core';
import { CommonService } from 'src/app/services/common.service';
import { LayoutService } from 'src/app/services/layout/layout.service';


@Component({
  selector: 'app-approved-payment-list',
  templateUrl: './approved-payment-list.component.html',
  styleUrls: ['./approved-payment-list.component.css']
})
export class ApprovedPaymentListComponent implements OnInit {

  selectedApproval: any;
  constructor(
    private layoutService: LayoutService,
    private service: CommonService) { 
    this.layoutService.setBreadcrumb('Confirmed Payments List');

    }

  ngOnInit(): void {
  }



  loadingData: boolean = false;
  showTable: boolean = true;
  paymentInvoice: boolean = false;
  approve: boolean = false;
  fin_year: string = '';
  approvedPaymentList: any = [];

  changeFinancialYear(financialYear: string) {
    this.fin_year = financialYear;
    this.showPendingPayments();
  }
  showPendingPayments = async () => {
    this.loadingData = true;
    this.approvedPaymentList = await this.service.get(`/dm/getApprovedPayments?fin_year=${this.fin_year}`);
    this.loadingData = false;
    this.showTable = true;
  }
  viewDetails = (x: any) => {
      this.loadingData = true;
      this.selectedApproval = x;
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

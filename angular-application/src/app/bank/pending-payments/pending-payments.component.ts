import { Component, OnInit } from '@angular/core';
import { ToastrService } from 'ngx-toastr';
import { CommonService } from 'src/app/services/common.service';
import { LayoutService } from 'src/app/services/layout/layout.service';


@Component({
  selector: 'app-pending-payments',
  templateUrl: './pending-payments.component.html',
  styleUrls: ['./pending-payments.component.css']
})
export class PendingPaymentsComponent implements OnInit {

  selectedApproval: string = '';
  constructor(
    private service: CommonService,
    private layoutService: LayoutService,
    private toastr: ToastrService
  ) { 
    this.layoutService.setBreadcrumb('Confirm Pending Payments');
  }

  ngOnInit(): void {    
  }

  showTable: boolean = true;
  paymentInvoice: boolean = false;
  approve: boolean = false;
  loadingData: boolean = false;
  fin_year: string = '';
  fin_year_list: any = [];
  pendingPaymentList: any = [];

  totalAmmount: any;
  selected_items: any = [];


  changeFinancialYear(financialYear: string) {
    this.fin_year = financialYear;
    this.showPendingPayments();
  }
  showPendingPayments = async () => {
      this.loadingData = true;
      let response = await this.service.get('/bank/getAllPaymentApprovals?fin_year=' + this.fin_year);
      this.loadingData = false;
      this.showTable = true;
      this.pendingPaymentList = response;
  }
  
  viewDetails = async (x: any) => {
      this.selectedApproval = x;
      this.loadingData = true;
      this.paymentInvoice = true;
      this.showTable = false;
      this.loadingData = false;
  }
  showApprovePayments = () => {
      this.totalAmmount = 0;
      this.selected_items = this.pendingPaymentList.filter((x: any) => {
          if (x.checkbox) {
              return x;
          }
      })
      this.approve = true;
      this.showTable = false;
  }
  approvePayments = async () => {
      try {
        this.loadingData = true;
        this.approve = false;
          await this.service.post(`/bank/confirmPayments`, { approval_list: this.selected_items });
          this.toastr.success('Successfully Confirmed the Payments.', '200');
          this.back();
          this.showPendingPayments();
      } catch (e) {
          window.alert('Server error. Please try again.');
          console.error(e);
          this.loadingData = false;
          this.approve = true;
      }
  }
  back = () => {
      this.paymentInvoice = false;
      this.showTable = true;
      this.approve = false;
  }










}

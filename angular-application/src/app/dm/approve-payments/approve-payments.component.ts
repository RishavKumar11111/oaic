import { Component, OnInit } from '@angular/core';
import { ToastrService } from 'ngx-toastr';
import { CommonService } from 'src/app/services/common.service';
import { LayoutService } from 'src/app/services/layout/layout.service';

@Component({
  selector: 'app-approve-payments',
  templateUrl: './approve-payments.component.html',
  styleUrls: ['./approve-payments.component.css']
})
export class ApprovePaymentsComponent implements OnInit {


    selectedApproval: any;

  constructor(
    private layoutService: LayoutService,
    private service: CommonService,
    private toastr: ToastrService
    ) { 
    this.layoutService.setBreadcrumb('Confirm Pending Payments');
  }

  ngOnInit(): void {
  }



  dist_id: string = `document`;
  showTable: boolean = true;
  paymentInvoice: boolean  = false;
  approve: boolean = false;
  loadingData: boolean = false;
  fin_year: string = '';
  pendingPaymentList: any = [];
  selected_items: any = [];
  totalAmmount: any;


  changeFinancialYear(financialYear: string) {
    this.fin_year = financialYear;
    this.showPendingPayments();
  }
  showPendingPayments = async () => {
      this.loadingData = true;
      let response = await this.service.get('/dm/getAllPaymentApprovals?fin_year=' + this.fin_year);
      this.pendingPaymentList = response.filter((e: any) => e.approval_date = new Date(e.approval_date));
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
  showApprovePayments = () => {
      this.totalAmmount = 0;
      this.selected_items = this.pendingPaymentList.filter((x: any, index: number) => {
          if (x.checkbox) {
              return x;
          }
      })
      this.approve = true;
      this.showTable = false;
  }
  approvePayments = async() => {
      this.loadingData = true;
      this.approve = false;
      try {
          let approval_ids = this.selected_items.map((item: any) => {
              return {  approval_id: item.approval_id,  pp_id: item.pp_id  }
          })
          await this.service.post('/dm/forwardToBank', { approval_ids: approval_ids });
          this.toastr.success('Successfully forwarded to bank.');
          window.location.href = "/dm/approvePayments";
          this.loadingData = false;
      } catch (e) {
          this.toastr.error('Server problem. Please try again.');
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

import { ToastrService } from 'ngx-toastr';
import { LayoutService } from 'src/app/services/layout/layout.service';
import { Component, OnInit } from '@angular/core';
import { CommonService } from 'src/app/services/common.service';


@Component({
  selector: 'app-withheld-amount',
  templateUrl: './withheld-amount.component.html',
  styleUrls: ['./withheld-amount.component.css']
})
export class WithheldAmountComponent implements OnInit {

  constructor(
        private layoutService: LayoutService,
        private service: CommonService,
        private toastr: ToastrService
  ) { 
        this.layoutService.setBreadcrumb('Wthheld Amount');
  }

  ngOnInit(): void {
  }



  dl_id = `document.querySelector('meta[name="dl_id"]').getAttribute('content')`;
  show_invoice_list = false;
  printPage = false;
  loader: boolean = false;
  fin_year: string = '';

  invoice_list: any = [];

  approval_id: any;
  indent_no: any;
  invoice_no: any;
  indent_amount: any;
  invoice_amount: any;
  invoice_date: any;
  indent_date: any;
  subTotal: any;
  paid_amount: any;
  pending_amount: any;
  remark: any;

  searchInvoiceNo: string = '';
  searchApprovalID: string = '';
  dl_remark: string = '';
  


  changeFinancialYear(financialYear: string) {
    this.fin_year = financialYear;
    this.loadInvoices();
  }

  loadInvoices = async () =>  {
      this.printPage = false;
      this.show_invoice_list = false;
      this.loader = true;
      this.invoice_list = await this.service.get(`/dl/getFinYearWisePendingApprovalList?fin_year=${this.fin_year}`)
      this.loader = false;
      this.show_invoice_list = true;
  }
  loadDetail = (x: any) => {
      this.approval_id = x.approval_id;
      this.indent_no = x.indent_no;
      this.invoice_no = x.invoice_no;
      this.indent_amount = x.indent_ammount;
      this.invoice_amount = x.invoice_ammount;
      this.invoice_date = new Date(x.invoice_date);
      this.indent_date = new Date(x.indent_date);
      this.indent_no = x.indent_no;
      this.invoice_no = x.invoice_no;
      this.subTotal = x.ammount;
      this.paid_amount = x.ammount - x.deduction_amount;
      this.pending_amount = x.deduction_amount;
      this.remark = x.remark;

  }
  resolveIssue = async () => {
      try {
          await this.service.post(`/dl/updateApprovalToPayble`, { approval_id: this.approval_id, dl_remark: this.dl_remark });
          this.toastr.success('Thank you. The withheld amount resolved successfully.');
          this.loadInvoices();
      } catch (e) {
          this.toastr.error('Failed to resolve that withheld amount. Please try again');
          console.error(e);
      }
  }







}

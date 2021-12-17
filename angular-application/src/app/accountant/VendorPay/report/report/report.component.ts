import { Component, OnInit } from '@angular/core';
import { LayoutService } from 'src/app/services/layout/layout.service';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { CommonService } from 'src/app/services/common.service';
import { ToastrService } from 'ngx-toastr';
import { FormControl, FormGroup } from '@angular/forms';
declare const Enumerable: any;

@Component({
  selector: 'app-report',
  templateUrl: './report.component.html',
  styleUrls: ['./report.component.css']
})
export class ReportComponent implements OnInit {
  dist_id: any;
  fin_year: any;
  dealer: any = {};
  approval_status: any;
  show_approval_list: any = true;
  show_approval_print: any = false;
  loader: any = false;
  dealer_list: any;
  approval_list: any = [];
  invoice_no: any ;
  indent_no: any ;
  invoice_date: any ;
  indent_date: any ;
  indent_amount: any ;
  invoice_amount: any ;
  remark: any ;
  paid_amount: any ;
  deduction_amount: any ;
  pay_now: any ;
  selected_dl_id: any ;
  subTotal: any ;
  dl: any ;
  less_cgst: any;
  less_sgst: any;
  invoice_items: any;
  
  constructor(
    private layoutService: LayoutService,
    private service: CommonService,
    private http: HttpClient,
    private toastr: ToastrService
  ) {
    this.layoutService.setBreadcrumb('Vendor Pay / Report');
    this.dist_id = layoutService.getDistrictID();
  }

  ngOnInit(): void {
  }

  changeFinancialYear(financialYear: string) {
    this.fin_year = financialYear;
    this.loadInvoiceListByFinYearWise();
    this.loadDealers();
  }

  loadDealers = async()=> {
    this.loader = true;
    let response = await this.service.get('/accountant/getAllDistWiseDelear?fin_year=' + this.fin_year + '&dist_id=' + this.dist_id)
    this.dealer_list = response;
    this.loader = false;
    }

  loadInvoiceListByFinYearWise = async () => {
      this.loader = true;
      const response = await this.service.get('/accountant/getFinYearWiseApprovalList?fin_year='+this.fin_year + '&dist_id='+ this.dist_id);
      this.approval_list = response;
      this.loader = false;
      this.show_approval_list = true;
  }

  loadApprovalListByDealer = () => {

  }

  loadApprovalListByStatus = () => {
    
  }
  
  showApproval = async (x: any) => {
      this.show_approval_list = false;
      this.show_approval_print = true;
      this.loader = true;
      try{
          let response = await this.service.get('/accountant/getApprovalDetail?approval_id=' + x.approval_id);
          let ad = response.aprDetail;
          this.invoice_no = ad.invoice_no;
          this.indent_no = ad.indent_no;
          this.invoice_date = new Date(ad.invoice_date);
          this.indent_date = new Date(ad.indent_date);
          this.indent_amount = ad.indent_ammount;
          this.invoice_amount = ad.invoice_ammount;
          this.remark = ad.remark;
          this.paid_amount = ad.paid_amount;
          this.deduction_amount = ad.deduction_amount;
          this.pay_now = ad.pay_now_amount;
          this.selected_dl_id = ad.dl_id;
          this.subTotal = ad.full_amount;

          this.dl = {
              dl_name: ad.LegalBussinessName,
              dl_address: ad.dl_address,
              bank_name: ad.bank_name,
              dl_ac_no: ad.dl_ac_no,
              dl_ifsc_code: ad.dl_ifsc_code,
              dl_mobile_no: ad.dl_mobile_no,
              dl_email: ad.dl_email
          };
          this.less_cgst = 0;
          this.less_sgst = 0;
          this.invoice_items = Enumerable.From(response.apprItems)
                  .GroupBy((item: any) => { return item.implement && item.make && item.model; })
                  .Select( (item: any)=> {
                      item.source[0].quantity = item.source.length;
                      return item.source[0];
                  })
                  .ToArray();
              this.invoice_items.forEach((element: any) => {
                  element.taxableValue = parseInt(element.quantity) * parseFloat(element.p_taxable_value);
                  this.less_cgst = parseFloat(this.less_cgst) + (parseInt(element.quantity) * parseFloat(element.p_cgst_1));
                  this.less_sgst = parseFloat(this.less_sgst) + (parseInt(element.quantity) * parseFloat(element.p_sgst_1));
                  element.invoiceValue = parseInt(element.quantity) * (parseFloat(element.p_invoice_value));
              })
          this.loader = false;
      } catch(e: any) {
          console.error(e.data);
          window.alert("Data can't fetch now. Please try again.");
          this.loader = false;
          
      }
  }
  back = () => {
    this.show_approval_print = false;
    this.show_approval_list = true;
  }


}

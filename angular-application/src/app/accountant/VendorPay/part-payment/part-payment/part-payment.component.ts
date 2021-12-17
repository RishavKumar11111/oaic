import { Component, OnInit } from '@angular/core';
import { LayoutService } from 'src/app/services/layout/layout.service';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { CommonService } from 'src/app/services/common.service';
import { ToastrService } from 'ngx-toastr';
import { FormControl, FormGroup } from '@angular/forms';
declare const Enumerable: any

@Component({
  selector: 'app-part-payment',
  templateUrl: './part-payment.component.html',
  styleUrls: ['./part-payment.component.css']
})
export class PartPaymentComponent implements OnInit {
  dist_id: any;
  fin_year: any;
  dealer: any ={};
  PayDetailes: any = false;
  show_invoice_list: any = true;
  paymentInvoice: any = false;
  showPrintIndent: any = false;
  loader: any = false;
  dealer_list: any=[];
  invoice_list: any = [];
  approval: any ;
  approval_id: any;
  indent_amount: any ;
  invoice_amount: any ;
  invoice_date: any ;
  indent_date: any ;
  indent_no: any ;
  invoice_no: any ;
  subTotal: any ;
  paid_amount: any ;
  pending_amount: any ;
  remark: any ;
  dl_remark: any ;
  less_cgst: any ;
  less_sgst: any ;
  selected_dl_id: any ;
  dl: any ;
  tax_mode: any ;
  gst_rate: any ;
  invoice_items: any;
  pay_now : any;
  deduction_amount: any;

  constructor(
    private layoutService: LayoutService,
    private service: CommonService,
    private http: HttpClient,
    private toastr: ToastrService
  ) {
    this.layoutService.setBreadcrumb('Vendor Pay / Part payment to vendor');
    this.dist_id = layoutService.getDistrictID();
  }

  ngOnInit(): void {
  }

  changeFinancialYear(financialYear: string) {
    this.fin_year = financialYear;
    this.loadApprovalPendingPaymentListByFinYearWise();
    this.loadDealers();
  }

  loadDealers = async()=> {
    let response = await this.service.get('/accountant/getAllDistWiseDelear?fin_year=' + this.fin_year + '&dist_id=' + this.dist_id)
    this.dealer_list = response;
    }

  loadApprovalPendingPaymentListByFinYearWise = async () => {
      this.loader = true;
      let response = await this.service.get('/accountant/getFinYearWisePendingApprovalList?fin_year=' + this.fin_year + '&dist_id=' + this.dist_id)
      this.invoice_list = response;
      this.loader = false;
      this.show_invoice_list = true;
      this.paymentInvoice = false;
            
    }
   
    
    loadList = async (x: any) => {
        this.approval = x;
        this.approval_id = x.approval_id;
        this.indent_amount = x.indent_ammount;
        this.invoice_amount = x.invoice_ammount;
        this.invoice_date = new Date(x.invoice_date);
        this.indent_date = new Date(x.indent_date);
        this.indent_no = x.indent_no;
        this.invoice_no = x.invoice_no;
        this.subTotal = x.ammount;
        this.paid_amount = x.paid_amount;
        this.pending_amount = x.deduction_amount;
        this.remark = x.remark;
        this.dl_remark = x.dl_remark;
        this.less_cgst = 0;
        this.less_sgst = 0;
        this.selected_dl_id = x.dl_id;

        let response = await this.service.get('/accountant/getDelearDetails?dl_id=' + x.dl_id)
        this.dl = response;
        this.tax_mode = x.gst_rate == null ? 1 : 2;
        this.gst_rate = x.gst_rate;

        let response1 = await this.service.get('/accountant/getApprovalItemsForPay?approval_id=' + x.approval_id)
        
        this.invoice_items = Enumerable.From(response1)
                    .GroupBy((item: any) => { return item.implement && item.make && item.model; })
                    .Select((item: any) => {
                        item.source[0].quantity = item.source.length;
                        return item.source[0];
                    })
                    .ToArray();
                this.invoice_items.forEach((element: any) => {
                    element.taxableValue = parseInt(element.quantity) * parseFloat(element.p_taxable_value);
                    this.less_cgst = parseFloat(this.less_cgst) + (parseFloat(element.quantity) * parseFloat(element.p_cgst_1));
                    this.less_sgst = parseFloat(this.less_sgst) + (parseFloat(element.quantity) * parseFloat(element.p_sgst_1));
                    if (this.tax_mode == 1) {
                        element.invoiceValue = parseInt(element.quantity) * (parseFloat(element.p_invoice_value));
                    } else {
                        element.sgst = element.cgst = ((parseFloat(element.taxableValue) / 100) * this.gst_rate) / 2;
                        element.invoiceValue = parseFloat(element.taxableValue) + parseFloat(element.cgst) + parseFloat(element.sgst);
                    }
                })
            
    }

    showDetailesOfPayment = async () => {
        this.pay_now = this.pending_amount - this.deduction_amount;
        this.paymentInvoice = true;
        this.show_invoice_list = false;
    }
    sendApproval = async() => {
        this.approval.deduction_amount = this.deduction_amount;
        this.approval.sub_total = this.subTotal;
        this.approval.paid_amount = this.paid_amount;
        this.approval.pending_amount = this.pending_amount;
        this.approval.pay_now = this.pay_now;
        this.approval.remark = this.remark;
        try {
           
            await this.service.post('/accountant/updatePartPaymentApproval',this.approval);
            // printElem('approval');
            setTimeout(() => {
                window.location.href = "/accountant/dealerPartPayment";
            }, 500);
        } catch (e: any) {
            window.alert('Failed to send approval. Please try again');
            console.error(e.data);
        }
    }
    back = () => {
      this.remark = '';
      this.deduction_amount = 0;
      this.paymentInvoice = false;
      this.show_invoice_list = true;
    }


}

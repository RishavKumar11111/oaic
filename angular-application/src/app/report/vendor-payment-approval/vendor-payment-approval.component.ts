import { Component, Input, OnInit } from '@angular/core';
import { ToastrService } from 'ngx-toastr';
import { CommonService } from 'src/app/services/common.service';

declare const Enumerable: any;

@Component({
  selector: 'app-vendor-payment-approval',
  templateUrl: './vendor-payment-approval.component.html',
  styleUrls: ['./vendor-payment-approval.component.css']
})
export class VendorPaymentApprovalComponent implements OnInit {

  @Input() invoice_list: any = [];
  @Input() payList: any = {};
  @Input() selectedApproval: any;

  indent_no: string = '';
  indent_date: any = '';
  invoice_no: string = '';
  invoice_date: any = '';
  indent_amount: string = '';
  invoice_amount: string = '';
  remark: string = '';
  subTotal: string = '';
  paid_amount: string = '';
  deduction_amount: string = '';
  pay_now: number = 0;
  dl: any = {};

  less_cgst: any = '';
  less_sgst: any = '';
  invoice_items: any = [];
  gst_rate: any = '';
  paymentDetails: any = [];
  quantity: any;
  DMDetails: any = [];
  AccountantDetails: any = [];
  POType: any;
  CustomerDetails: any = [];
  constructor(
    private service: CommonService,
    private toastr: ToastrService

  ) { }

  ngOnInit(): void {
    this.showIndent();

    // console.log(this.quantity,'qty');    
    // this.paymentDetails[0].TotalSellTaxableValue = (this.paymentDetails[0].SellTaxableValue * this.quantity).toFixed(2);
    // this.paymentDetails[0].TotalSellInvoiceValue = (this.paymentDetails[0].SellInvoiceValue * this.quantity).toFixed(2);
    // this.paymentDetails[0].TotalSellCGST = (this.paymentDetails[0].SellCGST * this.quantity).toFixed(2);
    // this.paymentDetails[0].TotalSellSGST = (this.paymentDetails[0].SellSGST * this.quantity).toFixed(2);
    // this.paymentDetails[0].TotalSellIGST = (this.paymentDetails[0].SellIGST * this.quantity).toFixed(2);



    // this.loadApprovalDetails();
  }
  // loadApprovalDetails = async () => {
  //   let x = this.selectedApproval;
  //   let response = await this.service.get('/report/getApprovalDetails?approval_id=' + x.approval_id);
  //             let invoice = response.invoice;
  //             this.indent_no = invoice.indent_no;
  //             this.indent_date = new Date(invoice.indent_date);
  //             this.invoice_no = invoice.invoice_no;
  //             this.invoice_date = new Date(invoice.invoice_date);
  //             this.indent_amount = invoice.indent_ammount;
  //             this.invoice_amount = invoice.invoice_ammount;
  //             this.remark = x.remark;
  //             this.subTotal = x.ammount;
  //             this.paid_amount = x.paid_amount;
  //             this.deduction_amount = x.deduction_amount;
  //             this.pay_now = +((+x.pay_now_amount).toFixed(2));

  //             this.dl = response.dl;
  //             this.less_cgst = 0;
  //             this.less_sgst = 0;
  //             this.invoice_items = Enumerable.From(response.data)
  //                 .GroupBy((item: any) => { return item.implement && item.make && item.model; })
  //                 .Select(function(item: any) {
  //                     item.source[0].quantity = item.source.length;
  //                     return item.source[0];
  //                 })
  //                 .ToArray();
  //             this.invoice_items.forEach((element: any) => {
  //                 element.taxableValue = parseInt(element.quantity) * parseFloat(element.p_taxable_value);
  //                 this.less_cgst = parseFloat(this.less_cgst) + (parseFloat(element.quantity) * parseFloat(element.p_cgst_1));
  //                 this.less_sgst = parseFloat(this.less_sgst) + (parseFloat(element.quantity) * parseFloat(element.p_sgst_1));
  //                 element.invoiceValue = parseInt(element.quantity) * (parseFloat(element.p_invoice_value));

  //             })
  // }

  showIndent = async () => {
    try {
      this.paymentDetails = this.payList;
      this.quantity = this.paymentDetails[0].ItemQuantity;
      this.POType = this.paymentDetails[0].POType;
      this.AccountantDetails = await this.service.get('/accountant/getAccName');
      this.DMDetails = await this.service.get('/accountant/getDMDetails');
      this.CustomerDetails = await this.service.get(`/accountant/getCustomerDetailsForInvoice?CustomerID=${this.paymentDetails[0].CustomerID}`);
    } catch (e) {
      console.error(e);
    }
  }
  showInvoice = async () => {

  }

}

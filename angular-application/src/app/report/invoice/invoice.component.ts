import { Component, Input, OnInit } from '@angular/core';
import { ToastrService } from 'ngx-toastr';
import { CommonService } from 'src/app/services/common.service';

@Component({
  selector: 'app-invoice',
  templateUrl: './invoice.component.html',
  styleUrls: ['./invoice.component.css']
})
export class InvoiceComponent implements OnInit {

  DMDetails: any = {};
  AccountantDetails: any = {}
  invoice_no: any
  invoice_date: any
  @Input() x: any = {};
  @Input() orderList: any = [];
  @Input() POType: any;
  @Input() invoicedata: any = [];
  receiverGstin: any
  totalAmount: number = 0;
  CustomerDetails: any = [];
  constructor(private service: CommonService, private toastr: ToastrService) {
    this.loadDMDetails();
  }

  ngOnInit(): void {
    this.totalAmount = this.orderList.reduce((a: any, b: any) => a + +b.TotalSellInvoiceValue, 0);
    if (this.POType.value == 'NonSubsidy') {
      this.loadCustomerDetails();
    }

  }

  loadDMDetails = async () => {
    try {
      this.AccountantDetails = await this.service.get('/accountant/getAccName');
      this.DMDetails = await this.service.get('/accountant/getDMDetails');
    } catch (e) {
      console.error(e);
      this.toastr.error('Error');
    }
  }


  loadCustomerDetails = async () => {
    try {
      this.CustomerDetails = await this.service.get(`/accountant/getCustomerDetailsForInvoice?CustomerID=${this.orderList[0].CustomerID}`);
    } catch (e) {
      console.error(e);
      this.toastr.error('Error');
    }
  }

}

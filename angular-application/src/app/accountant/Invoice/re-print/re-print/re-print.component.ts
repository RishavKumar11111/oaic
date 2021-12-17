import { Component, OnInit } from '@angular/core';
import { LayoutService } from 'src/app/services/layout/layout.service';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { CommonService } from 'src/app/services/common.service';
import { ToastrService } from 'ngx-toastr';
import { FormControl, FormGroup } from '@angular/forms';

@Component({
  selector: 'app-re-print',
  templateUrl: './re-print.component.html',
  styleUrls: ['./re-print.component.css']
})
export class RePrintComponent implements OnInit {
  dist_id: any;
  fin_year: any;
  fromDate: any;
  toDate: any;
  matchByFarmerName: any;
  matchByPermitNo: any;
  showTable: any = true;
  loader: any = false;
  DMDetails: any = [];
  items: any = [];
  invoice: boolean = false;
  InvoiceDetails: any;
  printIndent: boolean = false;
  showHeader: boolean = true;
  orderList: any;
  CustomerInvoiceNo: any;
  x: any;
  POType: FormControl = new FormControl();
  invoicedata: any;
  CustomerDetails:any;

  constructor(
    private layoutService: LayoutService,
    private service: CommonService,
    private http: HttpClient,
    private toastr: ToastrService
  ) {
    this.layoutService.setBreadcrumb('Invoice / Re-print');
    this.dist_id = layoutService.getDistrictID();
  }

  ngOnInit(): void {
  }

  changeFinancialYear(financialYear: string) {
    this.fin_year = financialYear;
    this.loadList();
  }

  getDMDetails = async () => {
    let response = await this.service.get('/accountant/getDMDetails');
    this.DMDetails = response;
  }

  loadList = async () => {
    this.loader = true;
    let response = await this.service.get('/accountant/getAllDeliveredToCustomerOrders?dist_id=' + this.dist_id + '&fin_year=' + this.fin_year)
    this.items = response;
    console.log(this.items,'item from db');    
    this.loader = false;
    this.showTable = true;
  }

  showDetails = async (x: any) => {
    this.x = x;
    this.invoicedata = {
      CustomerInvoiceNo : x.CustomerInvoiceNo,
      InsertedDate : x.InsertedDate
    };
    this.CustomerInvoiceNo = x.CustomerInvoiceNo;
    this.POType.setValue(x.POType);
    this.showTable = false;
    this.showHeader = false;
    const response = await this.service.get('/accountant/getCustomerInvoiceDetails?CustomerInvoiceNo=' + this.CustomerInvoiceNo);
    this.orderList = response;
    this.printIndent = true;
  }

  back = () => {
    this.printIndent = false;
    this.showTable = true;
    this.showHeader = true;
  }

}

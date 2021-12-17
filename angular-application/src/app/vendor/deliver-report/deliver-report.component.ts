import { Component, OnInit } from '@angular/core';
import { CommonService } from 'src/app/services/common.service';
import { LayoutService } from 'src/app/services/layout/layout.service';

@Component({
  selector: 'app-deliver-report',
  templateUrl: './deliver-report.component.html',
  styleUrls: ['./deliver-report.component.css']
})
export class DeliverReportComponent implements OnInit {

  constructor(
        private layoutService: LayoutService,
        private service: CommonService
  ) { 
        this.layoutService.setBreadcrumb('Deliver Report');    
  }

  ngOnInit(): void {
  }


    show_invoice_list = false;
    printPage: boolean = false;
    loader = false;
    first_box = true;
    fin_year = '';
    invoice_no: any = '';
    searchInvoiceNo: string= '';
    invoiceItems: any = [];
    invoice_list: any = [];
    total: any;
    invoice_data: any = {};
    my_bill_amount: any;
    changeFinancialYear(financialYear: string) {
      this.fin_year = financialYear;
      this.loadInvoices();
    }
    loadInvoices = async () => {
        this.printPage =false;
        this.show_invoice_list = false;
        this.loader = true;
        this.invoice_list= await this.service.get(`/dl/getAllInvoices?fin_year=${this.fin_year}`);
        this.loader = false;
        this.show_invoice_list = true;
    }
    showInvoice = async (invoice_no: any) => {
        this.show_invoice_list = false;
        this.printPage =false;
        this.loader = true;
        const response = await this.service.get('/dl/getInvoiceDetailsByInvoiceNo?invoice_no='+ invoice_no);
            this.invoice_data = response.invoiceItemsList[0];            
            this.my_bill_amount = 0;
            this.invoiceItems = response.invoiceItemsList;
            this.total = this.invoiceItems.reduce((a: any, b: any) => a + +b.TotalPurchaseInvoiceValue, 0);;
            this.invoice_no = invoice_no;
            this.loader = false;
            this.first_box = false;
            this.printPage = true;
          
    }
    back = () => {
        this.printPage =false;
        this.show_invoice_list = true;
        this.first_box = true;
    }





}

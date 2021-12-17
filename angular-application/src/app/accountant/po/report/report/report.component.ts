import { FormControl } from '@angular/forms';
import { Component, OnInit } from '@angular/core';
import { ToastrService } from 'ngx-toastr';
import { CommonService } from 'src/app/services/common.service';
import { LayoutService } from 'src/app/services/layout/layout.service';

@Component({
  selector: 'app-report',
  templateUrl: './report.component.html',
  styleUrls: ['./report.component.css']
})
export class ReportComponent implements OnInit {

  PODetails: any = {};
  PONo: FormControl = new FormControl('');

  constructor(
    private layoutService: LayoutService,
    private service: CommonService,
    private toastr: ToastrService
  ) { 
    this.layoutService.setBreadcrumb('Purchase Order / Cancellation of P.O.');
  }
  ngOnInit(): void {
  }






  indentsTable = false;
    printIndent = false;
    loadingData = false;
    first_box = true;
    fin_year: string = '';
    acc_name: string = ''
    paidListData: any = [];
    paymentList: any;
    search_dealer_name: string = '';
    search_indent_no: string = '';

    changeFinancialYear(financialYear: string) {
      this.fin_year = financialYear;
      this.loadManf();
    }
    loadAccDetails = async () => {
        const response = await this.service.get('/accountant/getAccName');
        this.acc_name = response.acc_name;
    }
    loadManf = async () => {
        this.loadingData = true;
        this.paidListData = await this.service.get('/accountant/getAllCancelledIndentList?fin_year=' + this.fin_year);
                this.printIndent = false;
                this.indentsTable = true;
                this.loadingData = false;
    }
    showDetails = async (PONo: any) => {
      this.indentsTable = false;
      this.loadingData = true;
      this.PONo.setValue(PONo);

      const response = await this.service.get('/api/getPODetails?PONumber=' + PONo);
      this.PODetails = response;
      this.loadingData = false;
      this.first_box = false;
      this.printIndent = true;
        // this.indentsTable = false;
        // this.loadingData = true;
        // const response = await this.service.get('/accountant/getIndentDetailsByIndentNo?indent_no=' + indent_no);
        //         this.paymentList = response;
        //         var data = Enumerable.From(this.paymentList)
        //             .GroupBy(function (item) { return (item.implement && item.make && item.model); })
        //             .Select(function (item) {
        //                 let length = item.source.length;
        //                 let newItem = {};
        //                 newItem.items = length;
        //                 newItem.implement = item.source[0].implement;
        //                 newItem.make = item.source[0].make;
        //                 newItem.model = item.source[0].model;
        //                 newItem.dl_name = item.source[0].LegalBussinessName;
        //                 newItem.purchase_price = parseInt(item.source[0].p_taxable_value) * parseInt(length);
        //                 newItem.tax_1 = parseInt(item.source[0].p_cgst_6) * parseInt(length);
        //                 newItem.tax_2 = parseInt(item.source[0].p_sgst_6) * parseInt(length);
        //                 newItem.final_ammount = (parseInt(item.source[0].p_invoice_value) ) * parseInt(length);
        //                 return newItem;
        //             })
        //             .ToArray();
        //         this.paymentList = data;

        //         let info = response[0];
        //         this.ref_no = indent_no;
        //         this.indent_date = new Date(info.indent_date);
        //         this.delearName = info.LegalBussinessName;
        //         this.delearAddress = info.dl_address;
        //         this.delearMobile = info.dl_mobile_no;
        //         this.dmName = info.dm_name;
        //         this.loadingData = false;
        //         this.printIndent = true;
        //         this.first_box = false;
    }
    back = () => {
        this.indentsTable = true;
        this.printIndent = false;
        this.first_box = true;
    }








}

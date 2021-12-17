import { Component, OnInit } from '@angular/core';
import { CommonService } from 'src/app/services/common.service';
import { LayoutService } from 'src/app/services/layout/layout.service';

@Component({
  selector: 'app-re-print-mrr',
  templateUrl: './re-print-mrr.component.html',
  styleUrls: ['./re-print-mrr.component.css']
})
export class RePrintMrrComponent implements OnInit {
  
  printData: any = [];
  mrr: any = {};
  constructor(
    private layoutService: LayoutService,
    private service: CommonService
  ) { 
    this.layoutService.setBreadcrumb('Material Receipt Report / Re-Print MRR');
    this.loadAlldetailsFirst();
  }
  ngOnInit(): void {
  }






  changeFinancialYear(financialYear: string) {
    this.fin_year = financialYear;
    this.loadMRRList();
  }
  printPage = false;
  showTable = false;
  loader = false;
  first_card = true;
  fin_year: string = '';
  AccountantDetails: any = {};
  DMDetails: any = {};
  mrr_list: any = [];
  vendorDetails: any;
  received_date: any;
  invoice: any;
  totalPriceInTable: any;
  fromDate: string = '';
  toDate: string = '';
  search_mrr_id: string = '';
  loadAlldetailsFirst = async () => {

    this.AccountantDetails = await this.service.get('/accountant/getAccName');
    this.DMDetails = await this.service.get('/accountant/getDMDetails');
  }
  loadMRRList = async () => {
      this.loader = true;
      const response = await this.service.get('/accountant/getAllDistMRRIds?fin_year=' + this.fin_year);
              this.mrr_list = response;
              this.loader = false;
              this.showTable = true;
  }
  showMRR = async (x: any) => {
      this.mrr.MRRNo = x.MRRNo
      this.showTable = false;
      this.loader = true;
      const response = await this.service.get('/accountant/getMRRDetails?mrr_id=' + x.MRRNo + '&dl_id=' + x.VendorID);      
      let data = response;
      this.vendorDetails = data.dl;
      this.invoice = data.invoice;
      this.printData = data.data;
      this.totalPriceInTable = 0;
      this.loader = false;
      this.printPage = true;
      this.first_card = false;
  }
  back = () => {
      this.printPage = false;
      this.showTable = true;
      this.first_card = true;
  }







}

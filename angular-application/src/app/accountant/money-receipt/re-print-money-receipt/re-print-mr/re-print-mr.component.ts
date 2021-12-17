import { Component, OnInit } from '@angular/core';
import { LayoutService } from 'src/app/services/layout/layout.service';
import { HttpClient } from '@angular/common/http';
import { CommonService } from 'src/app/services/common.service';

@Component({
  selector: 'app-re-print-mr',
  templateUrl: './re-print-mr.component.html',
  styleUrls: ['./re-print-mr.component.css']
})
export class RePrintMrComponent implements OnInit {
  fromDate: any;
  toDate: any;
  search_farmer_name: any;
  search_permit_no: any;
  dist_id: any;
  header: any;
  printPage: any = false;
  loadingData: any = false;
  showData: any = false;
  first_card: any = true;
  fin_year: any;
  data: any = {};
  all_receipts: any = [];
  orderBy: any;
  DMDetails: any;


  constructor(
    private layoutService: LayoutService,
    private service: CommonService
  ) {
    this.layoutService.setBreadcrumb('Money Receipt / Re-print Permit');
    this.dist_id = layoutService.getDistrictID();
  }

  ngOnInit(): void {

  }


  changeFinancialYear(financialYear: string) {
    this.fin_year = financialYear;
    this.loadAllReceiptsByFinYear();
    this.header = true;
  }

  loadAllReceiptsByFinYear = async () => {
    this.loadingData = true;
    let response = await this.service.get('/accountant/getFarmerReceiptsByFinYear?dist_id=' + this.dist_id + '&fin_year=' + this.fin_year);
    this.all_receipts = response;
    this.loadingData = false;
    this.showData = true;

  }

  showReceipt = async (receipt_no: any) => {
    this.showData = false
    this.loadingData = true
    const response = await this.service.get('/accountant/getReceiptDetails?receipt_no=' + receipt_no)
    const result = await this.service.get('/accountant/getDMDetails')
    this.data = response
    this.DMDetails = result
    this.loadingData = false
    this.printPage = true
    this.first_card = false
  }

  back = () => {
    this.showData = true;
    this.printPage = false;
    this.first_card = true;
  }

  sortedOrderOfColumn = (x: any) => {
    this.orderBy = x;
  }

  printElem = (x: any) => {

  }


}

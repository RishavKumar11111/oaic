import { Component, OnInit } from '@angular/core';
import { LayoutService } from 'src/app/services/layout/layout.service';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { CommonService } from 'src/app/services/common.service';

@Component({
  selector: 'app-global',
  templateUrl: './global.component.html',
  styleUrls: ['./global.component.css'],
})
export class GlobalComponent implements OnInit {
  fromDate: any;
  toDate: any;
  dist_id: any;
  header: any;
  ledgerTable: any = false;
  loader: any = false;
  fin_year: any;
  ledgers: any = [];
  opening_balance: any;
  totalCredit: any;
  totalDebit: any;
  total_credit: any;
  total_debit: any;
  orderBy: any;

  constructor(
    private layoutService: LayoutService,
    private service: CommonService,
    private http: HttpClient
  ) {
    this.layoutService.setBreadcrumb('Ledger / Global ledger');
    this.dist_id = layoutService.getDistrictID();
  }

  ngOnInit(): void {}

  changeFinancialYear(financialYear: string) {
    this.fin_year = financialYear;
    this.loadTable();
    this.header = true;
  }

  loadTable = async () => {
    this.loader = true;
    let response = await this.service.get(
      '/accountant/allLedgers?dist_id=' +
        this.dist_id +
        '&fin_year=' +
        this.fin_year
    );

    this.ledgers = response;
    console.log(this.ledgers,"ledgers");
    

    let data = response;
    this.opening_balance = 0;
    this.totalCredit = 0;
    this.totalDebit = 0;
    data.filter((e: any) => (e.date = new Date(e.date)));
    data.sort((a: any, b: any) => a.date - b.date);
    for (let i = 0; i < data.length; i++) {
      if (data[i].to == 'DS-' + this.dist_id) {
        data[i].credit = data[i].ammount;
        data[i].debit = 0;
        this.totalCredit += parseFloat(data[i].credit);
      } else if (data[i].from == 'DS-' + this.dist_id) {
        data[i].debit = data[i].ammount;
        data[i].credit = 0;
        this.totalDebit += parseFloat(data[i].debit);
      }
      if (i == 0) {
        data[i].balance =
          parseFloat(data[i].credit) - parseFloat(data[i].debit);
      } else {
        data[i].balance =
          parseFloat(data[i - 1].balance) +
          parseFloat(data[i].credit) -
          parseFloat(data[i].debit);
      }
    }
    this.total_credit = this.totalCredit;
    this.total_debit = this.totalDebit;
    this.loader = false;
    this.ledgerTable = true;
  };

  sortedOrderOfColumn = (x: any) => {
    this.orderBy = x;
  };
}

import { Component, OnInit } from '@angular/core';
import { LayoutService } from 'src/app/services/layout/layout.service';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { CommonService } from 'src/app/services/common.service';

@Component({
  selector: 'app-cash-book-payments',
  templateUrl: './cash-book-payments.component.html',
  styleUrls: ['./cash-book-payments.component.css']
})
export class CashBookPaymentsComponent implements OnInit {
  dist_id: any;
  fin_year: any;
  header: any;
  showTable: any = false;
  loader: any = false;
  ledgers: any = [];
  totalCredit: any;
  totalDebit: any;


  constructor(
    private layoutService: LayoutService,
    private service: CommonService,
    private http: HttpClient
  ) { 
    this.layoutService.setBreadcrumb('Cashbook / Payments');
    this.dist_id = layoutService.getDistrictID();
  }

  ngOnInit(): void {
  }

  changeFinancialYear(financialYear: string) {
    this.fin_year = financialYear;
    this.loadTable();
    this.header = true;
  }

  
   loadTable = async() => {
        this.loader = true;
        let response = await this.service.get('/accountant/getAllDebitLedgersForPayments?dist_id=' + this.dist_id + '&fin_year=' + this.fin_year)
            
              this.loader = false;
              this.showTable = true;
              this.ledgers = response;
              let data = response;
              this.totalCredit = 0;
              this.totalDebit = 0;
                data.filter((e: any) => e.date = new Date(e.date));
                data.sort((a: any, b: any) => b.date - a.date);
                for (let i = 0; i < data.length; i++) {

                    data[i].debit = data[i].ammount;
                    this.totalDebit += parseInt(data[i].debit);
                    if (i == 0) {
                        data[i].balance = data[i].ammount;
                    } else {
                        data[i].balance = parseInt(data[i - 1].balance) + parseInt(data[i].debit);
                    }
                    switch (data[i].purpose) {

                        case 'pay_against_expenditure':
                            {
                                data[i].perticulars = `Pay against ${data[i].schem_name}
                            on ${data[i].head_name}
                            on ${data[i].subhead_name}`;
                                data[i].links = false;
                                break;
                            }
                        case 'pay_against_expenditure_jn':
                            {
                                data[i].perticulars = `
                            Head : ${data[i].head_name},
                            Sub_head : ${data[i].subhead_name} 
                             JALANIDHHI`;
                                data[i].links = false;
                                break;
                            }
                        case 'pay_against_bill':
                            {
                                data[i].perticulars = `Pay against bill to ${data[i].to}, FARM MECHANISATION`;
                                data[i].links = false;
                                break;
                            }
                        case 'pay_against_bill_jn':
                            {
                                data[i].perticulars = `Pay against bill to ${data[i].to}, JALANIDHI`;
                                data[i].links = false;
                                break;
                            }
                        case 'paid_opening_balance':
                            {
                                data[i].perticulars = `Pay against ${data[i].system}
                            on ${data[i].head}
                            on ${data[i].subhead}
                            (Backlog money)`;
                                data[i].links = false;
                            }
                    }
                }
           
    }
    


}

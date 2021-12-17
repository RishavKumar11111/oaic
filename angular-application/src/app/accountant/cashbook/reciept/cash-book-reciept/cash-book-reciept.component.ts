import { Component, OnInit } from '@angular/core';
import { LayoutService } from 'src/app/services/layout/layout.service';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { CommonService } from 'src/app/services/common.service';

@Component({
  selector: 'app-cash-book-reciept',
  templateUrl: './cash-book-reciept.component.html',
  styleUrls: ['./cash-book-reciept.component.css']
})
export class CashBookRecieptComponent implements OnInit {
  fromDate: any;
  toDate: any;
  dist_id: any;
  fin_year: any;
  header: any;
  showTable: any = true;
  showCashBook: any = false;
  printPage: any = false;
  loader: any = false;
  ledgers: any = [];
  totalCredit: any;
  allData: any = [];
  totalDebit : any ;
  data: any = [];

  constructor(
    private layoutService: LayoutService,
    private service: CommonService,
    private http: HttpClient
  ) { 
    this.layoutService.setBreadcrumb('Cashbook / Receipts');
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
        let response = await this.service.get('/accountant/getAllCreditLedgersForReceipt?dist_id=' + this.dist_id + '&fin_year=' + this.fin_year)
            
        this.loader = false;
        this.showTable = true;
        this.ledgers = response;
                let data = response;
                this.totalCredit = 0;
                data.filter((e:any) => e.date = new Date(e.date));
                data.sort((a: any, b: any) => b.date - a.date);
                for (let i = 0; i < data.length; i++) {
                    data[i].balance = 0;
                    this.totalCredit += parseInt(data[i].ammount);

                    if (i == 0) {
                        data[i].balance = data[i].ammount;
                    } else {
                        data[i].balance = parseInt(data[i].ammount) + parseInt(data[i - 1].balance);
                    }

                    switch (data[i].purpose) {
                        case 'farmerAdvancePayment':
                            {
                                data[i].perticulars = `Received From M/S ${data[i].farmer_name}(${data[i].farmer_id})
                            Impement : ${data[i].implement}
                            Make : ${data[i].make}
                            Model : ${data[i].model}`;
                                data[i].links = true;
                                break;
                            }
                        case 'received_from_dept':
                            {
                                data[i].perticulars = `Received Rupees ${data[i].ammount} only /-
                            from  ${data[i].source_name}
                            under  ${data[i].schem_name}
                            against  ${data[i].comp_name}`;
                                data[i].links = false;
                                break;
                            }
                        case 'received_from_dept_jn':
                            {
                                data[i].perticulars = `Received Rupees ${data[i].ammount} only /-
                            from  JALANIDHI
                            under  ${data[i].scheme_name}
                            against  ${data[i].comp_id}`;
                                data[i].links = false;
                                break;
                            }
                        case 'farmer_advance_payment_jn':
                            {
                                data[i].perticulars = `Received from M/S ${data[i].farmer_name}(${data[i].farmer_id})
                            Impement : ${data[i].implement}
                            Make : ${data[i].make}
                            Model : ${data[i].model}
                            from JALANIDHI`;
                                data[i].links = false;
                                break;
                            }
                    }
                }
           
    }
    
   showDetails = async(permit_no: any) => {
       let response = await this.service.get('/accountant/getCashBookData?permit_no=' + permit_no)
          
        this.allData = response;
        this.showCashBook = true;
        this.showTable = false;

                let data = response;
                this.totalCredit = 0;
                this.totalDebit = 0;
                for (let i = 0; i < data.length; i++) {

                    data[i].date = new Date(data[i].date);
                    if (data[i].to == 'DS-' + this.dist_id) {
                        data[i].credit = data[i].ammount;
                        data[i].debit = 0;
                        this.totalCredit += parseInt(data[i].credit);
                    } else if (data[i].from == 'DS-' + this.dist_id) {
                        data[i].debit = data[i].ammount;
                        data[i].credit = 0;
                        this.totalDebit += parseInt(data[i].debit);
                    }
                    if (i == 0) {
                        data[i].balance = parseInt(data[i].credit) - parseInt(data[i].debit);
                    } else {
                        data[i].balance = (parseInt(data[i - 1].balance) + parseInt(data[i].credit)) - parseInt(data[i].debit);
                    }
                }
          
    }

 showReceipt = async(permit_no : any) => {
        let response = await this.service.get('/accountant/getReceiptDetailsByPermitNo?permit_no=' + permit_no)
        this.data = response;
        this.showTable = false;
        this.printPage = true;
            
    }

   back = () => {
        this.showCashBook = false;
        this.printPage = false;
        this.showTable = true;
    }

}

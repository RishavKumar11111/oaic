import { Component, OnInit } from '@angular/core';
import { LayoutService } from 'src/app/services/layout/layout.service';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { CommonService } from 'src/app/services/common.service';


@Component({
  selector: 'app-cash-book-consolidated',
  templateUrl: './cash-book-consolidated.component.html',
  styleUrls: ['./cash-book-consolidated.component.css']
})
export class CashBookConsolidatedComponent implements OnInit {
  fromDate: any;
  toDate: any;
  dist_id: any;
  fin_year : any;
  header: any;
  showTable: any = true;
  showCashBook: any = false;
  printPage: any = false;
  loader: any = false;
  ledgers: any= [];
  totalCredit: any;
  totalDebit: any;
  opening_balance: any;
  total_credit: any; 
  total_debit: any;
  allData: any = [];
  current_date : string;
  data: any = {};
  receipt_no: any;
  office: any;
  farmer_name: any;
  farmer_id: any;
  ammount: any;
  amount_in_rupees: any;
  permit_no: any;
  implement: any;
  payment_mode: any;
  source_bank: any;
  payment_no: any;
  receipt_payment_date: any;
  receipt_date: any;


  constructor(
    private layoutService: LayoutService,
    private service: CommonService,
    private http: HttpClient,

  ) { 
    this.layoutService.setBreadcrumb('Cashbook / Payments');
    this.dist_id = layoutService.getDistrictID();
    this.current_date = layoutService.getCurrentDate();
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
      let receipt_response = await this.service.get('/accountant/getAllCreditLedgersForReceipt?dist_id=' + this.dist_id + '&fin_year=' + this.fin_year)
      let payment_response = await this.service.get('/accountant/getAllDebitLedgersForPayments?dist_id=' + this.dist_id + '&fin_year=' + this.fin_year)
      let response = await receipt_response;
      this.loader = false;
      this.showTable = true;
      this.ledgers = response.concat(payment_response);
      let data = this.ledgers;
      this.totalCredit = 0;
      this.totalDebit = 0;
      this.opening_balance = 0;
      data.filter((e: any) => e.date = new Date(e.date));
      data.sort((a: any, b: any) => a.date - b.date);
      for (let i = 0; i < data.length; i++) {
          if ((data[i].to == 'DS-' + this.dist_id) || (data[i].to === 'ADMIN')) {
              data[i].credit = data[i].ammount;
              data[i].debit = 0;
              data[i].headName = 'Received';
              this.totalCredit += parseInt(data[i].credit);

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
          } else if (data[i].from == 'DS-' + this.dist_id) {
              data[i].debit = data[i].ammount;
              data[i].credit = 0;
              data[i].headName = 'Paid';
              this.totalDebit += parseInt(data[i].debit);
              switch (data[i].purpose) {
                  case 'pay_against_expenditure':
                      {
                          data[i].perticulars = `Pay Against ${data[i].schem_name}
                          On ${data[i].head_name}
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
                          data[i].perticulars = `Pay Against Bill To ${data[i].to}, FARM MECHANISATION`;
                          data[i].links = false;
                          break;
                      }
                  case 'pay_against_bill_jn':
                      {
                          data[i].perticulars = `Pay Against Bill To ${data[i].to}, JALANIDHI`;
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
          if (i == 0) {
              data[i].balance = parseInt(data[i].credit) - parseInt(data[i].debit);
          } else {
              data[i].balance = (parseInt(data[i - 1].balance) + parseInt(data[i].credit)) - parseInt(data[i].debit);
          }
      }
      this.total_credit = this.totalCredit;
      this.total_debit = this.totalDebit;
     
  }
 

  showDetails = async(permit_no: any) => {
      let response = await this.service.get('/accountant/getCashBookData?permit_no=' + permit_no)
          
              this.allData = response;
              this.showCashBook = true;
              this.showTable = false;

              let data = response;
              this.totalCredit = 0;
              this.totalDebit = 0;
              data.filter((e: any) => e.date = new Date(e.date));
              data.sort((a: any, b: any) => a.date - b.date);
              for (let i = 0; i < data.length; i++) {

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


  showReceipt = async(permit_no: any) => {
     let response = await this.service.get('/accountant/getReceiptDetailsByPermitNo?permit_no=' + permit_no)
         
              
              let data = response;
              this.data = data;
              this.receipt_no = data.receipt_no;
              this.office = data.office;
              this.farmer_name = data.farmer_name;
              this.farmer_id = data.farmer_id;
              this.ammount = data.ammount;
              this.amount_in_rupees = data.ammount;
              this.permit_no = data.permit_no;
              this.implement = data.implement;
              this.payment_mode = data.payment_mode;
              this.source_bank = data.source_bank;
              this.payment_no = data.payment_no;
              this.receipt_payment_date = new Date(data.payment_date);
              this.receipt_date = new Date(data.date);
              this.showTable = false;
              this.printPage = true;
          
  }

   

  back = () => {
   this.showCashBook = false;
   this.printPage = false;
   this.showTable = true;
  }


}

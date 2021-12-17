import { Component, OnInit } from '@angular/core';
import { LayoutService } from 'src/app/services/layout/layout.service';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { CommonService } from 'src/app/services/common.service';

@Component({
  selector: 'app-pay-backlog-money',
  templateUrl: './pay-backlog-money.component.html',
  styleUrls: ['./pay-backlog-money.component.css']
})
export class PayBacklogMoneyComponent implements OnInit {
  dist_id: any;
  dist_name: any;
  acc_name: any;
  fin_year: any;
  order_no:any;
  head: any;
  subhead: any;
  amount: any;
  payment_date: any;
  remark: any;
  pay_to: any;
  print_page: any = false;
  enter_detail: any = true;
  c_date: any = new Date();
  system:any = 'farm_mechanisation';
  order_no_list: any = [];
  receipt_no: any;

  constructor(
    private layoutService: LayoutService,
    private service: CommonService,
    private http: HttpClient
  ) {
    this.layoutService.setBreadcrumb('Backlog Balance / Receive money');
    this.dist_id = layoutService.getDistrictID();
    this.getAccName();
    this.getDistName();
    this.loadOrderNoList();
    }

  ngOnInit(): void {
  }

  getAccName = async () => {
    let response = await this.service.get('/accountant/getAccName?dist_id=' + this.dist_id);
    this.acc_name = response.acc_name;
  }
  
  getDistName = async () => {
    let response = await this.service.get('/accountant/getDistName?dist_id=' + this.dist_id);
    this.dist_name = response.dist_name;
  }
   

  loadOrderNoList = async () => {
        let response = await this.service.get('/accountant/getOpeningBalanceOrderNos?system=' + this.system);
        this.order_no_list = response;
       
    }
  receiveOPBalance = () => {
      this.print_page = true;
      this.enter_detail = false;
    }
  back = () => {
      this.print_page = false;
      this.enter_detail = true;
    }
   
  submit = async() => {
        let data = {
            order_no: this.order_no.order_no,
            system: this.system,
            head: this.head,
            subhead: this.subhead,
            amount: this.amount,
            payment_date: this.payment_date,
            remark: this.remark,
            dist_id: this.dist_id,
            to: this.pay_to
        }
        try {
            
            let response = await this.service.post('/accountant/addPaidOpeningBalance', data);
            this.receipt_no = response;
            // printElem('receipt');
            setTimeout(() => {
                window.location.href = '/accountant/paidOpeningBalance';
            }, 500);
        } catch (e: any) {
            window.alert('Server error. Please try again.');
            console.error(e.data);
        }
    }
}

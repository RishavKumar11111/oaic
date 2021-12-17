import { Component, OnInit } from '@angular/core';
import { LayoutService } from 'src/app/services/layout/layout.service';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { CommonService } from 'src/app/services/common.service';

@Component({
  selector: 'app-receive-backlog-money',
  templateUrl: './receive-backlog-money.component.html',
  styleUrls: ['./receive-backlog-money.component.css']
})
export class ReceiveBacklogMoneyComponent implements OnInit {
  dist_id: any;
  dist_name: any;
  acc_name: any;
  fin_year: any;
  header: any;
  head: any;
  subhead: any;
  amount: any;
  payment_date: any;
  payment_type: any;
  payment_no: any;
  remark: any;
  receive_from: any;
  old_order_no: any;
  receipt_no: any;
  order_no: any
  c_date = new Date();
  print_page:any = false;
  enter_detail1:any = true;
  enter_detail2:any = true;
  system:any = 'farm_mechanisation';
  type:any = 'new_order';
  order_no_list : any;
 

  constructor(
    private layoutService: LayoutService,
    private service: CommonService,
    private http: HttpClient
  ) {
    this.layoutService.setBreadcrumb('Backlog Balance / Receive money');
    this.dist_id = layoutService.getDistrictID();
    this.getAccName();
    this.getDistName();
    }

  ngOnInit(): void {
  }

  changeFinancialYear(financialYear: string) {
    this.fin_year = financialYear;
    this.header = true;
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
        if (this.type == 'old_order') {
          let response = await this.service.get('/accountant/getOpeningBalanceOrderNos?system=' + this.system)
          this.order_no_list = response;
        }
    }
    receiveOPBalance = () => {
        this.print_page = true;
        this.enter_detail1 = false;
        this.enter_detail2 = false;
    }
    back = () => {
      this.print_page = false;
      this.enter_detail1 = true;
      this.enter_detail2 = true;
    }
    submit = async() => {
        let data: any = {
            system: this.system,
            head: this.head,
            subhead: this.subhead,
            amount: this.amount,
            payment_date: this.payment_date,
            payment_type: this.payment_type,
            payment_no: this.payment_no,
            remark: this.remark,
            dist_id: this.dist_id,
            from: this.receive_from
        }
        if (this.type == 'old_order') {
           data.order_no = this.old_order_no.order_no;
        } else {
            data.order_no = this.order_no;
        }
        try {
            
            let response = await this.service.post('/accountant/addReceivedOpeningBalance', data);
            this.receipt_no = response;
            setTimeout(() => {
                window.location.href = '/accountant/receiveOpeningBalance';
            }, 500);
        } catch (e: any) {
            window.alert('Server problem. Please try again.');
            console.error(e.data);
        }



    }


}
